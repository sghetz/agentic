import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;
import 'package:server/src/config.dart';
import 'package:server/src/services/git_service.dart';
import 'package:server/src/services/github_service.dart';
import 'package:server/src/services/health_runner.dart';
import 'package:server/src/services/review_service.dart';
import 'package:test/test.dart';

Future<void> _git(List<String> args, {String? cwd}) async {
  final result = await Process.run('git', args, workingDirectory: cwd);
  if (result.exitCode != 0) {
    fail('git ${args.join(' ')} failed: ${result.stderr}');
  }
}

Future<ProcessResult> _alwaysPasses(
  String executable,
  List<String> args, {
  required String workingDirectory,
}) async {
  return ProcessResult(0, 0, '', '');
}

Future<ProcessResult> _alwaysFails(
  String executable,
  List<String> args, {
  required String workingDirectory,
}) async {
  return ProcessResult(0, 1, '', 'still broken');
}

GitHubService _hybridGithub() {
  return GitHubService(
    runner: (executable, args, {workingDirectory}) {
      if (executable == 'gh') {
        return Future.value(ProcessResult(0, 0, '', ''));
      }
      return Process.run(executable, args, workingDirectory: workingDirectory);
    },
  );
}

String _structuredOutput({
  String summary = 'Looks good, one gap.',
  List<String> missingTests = const ['No test for the expired-link case'],
}) {
  return jsonEncode({
    'structured_output': {
      'summary': summary,
      'acceptanceCriteriaMet': ['A reset link expires after 1 hour'],
      'acceptanceCriteriaUnmet': <String>[],
      'requirementIdsCovered': ['RF-07'],
      'requirementIdsMissing': <String>[],
      'codeQualityIssues': <String>[],
      'missingTests': missingTests,
    },
  });
}

const _taskSpec = core.TaskSpec(
  projectId: 'proj-1',
  goal: 'Let users reset their password via email',
  requirementIds: ['RF-07'],
  acceptanceCriteria: ['A reset link expires after 1 hour'],
  priority: core.TaskSpecPriority.high,
);

