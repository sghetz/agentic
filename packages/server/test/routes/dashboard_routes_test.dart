import 'dart:convert';

import 'package:server/src/app_context.dart';
import 'package:server/src/server.dart';
import 'package:server/src/services/analyst_extraction_service.dart';
import 'package:server/src/services/message_routing_service.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../test_support/http_test_support.dart';

const _structuredOutput = {
  'structured_output': {
    'goal': 'x',
    'requirementIds': <String>[],
    'acceptanceCriteria': <String>[],
    'affectedAreas': <String>[],
    'priority': 'low',
    'openQuestions': <String>[],
  },
};

void main() {
  late AppContext ctx;
  late Handler handler;

  setUp(() {
    ctx = buildTestContext();
    handler = buildHandler(ctx);
  });

  test(
    'aggregates counts and recent activity per org without mixing them',
    () async {
      final orgA = await createOrg(handler, slug: 'org-a');
      final projectA = await createProject(handler, orgA);
      await createTask(handler, orgA, projectA, title: 'A1');
      await createTask(handler, orgA, projectA, title: 'A2');

      final orgB = await createOrg(handler, slug: 'org-b');
      final projectB = await createProject(handler, orgB);
      await createTask(handler, orgB, projectB, title: 'B1');

      final (status, dashboard) = await send(handler, 'GET', '/dashboard');
      expect(status, 200);

      final orgs = (dashboard! as Map)['orgs'] as List;
      final summaryA =
          orgs.singleWhere((o) => (o as Map)['orgId'] == orgA) as Map;
      final summaryB =
          orgs.singleWhere((o) => (o as Map)['orgId'] == orgB) as Map;

      expect((summaryA['taskCountsByStatus'] as Map)['newTask'], 2);
      expect((summaryB['taskCountsByStatus'] as Map)['newTask'], 1);

      final activityA = summaryA['recentActivity'] as List;
      expect(
        activityA.map((e) => (e as Map)['taskTitle']),
        containsAll(['A1', 'A2']),
      );
      expect(
        activityA.map((e) => (e as Map)['taskTitle']),
        isNot(contains('B1')),
      );
    },
  );

  test('an org with no activity yet still appears with zero counts', () async {
    await createOrg(handler, slug: 'empty-org');
    final (status, dashboard) = await send(handler, 'GET', '/dashboard');
    expect(status, 200);
    final orgs = (dashboard! as Map)['orgs'] as List;
    expect(orgs, hasLength(1));
    final summary = orgs.single as Map;
    expect(summary['recentActivity'], isEmpty);
    expect(summary['unroutedMessageCount'], 0);
    expect(summary['draftTaskSpecCount'], 0);
  });

  test(
    'includes unroutedMessageCount and draftTaskSpecCount for the morning briefing',
    () async {
      // projectId isn't known until after the org/project are created, but
      // the routing fake needs to reference it -- route through a mutable
      // holder so the same context can be built up front.
      String? routedProjectId;
      final briefingCtx = buildTestContext(
        analystExtractionService: AnalystExtractionService(
          invoker: (_) async => jsonEncode(_structuredOutput),
        ),
        routingService: MessageRoutingService(
          invoker: (_) async => jsonEncode({
            'structured_output': {
              'projectId': routedProjectId,
              'confidence': 0.1,
            },
          }),
        ),
      );
      final briefingHandler = buildHandler(briefingCtx);
      final orgId = await createOrg(briefingHandler, slug: 'briefing-org');
      final projectId = await createProject(briefingHandler, orgId);
      routedProjectId = projectId;

      // One drafted Task Spec (via the manual-trigger route from slice 1).
      await send(
        briefingHandler,
        'POST',
        '/orgs/$orgId/projects/$projectId/task-specs/extract',
        json: {'rawText': 'something'},
      );

      // One message that stays unrouted (low confidence, from an org-level
      // WhatsApp source).
      final (_, sourceBody) = await send(
        briefingHandler,
        'POST',
        '/orgs/$orgId/sources',
        json: {'kind': 'whatsappImport'},
      );
      final sourceId = (sourceBody! as Map)['id'] as String;
      await send(
        briefingHandler,
        'POST',
        '/orgs/$orgId/sources/$sourceId/import-whatsapp',
        json: {'exportText': '[1/3/26, 09:15:00] Alice: hello'},
      );

      final (status, dashboard) = await send(
        briefingHandler,
        'GET',
        '/dashboard',
      );
      expect(status, 200);
      final orgs = (dashboard! as Map)['orgs'] as List;
      final summary =
          orgs.singleWhere((o) => (o as Map)['orgId'] == orgId) as Map;

      expect(summary['draftTaskSpecCount'], 1);
      expect(summary['unroutedMessageCount'], 1);
    },
  );
}
