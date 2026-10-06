import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;
import 'package:server/src/config.dart';
import 'package:server/src/services/git_service.dart';
import 'package:server/src/services/health_runner.dart';
import 'package:server/src/services/trivial_fix_service.dart';
import 'package:test/test.dart';

Future<void> _git(List<String> args, {String? cwd}) async {
  final result = await Process.run('git', args, workingDirectory: cwd);
  if (result.exitCode != 0) {
    fail('git ${args.join(' ')} failed: ${result.stderr}');
  }
}

const _diagnosis = core.FailureDiagnosis(
  category: core.FailureDiagnosisCategory.sdkMismatch,
  summary: 'Pre-null-safety SDK constraint.',
  suggestedFix: "Update the sdk constraint to '>=2.12.0 <4.0.0'.",
);

const _failedStep = core.HealthCheckStep(
  name: 'pub_get',
  status: core.HealthCheckStepStatus.failed,
  durationMs: 300,
  output: 'SDK version solving failed',
);

Future<ProcessResult> _alwaysPasses(
  String executable,
  List<String> args, {
  required String workingDirectory,
}) async {
  return ProcessResult(0, 0, '', '');
}

void main() {
  late Directory tmp;
  late AgenticPaths paths;
  late String repoPath;
  late core.Project project;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('agentic_trivialfix_test_');
    paths = AgenticPaths('${tmp.path}/data', '${tmp.path}/repos');
    repoPath = paths.repoPath('org', 'example');
    await Directory(repoPath).create(recursive: true);
    await _git(['init', repoPath]);
    await File(
      '$repoPath/pubspec.yaml',
    ).writeAsString("name: example\nenvironment:\n  sdk: '>=2.1.0 <3.0.0'\n");
    await _git(['add', '.'], cwd: repoPath);
    await _git([
      '-c',
      'user.email=test@example.com',
      '-c',
      'user.name=Test',
      'commit',
      '-m',
      'initial',
    ], cwd: repoPath);
    await _git(['branch', '-m', 'main'], cwd: repoPath);

    project = core.Project(
      id: 'proj-1',
      name: 'Example',
      slug: 'example',
      repos: const [],
      status: core.ProjectStatus.active,
      createdAt: DateTime.utc(2026, 1, 1),
    );
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  TrivialFixService buildService({
    required FixClaudeInvoker invoker,
    ProcessRunner healthProcessRunner = _alwaysPasses,
  }) {
    return TrivialFixService(
      paths: paths,
      gitService: const GitService(),
      runner: HealthRunner(processRunner: healthProcessRunner),
      invoker: invoker,
    );
  }

  test(
    'no changes -> notTrivial, worktree and branch are cleaned up',
    () async {
      final service = buildService(
        invoker: (args, {required workingDirectory}) async =>
            jsonEncode({'result': 'not trivial, skipping'}),
      );

      final result = await service.attemptFix(
        orgSlug: 'org',
        project: project,
        diagnosis: _diagnosis,
        failedStep: _failedStep,
      );

      expect(result.outcome, core.HealthFixOutcome.notTrivial);
      expect(result.branchName, isNull);
      expect(result.summary, 'not trivial, skipping');

      final branches = await Process.run('git', [
        'branch',
      ], workingDirectory: repoPath);
      expect(branches.stdout as String, isNot(contains('agentic/health-fix')));
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

  test(
    'changes made and verification passes -> fixed, change is committed on a new branch',
    () async {
      final service = buildService(
        invoker: (args, {required workingDirectory}) async {
          await File('$workingDirectory/pubspec.yaml').writeAsString(
            "name: example\nenvironment:\n  sdk: '>=2.12.0 <4.0.0'\n",
          );
          return jsonEncode({'result': 'updated the sdk constraint'});
        },
      );

      final result = await service.attemptFix(
        orgSlug: 'org',
        project: project,
        diagnosis: _diagnosis,
        failedStep: _failedStep,
      );

      expect(result.outcome, core.HealthFixOutcome.fixed);
      expect(result.branchName, startsWith('agentic/health-fix-'));
      expect(
        result.verificationReport?.status,
        core.HealthCheckStepStatus.passed,
      );

      final branches = await Process.run('git', [
        'branch',
      ], workingDirectory: repoPath);
      expect(branches.stdout as String, contains(result.branchName));

      final log = await Process.run('git', [
        'log',
        result.branchName!,
        '--oneline',
      ], workingDirectory: repoPath);
      expect(log.stdout as String, contains('Agentic: fix pub_get'));
    },
  );

  test(
    'changes made but verification still fails -> stillFailing, discarded',
    () async {
      final service = buildService(
        invoker: (args, {required workingDirectory}) async {
          await File(
            '$workingDirectory/pubspec.yaml',
          ).writeAsString('garbage: not a real fix\n');
          return jsonEncode({'result': 'attempted a fix'});
        },
        healthProcessRunner:
            (executable, args, {required workingDirectory}) async {
              return ProcessResult(0, 1, '', 'still broken');
            },
      );

      final result = await service.attemptFix(
        orgSlug: 'org',
        project: project,
        diagnosis: _diagnosis,
        failedStep: _failedStep,
      );

      expect(result.outcome, core.HealthFixOutcome.stillFailing);
      expect(
        result.verificationReport?.status,
        core.HealthCheckStepStatus.failed,
      );

      final branches = await Process.run('git', [
        'branch',
      ], workingDirectory: repoPath);
      expect(branches.stdout as String, isNot(contains('agentic/health-fix')));
    },
  );

  test(
    'Claude never gets git tool access, even implicitly via allowedTools',
    () async {
      List<String>? capturedArgs;
      final service = buildService(
        invoker: (args, {required workingDirectory}) async {
          capturedArgs = args;
          return jsonEncode({'result': 'no changes'});
        },
      );

      await service.attemptFix(
        orgSlug: 'org',
        project: project,
        diagnosis: _diagnosis,
        failedStep: _failedStep,
      );

      final toolsIndex = capturedArgs!.indexOf('--allowedTools');
      final allowedTools = capturedArgs![toolsIndex + 1];
      expect(allowedTools, isNot(contains('git')));
      expect(allowedTools, isNot(contains('Bash(git')));
    },
  );

  test(
    'an invoker exception discards the worktree instead of leaving it dangling',
    () async {
      final service = buildService(
        invoker: (args, {required workingDirectory}) async =>
            throw Exception('claude crashed'),
      );

      final result = await service.attemptFix(
        orgSlug: 'org',
        project: project,
        diagnosis: _diagnosis,
        failedStep: _failedStep,
      );

      expect(result.outcome, core.HealthFixOutcome.notTrivial);
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
}
