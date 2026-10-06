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

  test(
    'GET conversations creates the org-level general channel once',
    () async {
      final (status1, body1) = await send(
        handler,
        'GET',
        '/orgs/$orgId/conversations?channel=general',
      );
      expect(status1, 200);
      final id1 = (body1! as Map)['id'];

      final (status2, body2) = await send(
        handler,
        'GET',
        '/orgs/$orgId/conversations?channel=general',
      );
      expect(status2, 200);
      expect((body2! as Map)['id'], id1);
    },
  );

  test('a project-scoped channel is distinct from the org-level one', () async {
    final (_, orgBody) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations?channel=general',
    );
    final (_, projectBody) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations?channel=general&projectId=$projectId',
    );

    final projectMap = projectBody! as Map;
    expect((orgBody! as Map)['id'], isNot(projectMap['id']));
    expect(projectMap['projectId'], projectId);
  });

  test('missing channel query parameter is a 400', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations',
    );
    expect(status, 400);
  });

  test('an unknown projectId is a 404', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations?channel=general&projectId=no-such-project',
    );
    expect(status, 404);
  });

  test('posting then listing messages round trips', () async {
    final (_, convBody) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations?channel=agent:health',
    );
    final conversationId = (convBody! as Map)['id'] as String;

    final (postStatus, postBody) = await send(
      handler,
      'POST',
      '/orgs/$orgId/conversations/$conversationId/messages',
      json: {'content': 'is this project healthy?'},
    );
    expect(postStatus, 201);
    expect((postBody! as Map)['sender'], 'user');

    final (listStatus, listBody) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations/$conversationId/messages',
    );
    expect(listStatus, 200);
    expect((listBody! as List), hasLength(1));
  });

  test('messages for an unknown conversation return 404', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations/no-such-conversation/messages',
    );
    expect(status, 404);
  });
}
