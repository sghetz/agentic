import 'dart:io';

import 'package:server/src/app_context.dart';
import 'package:server/src/server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../test_support/http_test_support.dart';

Future<void> _git(List<String> args, {String? cwd}) async {
  final result = await Process.run('git', args, workingDirectory: cwd);
  if (result.exitCode != 0) {
    fail('git ${args.join(' ')} failed: ${result.stderr}');
  }
}

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

  group('onboarding', () {
    late Directory tmp;
    late String remotePath;

    setUp(() async {
      tmp = await Directory.systemTemp.createTemp(
        'agentic_onboard_route_test_',
      );
      remotePath = '${tmp.path}/remote.git';
      await _git(['init', '--bare', remotePath]);

      final seedPath = '${tmp.path}/seed';
      await _git(['clone', remotePath, seedPath]);
      await File('$seedPath/README.md').writeAsString('hello');
      await _git(['add', '.'], cwd: seedPath);
      await _git([
        '-c',
        'user.email=test@example.com',
        '-c',
        'user.name=Test',
        'commit',
        '-m',
        'initial',
      ], cwd: seedPath);
      await _git(['push', 'origin', 'HEAD:main'], cwd: seedPath);
    });

    tearDown(() async {
      await tmp.delete(recursive: true);
    });

    test('clones the configured repo and updates the project', () async {
      final (createStatus, created) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects',
        json: {
          'name': 'Onboarded',
          'slug': 'onboarded',
          'repos': [
            {'url': remotePath, 'defaultBranch': 'main', 'path': ''},
          ],
        },
      );
      expect(createStatus, 201);
      final projectId = (created! as Map)['id'] as String;

      final (status, onboarded) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$projectId/onboard',
        json: const {},
      );

      expect(status, 200);
      final repos = (onboarded! as Map)['repos'] as List;
      expect((repos.single as Map)['path'], contains('onboarded'));
    });

    test('404s for an unknown project', () async {
      final (status, _) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/no-such-project/onboard',
        json: const {},
      );
      expect(status, 404);
    });

    test('400s when the project has no repo configured', () async {
      final projectId = await createProject(handler, orgId, slug: 'no-repo');
      final (status, _) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$projectId/onboard',
        json: const {},
      );
      expect(status, 400);
    });
  });
}
