import 'package:server/src/app_context.dart';
import 'package:server/src/server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../test_support/http_test_support.dart';

void main() {
  late AppContext ctx;
  late Handler handler;
  late String orgId;
  late String projectId;

  setUp(() async {
    ctx = buildTestContext();
    handler = buildHandler(ctx);
    orgId = await createOrg(handler);
    projectId = await createProject(handler, orgId);
  });

  test('POST creates a task starting at newTask', () async {
    final (status, task) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/tasks',
      json: {'title': 'Fix the thing'},
    );
    expect(status, 201);
    expect((task! as Map)['currentStatus'], 'newTask');
  });

  test('GET a single task by id', () async {
    final taskId = await createTask(handler, orgId, projectId);
    final (status, task) = await send(
      handler,
      'GET',
      '/orgs/$orgId/tasks/$taskId',
    );
    expect(status, 200);
    expect((task! as Map)['id'], taskId);
  });

  test('GET with an unknown status query param returns 400', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/$orgId/projects/$projectId/tasks?status=bogus',
    );
    expect(status, 400);
  });

  test(
    'posting a statusChanged event updates the task and is reflected via GET',
    () async {
      final taskId = await createTask(handler, orgId, projectId);

      final (eventStatus, _) = await send(
        handler,
        'POST',
        '/orgs/$orgId/tasks/$taskId/events',
        json: {
          'actor': 'user',
          'eventType': 'statusChanged',
          'payload': {'to': 'specified'},
        },
      );
      expect(eventStatus, 201);

      final (getStatus, task) = await send(
        handler,
        'GET',
        '/orgs/$orgId/tasks/$taskId',
      );
      expect(getStatus, 200);
      expect((task! as Map)['currentStatus'], 'specified');
    },
  );

  test(
    'an illegal transition returns 409 with the allowed transitions',
    () async {
      final taskId = await createTask(handler, orgId, projectId);

      final (status, body) = await send(
        handler,
        'POST',
        '/orgs/$orgId/tasks/$taskId/events',
        json: {
          'actor': 'user',
          'eventType': 'statusChanged',
          'payload': {'to': 'done'},
        },
      );
      expect(status, 409);
      expect((body! as Map)['allowed'], isNotEmpty);
    },
  );

  test('GET /orgs/<orgId>/tasks/<taskId>/events lists the event log', () async {
    final taskId = await createTask(handler, orgId, projectId);
    final (status, events) = await send(
      handler,
      'GET',
      '/orgs/$orgId/tasks/$taskId/events',
    );
    expect(status, 200);
    final list = events! as List;
    expect(list, hasLength(1));
    expect((list.single as Map)['eventType'], 'created');
  });
}
