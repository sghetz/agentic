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

  test('POST /orgs creates, GET /orgs lists it', () async {
    final (createStatus, created) = await send(
      handler,
      'POST',
      '/orgs',
      json: {'name': 'Employer', 'slug': 'employer', 'type': 'employer'},
    );
    expect(createStatus, 201);
    expect((created! as Map)['slug'], 'employer');

    final (listStatus, list) = await send(handler, 'GET', '/orgs');
    expect(listStatus, 200);
    expect(
      (list! as List).map((o) => (o as Map)['slug']),
      contains('employer'),
    );
  });

  test('GET /orgs/<id> returns 404 for an unknown id', () async {
    final (status, _) = await send(handler, 'GET', '/orgs/does-not-exist');
    expect(status, 404);
  });

  test('PATCH /orgs/<id> updates fields', () async {
    final orgId = await createOrg(handler);
    final (status, updated) = await send(
      handler,
      'PATCH',
      '/orgs/$orgId',
      json: {'name': 'New Name'},
    );
    expect(status, 200);
    expect((updated! as Map)['name'], 'New Name');
  });

  test('POST /orgs with a duplicate slug returns 409', () async {
    await createOrg(handler, slug: 'dup');
    final (status, body) = await send(
      handler,
      'POST',
      '/orgs',
      json: {'name': 'Other', 'slug': 'dup', 'type': 'personal'},
    );
    expect(status, 409);
    expect(body, isNotNull);
  });
}
