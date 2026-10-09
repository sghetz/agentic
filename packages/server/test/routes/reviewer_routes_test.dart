import 'dart:convert';
import 'dart:io';

import 'package:server/src/app_context.dart';
import 'package:server/src/config.dart';
import 'package:server/src/server.dart';
import 'package:server/src/services/analyst_extraction_service.dart';
import 'package:server/src/services/developer_service.dart';
import 'package:server/src/services/git_service.dart';
import 'package:server/src/services/github_service.dart';
import 'package:server/src/services/health_runner.dart';
import 'package:server/src/services/review_service.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../test_support/http_test_support.dart';

const _taskSpecOutput = {
  'structured_output': {
    'goal': 'Let users reset their password via email',
    'requirementIds': ['RF-07'],
    'acceptanceCriteria': ['A reset link expires after 1 hour'],
    'affectedAreas': ['Auth'],
    'priority': 'high',
    'openQuestions': <String>[],
  },
};

const _reviewOutput = {
  'structured_output': {
    'summary': 'Covers the happy path.',
    'acceptanceCriteriaMet': ['A reset link expires after 1 hour'],
    'acceptanceCriteriaUnmet': <String>[],
    'requirementIdsCovered': ['RF-07'],
    'requirementIdsMissing': <String>[],
    'codeQualityIssues': <String>[],
    'missingTests': <String>[],
  },
};

Future<ProcessResult> _alwaysPasses(
  String executable,
  List<String> args, {
  required String workingDirectory,
}) async {
  return ProcessResult(0, 0, '', '');
}

Future<void> _git(List<String> args, {String? cwd}) async {
  final result = await Process.run('git', args, workingDirectory: cwd);
  if (result.exitCode != 0) {
    fail('git ${args.join(' ')} failed: ${result.stderr}');
  }
}

/// Real `git`, but a faked `gh` covering create/view/merge, so the whole
/// Developer -> Reviewer -> approve flow runs without touching the real
/// GitHub API.
GitHubService _fakeGithub() {
  return GitHubService(
    runner: (executable, args, {workingDirectory}) async {
      if (executable == 'gh') {
        if (args.contains('create')) {
          return ProcessResult(
            0,
            0,
            'https://github.com/org/repo/pull/9\n',
            '',
          );
        }
        if (args.contains('view')) {
          return ProcessResult(
            0,
            0,
            jsonEncode({
              'statusCheckRollup': [
                {
                  'name': 'build',
                  'status': 'COMPLETED',
                  'conclusion': 'SUCCESS',
                },
              ],
            }),
            '',
          );
        }
        if (args.contains('merge')) {
          return ProcessResult(0, 0, '', '');
        }
      }
      return Process.run(executable, args, workingDirectory: workingDirectory);
    },
  );
}

void main() {
  late AppContext ctx;
  late Handler handler;
  late String orgId;
  late String projectId;
  late String taskId;
  late Directory tmp;
  late String remotePath;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('agentic_reviewer_route_test_');
    remotePath = '${tmp.path}/remote.git';
    await _git(['init', '--bare', remotePath]);
    final seedPath = '${tmp.path}/seed';
    await _git(['clone', remotePath, seedPath]);
    await File('$seedPath/README.md').writeAsString('hello');
    await _git(['add', '.'], cwd: seedPath);
    await _git([
      '-c',
      'user.email=test@example.com',
      '-c',
      'user.name=Test',
      'commit',
      '-m',
      'initial',
    ], cwd: seedPath);
    await _git(['branch', '-m', 'main'], cwd: seedPath);
    await _git(['push', 'origin', 'HEAD:main'], cwd: seedPath);

    final paths = AgenticPaths('${tmp.path}/data', '${tmp.path}/repos');
    const gitService = GitService();
    final githubService = _fakeGithub();
    final health = HealthRunner(processRunner: _alwaysPasses);

    ctx = buildTestContext(
      analystExtractionService: AnalystExtractionService(
        invoker: (_) async => jsonEncode(_taskSpecOutput),
      ),
      developerService: DeveloperService(
        paths: paths,
        gitService: gitService,
        githubService: githubService,
        runner: health,
        invoker: (args, {required workingDirectory}) async {
          await File('$workingDirectory/lib.dart').writeAsString('// impl\n');
          return jsonEncode({'result': 'implemented it'});
        },
      ),
      reviewService: ReviewService(
        paths: paths,
        gitService: gitService,
        githubService: githubService,
        runner: health,
        invoker: (args, {required workingDirectory}) async =>
            jsonEncode(_reviewOutput),
      ),
      githubService: githubService,
      paths: paths,
    );
    handler = buildHandler(ctx);
    orgId = await createOrg(handler);

    final (_, projectBody) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects',
      json: {
        'name': 'Example',
        'slug': 'example',
        'repos': [
          {'url': remotePath, 'defaultBranch': 'main', 'path': ''},
        ],
      },
    );
    projectId = (projectBody! as Map)['id'] as String;

    taskId = await createTask(handler, orgId, projectId);
    await send(
      handler,
      'POST',
      '/orgs/$orgId/tasks/$taskId/events',
      json: {
        'actor': 'user',
        'eventType': 'statusChanged',
        'payload': {'to': 'specified'},
      },
    );
    final (_, taskSpecBody) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/task-specs/extract',
      json: {'rawText': 'password reset via email, RF-07'},
    );
    final specId = (taskSpecBody! as Map)['id'] as String;

    final (developStatus, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/develop',
      json: {'taskSpecArtifactId': specId},
    );
    expect(developStatus, 200);
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  test(
    'POST review reuses the attached Task Spec and moves to awaitingApproval',
    () async {
      final (status, body) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$projectId/tasks/$taskId/review',
      );

      expect(status, 200);
      final reviewArtifact = (body! as Map)['review'] as Map;
      expect(reviewArtifact['kind'], 'review');
      final content = jsonDecode(reviewArtifact['content'] as String) as Map;
      expect(content['summary'], 'Covers the happy path.');

      final (taskStatus, taskBody) = await send(
        handler,
        'GET',
        '/orgs/$orgId/tasks/$taskId',
      );
      expect(taskStatus, 200);
      expect((taskBody! as Map)['currentStatus'], 'awaitingApproval');
    },
  );

  test('review 400s when the task is not currently in review', () async {
    await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/review',
    );

    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/review',
    );
    expect(status, 400);
  });

  test('GET pr-checks returns the live check status', () async {
    final (status, body) = await send(
      handler,
      'GET',
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/pr-checks',
    );

    expect(status, 200);
    final checks = body! as List;
    expect(checks, hasLength(1));
    expect((checks.single as Map)['name'], 'build');
    expect((checks.single as Map)['conclusion'], 'success');
  });

  test('pr-checks 400s when there is no PR yet', () async {
    final freshTaskId = await createTask(handler, orgId, projectId);

    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/$orgId/projects/$projectId/tasks/$freshTaskId/pr-checks',
    );
    expect(status, 400);
  });

  test('approve 400s before the task is awaitingApproval, then merges and '
      'moves to done once it is', () async {
    final (tooEarly, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/approve',
    );
    expect(tooEarly, 400);

    await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/review',
    );

    final (status, body) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/approve',
    );
    expect(status, 200);
    expect((body! as Map)['status'], 'merged');

    final (taskStatus, taskBody) = await send(
      handler,
      'GET',
      '/orgs/$orgId/tasks/$taskId',
    );
    expect(taskStatus, 200);
    expect((taskBody! as Map)['currentStatus'], 'done');
  });
}
