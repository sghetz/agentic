import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:http/http.dart' as http;

import 'connector_registry.dart';
import 'keychain_service.dart';

class UnknownConnector implements Exception {
  UnknownConnector(this.connectorId);

  final String connectorId;

  @override
  String toString() => 'UnknownConnector($connectorId)';
}

/// An expired/unknown `state` param on the OAuth callback -- a client-side
/// problem (stale link, replay, tampering), not an upstream failure.
class InvalidOAuthState implements Exception {
  InvalidOAuthState(this.message);

  final String message;

  @override
  String toString() => 'InvalidOAuthState: $message';
}

/// The OAuth provider itself rejected something (bad credentials, bad
/// code, token endpoint error) -- an upstream failure, not a client mistake.
class ConnectorOAuthException implements Exception {
  ConnectorOAuthException(this.message);

  final String message;

  @override
  String toString() => 'ConnectorOAuthException: $message';
}

class CompletedConnection {
  const CompletedConnection({required this.orgId, required this.connectorId});

  final String orgId;
  final String connectorId;
}

class _PendingConnection {
  const _PendingConnection({
    required this.orgId,
    required this.connectorId,
    required this.createdAt,
  });

  final String orgId;
  final String connectorId;
  final DateTime createdAt;
}

/// The generic half of the connector framework: builds the authorize URL,
/// exchanges a callback code for tokens, and refreshes an expired access
/// token -- all deterministic HTTP, no LLM, shared across every connector.
/// Client id/secret and issued tokens are stored in Keychain, namespaced
/// per (org, connector); never in the database.
class ConnectorOAuthService {
  ConnectorOAuthService({
    required ConnectorRegistry registry,
    required KeychainService keychain,
    required String redirectUri,
    http.Client? httpClient,
    this.pendingTtl = const Duration(minutes: 10),
  }) : _registry = registry,
       _keychain = keychain,
       _redirectUri = redirectUri,
       _httpClient = httpClient ?? http.Client();

  final ConnectorRegistry _registry;
  final KeychainService _keychain;
  final String _redirectUri;
  final http.Client _httpClient;
  final Duration pendingTtl;
  final Map<String, _PendingConnection> _pending = {};

  String _service(String orgId, String connectorId) =>
      'agentic.$orgId.connector.$connectorId';

  /// Stores the owner-supplied client id/secret, records a short-lived
  /// pending-connection entry keyed by a fresh nonce, and returns the URL
  /// the UI should open in the system browser.
  Future<String> beginConnect({
    required String orgId,
    required String connectorId,
    required String clientId,
    required String clientSecret,
  }) async {
    final definition = _registry.definitionFor(connectorId);
    if (definition == null) throw UnknownConnector(connectorId);

    final service = _service(orgId, connectorId);
    await _keychain.setValue(
      service: service,
      account: 'clientId',
      value: clientId,
    );
    await _keychain.setValue(
      service: service,
      account: 'clientSecret',
      value: clientSecret,
    );

    final nonce = core.newId();
    _pending[nonce] = _PendingConnection(
      orgId: orgId,
      connectorId: connectorId,
      createdAt: DateTime.now().toUtc(),
    );

    final uri = Uri.parse(definition.authorizeUrl).replace(
      queryParameters: {
        'client_id': clientId,
        'redirect_uri': _redirectUri,
        'response_type': 'code',
        'scope': definition.scopes.join(' '),
        'state': nonce,
      },
    );
    return uri.toString();
  }

