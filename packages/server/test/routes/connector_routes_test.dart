import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:server/src/app_context.dart';
import 'package:server/src/server.dart';
import 'package:server/src/services/connector_oauth_service.dart';
import 'package:server/src/services/connector_registry.dart';
import 'package:server/src/services/keychain_service.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../test_support/http_test_support.dart';

const _outlook = core.ConnectorDefinition(
  id: 'outlook',
  displayName: 'Outlook',
  authorizeUrl:
      'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
  tokenUrl: 'https://login.microsoftonline.com/common/oauth2/v2.0/token',
  scopes: ['Mail.Read', 'offline_access'],
);

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
  late AppContext ctx;
  late Handler handler;
  late String orgId;

  setUp(() async {
    final registry = ConnectorRegistry(definitions: [_outlook]);
    final connectorOAuthService = ConnectorOAuthService(
      registry: registry,
      keychain: _inMemoryKeychain(),
      redirectUri: 'http://127.0.0.1:8787/connectors/callback',
      httpClient: MockClient(
        (request) async => http.Response(
          jsonEncode({
            'access_token': 'at-123',
            'refresh_token': 'rt-456',
            'expires_in': 3600,
          }),
          200,
        ),
      ),
    );

    ctx = buildTestContext(
      connectorRegistry: registry,
      connectorOAuthService: connectorOAuthService,
    );
    handler = buildHandler(ctx);
    orgId = await createOrg(handler);
  });

  test('GET /connectors lists the registered definitions', () async {
    final (status, body) = await send(handler, 'GET', '/connectors');

    expect(status, 200);
    final list = body! as List;
    expect(list, hasLength(1));
    expect((list.single as Map)['id'], 'outlook');
    expect((list.single as Map)['displayName'], 'Outlook');
  });

  test('connect returns an authorizeUrl for a known connector', () async {
    final (status, body) = await send(
      handler,
      'POST',
      '/orgs/$orgId/connectors/outlook/connect',
      json: {'clientId': 'id', 'clientSecret': 'secret'},
    );

    expect(status, 200);
    final authorizeUrl = (body! as Map)['authorizeUrl'] as String;
    expect(authorizeUrl, startsWith(_outlook.authorizeUrl));
  });

  test('connect 404s for an unknown connector', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/connectors/no-such-connector/connect',
      json: {'clientId': 'id', 'clientSecret': 'secret'},
    );
    expect(status, 404);
  });

  test('connect 404s for an unknown org', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/no-such-org/connectors/outlook/connect',
      json: {'clientId': 'id', 'clientSecret': 'secret'},
    );
    expect(status, 404);
  });

  test('connect 400s when clientId/clientSecret are missing', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/connectors/outlook/connect',
      json: const {},
    );
    expect(status, 400);
  });

  test(
    'the full connect -> callback flow creates an oauthConnector Source',
    () async {
      final (_, connectBody) = await send(
        handler,
        'POST',
        '/orgs/$orgId/connectors/outlook/connect',
        json: {'clientId': 'id', 'clientSecret': 'secret'},
      );
      final authorizeUrl = (connectBody! as Map)['authorizeUrl'] as String;
      final state = Uri.parse(authorizeUrl).queryParameters['state']!;

      // The callback is a browser landing page (HTML), not a JSON API
      // response, so this bypasses the `send()` helper's jsonDecode.
      final callbackResponse = await handler(
        Request(
          'GET',
          Uri.parse(
            'http://localhost/connectors/callback?code=abc&state=$state',
          ),
        ),
      );
      expect(callbackResponse.statusCode, 200);
      expect(callbackResponse.headers['content-type'], contains('text/html'));

      final (sourcesStatus, sourcesBody) = await send(
        handler,
        'GET',
        '/orgs/$orgId/sources',
      );
      expect(sourcesStatus, 200);
      final sources = sourcesBody! as List;
      expect(sources, hasLength(1));
      final source = sources.single as Map;
      expect(source['kind'], 'oauthConnector');
      expect((source['config'] as Map)['connectorId'], 'outlook');
    },
  );

  test('callback 400s for an unknown state', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/connectors/callback?code=abc&state=never-issued',
    );
    expect(status, 400);
  });

  test('callback 400s when code or state is missing', () async {
    final (status, _) = await send(handler, 'GET', '/connectors/callback');
    expect(status, 400);
  });
}
