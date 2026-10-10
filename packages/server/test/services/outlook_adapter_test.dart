import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:server/src/services/outlook_adapter.dart';
import 'package:test/test.dart';

Map<String, Object?> _graphMessage({
  required String id,
  required String receivedDateTime,
  String subject = 'Hello',
  String? fromAddress = 'alice@example.com',
  String bodyContent = '<p>Body</p>',
}) {
  return {
    'id': id,
    'receivedDateTime': receivedDateTime,
    'subject': subject,
    'from': fromAddress == null
        ? null
        : {
            'emailAddress': {'address': fromAddress, 'name': 'Alice'},
          },
    'body': {'contentType': 'html', 'content': bodyContent},
  };
}

void main() {
  test('maps a single page of messages', () async {
    final adapter = OutlookAdapter(
      httpClient: MockClient((request) async {
        expect(request.headers['Authorization'], 'Bearer at-123');
        return http.Response(
          jsonEncode({
            'value': [
              _graphMessage(id: 'm1', receivedDateTime: '2026-01-01T12:00:00Z'),
            ],
          }),
          200,
        );
      }),
    );

    final messages = await adapter.fetchSince('at-123', null);

    expect(messages, hasLength(1));
    expect(messages.single.externalId, 'm1');
    expect(messages.single.author, 'alice@example.com');
    expect(messages.single.sentAt, DateTime.parse('2026-01-01T12:00:00Z'));
    expect(messages.single.body, contains('Hello'));
    expect(messages.single.body, contains('<p>Body</p>'));
  });

  test('includes a receivedDateTime filter only when since is given', () async {
    Uri? capturedUri;
    final adapter = OutlookAdapter(
      httpClient: MockClient((request) async {
        capturedUri = request.url;
        return http.Response(jsonEncode({'value': <Object?>[]}), 200);
      }),
    );

    await adapter.fetchSince('at-123', null);
    expect(capturedUri!.queryParameters.containsKey(r'$filter'), isFalse);

    await adapter.fetchSince('at-123', DateTime.utc(2026, 1, 1, 12));
    expect(
      capturedUri!.queryParameters[r'$filter'],
      'receivedDateTime gt 2026-01-01T12:00:00.000Z',
    );
  });

  test('follows @odata.nextLink pagination', () async {
    var callCount = 0;
    final adapter = OutlookAdapter(
      httpClient: MockClient((request) async {
        callCount++;
        if (callCount == 1) {
          return http.Response(
            jsonEncode({
              'value': [
                _graphMessage(
                  id: 'm1',
                  receivedDateTime: '2026-01-01T10:00:00Z',
                ),
              ],
              '@odata.nextLink': 'https://graph.microsoft.com/v1.0/next-page',
            }),
            200,
          );
        }
        expect(
          request.url.toString(),
          'https://graph.microsoft.com/v1.0/next-page',
        );
        return http.Response(
          jsonEncode({
            'value': [
              _graphMessage(id: 'm2', receivedDateTime: '2026-01-01T11:00:00Z'),
            ],
          }),
          200,
        );
      }),
    );

    final messages = await adapter.fetchSince('at-123', null);

    expect(callCount, 2);
    expect(messages.map((m) => m.externalId), ['m1', 'm2']);
  });

  test('treats a message with no sender as unauthored, not an error', () async {
    final adapter = OutlookAdapter(
      httpClient: MockClient(
        (request) async => http.Response(
          jsonEncode({
            'value': [
              _graphMessage(
                id: 'm1',
                receivedDateTime: '2026-01-01T12:00:00Z',
                fromAddress: null,
              ),
            ],
          }),
          200,
        ),
      ),
    );

    final messages = await adapter.fetchSince('at-123', null);

    expect(messages.single.author, isNull);
  });

  test('throws OutlookSyncException when Graph rejects the request', () async {
    final adapter = OutlookAdapter(
      httpClient: MockClient(
        (request) async => http.Response('{"error":"invalid_token"}', 401),
      ),
    );

    expect(
      () => adapter.fetchSince('expired-token', null),
      throwsA(isA<OutlookSyncException>()),
    );
  });
}
