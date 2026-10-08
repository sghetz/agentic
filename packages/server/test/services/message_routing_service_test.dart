import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:server/src/services/message_routing_service.dart';
import 'package:test/test.dart';

final _projects = [
  core.Project(
    id: 'proj-1',
    name: 'Expense Manager',
    slug: 'expense-manager',
    repos: const [],
    status: core.ProjectStatus.active,
    createdAt: DateTime.utc(2026, 1, 1),
  ),
  core.Project(
    id: 'proj-2',
    name: 'Habit Tracker',
    slug: 'habit-tracker',
    repos: const [],
    status: core.ProjectStatus.active,
    createdAt: DateTime.utc(2026, 1, 1),
  ),
];

void main() {
  test('parses a successful structured_output envelope', () async {
    final service = MessageRoutingService(
      invoker: (args) async => jsonEncode({
        'structured_output': {'projectId': 'proj-1', 'confidence': 0.92},
      }),
    );

    final result = await service.route(
      messageBody: 'can we export expense reports as a PDF?',
      projects: _projects,
    );

    expect(result, isNotNull);
    expect(result!.projectId, 'proj-1');
    expect(result.confidence, 0.92);
  });

  test('lists every project with its id in the prompt', () async {
    String? capturedPrompt;
    final service = MessageRoutingService(
      invoker: (args) async {
        capturedPrompt = args[args.indexOf('-p') + 1];
        return jsonEncode({
          'structured_output': {'projectId': 'proj-1', 'confidence': 0.5},
        });
      },
    );

    await service.route(messageBody: 'x', projects: _projects);

    expect(capturedPrompt, contains('Expense Manager'));
    expect(capturedPrompt, contains('proj-1'));
    expect(capturedPrompt, contains('Habit Tracker'));
    expect(capturedPrompt, contains('proj-2'));
  });

  test('returns null when the model names a project not in the list', () async {
    final service = MessageRoutingService(
      invoker: (args) async => jsonEncode({
        'structured_output': {
          'projectId': 'proj-does-not-exist',
          'confidence': 0.9,
        },
      }),
    );

    final result = await service.route(messageBody: 'x', projects: _projects);
    expect(result, isNull);
  });

  test(
    'returns null when given no projects, without calling the invoker',
    () async {
      var invoked = false;
      final service = MessageRoutingService(
        invoker: (args) async {
          invoked = true;
          return '{}';
        },
      );

      final result = await service.route(messageBody: 'x', projects: const []);
      expect(result, isNull);
      expect(invoked, isFalse);
    },
  );

  test('returns null when structured_output is missing, not throws', () async {
    final service = MessageRoutingService(
      invoker: (args) async => jsonEncode({'result': 'no schema used'}),
    );
    expect(await service.route(messageBody: 'x', projects: _projects), isNull);
  });

  test('returns null when the CLI output is not valid JSON', () async {
    final service = MessageRoutingService(
      invoker: (args) async => 'not json at all',
    );
    expect(await service.route(messageBody: 'x', projects: _projects), isNull);
  });

  test('returns null when the invoker throws', () async {
    final service = MessageRoutingService(
      invoker: (args) async => throw Exception('claude: command not found'),
    );
    expect(await service.route(messageBody: 'x', projects: _projects), isNull);
  });

  test('returns null when the invoker hangs past the timeout', () async {
    final service = MessageRoutingService(
      timeout: const Duration(milliseconds: 50),
      invoker: (args) async {
        await Future<void>.delayed(const Duration(seconds: 2));
        return '{}';
      },
    );
    expect(await service.route(messageBody: 'x', projects: _projects), isNull);
  });

  test('disables tool access and requests a JSON schema', () async {
    List<String>? capturedArgs;
    final service = MessageRoutingService(
      invoker: (args) async {
        capturedArgs = args;
        return jsonEncode({
          'structured_output': {'projectId': 'proj-1', 'confidence': 0.5},
        });
      },
    );

    await service.route(messageBody: 'x', projects: _projects);

    final toolsIndex = capturedArgs!.indexOf('--tools');
    expect(capturedArgs![toolsIndex + 1], '');
    expect(capturedArgs, contains('--json-schema'));
    expect(capturedArgs, contains('--no-session-persistence'));
  });
}
