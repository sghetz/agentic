import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:server/src/services/analyst_extraction_service.dart';
import 'package:test/test.dart';

const _rawText =
    'We need a way for users to reset their password via email (RF-07). '
    'A reset link should expire after 1 hour.';

void main() {
  test('parses a successful structured_output envelope', () async {
    final service = AnalystExtractionService(
      invoker: (args) async => jsonEncode({
        'structured_output': {
          'goal': 'Let users reset their password via email',
          'requirementIds': ['RF-07'],
          'acceptanceCriteria': ['A reset link expires after 1 hour'],
          'affectedAreas': ['Auth'],
          'priority': 'high',
          'openQuestions': <String>[],
        },
      }),
    );

    final spec = await service.extract(projectId: 'proj-1', rawText: _rawText);

    expect(spec, isNotNull);
    expect(spec!.projectId, 'proj-1');
    expect(spec.goal, 'Let users reset their password via email');
    expect(spec.requirementIds, ['RF-07']);
    expect(spec.priority, core.TaskSpecPriority.high);
  });

  test(
    'injects the caller-supplied projectId, not anything from the model',
    () async {
      final service = AnalystExtractionService(
        invoker: (args) async => jsonEncode({
          'structured_output': {
            'goal': 'x',
            'requirementIds': <String>[],
            'acceptanceCriteria': <String>[],
            'affectedAreas': <String>[],
            'priority': 'low',
            'openQuestions': <String>[],
          },
        }),
      );

      final spec = await service.extract(projectId: 'proj-42', rawText: 'x');

      expect(spec!.projectId, 'proj-42');
    },
  );

  test('passes the raw text in the prompt', () async {
    String? capturedPrompt;
    final service = AnalystExtractionService(
      invoker: (args) async {
        capturedPrompt = args[args.indexOf('-p') + 1];
        return jsonEncode({
          'structured_output': {
            'goal': 'x',
            'requirementIds': <String>[],
            'acceptanceCriteria': <String>[],
            'affectedAreas': <String>[],
            'priority': 'low',
            'openQuestions': <String>[],
          },
        });
      },
    );

    await service.extract(projectId: 'proj-1', rawText: _rawText);

    expect(capturedPrompt, contains('RF-07'));
    expect(capturedPrompt, contains('expire after 1 hour'));
  });

  test('disables tool access and requests a JSON schema', () async {
    List<String>? capturedArgs;
    final service = AnalystExtractionService(
      invoker: (args) async {
        capturedArgs = args;
        return jsonEncode({
          'structured_output': {
            'goal': 'x',
            'requirementIds': <String>[],
            'acceptanceCriteria': <String>[],
            'affectedAreas': <String>[],
            'priority': 'low',
            'openQuestions': <String>[],
          },
        });
      },
    );

    await service.extract(projectId: 'proj-1', rawText: _rawText);

    expect(capturedArgs, isNotNull);
    final toolsIndex = capturedArgs!.indexOf('--tools');
    expect(capturedArgs![toolsIndex + 1], '');
    expect(capturedArgs, contains('--json-schema'));
    expect(capturedArgs, contains('--no-session-persistence'));
  });

  test('returns null when structured_output is missing, not throws', () async {
    final service = AnalystExtractionService(
      invoker: (args) async => jsonEncode({'result': 'no schema used'}),
    );
    expect(
      await service.extract(projectId: 'proj-1', rawText: _rawText),
      isNull,
    );
  });

  test('returns null when the CLI output is not valid JSON', () async {
    final service = AnalystExtractionService(
      invoker: (args) async => 'not json at all',
    );
    expect(
      await service.extract(projectId: 'proj-1', rawText: _rawText),
      isNull,
    );
  });

  test('returns null when the invoker throws', () async {
    final service = AnalystExtractionService(
      invoker: (args) async => throw Exception('claude: command not found'),
    );
    expect(
      await service.extract(projectId: 'proj-1', rawText: _rawText),
      isNull,
    );
  });

  test('returns null when the invoker hangs past the timeout', () async {
    final service = AnalystExtractionService(
      timeout: const Duration(milliseconds: 50),
      invoker: (args) async {
        await Future<void>.delayed(const Duration(seconds: 2));
        return '{}';
      },
    );
    expect(
      await service.extract(projectId: 'proj-1', rawText: _rawText),
      isNull,
    );
  });
}
