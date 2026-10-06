import 'dart:io';

import 'package:core/core.dart' as core;

typedef ProcessRunner =
    Future<ProcessResult> Function(
      String executable,
      List<String> args, {
      required String workingDirectory,
    });

Future<ProcessResult> _defaultProcessRunner(
  String executable,
  List<String> args, {
  required String workingDirectory,
}) {
  return Process.run(executable, args, workingDirectory: workingDirectory);
}

/// Runs the deterministic Flutter pipeline against a cloned repo:
/// `fvm flutter pub get -> analyze -> test -> build apk -> build ios
/// --no-codesign` (preceded by `fvm use` when a version was detected).
/// The first failing step stops the pipeline; later steps are recorded as
/// `skipped`. No LLM involvement -- just process exit codes.
class HealthRunner {
  const HealthRunner({ProcessRunner processRunner = _defaultProcessRunner})
    : _processRunner = processRunner;

  final ProcessRunner _processRunner;

  static const _flutterSteps = [
    ['pub_get', 'pub', 'get'],
    ['analyze', 'analyze'],
    ['test', 'test'],
    ['build_apk', 'build', 'apk'],
    ['build_ios', 'build', 'ios', '--no-codesign'],
  ];

  Future<core.HealthReport> run(
    String repoPath, {
    String? flutterVersion,
  }) async {
    final startedAt = DateTime.now().toUtc();
    final steps = <core.HealthCheckStep>[];
    var failed = false;

    if (flutterVersion != null) {
      final pinned = await _runOrSkip(failed, 'fvm_use', 'fvm', [
        'use',
        flutterVersion,
        '--force',
      ], repoPath);
      steps.add(pinned);
      failed = failed || pinned.status != core.HealthCheckStepStatus.passed;
    }

    final command = flutterVersion != null ? 'fvm' : 'flutter';
    for (final step in _flutterSteps) {
      final name = step.first;
      final args = flutterVersion != null
          ? ['flutter', ...step.skip(1)]
          : step.skip(1).toList();
      final result = await _runOrSkip(failed, name, command, args, repoPath);
      steps.add(result);
      failed = failed || result.status != core.HealthCheckStepStatus.passed;
    }

    final overallFailed = steps.any(
      (s) => s.status == core.HealthCheckStepStatus.failed,
    );
    return core.HealthReport(
      status: overallFailed
          ? core.HealthCheckStepStatus.failed
          : core.HealthCheckStepStatus.passed,
      steps: steps,
      startedAt: startedAt,
      finishedAt: DateTime.now().toUtc(),
    );
  }

  Future<core.HealthCheckStep> _runOrSkip(
    bool alreadyFailed,
    String name,
    String executable,
    List<String> args,
    String cwd,
  ) {
    if (alreadyFailed) {
      return Future.value(
        core.HealthCheckStep(
          name: name,
          status: core.HealthCheckStepStatus.skipped,
          durationMs: 0,
          output: '',
        ),
      );
    }
    return _runStep(name, executable, args, cwd);
  }

  Future<core.HealthCheckStep> _runStep(
    String name,
    String executable,
    List<String> args,
    String cwd,
  ) async {
    final stopwatch = Stopwatch()..start();
    final (status, output) = await _execute(executable, args, cwd);
    stopwatch.stop();
    return core.HealthCheckStep(
      name: name,
      status: status,
      durationMs: stopwatch.elapsedMilliseconds,
      output: output,
    );
  }

  Future<(core.HealthCheckStepStatus, String)> _execute(
    String executable,
    List<String> args,
    String cwd,
  ) async {
    try {
      final result = await _processRunner(
        executable,
        args,
        workingDirectory: cwd,
      );
      final status = result.exitCode == 0
          ? core.HealthCheckStepStatus.passed
          : core.HealthCheckStepStatus.failed;
      return (status, '${result.stdout}\n${result.stderr}'.trim());
    } on ProcessException catch (e) {
      return (
        core.HealthCheckStepStatus.failed,
        'Failed to run $executable: ${e.message}',
      );
    }
  }
}
