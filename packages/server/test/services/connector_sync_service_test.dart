import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;
import 'package:http/testing.dart';
import 'package:server/src/repositories/org_store.dart';
import 'package:server/src/services/analyst_extraction_service.dart';
import 'package:server/src/services/connector_adapter.dart';
import 'package:server/src/services/connector_oauth_service.dart';
import 'package:server/src/services/connector_registry.dart';
import 'package:server/src/services/connector_sync_service.dart';
import 'package:server/src/services/keychain_service.dart';
import 'package:server/src/services/message_routing_service.dart';
import 'package:server/src/storage/org_database.dart';
import 'package:test/test.dart';

const _structuredOutput = {
  'structured_output': {
    'goal': 'Fix the export bug',
    'requirementIds': <String>[],
    'acceptanceCriteria': <String>[],
    'affectedAreas': <String>[],
    'priority': 'medium',
    'openQuestions': <String>[],
  },
};

const _fakeDefinition = core.ConnectorDefinition(
  id: 'fake',
  displayName: 'Fake',
  authorizeUrl: 'https://example.com/authorize',
  tokenUrl: 'https://example.com/token',
  scopes: ['read'],
);

class _FakeAdapter implements ConnectorAdapter {
  _FakeAdapter(this.messages);

  final List<ConnectorMessage> messages;
  String? capturedToken;
  DateTime? capturedSince;
  bool sinceWasCaptured = false;

  @override
  String get connectorId => 'fake';

  @override
  Future<List<ConnectorMessage>> fetchSince(
    String accessToken,
    DateTime? since,
  ) async {
    capturedToken = accessToken;
    capturedSince = since;
    sinceWasCaptured = true;
    return messages;
  }
}

KeychainService _inMemoryKeychain() {
  final store = <String, String>{};
  return KeychainService(
    runner: (executable, args) async {
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
        default:
          return ProcessResult(0, 1, '', 'unknown');
      }
    },
  );
}

