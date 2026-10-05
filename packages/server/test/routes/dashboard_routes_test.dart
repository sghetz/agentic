import 'package:server/src/app_context.dart';
import 'package:server/src/server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../test_support/http_test_support.dart';

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
    expect((orgs.single as Map)['recentActivity'], isEmpty);
  });
}