void main() {
  late Directory tmp;
  late AgenticPaths paths;
  late String remotePath;
  late core.Project project;
  late core.Task task;
  late String worktreePath;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('agentic_review_test_');
    paths = AgenticPaths('${tmp.path}/data', '${tmp.path}/repos');
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

    project = core.Project(
      id: 'proj-1',
      name: 'Example',
      slug: 'example',
      repos: [
        core.RepoConfig(url: remotePath, defaultBranch: 'main', path: ''),
      ],
      status: core.ProjectStatus.active,
      createdAt: DateTime.utc(2026, 1, 1),
    );

    task = core.Task(
      id: 'task-1',
      projectId: 'proj-1',
      title: 'Reset password via email',
      currentStatus: core.TaskStatus.inReview,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

    // Simulate what a completed develop() call leaves behind: a task-keyed
    // worktree on a branch with Developer's commit already on it.
    final repoPath = paths.repoPath('org', 'example');
    await _git(['clone', remotePath, repoPath]);
    worktreePath = paths.worktreePath('org', 'example', 'task-1');
    const gitService = GitService();
    await gitService.createWorktree(
      repoPath: repoPath,
      branchName: 'agentic/task-task-1',
      worktreePath: worktreePath,
    );
    await File('$worktreePath/lib.dart').writeAsString('// developer impl\n');
    await _git(['add', '.'], cwd: worktreePath);
    await _git([
      '-c',
      'user.email=test@example.com',
      '-c',
      'user.name=Test',
      'commit',
      '-m',
      'Agentic: implement password reset',
    ], cwd: worktreePath);
    await _git([
      'push',
      '-u',
      'origin',
      'agentic/task-task-1',
    ], cwd: worktreePath);
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  ReviewService buildService({
    required ReviewClaudeInvoker invoker,
    ProcessRunner healthProcessRunner = _alwaysPasses,
  }) {
    return ReviewService(
      paths: paths,
      gitService: const GitService(),
      githubService: _hybridGithub(),
      runner: HealthRunner(processRunner: healthProcessRunner),
      invoker: invoker,
    );
  }

  test('throws NoWorktreeFound when develop() was never run', () async {
    final service = buildService(
      invoker: (args, {required workingDirectory}) async => _structuredOutput(),
    );
    final unknownTask = task.copyWith(id: 'task-does-not-exist');

    expect(
      () => service.review(
        orgSlug: 'org',
        project: project,
        task: unknownTask,
        taskSpec: _taskSpec,
      ),
      throwsA(isA<NoWorktreeFound>()),
    );
  });

  test('returns the structured Review Report', () async {
    final service = buildService(
      invoker: (args, {required workingDirectory}) async => _structuredOutput(),
    );

    final report = await service.review(
      orgSlug: 'org',
      project: project,
      task: task,
      taskSpec: _taskSpec,
    );

    expect(report, isNotNull);
    expect(report!.summary, 'Looks good, one gap.');
    expect(report.acceptanceCriteriaMet, ['A reset link expires after 1 hour']);
    expect(report.missingTests, ['No test for the expired-link case']);
  });

  test('inlines the diff against the base branch into the prompt', () async {
    String? capturedPrompt;
    final service = buildService(
      invoker: (args, {required workingDirectory}) async {
        capturedPrompt = args[args.indexOf('-p') + 1];
        return _structuredOutput();
      },
    );

    await service.review(
      orgSlug: 'org',
      project: project,
      task: task,
      taskSpec: _taskSpec,
    );

    expect(capturedPrompt, contains('lib.dart'));
    expect(capturedPrompt, contains('developer impl'));
  });

  test(
    'Reviewer edits that pass verification are committed and pushed',
    () async {
      final service = buildService(
        invoker: (args, {required workingDirectory}) async {
          await File(
            '$workingDirectory/lib_test.dart',
          ).writeAsString('// test\n');
          return _structuredOutput(missingTests: const []);
        },
      );

      final report = await service.review(
        orgSlug: 'org',
        project: project,
        task: task,
        taskSpec: _taskSpec,
      );

      expect(report, isNotNull);
      final remoteBranches = await Process.run('git', [
        'log',
        'origin/agentic/task-task-1',
        '--oneline',
      ], workingDirectory: worktreePath);
      expect(remoteBranches.stdout as String, contains('review additions'));
    },
  );

  test(
    'Reviewer edits that fail verification are left uncommitted, never pushed',
    () async {
      final service = buildService(
        invoker: (args, {required workingDirectory}) async {
          await File(
            '$workingDirectory/lib_test.dart',
          ).writeAsString('// broken test\n');
          return _structuredOutput(missingTests: const []);
        },
        healthProcessRunner: _alwaysFails,
      );

      final report = await service.review(
        orgSlug: 'org',
        project: project,
        task: task,
        taskSpec: _taskSpec,
      );

      expect(report, isNotNull);
      final status = await Process.run('git', [
        'status',
        '--porcelain',
      ], workingDirectory: worktreePath);
      expect((status.stdout as String).trim(), isNotEmpty);
    },
  );

  test('an invoker exception returns null rather than throwing', () async {
    final service = buildService(
      invoker: (args, {required workingDirectory}) async =>
          throw Exception('claude crashed'),
    );

    final report = await service.review(
      orgSlug: 'org',
      project: project,
      task: task,
      taskSpec: _taskSpec,
    );

    expect(report, isNull);
  });

  test(
    'malformed structured output returns null rather than throwing',
    () async {
      final service = buildService(
        invoker: (args, {required workingDirectory}) async =>
            jsonEncode({'result': 'no schema used'}),
      );

      final report = await service.review(
        orgSlug: 'org',
        project: project,
        task: task,
        taskSpec: _taskSpec,
      );

      expect(report, isNull);
    },
  );

  test('Claude never gets git or gh tool access', () async {
    List<String>? capturedArgs;
    final service = buildService(
      invoker: (args, {required workingDirectory}) async {
        capturedArgs = args;
        return _structuredOutput();
      },
    );

    await service.review(
      orgSlug: 'org',
      project: project,
      task: task,
      taskSpec: _taskSpec,
    );

    final toolsIndex = capturedArgs!.indexOf('--allowedTools');
    final allowedTools = capturedArgs![toolsIndex + 1];
    expect(allowedTools, isNot(contains('Bash(git')));
    expect(allowedTools, isNot(contains('Bash(gh')));
  });
}