void main() {
  late OrgDatabase db;
  late OrgStore store;
  late core.Project project;
  late KeychainService keychain;

  setUp(() async {
    db = OrgDatabase.memory();
    store = OrgStore('org-1', db);
    project = await store.createProject(
      const core.CreateProjectRequest(name: 'P', slug: 'p'),
    );
    keychain = _inMemoryKeychain();
  });

  tearDown(() => db.close());

  ConnectorOAuthService buildOAuth() {
    return ConnectorOAuthService(
      registry: ConnectorRegistry(definitions: [_fakeDefinition]),
      keychain: keychain,
      redirectUri: 'http://127.0.0.1:8787/connectors/callback',
      httpClient: MockClient(
        (_) async => throw Exception('should never make an HTTP call'),
      ),
    );
  }

  ConnectorSyncService buildService({
    required _FakeAdapter adapter,
    MessageRoutingService? routingService,
    AnalystExtractionService? extractionService,
  }) {
    return ConnectorSyncService(
      registry: ConnectorRegistry(
        definitions: [_fakeDefinition],
        adapters: {'fake': adapter},
      ),
      oauth: buildOAuth(),
      routingService:
          routingService ?? MessageRoutingService(invoker: (_) async => '{}'),
      extractionService:
          extractionService ??
          AnalystExtractionService(
            invoker: (_) async => jsonEncode(_structuredOutput),
          ),
    );
  }

  Future<void> seedAccessToken() {
    return keychain.setValue(
      service: 'agentic.org-1.connector.fake',
      account: 'accessToken',
      value: 'at-123',
    );
  }

  test('throws NotConnected when there is no stored access token', () async {
    final adapter = _FakeAdapter(const []);
    final service = buildService(adapter: adapter);
    final source = await store.createSource(
      core.CreateSourceRequest(
        kind: core.SourceKind.oauthConnector,
        config: const {'connectorId': 'fake'},
        projectId: project.id,
      ),
    );

    expect(
      () => service.sync(orgId: 'org-1', source: source, store: store),
      throwsA(isA<NotConnected>()),
    );
  });

  test(
    'throws UnknownConnector when the registry has no matching adapter',
    () async {
      await seedAccessToken();
      final service = ConnectorSyncService(
        registry: ConnectorRegistry(
          definitions: [_fakeDefinition],
          adapters: {},
        ),
        oauth: buildOAuth(),
      );
      final source = await store.createSource(
        core.CreateSourceRequest(
          kind: core.SourceKind.oauthConnector,
          config: const {'connectorId': 'fake'},
          projectId: project.id,
        ),
      );

      expect(
        () => service.sync(orgId: 'org-1', source: source, store: store),
        throwsA(isA<UnknownConnector>()),
      );
    },
  );

  test('throws ArgumentError for a non-oauthConnector source', () async {
    final adapter = _FakeAdapter(const []);
    final service = buildService(adapter: adapter);
    final source = await store.createSource(
      core.CreateSourceRequest(
        kind: core.SourceKind.erf,
        projectId: project.id,
      ),
    );

    expect(
      () => service.sync(orgId: 'org-1', source: source, store: store),
      throwsArgumentError,
    );
  });

  test(
    'a project-scoped source routes directly and drafts a Task Spec',
    () async {
      await seedAccessToken();
      final adapter = _FakeAdapter([
        ConnectorMessage(
          externalId: 'msg-1',
          author: 'alice@example.com',
          sentAt: DateTime.utc(2026, 1, 1),
          body: 'can someone look at the export bug?',
        ),
      ]);
      var routingCalls = 0;
      final service = buildService(
        adapter: adapter,
        routingService: MessageRoutingService(
          invoker: (_) async {
            routingCalls++;
            return '{}';
          },
        ),
      );
      final source = await store.createSource(
        core.CreateSourceRequest(
          kind: core.SourceKind.oauthConnector,
          config: const {'connectorId': 'fake'},
          projectId: project.id,
        ),
      );

      final result = await service.sync(
        orgId: 'org-1',
        source: source,
        store: store,
      );

      expect(result.newMessages, 1);
      expect(result.routedMessages, 1);
      expect(result.unroutedMessages, 0);
      expect(result.specsCreated, 1);
      expect(routingCalls, 0);
      expect(adapter.capturedToken, 'at-123');

      final specs = await store.listProjectArtifacts(
        project.id,
        kind: core.ArtifactKind.taskSpec,
      );
      expect(specs, hasLength(1));
    },
  );

  test(
    'an org-scoped source above the confidence threshold auto-routes',
    () async {
      await seedAccessToken();
      final adapter = _FakeAdapter([
        ConnectorMessage(
          externalId: 'msg-1',
          sentAt: DateTime.utc(2026, 1, 1),
          body: 'can we export as PDF?',
        ),
      ]);
      final service = buildService(
        adapter: adapter,
        routingService: MessageRoutingService(
          invoker: (_) async => jsonEncode({
            'structured_output': {'projectId': project.id, 'confidence': 0.9},
          }),
        ),
      );
      final source = await store.createSource(
        const core.CreateSourceRequest(
          kind: core.SourceKind.oauthConnector,
          config: {'connectorId': 'fake'},
        ),
      );

      final result = await service.sync(
        orgId: 'org-1',
        source: source,
        store: store,
      );

      expect(result.newMessages, 1);
      expect(result.routedMessages, 1);
      expect(result.specsCreated, 1);

      final messages = await store.listMessages(sourceId: source.id);
      expect(messages.single.routedProjectId, project.id);
      expect(messages.single.routingConfidence, 0.9);
    },
  );

  test(
    'an org-scoped source below the confidence threshold stays unrouted',
    () async {
      await seedAccessToken();
      final adapter = _FakeAdapter([
        ConnectorMessage(
          externalId: 'msg-1',
          sentAt: DateTime.utc(2026, 1, 1),
          body: "hey what's up",
        ),
      ]);
      var extractionCalls = 0;
      final service = buildService(
        adapter: adapter,
        routingService: MessageRoutingService(
          invoker: (_) async => jsonEncode({
            'structured_output': {'projectId': project.id, 'confidence': 0.4},
          }),
        ),
        extractionService: AnalystExtractionService(
          invoker: (_) async {
            extractionCalls++;
            return jsonEncode(_structuredOutput);
          },
        ),
      );
      final source = await store.createSource(
        const core.CreateSourceRequest(
          kind: core.SourceKind.oauthConnector,
          config: {'connectorId': 'fake'},
        ),
      );

      final result = await service.sync(
        orgId: 'org-1',
        source: source,
        store: store,
      );

      expect(result.newMessages, 1);
      expect(result.routedMessages, 0);
      expect(result.unroutedMessages, 1);
      expect(result.specsCreated, 0);
      expect(extractionCalls, 0);
    },
  );

  test('a repeat sync of the same messages does no new work', () async {
    await seedAccessToken();
    final messages = [
      ConnectorMessage(
        externalId: 'msg-1',
        sentAt: DateTime.utc(2026, 1, 1),
        body: 'hello',
      ),
    ];
    final adapter = _FakeAdapter(messages);
    var extractionCalls = 0;
    final service = buildService(
      adapter: adapter,
      extractionService: AnalystExtractionService(
        invoker: (_) async {
          extractionCalls++;
          return jsonEncode(_structuredOutput);
        },
      ),
    );
    final source = await store.createSource(
      core.CreateSourceRequest(
        kind: core.SourceKind.oauthConnector,
        config: const {'connectorId': 'fake'},
        projectId: project.id,
      ),
    );

    final first = await service.sync(
      orgId: 'org-1',
      source: source,
      store: store,
    );
    final second = await service.sync(
      orgId: 'org-1',
      source: source,
      store: store,
    );

    expect(first.newMessages, 1);
    expect(second.newMessages, 0);
    expect(second.specsCreated, 0);
    expect(extractionCalls, 1);
  });

  test('the first sync passes since=null', () async {
    await seedAccessToken();
    final adapter = _FakeAdapter(const []);
    final service = buildService(adapter: adapter);
    final source = await store.createSource(
      core.CreateSourceRequest(
        kind: core.SourceKind.oauthConnector,
        config: const {'connectorId': 'fake'},
        projectId: project.id,
      ),
    );

    await service.sync(orgId: 'org-1', source: source, store: store);

    expect(adapter.sinceWasCaptured, isTrue);
    expect(adapter.capturedSince, isNull);
  });

  test(
    'a later sync passes since as the latest existing message\'s sentAt',
    () async {
      await seedAccessToken();
      final firstBatch = _FakeAdapter([
        ConnectorMessage(
          externalId: 'msg-1',
          sentAt: DateTime.utc(2026, 1, 1, 10),
          body: 'first',
        ),
        ConnectorMessage(
          externalId: 'msg-2',
          sentAt: DateTime.utc(2026, 1, 1, 12),
          body: 'second, latest',
        ),
      ]);
      await buildService(adapter: firstBatch).sync(
        orgId: 'org-1',
        source: await store.createSource(
          core.CreateSourceRequest(
            kind: core.SourceKind.oauthConnector,
            config: const {'connectorId': 'fake'},
            projectId: project.id,
          ),
        ),
        store: store,
      );
      // Re-fetch the source actually used above for the second sync call.
      final sources = await store.listSources(projectId: project.id);
      final source = sources.single;

      final secondBatch = _FakeAdapter(const []);
      await buildService(
        adapter: secondBatch,
      ).sync(orgId: 'org-1', source: source, store: store);

      expect(secondBatch.capturedSince, DateTime.utc(2026, 1, 1, 12));
    },
  );
}
