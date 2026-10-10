import 'dart:convert';
import 'dart:io';

import 'package:http/testing.dart';
import 'package:server/src/app_context.dart';
import 'package:server/src/server.dart';
import 'package:server/src/services/analyst_extraction_service.dart';
import 'package:server/src/services/connector_adapter.dart';
import 'package:server/src/services/connector_oauth_service.dart';
import 'package:server/src/services/connector_registry.dart';
import 'package:server/src/services/keychain_service.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../test_support/http_test_support.dart';

class _FakeAdapter implements ConnectorAdapter {
  _FakeAdapter(this.messages);

  final List<ConnectorMessage> messages;

  @override
  String get connectorId => 'outlook';

  @override
  Future<List<ConnectorMessage>> fetchSince(
    String accessToken,
    DateTime? since,
  ) async => messages;
}

/// The real orgId isn't known until *after* `createOrg` is called through
/// the handler this keychain is already wired into -- so this returns the
/// backing store too, seeded once the real orgId is known.
({KeychainService keychain, Map<String, String> store})
_mutableInMemoryKeychain() {
  final store = <String, String>{};
  final keychain = KeychainService(
    runner: (executable, args) async {
      final account = args[args.indexOf('-a') + 1];
      final service = args[args.indexOf('-s') + 1];
      final key = '$service|$account';
      switch (args.first) {
        case 'find-generic-password':
          final value = store[key];
          return value == null
              ? ProcessResult(0, 44, '', 'not found')
              : ProcessResult(0, 0, value, '');
        default:
          return ProcessResult(0, 1, '', 'unsupported in this fake');
      }
    },
  );
  return (keychain: keychain, store: store);
}

