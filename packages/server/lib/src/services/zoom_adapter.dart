import 'dart:convert';

import 'package:http/http.dart' as http;

import 'connector_adapter.dart';

class ZoomSyncException implements Exception {
  ZoomSyncException(this.message);

  final String message;

  @override
  String toString() => 'ZoomSyncException: $message';
}

/// Fetches cloud recordings via Zoom's REST API (`/users/me/recordings`,
/// `from`/`to` date range + `next_page_token` pagination) and, for each
/// meeting that has a `TRANSCRIPT` recording file, downloads its VTT
/// content as that meeting's message body. A meeting with no transcript
/// file (not recorded to the cloud, or transcription wasn't enabled) is
/// skipped, not an error. Unlike a mail message, a transcript has no
/// single sender -- `author` is left unset.
class ZoomAdapter implements ConnectorAdapter {
  ZoomAdapter({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  @override
  String get connectorId => 'zoom';

  @override
  Future<List<ConnectorMessage>> fetchSince(
    String accessToken,
    DateTime? since,
  ) async {
    final messages = <ConnectorMessage>[];
    final from =
        since ?? DateTime.now().toUtc().subtract(const Duration(days: 30));
    final to = DateTime.now().toUtc();
    String? nextPageToken;

    do {
      final uri = Uri.parse('https://api.zoom.us/v2/users/me/recordings')
          .replace(
            queryParameters: {
              'from': _dateOnly(from),
              'to': _dateOnly(to),
              'page_size': '30',
              'next_page_token': ?nextPageToken,
            },
          );
      final response = await _httpClient.get(
        uri,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode >= 400) {
        throw ZoomSyncException(
          'Zoom recordings request failed (${response.statusCode}): '
          '${response.body}',
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, Object?>;
      final meetings = decoded['meetings'] as List? ?? const [];
      for (final raw in meetings) {
        final message = await _toConnectorMessage(
          raw as Map<String, Object?>,
          accessToken,
        );
        if (message != null) messages.add(message);
      }

      final token = decoded['next_page_token'] as String?;
      nextPageToken = (token == null || token.isEmpty) ? null : token;
    } while (nextPageToken != null);

    return messages;
  }

  Future<ConnectorMessage?> _toConnectorMessage(
    Map<String, Object?> meeting,
    String accessToken,
  ) async {
    final files = (meeting['recording_files'] as List? ?? const [])
        .cast<Map<String, Object?>>();
    final transcriptFile = files
        .where((f) => f['file_type'] == 'TRANSCRIPT')
        .firstOrNull;
    final downloadUrl = transcriptFile?['download_url'] as String?;
    if (downloadUrl == null) return null;

    final transcriptResponse = await _httpClient.get(
      Uri.parse(downloadUrl),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (transcriptResponse.statusCode >= 400) {
      throw ZoomSyncException(
        'Zoom transcript download failed '
        '(${transcriptResponse.statusCode}): ${transcriptResponse.body}',
      );
    }

    final topic = meeting['topic'] as String? ?? '(untitled meeting)';
    final startTime = meeting['start_time'] as String?;
    final externalId = (meeting['uuid'] ?? meeting['id']).toString();

    return ConnectorMessage(
      externalId: externalId,
      sentAt: startTime == null
          ? DateTime.now().toUtc()
          : DateTime.parse(startTime),
      body: '$topic\n\n${transcriptResponse.body}',
      raw: meeting,
    );
  }

  String _dateOnly(DateTime dt) => dt.toIso8601String().split('T').first;
}
