import 'dart:convert';

import 'package:http/http.dart' as http;

import 'connector_adapter.dart';

class OutlookSyncException implements Exception {
  OutlookSyncException(this.message);

  final String message;

  @override
  String toString() => 'OutlookSyncException: $message';
}

/// Fetches inbox messages via Microsoft Graph (`/me/mailFolders/Inbox/
/// messages`), incrementally when [since] is given (`$filter=receivedDateTime
/// gt ...`), following `@odata.nextLink` pagination. The only
/// Outlook-specific code in the whole connector -- OAuth, token storage/
/// refresh, and turning these into stored `Message`s are all generic
/// framework code shared with every other connector.
class OutlookAdapter implements ConnectorAdapter {
  OutlookAdapter({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  @override
  String get connectorId => 'outlook';

  @override
  Future<List<ConnectorMessage>> fetchSince(
    String accessToken,
    DateTime? since,
  ) async {
    final messages = <ConnectorMessage>[];
    Uri? uri = _initialUri(since);

    while (uri != null) {
      final response = await _httpClient.get(
        uri,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode >= 400) {
        throw OutlookSyncException(
          'Microsoft Graph request failed (${response.statusCode}): '
          '${response.body}',
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, Object?>;
      final values = decoded['value'] as List? ?? const [];
      for (final raw in values) {
        messages.add(_toConnectorMessage(raw as Map<String, Object?>));
      }

      final nextLink = decoded['@odata.nextLink'] as String?;
      uri = nextLink == null ? null : Uri.parse(nextLink);
    }

    return messages;
  }

  Uri _initialUri(DateTime? since) {
    return Uri.parse(
      'https://graph.microsoft.com/v1.0/me/mailFolders/Inbox/messages',
    ).replace(
      queryParameters: {
        r'$select': 'id,receivedDateTime,subject,from,body',
        r'$orderby': 'receivedDateTime asc',
        r'$top': '50',
        if (since != null)
          r'$filter': 'receivedDateTime gt ${since.toUtc().toIso8601String()}',
      },
    );
  }

  ConnectorMessage _toConnectorMessage(Map<String, Object?> json) {
    final fromAddress =
        ((json['from'] as Map<String, Object?>?)?['emailAddress']
                as Map<String, Object?>?)?['address']
            as String?;
    final subject = json['subject'] as String? ?? '(no subject)';
    final bodyContent =
        (json['body'] as Map<String, Object?>?)?['content'] as String? ?? '';

    return ConnectorMessage(
      externalId: json['id'] as String,
      author: fromAddress,
      sentAt: DateTime.parse(json['receivedDateTime'] as String),
      body: '$subject\n\n$bodyContent',
      raw: json,
    );
  }
}
