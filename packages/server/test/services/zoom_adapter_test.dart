import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:server/src/services/zoom_adapter.dart';
import 'package:test/test.dart';

Map<String, Object?> _meeting({
  required String uuid,
  required String startTime,
  String topic = 'Planning sync',
  bool withTranscript = true,
}) {
  return {
    'uuid': uuid,
    'topic': topic,
    'start_time': startTime,
    'recording_files': [
      {'file_type': 'MP4', 'download_url': 'https://zoom.us/rec/video/$uuid'},
      if (withTranscript)
        {
          'file_type': 'TRANSCRIPT',
          'download_url': 'https://zoom.us/rec/transcript/$uuid.vtt',
        },
    ],
  };
}

void main() {
  test('downloads and maps the transcript of a recorded meeting', () async {
    final adapter = ZoomAdapter(
      httpClient: MockClient((request) async {
        if (request.url.host == 'api.zoom.us') {
          expect(request.headers['Authorization'], 'Bearer at-123');
          return http.Response(
            jsonEncode({
              'meetings': [
                _meeting(uuid: 'm1', startTime: '2026-01-01T10:00:00Z'),
              ],
            }),
            200,
          );
        }
        expect(request.url.toString(), 'https://zoom.us/rec/transcript/m1.vtt');
        expect(request.headers['Authorization'], 'Bearer at-123');
        return http.Response('WEBVTT\n\n1\nHello there', 200);
      }),
    );

    final messages = await adapter.fetchSince('at-123', null);

    expect(messages, hasLength(1));
    expect(messages.single.externalId, 'm1');
    expect(messages.single.author, isNull);
    expect(messages.single.sentAt, DateTime.parse('2026-01-01T10:00:00Z'));
    expect(messages.single.body, contains('Planning sync'));
    expect(messages.single.body, contains('Hello there'));
  });

  test('skips a meeting with no transcript file, not an error', () async {
    final adapter = ZoomAdapter(
      httpClient: MockClient((request) async {
        return http.Response(
          jsonEncode({
            'meetings': [
              _meeting(
                uuid: 'm1',
                startTime: '2026-01-01T10:00:00Z',
                withTranscript: false,
              ),
            ],
          }),
          200,
        );
      }),
    );

    final messages = await adapter.fetchSince('at-123', null);

    expect(messages, isEmpty);
  });

  test('follows next_page_token pagination', () async {
    var callCount = 0;
    final adapter = ZoomAdapter(
      httpClient: MockClient((request) async {
        if (request.url.host != 'api.zoom.us') {
          return http.Response('WEBVTT\n\ntranscript', 200);
        }
        callCount++;
        if (callCount == 1) {
          expect(request.url.queryParameters['next_page_token'], isNull);
          return http.Response(
            jsonEncode({
              'meetings': [
                _meeting(uuid: 'm1', startTime: '2026-01-01T10:00:00Z'),
              ],
              'next_page_token': 'page2',
            }),
            200,
          );
        }
        expect(request.url.queryParameters['next_page_token'], 'page2');
        return http.Response(
          jsonEncode({
            'meetings': [
              _meeting(uuid: 'm2', startTime: '2026-01-02T10:00:00Z'),
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

  test(
    'uses the from/to date range: since when given, 30 days back otherwise',
    () async {
      Uri? capturedUri;
      final adapter = ZoomAdapter(
        httpClient: MockClient((request) async {
          if (request.url.host == 'api.zoom.us') {
            capturedUri = request.url;
            return http.Response(jsonEncode({'meetings': <Object?>[]}), 200);
          }
          return http.Response('', 200);
        }),
      );

      final since = DateTime.utc(2026, 1, 5);
      await adapter.fetchSince('at-123', since);
      expect(capturedUri!.queryParameters['from'], '2026-01-05');

      await adapter.fetchSince('at-123', null);
      final expectedFrom = DateTime.now().toUtc().subtract(
        const Duration(days: 30),
      );
      expect(
        capturedUri!.queryParameters['from'],
        expectedFrom.toIso8601String().split('T').first,
      );
    },
  );

  test(
    'throws ZoomSyncException when the recordings list request fails',
    () async {
      final adapter = ZoomAdapter(
        httpClient: MockClient(
          (request) async => http.Response('{"message":"invalid token"}', 401),
        ),
      );

      expect(
        () => adapter.fetchSince('expired', null),
        throwsA(isA<ZoomSyncException>()),
      );
    },
  );

  test('throws ZoomSyncException when the transcript download fails', () async {
    final adapter = ZoomAdapter(
      httpClient: MockClient((request) async {
        if (request.url.host == 'api.zoom.us') {
          return http.Response(
            jsonEncode({
              'meetings': [
                _meeting(uuid: 'm1', startTime: '2026-01-01T10:00:00Z'),
              ],
            }),
            200,
          );
        }
        return http.Response('not found', 404);
      }),
    );

    expect(
      () => adapter.fetchSince('at-123', null),
      throwsA(isA<ZoomSyncException>()),
    );
  });
}
