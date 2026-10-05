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
  late String taskId;

  setUp(() async {
    ctx = buildTestContext();
    handler = buildHandler(ctx);
    orgId = await createOrg(handler);
    projectId = await createProject(handler, orgId);
    taskId = await createTask(handler, orgId, projectId);
  });

  test('a comment event is appended without changing status', () async {
    final (status, event) = await send(
      handler,
      'POST',
      '/orgs/$orgId/tasks/$taskId/events',
      json: {
        'actor': 'agent:developer',
        'eventType': 'commented',
        'payload': {'text': 'opened a PR'},
      },
    );
    expect(status, 201);
    expect((event! as Map)['actor'], 'agent:developer');

    final (eventsStatus, events) = await send(
      handler,
      'GET',
      '/orgs/$orgId/tasks/$taskId/events',
    );
    expect(eventsStatus, 200);
    expect((events! as List), hasLength(2)); // created + commented
  });

  test('reopened is rejected unless the task is done', () async {
    final (status, body) = await send(
      handler,
      'POST',
      '/orgs/$orgId/tasks/$taskId/events',
      json: {
        'actor': 'user',
        'eventType': 'reopened',
        'payload': <String, Object?>{},
      },
    );
    expect(status, 409);
    expect(body, isNotNull);
  });

  test('events for an unknown task return 404', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/$orgId/tasks/no-such-task/events',
    );
    expect(status, 404);
  });
}
