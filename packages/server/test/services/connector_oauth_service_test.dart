import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:server/src/services/connector_oauth_service.dart';
import 'package:server/src/services/connector_registry.dart';
import 'package:server/src/services/keychain_service.dart';
import 'package:test/test.dart';

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
  late KeychainService keychain;
  const registry = ConnectorRegistry(definitions: [_outlook]);

  ConnectorOAuthService buildService({
    required http.Client httpClient,
    Duration pendingTtl = const Duration(minutes: 10),
  }) {
    keychain = _inMemoryKeychain();
    return ConnectorOAuthService(
      registry: registry,
      keychain: keychain,
      redirectUri: 'http://127.0.0.1:8787/connectors/callback',
      httpClient: httpClient,
      pendingTtl: pendingTtl,
    );
  }

  group('beginConnect', () {
    test('throws UnknownConnector for an unregistered id', () {
      final service = buildService(
        httpClient: MockClient((_) async => http.Response('', 200)),
      );

      expect(
        () => service.beginConnect(
          orgId: 'org-1',
          connectorId: 'no-such-connector',
          clientId: 'id',
          clientSecret: 'secret',
        ),
        throwsA(isA<UnknownConnector>()),
      );
    });

    test(
      'stores client credentials and returns a correct authorize URL',
      () async {
        final service = buildService(
          httpClient: MockClient((_) async => http.Response('', 200)),
        );

        final authorizeUrl = await service.beginConnect(
          orgId: 'org-1',
          connectorId: 'outlook',
          clientId: 'my-client-id',
          clientSecret: 'my-client-secret',
        );

        final uri = Uri.parse(authorizeUrl);
        expect(uri.origin, 'https://login.microsoftonline.com');
        expect(uri.path, '/common/oauth2/v2.0/authorize');
        expect(uri.queryParameters['client_id'], 'my-client-id');
        expect(
          uri.queryParameters['redirect_uri'],
          'http://127.0.0.1:8787/connectors/callback',
        );
        expect(uri.queryParameters['response_type'], 'code');
        expect(uri.queryParameters['scope'], 'Mail.Read offline_access');
        expect(uri.queryParameters['state'], isNotEmpty);

        expect(
          await keychain.getValue(
            service: 'agentic.org-1.connector.outlook',
            account: 'clientId',
          ),
          'my-client-id',
        );
        expect(
          await keychain.getValue(
            service: 'agentic.org-1.connector.outlook',
            account: 'clientSecret',
          ),
          'my-client-secret',
        );
      },
    );
  });

  group('completeConnect', () {
    test('throws InvalidOAuthState for an unknown state', () {
      final service = buildService(
        httpClient: MockClient((_) async => http.Response('', 200)),
      );

      expect(
        () => service.completeConnect(code: 'abc', state: 'never-issued'),
        throwsA(isA<InvalidOAuthState>()),
      );
    });

    test(
      'throws InvalidOAuthState for an expired pending connection',
      () async {
        final service = buildService(
          httpClient: MockClient((_) async => http.Response('', 200)),
          pendingTtl: Duration.zero,
        );
        final authorizeUrl = await service.beginConnect(
          orgId: 'org-1',
          connectorId: 'outlook',
          clientId: 'id',
          clientSecret: 'secret',
        );
        final state = Uri.parse(authorizeUrl).queryParameters['state']!;

        expect(
          () => service.completeConnect(code: 'abc', state: state),
          throwsA(isA<InvalidOAuthState>()),
        );
      },
    );

    test('exchanges the code for tokens and stores them', () async {
      http.Request? captured;
      final service = buildService(
        httpClient: MockClient((request) async {
          captured = request;
          return http.Response(
            jsonEncode({
              'access_token': 'at-123',
              'refresh_token': 'rt-456',
              'expires_in': 3600,
            }),
            200,
          );
        }),
      );
      final authorizeUrl = await service.beginConnect(
        orgId: 'org-1',
        connectorId: 'outlook',
        clientId: 'my-id',
        clientSecret: 'my-secret',
      );
      final state = Uri.parse(authorizeUrl).queryParameters['state']!;

      final completed = await service.completeConnect(
        code: 'the-code',
        state: state,
      );

      expect(completed.orgId, 'org-1');
      expect(completed.connectorId, 'outlook');
      expect(captured!.url.toString(), _outlook.tokenUrl);
      expect(captured!.bodyFields['grant_type'], 'authorization_code');
      expect(captured!.bodyFields['code'], 'the-code');
      expect(captured!.bodyFields['client_id'], 'my-id');
      expect(captured!.bodyFields['client_secret'], 'my-secret');

      expect(
        await keychain.getValue(
          service: 'agentic.org-1.connector.outlook',
          account: 'accessToken',
        ),
        'at-123',
      );
      expect(
        await keychain.getValue(
          service: 'agentic.org-1.connector.outlook',
          account: 'refreshToken',
        ),
        'rt-456',
      );
    });

    test('replaying the same state a second time fails (single use)', () async {
      final service = buildService(
        httpClient: MockClient(
          (_) async => http.Response(jsonEncode({'access_token': 'at'}), 200),
        ),
      );
      final authorizeUrl = await service.beginConnect(
        orgId: 'org-1',
        connectorId: 'outlook',
        clientId: 'id',
        clientSecret: 'secret',
      );
      final state = Uri.parse(authorizeUrl).queryParameters['state']!;
      await service.completeConnect(code: 'abc', state: state);

      expect(
        () => service.completeConnect(code: 'abc', state: state),
        throwsA(isA<InvalidOAuthState>()),
      );
    });

    test(
      'throws ConnectorOAuthException when the provider rejects the code',
      () async {
        final service = buildService(
          httpClient: MockClient(
            (_) async =>
                http.Response(jsonEncode({'error': 'invalid_grant'}), 400),
          ),
        );
        final authorizeUrl = await service.beginConnect(
          orgId: 'org-1',
          connectorId: 'outlook',
          clientId: 'id',
          clientSecret: 'secret',
        );
        final state = Uri.parse(authorizeUrl).queryParameters['state']!;

        expect(
          () => service.completeConnect(code: 'bad-code', state: state),
          throwsA(isA<ConnectorOAuthException>()),
        );
      },
    );
  });

  group('getValidAccessToken', () {
    test('returns null when there is no stored connection', () async {
      final service = buildService(
        httpClient: MockClient((_) async => http.Response('', 200)),
      );

      final token = await service.getValidAccessToken(
        orgId: 'org-1',
        connectorId: 'outlook',
      );

      expect(token, isNull);
    });

    test('returns the stored token directly when still valid', () async {
      final service = buildService(
        httpClient: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'access_token': 'at-123',
              'refresh_token': 'rt-456',
              'expires_in': 3600,
            }),
            200,
          ),
        ),
      );
      final authorizeUrl = await service.beginConnect(
        orgId: 'org-1',
        connectorId: 'outlook',
        clientId: 'id',
        clientSecret: 'secret',
      );
      final state = Uri.parse(authorizeUrl).queryParameters['state']!;
      await service.completeConnect(code: 'abc', state: state);

      final token = await service.getValidAccessToken(
        orgId: 'org-1',
        connectorId: 'outlook',
      );

      expect(token, 'at-123');
    });

    test('refreshes an expired token and returns the new one', () async {
      var callCount = 0;
      final service = buildService(
        httpClient: MockClient((request) async {
          callCount++;
          if (callCount == 1) {
            // The initial authorization_code exchange -- expires immediately.
            return http.Response(
              jsonEncode({
                'access_token': 'at-old',
                'refresh_token': 'rt-456',
                'expires_in': 0,
              }),
              200,
            );
          }
          expect(request.bodyFields['grant_type'], 'refresh_token');
          expect(request.bodyFields['refresh_token'], 'rt-456');
          return http.Response(
            jsonEncode({'access_token': 'at-new', 'expires_in': 3600}),
            200,
          );
        }),
      );
      final authorizeUrl = await service.beginConnect(
        orgId: 'org-1',
        connectorId: 'outlook',
        clientId: 'id',
        clientSecret: 'secret',
      );
      final state = Uri.parse(authorizeUrl).queryParameters['state']!;
      await service.completeConnect(code: 'abc', state: state);

      final token = await service.getValidAccessToken(
        orgId: 'org-1',
        connectorId: 'outlook',
      );

      expect(token, 'at-new');
      expect(callCount, 2);
    });

    test('returns null when refresh fails (e.g. a revoked grant)', () async {
      var callCount = 0;
      final service = buildService(
        httpClient: MockClient((request) async {
          callCount++;
          if (callCount == 1) {
            return http.Response(
              jsonEncode({
                'access_token': 'at-old',
                'refresh_token': 'rt-456',
                'expires_in': 0,
              }),
              200,
            );
          }
          return http.Response(jsonEncode({'error': 'invalid_grant'}), 400);
        }),
      );
      final authorizeUrl = await service.beginConnect(
        orgId: 'org-1',
        connectorId: 'outlook',
        clientId: 'id',
        clientSecret: 'secret',
      );
      final state = Uri.parse(authorizeUrl).queryParameters['state']!;
      await service.completeConnect(code: 'abc', state: state);

      final token = await service.getValidAccessToken(
        orgId: 'org-1',
        connectorId: 'outlook',
      );

      expect(token, isNull);
    });
  });
}
