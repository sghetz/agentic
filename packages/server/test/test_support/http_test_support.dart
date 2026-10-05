import 'dart:convert';

import 'package:server/src/app_context.dart';
import 'package:server/src/repositories/registry_store.dart';
import 'package:server/src/storage/org_database.dart';
import 'package:server/src/storage/registry_database.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

AppContext buildTestContext() {
  return AppContext(
    registryStore: RegistryStore(RegistryDatabase.memory()),
    openOrgDatabase: (_) => OrgDatabase.memory(),
  );
}

/// Sends a request straight to a shelf [Handler] -- no socket needed.
Future<(int status, Object? body)> send(
  Handler handler,
  String method,
  String path, {
  Map<String, Object?>? json,
}) async {
  final request = Request(
    method,
    Uri.parse('http://localhost$path'),
    body: json == null ? null : jsonEncode(json),
    headers: json == null ? null : {'content-type': 'application/json'},
  );
  final response = await handler(request);
  final text = await response.readAsString();
  return (response.statusCode, text.isEmpty ? null : jsonDecode(text));
}

Future<String> createOrg(Handler handler, {String slug = 'org'}) async {
  final (status, body) = await send(
    handler,
    'POST',
    '/orgs',
    json: {'name': 'Org', 'slug': slug, 'type': 'employer'},
  );
  expect(status, 201);
  return (body! as Map)['id'] as String;
}

Future<String> createProject(
  Handler handler,
  String orgId, {
  String slug = 'proj',
}) async {
  final (status, body) = await send(
    handler,
    'POST',
    '/orgs/$orgId/projects',
    json: {'name': 'Project', 'slug': slug},
  );
  expect(status, 201);
  return (body! as Map)['id'] as String;
}

Future<String> createTask(
  Handler handler,
  String orgId,
  String projectId, {
  String title = 'Task',
}) async {
  final (status, body) = await send(
    handler,
    'POST',
    '/orgs/$orgId/projects/$projectId/tasks',
    json: {'title': title},
  );
  expect(status, 201);
  return (body! as Map)['id'] as String;
}
