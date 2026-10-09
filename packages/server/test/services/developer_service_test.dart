import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;
import 'package:server/src/config.dart';
import 'package:server/src/services/developer_service.dart';
import 'package:server/src/services/git_service.dart';
import 'package:server/src/services/github_service.dart';
import 'package:server/src/services/health_runner.dart';
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

/// Real `git` for push (works fine against a local bare remote, no network
/// needed) but a faked `gh` so PR creation never hits the real GitHub API.
GitHubService _hybridGithub({
  String prUrl = 'https://github.com/org/repo/pull/1',
}) {
  return GitHubService(
    runner: (executable, args, {workingDirectory}) {
      if (executable == 'gh') {
        return Future.value(ProcessResult(0, 0, '$prUrl\n', ''));
      }
      return Process.run(executable, args, workingDirectory: workingDirectory);
    },
  );
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

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('agentic_developer_test_');
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
      currentStatus: core.TaskStatus.specified,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  DeveloperService buildService({
    required DeveloperClaudeInvoker invoker,
    ProcessRunner healthProcessRunner = _alwaysPasses,
    GitHubService? githubService,
  }) {
    return DeveloperService(
      paths: paths,
      gitService: const GitService(),
      githubService: githubService ?? _hybridGithub(),
      runner: HealthRunner(processRunner: healthProcessRunner),
      invoker: invoker,
    );
  }

  test('no changes -> noChanges, worktree and branch are cleaned up', () async {
    final service = buildService(
      invoker: (args, {required workingDirectory}) async =>
          jsonEncode({'result': 'nothing to do'}),
    );

    final result = await service.develop(
      orgSlug: 'org',
      project: project,
      task: task,
      taskSpec: _taskSpec,
    );

    expect(result.outcome, core.DeveloperOutcome.noChanges);
    expect(result.branchName, isNull);

    final repoPath = paths.repoPath('org', 'example');
    final worktrees = await Process.run('git', [
      'worktree',
      'list',
    ], workingDirectory: repoPath);
    expect(
      (worktrees.stdout as String)
          .split('\n')
          .where((l) => l.trim().isNotEmpty),
      hasLength(1),
    );
  });

  test(
    'changes made and verification passes -> prOpened, pushed with a real PR',
    () async {
      final service = buildService(
        invoker: (args, {required workingDirectory}) async {
          await File('$workingDirectory/lib.dart').writeAsString('// impl\n');
          return jsonEncode({'result': 'implemented password reset'});
        },
      );

      final result = await service.develop(
        orgSlug: 'org',
        project: project,
        task: task,
        taskSpec: _taskSpec,
      );

      expect(result.outcome, core.DeveloperOutcome.prOpened);
      expect(result.branchName, 'agentic/task-task-1');
      expect(
        result.verificationReport?.status,
        core.HealthCheckStepStatus.passed,
      );
      expect(result.pullRequest?.url, 'https://github.com/org/repo/pull/1');
      expect(result.pullRequest?.baseBranch, 'main');

      final repoPath = paths.repoPath('org', 'example');
      final remoteBranches = await Process.run('git', [
        'branch',
        '-r',
      ], workingDirectory: repoPath);
      expect(remoteBranches.stdout as String, contains('agentic/task-task-1'));

      // Kept alive for Reviewer -- never discarded on success.
      final worktreePath = paths.worktreePath('org', 'example', 'task-1');
      expect(await Directory(worktreePath).exists(), isTrue);
    },
  );

  test('changes made but verification fails -> verificationFailed, committed '
      'locally and kept, never pushed', () async {
    final service = buildService(
      invoker: (args, {required workingDirectory}) async {
        await File('$workingDirectory/lib.dart').writeAsString('// broken\n');
        return jsonEncode({'result': 'attempted the implementation'});
      },
      healthProcessRunner: _alwaysFails,
    );

    final result = await service.develop(
      orgSlug: 'org',
      project: project,
      task: task,
      taskSpec: _taskSpec,
    );

    expect(result.outcome, core.DeveloperOutcome.verificationFailed);
    expect(result.branchName, 'agentic/task-task-1');
    expect(result.pullRequest, isNull);

    final repoPath = paths.repoPath('org', 'example');
    final remoteBranches = await Process.run('git', [
      'branch',
      '-r',
    ], workingDirectory: repoPath);
    expect(
      remoteBranches.stdout as String,
      isNot(contains('agentic/task-task-1')),
    );

    final worktreePath = paths.worktreePath('org', 'example', 'task-1');
    expect(await Directory(worktreePath).exists(), isTrue);
  });

  test('a retried develop() call reuses the existing worktree instead of '
      'failing on git worktree add', () async {
    final firstAttempt = buildService(
      invoker: (args, {required workingDirectory}) async {
        await File('$workingDirectory/lib.dart').writeAsString('// broken\n');
        return jsonEncode({'result': 'first attempt'});
      },
      healthProcessRunner: _alwaysFails,
    );
    final first = await firstAttempt.develop(
      orgSlug: 'org',
      project: project,
      task: task,
      taskSpec: _taskSpec,
    );
    expect(first.outcome, core.DeveloperOutcome.verificationFailed);

    final secondAttempt = buildService(
      invoker: (args, {required workingDirectory}) async {
        await File('$workingDirectory/lib2.dart').writeAsString('// fixed\n');
        return jsonEncode({'result': 'second attempt, fixed it'});
      },
    );
    final second = await secondAttempt.develop(
      orgSlug: 'org',
      project: project,
      task: task,
      taskSpec: _taskSpec,
    );

    expect(second.outcome, core.DeveloperOutcome.prOpened);
  });

  test(
    'an invoker exception with no changes made discards the worktree',
    () async {
      final service = buildService(
        invoker: (args, {required workingDirectory}) async =>
            throw Exception('claude crashed'),
      );

      final result = await service.develop(
        orgSlug: 'org',
        project: project,
        task: task,
        taskSpec: _taskSpec,
      );

      expect(result.outcome, core.DeveloperOutcome.sessionFailed);
      final repoPath = paths.repoPath('org', 'example');
      final worktrees = await Process.run('git', [
        'worktree',
        'list',
      ], workingDirectory: repoPath);
      expect(
        (worktrees.stdout as String)
            .split('\n')
            .where((l) => l.trim().isNotEmpty),
        hasLength(1),
      );
    },
  );

  test('Claude never gets git or gh tool access', () async {
    List<String>? capturedArgs;
    final service = buildService(
      invoker: (args, {required workingDirectory}) async {
        capturedArgs = args;
        return jsonEncode({'result': 'no changes'});
      },
    );

    await service.develop(
      orgSlug: 'org',
      project: project,
      task: task,
      taskSpec: _taskSpec,
    );

    final toolsIndex = capturedArgs!.indexOf('--allowedTools');
    final allowedTools = capturedArgs![toolsIndex + 1];
    expect(allowedTools, isNot(contains('Bash(git')));
    expect(allowedTools, isNot(contains('Bash(gh')));
    expect(allowedTools, isNot(contains(' git ')));
  });
}
