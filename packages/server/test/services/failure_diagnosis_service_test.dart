import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:server/src/services/failure_diagnosis_service.dart';
import 'package:test/test.dart';

const _failedStep = core.HealthCheckStep(
  name: 'pub_get',
  status: core.HealthCheckStepStatus.failed,
  durationMs: 346,
  output:
      'The lower bound of "sdk: \'>=2.1.0 <3.0.0\'" must be 2.12.0 or higher.',
);

void main() {
  test('parses a successful structured_output envelope', () async {
    final service = FailureDiagnosisService(
      invoker: (args) async => jsonEncode({
        'structured_output': {
          'category': 'sdkMismatch',
          'summary': 'Pre-null-safety SDK constraint.',
          'suggestedFix': "Update the sdk constraint to '>=2.12.0 <4.0.0'.",
        },
      }),
    );

    final diagnosis = await service.diagnose(_failedStep);

    expect(diagnosis, isNotNull);
    expect(diagnosis!.category, core.FailureDiagnosisCategory.sdkMismatch);
    expect(diagnosis.summary, 'Pre-null-safety SDK constraint.');
  });

  test('passes the failed step name and output in the prompt', () async {
    String? capturedPrompt;
    final service = FailureDiagnosisService(
      invoker: (args) async {
        capturedPrompt = args[args.indexOf('-p') + 1];
        return jsonEncode({
          'structured_output': {
            'category': 'codeBreak',
            'summary': 'x',
            'suggestedFix': 'y',
          },
        });
      },
    );

    await service.diagnose(_failedStep);

    expect(capturedPrompt, contains('pub_get'));
    expect(capturedPrompt, contains('must be 2.12.0 or higher'));
  });

  test('disables tool access and requests a JSON schema', () async {
    List<String>? capturedArgs;
    final service = FailureDiagnosisService(
      invoker: (args) async {
        capturedArgs = args;
        return jsonEncode({
          'structured_output': {
            'category': 'codeBreak',
            'summary': 'x',
            'suggestedFix': 'y',
          },
        });
      },
    );

    await service.diagnose(_failedStep);

    expect(capturedArgs, isNotNull);
    final toolsIndex = capturedArgs!.indexOf('--tools');
    expect(capturedArgs![toolsIndex + 1], '');
    expect(capturedArgs, contains('--json-schema'));
    expect(capturedArgs, contains('--no-session-persistence'));
  });

  test('returns null when structured_output is missing, not throws', () async {
    final service = FailureDiagnosisService(
      invoker: (args) async => jsonEncode({'result': 'no schema used'}),
    );
    expect(await service.diagnose(_failedStep), isNull);
  });

  test('returns null when the CLI output is not valid JSON', () async {
    final service = FailureDiagnosisService(
      invoker: (args) async => 'not json at all',
    );
    expect(await service.diagnose(_failedStep), isNull);
  });

  test('returns null when the invoker throws', () async {
    final service = FailureDiagnosisService(
      invoker: (args) async => throw Exception('claude: command not found'),
    );
    expect(await service.diagnose(_failedStep), isNull);
  });

  test('returns null when the invoker hangs past the timeout', () async {
    final service = FailureDiagnosisService(
      timeout: const Duration(milliseconds: 50),
      invoker: (args) async {
        await Future<void>.delayed(const Duration(seconds: 2));
        return '{}';
      },
    );
    expect(await service.diagnose(_failedStep), isNull);
  });
}
