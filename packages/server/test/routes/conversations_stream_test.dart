import 'dart:convert';
import 'dart:io';

import 'package:server/src/server.dart';
import 'package:server/src/services/claude_conversation_service.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:test/test.dart';
import 'package:web_socket_channel/io.dart';

import '../test_support/http_test_support.dart';

String _result(String text) => jsonEncode({'type': 'result', 'result': text});

String _delta(String text) => jsonEncode({
  'type': 'stream_event',
  'event': {
    'type': 'content_block_delta',
    'index': 1,
    'delta': {'type': 'text_delta', 'text': text},
  },
});

void main() {
  test(
    'a WebSocket subscriber receives delta then done events for a Health turn',
    () async {
      final ctx = buildTestContext(
        conversationService: ClaudeConversationService(
          invoker: (args, {required workingDirectory}) => Stream.fromIterable([
            _delta('Looks '),
            _delta('healthy.'),
            _result('Looks healthy.'),
          ]),
        ),
      );
      final server = await shelf_io.serve(buildHandler(ctx), '127.0.0.1', 0);
      addTearDown(server.close);

      final base = Uri.parse('http://127.0.0.1:${server.port}');

      Future<Map<String, Object?>> postJson(String path, Object body) async {
        final (status, parsed) = await _post(base.resolve(path), body);
        expect(status, 201);
        return parsed;
      }

      final org = await _create(base, '/orgs', {
        'name': 'Org',
        'slug': 'ws-org',
        'type': 'personal',
      });
      final proj = await _create(base, '/orgs/${org['id']}/projects', {
        'name': 'Proj',
        'slug': 'ws-proj',
      });
      final conv = await _get(
        base,
        '/orgs/${org['id']}/conversations?channel=agent:health&projectId=${proj['id']}',
      );
      final conversationId = conv['id'] as String;

      final wsUri = base
          .replace(scheme: 'ws')
          .resolve('/orgs/${org['id']}/conversations/$conversationId/stream');
      final socket = IOWebSocketChannel.connect(wsUri);
      final events = <Map<String, Object?>>[];
      final sub = socket.stream.listen(
        (raw) => events.add(jsonDecode(raw as String) as Map<String, Object?>),
      );

      // Give the socket a moment to finish connecting before triggering the
      // turn, so it doesn't miss the deltas.
      await Future<void>.delayed(const Duration(milliseconds: 200));

      await postJson(
        '/orgs/${org['id']}/conversations/$conversationId/messages',
        {'content': 'is this healthy?'},
      );

      await Future<void>.delayed(const Duration(milliseconds: 200));
      await sub.cancel();
      await socket.sink.close();

      expect(events, hasLength(3));
      expect(events[0], {'type': 'delta', 'text': 'Looks '});
      expect(events[1], {'type': 'delta', 'text': 'healthy.'});
      expect(events[2]['type'], 'done');
      final message = events[2]['message'] as Map<String, Object?>;
      expect(message['content'], 'Looks healthy.');
      expect(message['sender'], 'agent:health');
    },
  );
}

Future<Map<String, Object?>> _create(
  Uri base,
  String path,
  Map<String, Object?> body,
) async {
  final (status, parsed) = await _post(base.resolve(path), body);
  expect(status, 201);
  return parsed;
}

Future<Map<String, Object?>> _get(Uri base, String path) async {
  final (status, parsed) = await _request('GET', base.resolve(path));
  expect(status, 200);
  return parsed;
}

Future<(int, Map<String, Object?>)> _post(Uri uri, Object body) =>
    _request('POST', uri, body: body);

/// Tiny raw `dart:io` HTTP request -- avoids pulling in `package:http` just
/// for this one streaming test (every other test uses the in-memory
/// `send()` helper, which can't perform a WebSocket upgrade).
Future<(int, Map<String, Object?>)> _request(
  String method,
  Uri uri, {
  Object? body,
}) async {
  final client = HttpClient();
  final request = await client.openUrl(method, uri);
  if (body != null) {
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(body));
  }
  final response = await request.close();
  final text = await response.transform(utf8.decoder).join();
  client.close();
  return (response.statusCode, jsonDecode(text) as Map<String, Object?>);
}
