import 'dart:convert';
import 'dart:io';

import 'package:server/src/app_context.dart';
import 'package:server/src/config.dart';
import 'package:server/src/repositories/registry_store.dart';
import 'package:server/src/services/analyst_extraction_service.dart';
import 'package:server/src/services/claude_conversation_service.dart';
import 'package:server/src/services/connector_oauth_service.dart';
import 'package:server/src/services/connector_registry.dart';
import 'package:server/src/services/creative_extraction_service.dart';
import 'package:server/src/services/developer_service.dart';
import 'package:server/src/services/failure_diagnosis_service.dart';
import 'package:server/src/services/flutter_version_detector.dart';
import 'package:server/src/services/git_service.dart';
import 'package:server/src/services/github_service.dart';
import 'package:server/src/services/health_check_service.dart';
import 'package:server/src/services/health_runner.dart';
import 'package:server/src/services/keychain_service.dart';
import 'package:server/src/services/message_routing_service.dart';
import 'package:server/src/services/onboarding_service.dart';
import 'package:server/src/services/review_service.dart';
import 'package:server/src/services/trivial_fix_service.dart';
import 'package:server/src/storage/org_database.dart';
import 'package:server/src/storage/registry_database.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

/// An in-memory fake for the `security` CLI -- never touches the real
/// macOS Keychain. Good enough to round-trip `KeychainService`'s three
/// operations for tests that don't care about real Keychain behavior
/// (that's covered directly in `keychain_service_test.dart`).
SecurityProcessRunner _inMemoryKeychain() {
  final store = <String, String>{};
  return (executable, args) async {
    final account = args[args.indexOf('-a') + 1];
    final service = args[args.indexOf('-s') + 1];
    final key = '$service|$account';
    switch (args.first) {
      case 'add-generic-password':
        store[key] = args[args.indexOf('-w') + 1];
        return ProcessResult(0, 0, '', '');
      case 'find-generic-password':
        final value = store[key];
        return value == null
            ? ProcessResult(0, 44, '', 'not found')
            : ProcessResult(0, 0, value, '');
      case 'delete-generic-password':
        store.remove(key);
        return ProcessResult(0, 0, '', '');
      default:
        return ProcessResult(0, 1, '', 'unknown security action');
    }
  };
}

AppContext buildTestContext({
  ClaudeConversationService? conversationService,
  AnalystExtractionService? analystExtractionService,
  MessageRoutingService? routingService,
  CreativeExtractionService? creativeExtractionService,
  DeveloperService? developerService,
  ReviewService? reviewService,
  GitHubService? githubService,
  ConnectorOAuthService? connectorOAuthService,
  ConnectorRegistry? connectorRegistry,
  AgenticPaths? paths,
}) {
  // A test that builds its own custom developerService/reviewService (which
  // each need an AgenticPaths) must pass that *same* instance here too --
  // ctx.paths is used directly by routes like pr-checks/approve, and a
  // mismatched second instance points at a directory nothing ever wrote to.
  if (paths == null) {
    final tempDir = Directory.systemTemp.createTempSync('agentic_test_');
    paths = AgenticPaths('${tempDir.path}/data', '${tempDir.path}/repos');
  }
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
    // Never calls the real `claude` CLI or `gh`/`git push` in tests, and
    // never actually edits anything -- returns no changes, so every test
    // run safely discards the worktree it creates. Tests that care about
    // Developer behavior inject their own `developerService` directly.
    developerService:
        developerService ??
        DeveloperService(
          paths: paths,
          gitService: gitService,
          githubService: const GitHubService(),
          runner: const HealthRunner(),
          invoker: (_, {required workingDirectory}) async =>
              jsonEncode({'result': 'no changes made'}),
        ),
    // Never calls the real `claude` CLI in tests. Only reached when a test
    // actually sets up a worktree first (otherwise `review()` throws
    // `NoWorktreeFound` before ever invoking Claude). Tests that care about
    // Review behavior inject their own `reviewService` directly.
    reviewService:
        reviewService ??
        ReviewService(
          paths: paths,
          gitService: gitService,
          githubService: const GitHubService(),
          runner: const HealthRunner(),
          invoker: (_, {required workingDirectory}) async => jsonEncode({
            'structured_output': {
              'summary': 'no review performed',
              'acceptanceCriteriaMet': <String>[],
              'acceptanceCriteriaUnmet': <String>[],
              'requirementIdsCovered': <String>[],
              'requirementIdsMissing': <String>[],
              'codeQualityIssues': <String>[],
              'missingTests': <String>[],
            },
          }),
        ),
    // Used directly by the pr-checks/approve routes (not just nested inside
    // developerService/reviewService) -- tests that exercise those routes
    // must pass the *same* fake instance here too.
    githubService: githubService ?? const GitHubService(),
    connectorRegistry: connectorRegistry ?? ConnectorRegistry(),
    // Never hits a real OAuth provider: the default empty registry means
    // beginConnect/completeConnect throw UnknownConnector before any HTTP
    // call happens. Tests that care about a real connector flow inject
    // their own `connectorOAuthService` (with a fake http.Client) and
    // matching `connectorRegistry` directly.
    connectorOAuthService:
        connectorOAuthService ??
        ConnectorOAuthService(
          registry: connectorRegistry ?? ConnectorRegistry(),
          keychain: KeychainService(runner: _inMemoryKeychain()),
          redirectUri: 'http://127.0.0.1:8787/connectors/callback',
        ),
    paths: paths,
    // Never calls the real `claude` CLI in tests. Tests that care about
    // chat-reply behavior pass their own `conversationService`.
    conversationService:
        conversationService ??
        ClaudeConversationService(
          invoker: (_, {required workingDirectory}) => const Stream.empty(),
        ),
    // Never calls the real `claude` CLI in tests. Tests that care about
    // extraction content pass their own `analystExtractionService`.
    analystExtractionService:
        analystExtractionService ??
        AnalystExtractionService(invoker: (_) async => '{}'),
    // Never calls the real `claude` CLI in tests. Tests that care about
    // routing content pass their own `routingService`.
    routingService:
        routingService ?? MessageRoutingService(invoker: (_) async => '{}'),
    // Never calls the real `claude` CLI in tests. Tests that care about
    // generation content pass their own `creativeExtractionService`.
    creativeExtractionService:
        creativeExtractionService ??
        CreativeExtractionService(invoker: (_) async => '{}'),
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
