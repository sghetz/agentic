import 'package:server/src/app_context.dart';
import 'package:server/src/server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../test_support/http_test_support.dart';

void main() {
  late AppContext ctx;
  late Handler handler;
  late String orgId;

  setUp(() async {
    ctx = buildTestContext();
    handler = buildHandler(ctx);
    orgId = await createOrg(handler);
  });

  test('POST then GET a project round trips', () async {
    final projectId = await createProject(handler, orgId);
    final (status, project) = await send(
      handler,
      'GET',
      '/orgs/$orgId/projects/$projectId',
    );
    expect(status, 200);
    expect((project! as Map)['slug'], 'proj');
  });

  test('projects routes 404 under an unknown org', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/no-such-org/projects',
    );
    expect(status, 404);
  });

  test('PATCH updates and POST .../archive archives', () async {
    final projectId = await createProject(handler, orgId);

    final (patchStatus, patched) = await send(
      handler,
      'PATCH',
      '/orgs/$orgId/projects/$projectId',
      json: {'name': 'Renamed'},
    );
    expect(patchStatus, 200);
    expect((patched! as Map)['name'], 'Renamed');

    final (archiveStatus, archived) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/archive',
      json: const {},
    );
    expect(archiveStatus, 200);
    expect((archived! as Map)['status'], 'archived');

    final (listStatus, list) = await send(
      handler,
      'GET',
      '/orgs/$orgId/projects',
    );
    expect(listStatus, 200);
    expect(list! as List, isEmpty);
  });

  group('project links', () {
    test('POST creates a link, GET lists it, DELETE removes it', () async {
      final a = await createProject(handler, orgId, slug: 'a');
      final b = await createProject(handler, orgId, slug: 'b');

      final (createStatus, link) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$a/links',
        json: {'toProjectId': b, 'relation': 'dependsOn'},
      );
      expect(createStatus, 201);
      final linkId = (link! as Map)['id'] as String;

      final (listStatus, list) = await send(
        handler,
        'GET',
        '/orgs/$orgId/projects/$a/links',
      );
      expect(listStatus, 200);
      expect((list! as List), hasLength(1));

      final (deleteStatus, _) = await send(
        handler,
        'DELETE',
        '/orgs/$orgId/projects/$a/links/$linkId',
      );
      expect(deleteStatus, 204);
    });

    test('linking to an unknown project id returns 404', () async {
      final a = await createProject(handler, orgId);
      final (status, _) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$a/links',
        json: {'toProjectId': 'unknown', 'relation': 'related'},
      );
      expect(status, 404);
    });
  });
}
