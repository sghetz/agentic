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

  test('POST creates an artifact starting at version 1', () async {
    final (status, artifact) = await send(
      handler,
      'POST',
      '/orgs/$orgId/tasks/$taskId/artifacts',
      json: {'kind': 'diagram', 'uri': 'file://diagram.mmd'},
    );
    expect(status, 201);
    expect((artifact! as Map)['version'], 1);
  });

  test('a second artifact of the same kind gets version 2', () async {
    await send(
      handler,
      'POST',
      '/orgs/$orgId/tasks/$taskId/artifacts',
      json: {'kind': 'diagram', 'uri': 'file://v1.mmd'},
    );
    final (status, artifact) = await send(
      handler,
      'POST',
      '/orgs/$orgId/tasks/$taskId/artifacts',
      json: {'kind': 'diagram', 'uri': 'file://v2.mmd'},
    );
    expect(status, 201);
    expect((artifact! as Map)['version'], 2);
  });

  test('GET lists artifacts for a task', () async {
    await send(
      handler,
      'POST',
      '/orgs/$orgId/tasks/$taskId/artifacts',
      json: {'kind': 'pr', 'uri': 'https://pr/1'},
    );
    final (status, artifacts) = await send(
      handler,
      'GET',
      '/orgs/$orgId/tasks/$taskId/artifacts',
    );
    expect(status, 200);
    expect((artifacts! as List), hasLength(1));
  });

  test('POST under an unknown task returns 404', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/tasks/no-such-task/artifacts',
      json: {'kind': 'pr', 'uri': 'https://pr/1'},
    );
    expect(status, 404);
  });
}
