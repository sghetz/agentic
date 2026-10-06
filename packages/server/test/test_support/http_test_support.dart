import 'dart:convert';
import 'dart:io';

import 'package:server/src/app_context.dart';
import 'package:server/src/config.dart';
import 'package:server/src/repositories/registry_store.dart';
import 'package:server/src/services/failure_diagnosis_service.dart';
import 'package:server/src/services/flutter_version_detector.dart';
import 'package:server/src/services/git_service.dart';
import 'package:server/src/services/health_check_service.dart';
import 'package:server/src/services/health_runner.dart';
import 'package:server/src/services/onboarding_service.dart';
import 'package:server/src/services/trivial_fix_service.dart';
import 'package:server/src/storage/org_database.dart';
import 'package:server/src/storage/registry_database.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

AppContext buildTestContext() {
  final tempDir = Directory.systemTemp.createTempSync('agentic_test_');
  final paths = AgenticPaths('${tempDir.path}/data', '${tempDir.path}/repos');
  const gitService = GitService();
  const detector = FlutterVersionDetector();
  return AppContext(
    registryStore: RegistryStore(RegistryDatabase.memory()),
    openOrgDatabase: (_) => OrgDatabase.memory(),
    onboardingService: OnboardingService(
      paths: paths,
      gitService: gitService,
      detector: detector,
    ),
    healthCheckService: HealthCheckService(
      paths: paths,
      gitService: gitService,
      detector: detector,
      runner: const HealthRunner(),
      // Never calls the real `claude` CLI in tests: that costs real money
      // and adds several seconds per call. Tests that care about diagnosis
      // content inject their own fake invoker directly.
      diagnosisService: FailureDiagnosisService(invoker: (_) async => '{}'),
    ),
    // Never calls the real `claude` CLI in tests, and never actually edits
    // anything -- returns no changes, so every test run safely discards
    // the worktree it creates. Tests that care about fix behavior inject
    // their own fake invoker directly.
    trivialFixService: TrivialFixService(
      paths: paths,
      gitService: gitService,
      runner: const HealthRunner(),
      invoker: (_, {required workingDirectory}) async =>
          jsonEncode({'result': 'no changes made'}),
    ),
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
