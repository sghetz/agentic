import 'dart:convert';

import 'package:server/src/services/claude_conversation_service.dart';
import 'package:test/test.dart';

void main() {
  group('ClaudeConversationService', () {
    test(
      'a first turn (no existing session) creates one via --session-id',
      () async {
        List<String>? capturedArgs;
        final service = ClaudeConversationService(
          invoker: (args, {required workingDirectory}) async {
            capturedArgs = args;
            return jsonEncode({'result': 'hi there'});
          },
        );

        final reply = await service.reply(
          role: 'health',
          userMessage: 'hello',
          workingDirectory: '/tmp',
        );

        expect(reply, isNotNull);
        expect(reply!.content, 'hi there');
        expect(capturedArgs, contains('--session-id'));
        expect(capturedArgs, isNot(contains('--resume')));
        expect(
          reply.sessionId,
          capturedArgs![capturedArgs!.indexOf('--session-id') + 1],
        );
      },
    );

    test('a later turn (existing session) resumes via --resume', () async {
      List<String>? capturedArgs;
      final service = ClaudeConversationService(
        invoker: (args, {required workingDirectory}) async {
          capturedArgs = args;
          return jsonEncode({'result': 'still here'});
        },
      );

      final reply = await service.reply(
        role: 'health',
        userMessage: 'and now?',
        workingDirectory: '/tmp',
        existingSessionId: 'session-123',
      );

      expect(reply!.sessionId, 'session-123');
      expect(capturedArgs, containsAllInOrder(['--resume', 'session-123']));
      expect(capturedArgs, isNot(contains('--session-id')));
    });

    test(
      'resends a role-specific system prompt via --append-system-prompt',
      () async {
        List<String>? capturedArgs;
        final service = ClaudeConversationService(
          invoker: (args, {required workingDirectory}) async {
            capturedArgs = args;
            return jsonEncode({'result': 'ok'});
          },
        );

        await service.reply(
          role: 'health',
          userMessage: 'hi',
          workingDirectory: '/tmp',
        );

        final index = capturedArgs!.indexOf('--append-system-prompt');
        expect(index, greaterThanOrEqualTo(0));
        expect(capturedArgs![index + 1], contains('Health agent'));
      },
    );

    test('passes the given working directory through to the invoker', () async {
      String? capturedCwd;
      final service = ClaudeConversationService(
        invoker: (args, {required workingDirectory}) async {
          capturedCwd = workingDirectory;
          return jsonEncode({'result': 'ok'});
        },
      );

      await service.reply(
        role: 'health',
        userMessage: 'hi',
        workingDirectory: '/some/repo/path',
      );

      expect(capturedCwd, '/some/repo/path');
    });

    test('disables tool access with --tools ""', () async {
      List<String>? capturedArgs;
      final service = ClaudeConversationService(
        invoker: (args, {required workingDirectory}) async {
          capturedArgs = args;
          return jsonEncode({'result': 'ok'});
        },
      );

      await service.reply(
        role: 'health',
        userMessage: 'hi',
        workingDirectory: '/tmp',
      );

      expect(capturedArgs, containsAllInOrder(['--tools', '']));
    });

    test('returns null when the result field is missing', () async {
      final service = ClaudeConversationService(
        invoker: (_, {required workingDirectory}) async =>
            jsonEncode({'not_result': 'x'}),
      );

      final reply = await service.reply(
        role: 'health',
        userMessage: 'hi',
        workingDirectory: '/tmp',
      );

      expect(reply, isNull);
    });

    test('returns null when the result field is empty', () async {
      final service = ClaudeConversationService(
        invoker: (_, {required workingDirectory}) async =>
            jsonEncode({'result': ''}),
      );

      final reply = await service.reply(
        role: 'health',
        userMessage: 'hi',
        workingDirectory: '/tmp',
      );

      expect(reply, isNull);
    });

    test('returns null (never throws) when the invoker fails', () async {
      final service = ClaudeConversationService(
        invoker: (_, {required workingDirectory}) async =>
            throw Exception('claude not installed'),
      );

      final reply = await service.reply(
        role: 'health',
        userMessage: 'hi',
        workingDirectory: '/tmp',
      );

      expect(reply, isNull);
    });

    test('returns null when the invoker output is malformed JSON', () async {
      final service = ClaudeConversationService(
        invoker: (_, {required workingDirectory}) async => 'not json',
      );

      final reply = await service.reply(
        role: 'health',
        userMessage: 'hi',
        workingDirectory: '/tmp',
      );

      expect(reply, isNull);
    });
  });
}
