import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:server/src/services/creative_extraction_service.dart';
import 'package:test/test.dart';

const _taskSpec = core.TaskSpec(
  projectId: 'proj-1',
  goal: 'Let users reset their password via email',
  requirementIds: ['RF-07'],
  acceptanceCriteria: ['A reset link expires after 1 hour'],
  affectedAreas: ['Auth'],
  priority: core.TaskSpecPriority.high,
);

Map<String, Object?> _structuredOutput({
  String mermaid = 'flowchart TD\nA-->B',
}) => {
  'structured_output': {
    'screens': [
      {
        'name': 'Login',
        'purpose': 'Let the user sign in',
        'states': ['loading', 'error'],
        'navigatesTo': ['ResetPassword'],
      },
      {
        'name': 'ResetPassword',
        'purpose': 'Request a password reset email',
        'states': ['empty', 'loading', 'error', 'success'],
        'navigatesTo': <String>[],
      },
    ],
    'mermaid': mermaid,
  },
};

void main() {
  test('parses a successful structured_output envelope', () async {
    final service = CreativeExtractionService(
      invoker: (args) async => jsonEncode(_structuredOutput()),
    );

    final result = await service.generate(
      projectId: 'proj-1',
      taskSpec: _taskSpec,
    );

    expect(result, isNotNull);
    expect(result!.designSpec.projectId, 'proj-1');
    expect(result.designSpec.screens, hasLength(2));
    expect(result.designSpec.screens.first.name, 'Login');
    expect(result.designSpec.screens.first.navigatesTo, ['ResetPassword']);
    expect(result.mermaid, 'flowchart TD\nA-->B');
  });

  test('carries requirementIds over from the source Task Spec', () async {
    final service = CreativeExtractionService(
      invoker: (args) async => jsonEncode(_structuredOutput()),
    );

    final result = await service.generate(
      projectId: 'proj-1',
      taskSpec: _taskSpec,
    );

    expect(result!.designSpec.requirementIds, ['RF-07']);
  });

  test('passes the goal, requirements, and criteria in the prompt', () async {
    String? capturedPrompt;
    final service = CreativeExtractionService(
      invoker: (args) async {
        capturedPrompt = args[args.indexOf('-p') + 1];
        return jsonEncode(_structuredOutput());
      },
    );

    await service.generate(projectId: 'proj-1', taskSpec: _taskSpec);

    expect(capturedPrompt, contains('Let users reset their password'));
    expect(capturedPrompt, contains('RF-07'));
    expect(capturedPrompt, contains('expires after 1 hour'));
  });

  test('includes the design system reference when given', () async {
    String? capturedPrompt;
    final service = CreativeExtractionService(
      invoker: (args) async {
        capturedPrompt = args[args.indexOf('-p') + 1];
        return jsonEncode(_structuredOutput());
      },
    );

    await service.generate(
      projectId: 'proj-1',
      taskSpec: _taskSpec,
      designSystemRef: 'acme_design_system',
    );

    expect(capturedPrompt, contains('acme_design_system'));
  });

  test('omits any design system instruction when not given', () async {
    String? capturedPrompt;
    final service = CreativeExtractionService(
      invoker: (args) async {
        capturedPrompt = args[args.indexOf('-p') + 1];
        return jsonEncode(_structuredOutput());
      },
    );

    await service.generate(projectId: 'proj-1', taskSpec: _taskSpec);

    expect(capturedPrompt, isNot(contains('design system package')));
  });

  test('disables tool access and requests a JSON schema', () async {
    List<String>? capturedArgs;
    final service = CreativeExtractionService(
      invoker: (args) async {
        capturedArgs = args;
        return jsonEncode(_structuredOutput());
      },
    );

    await service.generate(projectId: 'proj-1', taskSpec: _taskSpec);

    final toolsIndex = capturedArgs!.indexOf('--tools');
    expect(capturedArgs![toolsIndex + 1], '');
    expect(capturedArgs, contains('--json-schema'));
    expect(capturedArgs, contains('--no-session-persistence'));
  });

  test('returns null when structured_output is missing, not throws', () async {
    final service = CreativeExtractionService(
      invoker: (args) async => jsonEncode({'result': 'no schema used'}),
    );
    expect(
      await service.generate(projectId: 'proj-1', taskSpec: _taskSpec),
      isNull,
    );
  });

  test(
    'returns null when mermaid is missing from the structured output',
    () async {
      final service = CreativeExtractionService(
        invoker: (args) async => jsonEncode({
          'structured_output': {'screens': <Object?>[]},
        }),
      );
      expect(
        await service.generate(projectId: 'proj-1', taskSpec: _taskSpec),
        isNull,
      );
    },
  );

  test('returns null when the CLI output is not valid JSON', () async {
    final service = CreativeExtractionService(
      invoker: (args) async => 'not json at all',
    );
    expect(
      await service.generate(projectId: 'proj-1', taskSpec: _taskSpec),
      isNull,
    );
  });

  test('returns null when the invoker throws', () async {
    final service = CreativeExtractionService(
      invoker: (args) async => throw Exception('claude: command not found'),
    );
    expect(
      await service.generate(projectId: 'proj-1', taskSpec: _taskSpec),
      isNull,
    );
  });

  test('returns null when the invoker hangs past the timeout', () async {
    final service = CreativeExtractionService(
      timeout: const Duration(milliseconds: 50),
      invoker: (args) async {
        await Future<void>.delayed(const Duration(seconds: 2));
        return '{}';
      },
    );
    expect(
      await service.generate(projectId: 'proj-1', taskSpec: _taskSpec),
      isNull,
    );
  });
}
