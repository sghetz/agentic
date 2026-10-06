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
  late Directory tmp;
  late String remotePath;

  setUp(() async {
    ctx = buildTestContext();
    handler = buildHandler(ctx);
    orgId = await createOrg(handler);

    tmp = await Directory.systemTemp.createTemp(
      'agentic_healthcheck_route_test_',
    );
    remotePath = '${tmp.path}/remote.git';
    await _git(['init', '--bare', remotePath]);

    final seedPath = '${tmp.path}/seed';
    await _git(['clone', remotePath, seedPath]);
    await File(
      '$seedPath/README.md',
    ).writeAsString('not actually a Flutter project');
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

  Future<String> createProjectWithRepo(String slug) async {
    final (status, body) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects',
      json: {
        'name': slug,
        'slug': slug,
        'repos': [
          {'url': remotePath, 'defaultBranch': 'main', 'path': ''},
        ],
      },
    );
    expect(status, 201);
    return (body! as Map)['id'] as String;
  }

  test(
    'POST .../health-check clones, runs the pipeline, and stores a project artifact',
    () async {
      final projectId = await createProjectWithRepo('checked');

      final (status, artifact) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$projectId/health-check',
      );

      expect(status, 201);
      final map = artifact! as Map;
      expect(map['kind'], 'healthReport');
      expect(map['projectId'], projectId);
      expect(map['taskId'], isNull);
      expect(map['content'], isNotNull);
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test('404s for an unknown project', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/no-such-project/health-check',
    );
    expect(status, 404);
  });

  test('400s when the project has no repo configured', () async {
    final projectId = await createProject(handler, orgId, slug: 'no-repo');
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/health-check',
    );
    expect(status, 400);
  });

  test(
    'POST /orgs/<orgId>/health-check runs every project with a repo',
    () async {
      await createProjectWithRepo('a');
      await createProject(handler, orgId, slug: 'b-no-repo');

      final (status, body) = await send(
        handler,
        'POST',
        '/orgs/$orgId/health-check',
      );

      expect(status, 200);
      final list = body! as List;
      expect(list, hasLength(1)); // only the project with a repo gets checked
      expect((list.single as Map)['kind'], 'healthReport');
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test('GET .../health-reports lists reports newest first', () async {
    final projectId = await createProjectWithRepo('history');

    await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/health-check',
    );
    await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/health-check',
    );

    final (status, body) = await send(
      handler,
      'GET',
      '/orgs/$orgId/projects/$projectId/health-reports',
    );

    expect(status, 200);
    final list = body! as List;
    expect(list, hasLength(2));
    expect((list.first as Map)['version'], 2); // newest first
  }, timeout: const Timeout(Duration(minutes: 2)));

  group('health-fix', () {
    test('400s when there is no health report yet', () async {
      final projectId = await createProjectWithRepo('no-report-yet');
      final (status, _) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$projectId/health-fix',
      );
      expect(status, 400);
    });

    test('404s for an unknown project', () async {
      final (status, _) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/no-such-project/health-fix',
      );
      expect(status, 404);
    });

    test(
      'attempts a fix once a health report exists, and the test context never calls the real CLI',
      () async {
        final projectId = await createProjectWithRepo('fixable');
        final (checkStatus, _) = await send(
          handler,
          'POST',
          '/orgs/$orgId/projects/$projectId/health-check',
        );
        expect(checkStatus, 201);

        final (status, body) = await send(
          handler,
          'POST',
          '/orgs/$orgId/projects/$projectId/health-fix',
        );

        // The seeded repo's health-check fails with no diagnosis attached
        // (the default test context's diagnosis invoker returns `{}`), so
        // there's nothing to act on -- this still proves the route wires
        // through to the service without ever shelling out to `claude`.
        expect(status, 400);
        expect((body! as Map)['error'], contains('no diagnosis'));
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
