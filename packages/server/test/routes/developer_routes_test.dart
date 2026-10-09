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

void main() {
  late AppContext ctx;
  late Handler handler;
  late String orgId;
  late String projectId;
  late String taskId;
  late String taskSpecArtifactId;
  late Directory tmp;
  late String remotePath;

  Future<void> markSpecified(String taskId) async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/tasks/$taskId/events',
      json: {
        'actor': 'user',
        'eventType': 'statusChanged',
        'payload': {'to': 'specified'},
      },
    );
    expect(status, 201);
  }

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp(
      'agentic_developer_route_test_',
    );
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

    ctx = buildTestContext(
      analystExtractionService: AnalystExtractionService(
        invoker: (_) async => jsonEncode(_taskSpecOutput),
      ),
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
    await markSpecified(taskId);

    final (_, taskSpecBody) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/task-specs/extract',
      json: {'rawText': 'password reset via email, RF-07'},
    );
    taskSpecArtifactId = (taskSpecBody! as Map)['id'] as String;
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  test(
    'runs Developer, transitions to inDevelopment, and never calls the real CLI',
    () async {
      final (status, body) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$projectId/tasks/$taskId/develop',
        json: {'taskSpecArtifactId': taskSpecArtifactId},
      );

      expect(status, 200);
      final result = (body! as Map)['result'] as Map;
      expect(result['outcome'], 'noChanges');

      final (taskStatus, taskBody) = await send(
        handler,
        'GET',
        '/orgs/$orgId/tasks/$taskId',
      );
      expect(taskStatus, 200);
      expect((taskBody! as Map)['currentStatus'], 'inDevelopment');
    },
  );

  test('records an artifactAttached event for the Task Spec used', () async {
    await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/develop',
      json: {'taskSpecArtifactId': taskSpecArtifactId},
    );

    final (status, body) = await send(
      handler,
      'GET',
      '/orgs/$orgId/tasks/$taskId/events',
    );
    expect(status, 200);
    final events = body! as List;
    final attached = events.cast<Map>().where(
      (e) => e['eventType'] == 'artifactAttached',
    );
    expect(
      attached.any(
        (e) => (e['payload'] as Map)['artifactId'] == taskSpecArtifactId,
      ),
      isTrue,
    );
  });

  test(
    'a successful implementation opens a PR, stores it, and moves to inReview',
    () async {
      final successCtx = buildTestContext(
        analystExtractionService: AnalystExtractionService(
          invoker: (_) async => jsonEncode(_taskSpecOutput),
        ),
        developerService: DeveloperService(
          paths: AgenticPaths('${tmp.path}/data', '${tmp.path}/repos'),
          gitService: const GitService(),
          githubService: GitHubService(
            runner: (executable, args, {workingDirectory}) {
              if (executable == 'gh') {
                return Future.value(
                  ProcessResult(
                    0,
                    0,
                    'https://github.com/org/repo/pull/7\n',
                    '',
                  ),
                );
              }
              return Process.run(
                executable,
                args,
                workingDirectory: workingDirectory,
              );
            },
          ),
          runner: HealthRunner(processRunner: _alwaysPasses),
          invoker: (args, {required workingDirectory}) async {
            await File('$workingDirectory/lib.dart').writeAsString('// impl\n');
            return jsonEncode({'result': 'implemented it'});
          },
        ),
      );
      final successHandler = buildHandler(successCtx);
      final org = await createOrg(successHandler, slug: 'success-org');
      final (_, projectBody) = await send(
        successHandler,
        'POST',
        '/orgs/$org/projects',
        json: {
          'name': 'Example',
          'slug': 'example',
          'repos': [
            {'url': remotePath, 'defaultBranch': 'main', 'path': ''},
          ],
        },
      );
      final proj = (projectBody! as Map)['id'] as String;
      final task = await createTask(successHandler, org, proj);
      await send(
        successHandler,
        'POST',
        '/orgs/$org/tasks/$task/events',
        json: {
          'actor': 'user',
          'eventType': 'statusChanged',
          'payload': {'to': 'specified'},
        },
      );
      final (_, taskSpecBody) = await send(
        successHandler,
        'POST',
        '/orgs/$org/projects/$proj/task-specs/extract',
        json: {'rawText': 'password reset via email, RF-07'},
      );
      final specId = (taskSpecBody! as Map)['id'] as String;

      final (status, body) = await send(
        successHandler,
        'POST',
        '/orgs/$org/projects/$proj/tasks/$task/develop',
        json: {'taskSpecArtifactId': specId},
      );

      expect(status, 200);
      final map = body! as Map;
      expect((map['result'] as Map)['outcome'], 'prOpened');
      final prArtifact = map['pr'] as Map;
      expect(prArtifact['kind'], 'pr');
      expect(prArtifact['taskId'], task);
      final prContent = jsonDecode(prArtifact['content'] as String) as Map;
      expect(prContent['url'], 'https://github.com/org/repo/pull/7');

      final (taskStatus, taskBody) = await send(
        successHandler,
        'GET',
        '/orgs/$org/tasks/$task',
      );
      expect(taskStatus, 200);
      expect((taskBody! as Map)['currentStatus'], 'inReview');
    },
  );

  test('taskSpecArtifactId is required', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/develop',
      json: const {},
    );
    expect(status, 400);
  });

  test('an unknown taskSpecArtifactId is a 404', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/tasks/$taskId/develop',
      json: {'taskSpecArtifactId': 'no-such-artifact'},
    );
    expect(status, 404);
  });

  test('an unknown task is a 404', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/tasks/no-such-task/develop',
      json: {'taskSpecArtifactId': taskSpecArtifactId},
    );
    expect(status, 404);
  });

  test(
    'a task still in newTask (never specified) is a 409 with allowed transitions',
    () async {
      final freshTaskId = await createTask(handler, orgId, projectId);

      final (status, body) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$projectId/tasks/$freshTaskId/develop',
        json: {'taskSpecArtifactId': taskSpecArtifactId},
      );

      expect(status, 409);
      expect((body! as Map)['error'], 'invalid transition');
    },
  );

  test(
    'calling develop twice (already inDevelopment) does not error',
    () async {
      final (first, _) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$projectId/tasks/$taskId/develop',
        json: {'taskSpecArtifactId': taskSpecArtifactId},
      );
      expect(first, 200);

      final (second, body) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$projectId/tasks/$taskId/develop',
        json: {'taskSpecArtifactId': taskSpecArtifactId},
      );
      expect(second, 200);
      expect((body! as Map)['result'], isNotNull);
    },
  );
}
