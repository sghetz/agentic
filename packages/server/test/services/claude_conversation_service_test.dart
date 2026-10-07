import 'dart:convert';

import 'package:server/src/services/claude_conversation_service.dart';
import 'package:test/test.dart';

String _streamEvent(String text) => jsonEncode({
  'type': 'stream_event',
  'event': {
    'type': 'content_block_delta',
    'index': 1,
    'delta': {'type': 'text_delta', 'text': text},
  },
});

String _thinkingEvent(String text) => jsonEncode({
  'type': 'stream_event',
  'event': {
    'type': 'content_block_delta',
    'index': 0,
    'delta': {'type': 'thinking_delta', 'thinking': text},
  },
});

String _resultLine(String result) =>
    jsonEncode({'type': 'result', 'result': result});

void main() {
  group('ClaudeConversationService.replyStream', () {
    test('yields a text delta per visible chunk, then one result', () async {
      final service = ClaudeConversationService(
        invoker: (args, {required workingDirectory}) => Stream.fromIterable([
          _streamEvent('Hello'),
          _streamEvent(' there'),
          _resultLine('Hello there'),
        ]),
      );

      final events = await service
          .replyStream(
            role: 'health',
            userMessage: 'hi',
            workingDirectory: '/tmp',
          )
          .toList();

      expect(events, hasLength(3));
      expect((events[0] as ClaudeStreamTextDelta).text, 'Hello');
      expect((events[1] as ClaudeStreamTextDelta).text, ' there');
      expect((events[2] as ClaudeStreamResult).content, 'Hello there');
    });

    test('ignores thinking_delta chunks', () async {
      final service = ClaudeConversationService(
        invoker: (args, {required workingDirectory}) => Stream.fromIterable([
          _thinkingEvent('internal reasoning'),
          _streamEvent('visible answer'),
          _resultLine('visible answer'),
        ]),
      );

      final events = await service
          .replyStream(
            role: 'health',
            userMessage: 'hi',
            workingDirectory: '/tmp',
          )
          .toList();

      expect(events, hasLength(2));
      expect((events[0] as ClaudeStreamTextDelta).text, 'visible answer');
    });

    test(
      'a first turn (no existing session) creates one via --session-id',
      () async {
        List<String>? capturedArgs;
        final service = ClaudeConversationService(
          invoker: (args, {required workingDirectory}) {
            capturedArgs = args;
            return Stream.fromIterable([_resultLine('ok')]);
          },
        );

        final events = await service
            .replyStream(
              role: 'health',
              userMessage: 'hi',
              workingDirectory: '/tmp',
            )
            .toList();

        final result = events.single as ClaudeStreamResult;
        expect(capturedArgs, contains('--session-id'));
        expect(capturedArgs, isNot(contains('--resume')));
        expect(
          result.sessionId,
          capturedArgs![capturedArgs!.indexOf('--session-id') + 1],
        );
      },
    );

    test('a later turn (existing session) resumes via --resume', () async {
      List<String>? capturedArgs;
      final service = ClaudeConversationService(
        invoker: (args, {required workingDirectory}) {
          capturedArgs = args;
          return Stream.fromIterable([_resultLine('ok')]);
        },
      );

      final events = await service
          .replyStream(
            role: 'health',
            userMessage: 'and now?',
            workingDirectory: '/tmp',
            existingSessionId: 'session-123',
          )
          .toList();

      final result = events.single as ClaudeStreamResult;
      expect(result.sessionId, 'session-123');
      expect(capturedArgs, containsAllInOrder(['--resume', 'session-123']));
      expect(capturedArgs, isNot(contains('--session-id')));
    });

    test('requires --verbose alongside stream-json output', () async {
      List<String>? capturedArgs;
      final service = ClaudeConversationService(
        invoker: (args, {required workingDirectory}) {
          capturedArgs = args;
          return Stream.fromIterable([_resultLine('ok')]);
        },
      );

      await service
          .replyStream(
            role: 'health',
            userMessage: 'hi',
            workingDirectory: '/tmp',
          )
          .toList();

      expect(capturedArgs, contains('--verbose'));
      expect(
        capturedArgs,
        containsAllInOrder(['--output-format', 'stream-json']),
      );
      expect(capturedArgs, contains('--include-partial-messages'));
    });

    test('passes the given working directory through to the invoker', () async {
      String? capturedCwd;
      final service = ClaudeConversationService(
        invoker: (args, {required workingDirectory}) {
          capturedCwd = workingDirectory;
          return Stream.fromIterable([_resultLine('ok')]);
        },
      );

      await service
          .replyStream(
            role: 'health',
            userMessage: 'hi',
            workingDirectory: '/some/repo/path',
          )
          .toList();

      expect(capturedCwd, '/some/repo/path');
    });

    test('yields nothing when the stream never produces a result', () async {
      final service = ClaudeConversationService(
        invoker: (args, {required workingDirectory}) =>
            Stream.fromIterable([_streamEvent('partial only')]),
      );

      final events = await service
          .replyStream(
            role: 'health',
            userMessage: 'hi',
            workingDirectory: '/tmp',
          )
          .toList();

      expect(events, hasLength(1));
      expect(events.single, isA<ClaudeStreamTextDelta>());
    });

    test(
      'yields nothing (never throws) when the invoker stream errors',
      () async {
        final service = ClaudeConversationService(
          invoker: (args, {required workingDirectory}) =>
              Stream.error(Exception('claude not installed')),
        );

        final events = await service
            .replyStream(
              role: 'health',
              userMessage: 'hi',
              workingDirectory: '/tmp',
            )
            .toList();

        expect(events, isEmpty);
      },
    );

    test('skips unparsable lines without failing the whole turn', () async {
      final service = ClaudeConversationService(
        invoker: (args, {required workingDirectory}) =>
            Stream.fromIterable(['not json', _resultLine('ok anyway')]),
      );

      final events = await service
          .replyStream(
            role: 'health',
            userMessage: 'hi',
            workingDirectory: '/tmp',
          )
          .toList();

      expect(events, hasLength(1));
      expect((events.single as ClaudeStreamResult).content, 'ok anyway');
    });
  });
}