const _structuredOutput = {
  'structured_output': {
    'goal': 'Let users reset their password via email',
    'requirementIds': ['RF-07'],
    'acceptanceCriteria': <String>[],
    'affectedAreas': <String>[],
    'priority': 'medium',
    'openQuestions': <String>[],
  },
};

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

  test('POST .../sources creates a project-scoped source', () async {
    final (status, body) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources',
      json: {
        'kind': 'erf',
        'config': {'folderPath': '/tmp/erf'},
        'projectId': projectId,
      },
    );

    expect(status, 201);
    final map = body! as Map;
    expect(map['kind'], 'erf');
    expect(map['projectId'], projectId);
  });

  test('GET .../sources lists sources, filterable by projectId', () async {
    await send(
      handler,
      'POST',
      '/orgs/$orgId/sources',
      json: {
        'kind': 'erf',
        'config': {'folderPath': '/tmp/erf'},
        'projectId': projectId,
      },
    );
    await send(
      handler,
      'POST',
      '/orgs/$orgId/sources',
      json: {'kind': 'whatsappImport'},
    );

    final (status, body) = await send(
      handler,
      'GET',
      '/orgs/$orgId/sources?projectId=$projectId',
    );
    expect(status, 200);
    expect((body! as List), hasLength(1));

    final (allStatus, allBody) = await send(
      handler,
      'GET',
      '/orgs/$orgId/sources',
    );
    expect(allStatus, 200);
    expect((allBody! as List), hasLength(2));
  });

  test('scanning a non-erf source is a 400', () async {
    final (_, sourceBody) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources',
      json: {'kind': 'whatsappImport'},
    );
    final sourceId = (sourceBody! as Map)['id'] as String;

    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources/$sourceId/scan',
      json: const {},
    );
    expect(status, 400);
  });

  test('scanning an unknown source is a 404', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources/no-such-source/scan',
      json: const {},
    );
    expect(status, 404);
  });

  test(
    'POST .../scan on a real erf source imports a file and drafts a spec',
    () async {
      final tmp = await Directory.systemTemp.createTemp('agentic_route_erf_');
      addTearDown(() => tmp.delete(recursive: true));
      await File('${tmp.path}/RF-07.txt').writeAsString(
        'Users must be able to reset their password via an emailed link.',
      );

      final scanCtx = buildTestContext(
        analystExtractionService: AnalystExtractionService(
          invoker: (_) async => jsonEncode(_structuredOutput),
        ),
      );
      final scanHandler = buildHandler(scanCtx);
      final org = await createOrg(scanHandler, slug: 'erf-scan-org');
      final proj = await createProject(scanHandler, org);

      final (_, sourceBody) = await send(
        scanHandler,
        'POST',
        '/orgs/$org/sources',
        json: {
          'kind': 'erf',
          'config': {'folderPath': tmp.path},
          'projectId': proj,
        },
      );
      final sourceId = (sourceBody! as Map)['id'] as String;

      final (status, body) = await send(
        scanHandler,
        'POST',
        '/orgs/$org/sources/$sourceId/scan',
        json: const {},
      );

      expect(status, 200);
      final map = body! as Map;
      expect(map['newMessages'], 1);
      expect(map['specsCreated'], 1);
      expect(map['failedFiles'], isEmpty);

      final (_, messagesBody) = await send(
        scanHandler,
        'GET',
        '/orgs/$org/sources/$sourceId/messages',
      );
      expect((messagesBody! as List), hasLength(1));

      final (_, specsBody) = await send(
        scanHandler,
        'GET',
        '/orgs/$org/projects/$proj/task-specs',
      );
      expect((specsBody! as List), hasLength(1));
    },
  );

  test('messages for an unknown source is a 404', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/$orgId/sources/no-such-source/messages',
    );
    expect(status, 404);
  });

  test('importing WhatsApp text into a non-whatsapp source is a 400', () async {
    final (_, sourceBody) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources',
      json: {
        'kind': 'erf',
        'config': {'folderPath': '/tmp/erf'},
        'projectId': projectId,
      },
    );
    final sourceId = (sourceBody! as Map)['id'] as String;

    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources/$sourceId/import-whatsapp',
      json: {'exportText': '[1/3/26, 09:15:00] Alice: hi'},
    );
    expect(status, 400);
  });

  test('exportText is required', () async {
    final (_, sourceBody) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources',
      json: {'kind': 'whatsappImport', 'projectId': projectId},
    );
    final sourceId = (sourceBody! as Map)['id'] as String;

    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources/$sourceId/import-whatsapp',
      json: const {},
    );
    expect(status, 400);
  });

  test(
    'POST .../import-whatsapp on a project-scoped source imports and drafts specs',
    () async {
      final importCtx = buildTestContext(
        analystExtractionService: AnalystExtractionService(
          invoker: (_) async => jsonEncode(_structuredOutput),
        ),
      );
      final importHandler = buildHandler(importCtx);
      final org = await createOrg(importHandler, slug: 'whatsapp-import-org');
      final proj = await createProject(importHandler, org);

      final (_, sourceBody) = await send(
        importHandler,
        'POST',
        '/orgs/$org/sources',
        json: {'kind': 'whatsappImport', 'projectId': proj},
      );
      final sourceId = (sourceBody! as Map)['id'] as String;

      final (status, body) = await send(
        importHandler,
        'POST',
        '/orgs/$org/sources/$sourceId/import-whatsapp',
        json: {
          'exportText':
              '[1/3/26, 09:15:00] Alice: can someone look at the export bug?',
        },
      );

      expect(status, 200);
      final map = body! as Map;
      expect(map['newMessages'], 1);
      expect(map['routedMessages'], 1);
      expect(map['unroutedMessages'], 0);
      expect(map['specsCreated'], 1);

      final (_, specsBody) = await send(
        importHandler,
        'GET',
        '/orgs/$org/projects/$proj/task-specs',
      );
      expect((specsBody! as List), hasLength(1));
    },
  );

  test('sync 400s for a non-oauthConnector source', () async {
    final (_, sourceBody) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources',
      json: {'kind': 'erf', 'config': {}, 'projectId': projectId},
    );
    final sourceId = (sourceBody! as Map)['id'] as String;

    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources/$sourceId/sync',
    );
    expect(status, 400);
  });

  test('sync 400s when the connector has never been connected', () async {
    final (_, sourceBody) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources',
      json: {
        'kind': 'oauthConnector',
        'config': {'connectorId': 'outlook'},
        'projectId': projectId,
      },
    );
    final sourceId = (sourceBody! as Map)['id'] as String;

    final (status, body) = await send(
      handler,
      'POST',
      '/orgs/$orgId/sources/$sourceId/sync',
    );
    expect(status, 400);
    expect((body! as Map)['error'], contains('connect it first'));
  });

  test(
    'POST .../sync on a connected, project-scoped source imports and drafts specs',
    () async {
      final registry = ConnectorRegistry(
        adapters: {
          'outlook': _FakeAdapter([
            ConnectorMessage(
              externalId: 'm1',
              author: 'alice@example.com',
              sentAt: DateTime.utc(2026, 1, 1),
              body: 'password reset via email, RF-07',
            ),
          ]),
        },
      );
      final fakeKeychain = _mutableInMemoryKeychain();
      final syncCtx = buildTestContext(
        connectorRegistry: registry,
        connectorOAuthService: ConnectorOAuthService(
          registry: registry,
          keychain: fakeKeychain.keychain,
          redirectUri: 'http://127.0.0.1:8787/connectors/callback',
          httpClient: MockClient(
            (_) async => throw Exception('should never make an HTTP call'),
          ),
        ),
        analystExtractionService: AnalystExtractionService(
          invoker: (_) async => jsonEncode(_structuredOutput),
        ),
      );
      final syncHandler = buildHandler(syncCtx);
      final org = await createOrg(syncHandler, slug: 'sync-org');
      final proj = await createProject(syncHandler, org);
      // Only known after createOrg -- seed the token under the real orgId.
      fakeKeychain.store['agentic.$org.connector.outlook|accessToken'] =
          'at-123';

      final (_, sourceBody) = await send(
        syncHandler,
        'POST',
        '/orgs/$org/sources',
        json: {
          'kind': 'oauthConnector',
          'config': {'connectorId': 'outlook'},
          'projectId': proj,
        },
      );
      final sourceId = (sourceBody! as Map)['id'] as String;

      final (status, body) = await send(
        syncHandler,
        'POST',
        '/orgs/$org/sources/$sourceId/sync',
      );

      expect(status, 200);
      final map = body! as Map;
      expect(map['newMessages'], 1);
      expect(map['routedMessages'], 1);
      expect(map['specsCreated'], 1);

      final (_, specsBody) = await send(
        syncHandler,
        'GET',
        '/orgs/$org/projects/$proj/task-specs',
      );
      expect((specsBody! as List), hasLength(1));
    },
  );
}
