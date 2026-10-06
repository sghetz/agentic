import 'dart:io';

import 'package:core/core.dart' as core;
import 'package:server/src/services/health_runner.dart';
import 'package:test/test.dart';

typedef _Call = (String executable, List<String> args);

class _FakeProcesses {
  final calls = <_Call>[];
  final Map<String, ProcessResult> _results = {};

  void stub(
    String key, {
    int exitCode = 0,
    String stdout = '',
    String stderr = '',
  }) {
    _results[key] = ProcessResult(0, exitCode, stdout, stderr);
  }

  Future<ProcessResult> run(
    String executable,
    List<String> args, {
    required String workingDirectory,
  }) async {
    calls.add((executable, args));
    final key = '$executable ${args.join(' ')}';
    return _results[key] ?? ProcessResult(0, 0, '', '');
  }
}

void main() {
  test('runs the full pipeline in order when everything passes', () async {
    final fake = _FakeProcesses();
    final runner = HealthRunner(processRunner: fake.run);

    final report = await runner.run('/repo');

    expect(report.status, core.HealthCheckStepStatus.passed);
    expect(report.steps.map((s) => s.name), [
      'pub_get',
      'analyze',
      'test',
      'build_apk',
      'build_ios',
    ]);
    expect(
      report.steps,
      everyElement(
        (core.HealthCheckStep s) =>
            s.status == core.HealthCheckStepStatus.passed,
      ),
    );
    final (firstExecutable, firstArgs) = fake.calls.first;
    expect(firstExecutable, 'flutter');
    expect(firstArgs, ['pub', 'get']);
  });

  test('stops at the first failure and skips the rest', () async {
    final fake = _FakeProcesses()
      ..stub('flutter analyze', exitCode: 1, stderr: 'error • lib/main.dart');
    final runner = HealthRunner(processRunner: fake.run);

    final report = await runner.run('/repo');

    expect(report.status, core.HealthCheckStepStatus.failed);
    final byName = {for (final s in report.steps) s.name: s.status};
    expect(byName['pub_get'], core.HealthCheckStepStatus.passed);
    expect(byName['analyze'], core.HealthCheckStepStatus.failed);
    expect(byName['test'], core.HealthCheckStepStatus.skipped);
    expect(byName['build_apk'], core.HealthCheckStepStatus.skipped);
    expect(byName['build_ios'], core.HealthCheckStepStatus.skipped);

    // Only pub_get and analyze actually ran a process.
    expect(fake.calls, hasLength(2));
  });

  test('pins the Flutter version via fvm when one was detected', () async {
    final fake = _FakeProcesses();
    final runner = HealthRunner(processRunner: fake.run);

    final report = await runner.run('/repo', flutterVersion: '3.29.0');

    expect(report.steps.map((s) => s.name), [
      'fvm_use',
      'pub_get',
      'analyze',
      'test',
      'build_apk',
      'build_ios',
    ]);
    final (firstExecutable, firstArgs) = fake.calls.first;
    expect(firstExecutable, 'fvm');
    expect(firstArgs, ['use', '3.29.0', '--force']);
    final (secondExecutable, secondArgs) = fake.calls[1];
    expect(secondExecutable, 'fvm');
    expect(secondArgs, ['flutter', 'pub', 'get']);
  });

  test('a failed fvm_use skips every pipeline step', () async {
    final fake = _FakeProcesses()
      ..stub(
        'fvm use 3.29.0 --force',
        exitCode: 1,
        stderr: 'version not found',
      );
    final runner = HealthRunner(processRunner: fake.run);

    final report = await runner.run('/repo', flutterVersion: '3.29.0');

    expect(report.status, core.HealthCheckStepStatus.failed);
    expect(
      report.steps.skip(1),
      everyElement(
        (core.HealthCheckStep s) =>
            s.status == core.HealthCheckStepStatus.skipped,
      ),
    );
    expect(fake.calls, hasLength(1));
  });

  test(
    'a missing executable is recorded as a failed step, not an exception',
    () async {
      Future<ProcessResult> throwingRunner(
        String executable,
        List<String> args, {
        required String workingDirectory,
      }) {
        throw const ProcessException(
          'flutter',
          [],
          'No such file or directory',
        );
      }

      final runner = HealthRunner(processRunner: throwingRunner);
      final report = await runner.run('/repo');

      expect(report.status, core.HealthCheckStepStatus.failed);
      expect(report.steps.first.status, core.HealthCheckStepStatus.failed);
      expect(report.steps.first.output, contains('No such file or directory'));
    },
  );
}
