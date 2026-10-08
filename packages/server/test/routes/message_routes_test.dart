import 'dart:convert';

import 'package:server/src/app_context.dart';
import 'package:server/src/server.dart';
import 'package:server/src/services/analyst_extraction_service.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../test_support/http_test_support.dart';

const _structuredOutput = {
  'structured_output': {
    'goal': 'Fix the export bug',
    'requirementIds': <String>[],
    'acceptanceCriteria': <String>[],
    'affectedAreas': <String>[],
    'priority': 'medium',
    'openQuestions': <String>[],
  },
};

void main() {
  late AppContext ctx;
  late Handler handler;
  late String orgId;
  late String projectId;
  late String sourceId;
  late String messageId;

  setUp(() async {
    ctx = buildTestContext(
      analystExtractionService: AnalystExtractionService(
        invoker: (_) async => jsonEncode(_structuredOutput),
      ),
    );
    handler = buildHandler(ctx);
    orgId = await createOrg(handler);
    projectId = await createProject(handler, orgId);

    final (_, sourceBody) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources',
      json: {'kind': 'whatsappImport'},
    );
    sourceId = (sourceBody! as Map)['id'] as String;

    final (_, importBody) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources/$sourceId/import-whatsapp',
      json: {'exportText': '[1/3/26, 09:15:00] Alice: hey whats up'},
    );
    final importResult = importBody! as Map;
    expect(importResult['unroutedMessages'], 1);

    final (_, messagesBody) = await send(
      handler,
      'GET',
      '/orgs/$orgId/sources/$sourceId/messages',
    );
    messageId = ((messagesBody! as List).single as Map)['id'] as String;
  });

  test('GET .../messages/unrouted lists the unrouted message', () async {
    final (status, body) = await send(
      handler,
      'GET',
      '/orgs/$orgId/messages/unrouted',
    );

    expect(status, 200);
    final messages = body! as List;
    expect(messages, hasLength(1));
    expect((messages.single as Map)['id'], messageId);
  });

  test('POST .../assign sets the project and drafts a Task Spec', () async {
    final (status, body) = await send(
      handler,
      'POST',
      '/orgs/$orgId/messages/$messageId/assign',
      json: {'projectId': projectId},
    );

    expect(status, 200);
    final map = body! as Map;
    expect(map['routedProjectId'], projectId);
    expect(map['processedAt'], isNotNull);

    final (_, unroutedBody) = await send(
      handler,
      'GET',
      '/orgs/$orgId/messages/unrouted',
    );
    expect((unroutedBody! as List), isEmpty);

    final (_, specsBody) = await send(
      handler,
      'GET',
      '/orgs/$orgId/projects/$projectId/task-specs',
    );
    expect((specsBody! as List), hasLength(1));
  });

  test('assigning an unknown message is a 404', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/messages/no-such-message/assign',
      json: {'projectId': projectId},
    );
    expect(status, 404);
  });

  test('assigning to an unknown project is a 404', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/messages/$messageId/assign',
      json: {'projectId': 'no-such-project'},
    );
    expect(status, 404);
  });

  test('projectId is required', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/messages/$messageId/assign',
      json: const {},
    );
    expect(status, 400);
  });

  test(
    'assigning an already-processed message does not draft a second spec',
    () async {
      await send(
        handler,
        'POST',
        '/orgs/$orgId/messages/$messageId/assign',
        json: {'projectId': projectId},
      );

      // Re-assign (e.g. the owner picks a different project for it).
      final project2 = await createProject(handler, orgId, slug: 'proj-2');
      await send(
        handler,
        'POST',
        '/orgs/$orgId/messages/$messageId/assign',
        json: {'projectId': project2},
      );

      final (_, specsBody1) = await send(
        handler,
        'GET',
        '/orgs/$orgId/projects/$projectId/task-specs',
      );
      final (_, specsBody2) = await send(
        handler,
        'GET',
        '/orgs/$orgId/projects/$project2/task-specs',
      );
      expect((specsBody1! as List), hasLength(1));
      expect((specsBody2! as List), isEmpty);
    },
  );
}