  /// Exchanges [code] for tokens and stores them in Keychain. Throws
  /// [InvalidOAuthState] for an unknown/expired/replayed [state], or
  /// [ConnectorOAuthException] if the provider rejects the exchange.
  Future<CompletedConnection> completeConnect({
    required String code,
    required String state,
  }) async {
    final pending = _pending.remove(state);
    if (pending == null) {
      throw InvalidOAuthState('Unknown or already-used connection attempt');
    }
    if (DateTime.now().toUtc().difference(pending.createdAt) > pendingTtl) {
      throw InvalidOAuthState('Connection attempt expired');
    }

    final definition = _registry.definitionFor(pending.connectorId);
    if (definition == null) throw UnknownConnector(pending.connectorId);

    final service = _service(pending.orgId, pending.connectorId);
    final clientId = await _keychain.getValue(
      service: service,
      account: 'clientId',
    );
    final clientSecret = await _keychain.getValue(
      service: service,
      account: 'clientSecret',
    );
    if (clientId == null || clientSecret == null) {
      throw ConnectorOAuthException(
        'Missing stored client credentials for ${pending.connectorId}',
      );
    }

    final tokens = await _requestTokens(definition.tokenUrl, {
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': _redirectUri,
      'client_id': clientId,
      'client_secret': clientSecret,
    });
    await _storeTokens(service, tokens);

    return CompletedConnection(
      orgId: pending.orgId,
      connectorId: pending.connectorId,
    );
  }

  /// A currently-valid access token for (org, connector), refreshing it
  /// first if it's expired. `null` means there's no stored connection, or
  /// refreshing failed (e.g. a revoked grant) -- the caller should treat
  /// that as "needs to reconnect," not retry.
  Future<String?> getValidAccessToken({
    required String orgId,
    required String connectorId,
  }) async {
    final service = _service(orgId, connectorId);
    final accessToken = await _keychain.getValue(
      service: service,
      account: 'accessToken',
    );
    if (accessToken == null) return null;

    final expiresAtRaw = await _keychain.getValue(
      service: service,
      account: 'accessTokenExpiresAt',
    );
    if (expiresAtRaw == null) return accessToken;

    final expiresAt = DateTime.parse(expiresAtRaw);
    final stillValid = DateTime.now().toUtc().isBefore(
      expiresAt.subtract(const Duration(minutes: 1)),
    );
    if (stillValid) return accessToken;

    final definition = _registry.definitionFor(connectorId);
    final refreshToken = await _keychain.getValue(
      service: service,
      account: 'refreshToken',
    );
    final clientId = await _keychain.getValue(
      service: service,
      account: 'clientId',
    );
    final clientSecret = await _keychain.getValue(
      service: service,
      account: 'clientSecret',
    );
    if (definition == null ||
        refreshToken == null ||
        clientId == null ||
        clientSecret == null) {
      return null;
    }

    final Map<String, Object?> tokens;
    try {
      tokens = await _requestTokens(definition.tokenUrl, {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': clientId,
        'client_secret': clientSecret,
      });
    } on ConnectorOAuthException {
      return null;
    }
    await _storeTokens(service, tokens);
    return tokens['access_token'] as String?;
  }

  Future<Map<String, Object?>> _requestTokens(
    String tokenUrl,
    Map<String, String> body,
  ) async {
    final response = await _httpClient.post(
      Uri.parse(tokenUrl),
      headers: {'content-type': 'application/x-www-form-urlencoded'},
      body: body,
    );
    if (response.statusCode >= 400) {
      throw ConnectorOAuthException(
        'Token request failed (${response.statusCode}): ${response.body}',
      );
    }
    final decoded = jsonDecode(response.body) as Map<String, Object?>;
    if (decoded['access_token'] == null) {
      throw ConnectorOAuthException(
        'Token response missing access_token: ${response.body}',
      );
    }
    return decoded;
  }

  Future<void> _storeTokens(String service, Map<String, Object?> tokens) async {
    await _keychain.setValue(
      service: service,
      account: 'accessToken',
      value: tokens['access_token'] as String,
    );
    final refreshToken = tokens['refresh_token'] as String?;
    if (refreshToken != null) {
      await _keychain.setValue(
        service: service,
        account: 'refreshToken',
        value: refreshToken,
      );
    }
    final expiresIn = tokens['expires_in'];
    if (expiresIn is int) {
      final expiresAt = DateTime.now().toUtc().add(
        Duration(seconds: expiresIn),
      );
      await _keychain.setValue(
        service: service,
        account: 'accessTokenExpiresAt',
        value: expiresAt.toIso8601String(),
      );
    }
  }
}
