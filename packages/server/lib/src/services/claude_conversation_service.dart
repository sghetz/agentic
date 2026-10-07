import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;

typedef ChatClaudeStreamInvoker =
    Stream<String> Function(
      List<String> args, {
      required String workingDirectory,
    });

/// Streams stdout line by line (NDJSON, one JSON object per line) as the
/// process runs, instead of collecting it all and returning at the end.
Stream<String> _defaultChatClaudeStreamInvoker(
  List<String> args, {
  required String workingDirectory,
}) {
  final controller = StreamController<String>();
  unawaited(() async {
    try {
      final process = await Process.start(
        'claude',
        args,
        workingDirectory: workingDirectory,
      );
      unawaited(process.stdin.close());
      final stderrFuture = process.stderr.transform(utf8.decoder).join();
      await process.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .forEach(controller.add);
      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        final stderr = await stderrFuture;
        controller.addError(ProcessException('claude', args, stderr, exitCode));
      }
    } catch (e) {
      controller.addError(e);
    } finally {
      await controller.close();
    }
  }());
  return controller.stream;
}

sealed class ClaudeStreamEvent {}

class ClaudeStreamTextDelta extends ClaudeStreamEvent {
  ClaudeStreamTextDelta(this.text);
  final String text;
}

class ClaudeStreamResult extends ClaudeStreamEvent {
  ClaudeStreamResult({required this.content, required this.sessionId});
  final String content;
  final String sessionId;
}

/// One turn of a chat conversation with an agent role, via Claude Code CLI,
/// streamed via `--output-format stream-json --include-partial-messages`
/// (which requires `--verbose` in print mode -- confirmed against the real
/// CLI). Yields a [ClaudeStreamTextDelta] per visible text chunk as it
/// arrives (the model's internal `thinking_delta` chunks are not surfaced),
/// then a single [ClaudeStreamResult] once the CLI's own final `result`
/// line arrives with the full text and the session id to persist.
///
/// `systemPrompt` is built by the caller (see `role_prompts.dart`) rather
/// than switched on internally, since a role's prompt can depend on data
/// this service has no business knowing (e.g. the Orchestrator's list of
/// projects in the org) -- this service only knows how to run one CLI turn.
/// `mcpConfigJson` is an inline `--mcp-config` JSON string (the CLI accepts
/// a literal string or a file path there); when present, `--strict-mcp-config`
/// is always added too, since `--tools ""` alone doesn't hide ambient MCP
/// servers configured globally on the machine (confirmed live). Session
/// continuity, system-prompt resending, and `workingDirectory` all carry the
/// same reasoning as before (see `docs/PHASE_2_SPEC.md`) -- only the
/// transport changed, not the turn semantics. Best-effort: a stream that
/// errors, is truncated, or never produces a `result` line simply yields no
/// [ClaudeStreamResult] -- the caller is responsible for treating "no
/// result" as "no reply", not a broken chat.
class ClaudeConversationService {
  const ClaudeConversationService({
    ChatClaudeStreamInvoker invoker = _defaultChatClaudeStreamInvoker,
    this.model = 'sonnet',
    this.timeout = const Duration(seconds: 90),
  }) : _invoker = invoker;

  final ChatClaudeStreamInvoker _invoker;
  final String model;
  final Duration timeout;

  Stream<ClaudeStreamEvent> replyStream({
    required String systemPrompt,
    required String userMessage,
    required String workingDirectory,
    String? existingSessionId,
    String? mcpConfigJson,
    List<String>? allowedTools,
  }) async* {
    final sessionId = existingSessionId ?? core.newId();
    final args = [
      '-p',
      userMessage,
      '--output-format',
      'stream-json',
      '--include-partial-messages',
      '--verbose',
      '--append-system-prompt',
      systemPrompt,
      '--tools',
      '',
      if (mcpConfigJson != null) ...[
        '--mcp-config',
        mcpConfigJson,
        // Only the one MCP server we just passed should ever be visible --
        // confirmed live that --tools "" alone doesn't hide ambient MCP
        // servers configured globally on the machine.
        '--strict-mcp-config',
      ],
      // MCP tools still go through the normal permission system even from a
      // --strict-mcp-config server -- confirmed live that without this,
      // every call_tool is silently blocked in non-interactive `-p` mode.
      if (allowedTools != null && allowedTools.isNotEmpty) ...[
        '--allowedTools',
        allowedTools.join(' '),
      ],
      '--model',
      model,
      if (existingSessionId == null) ...[
        '--session-id',
        sessionId,
      ] else ...[
        '--resume',
        sessionId,
      ],
      '--max-budget-usd',
      '0.50',
    ];

    try {
      final lines = _invoker(
        args,
        workingDirectory: workingDirectory,
      ).timeout(timeout);
      await for (final line in lines) {
        if (line.trim().isEmpty) continue;
        final Map<String, Object?> event;
        try {
          event = jsonDecode(line) as Map<String, Object?>;
        } catch (_) {
          continue;
        }

        switch (event['type']) {
          case 'stream_event':
            final text = _textDeltaFrom(event);
            if (text != null && text.isNotEmpty) {
              yield ClaudeStreamTextDelta(text);
            }
          case 'result':
            final content = event['result'] as String?;
            if (content != null && content.isNotEmpty) {
              yield ClaudeStreamResult(content: content, sessionId: sessionId);
            }
        }
      }
    } catch (_) {
      // Best-effort: swallow and yield nothing further.
    }
  }

  String? _textDeltaFrom(Map<String, Object?> streamEventLine) {
    final inner = streamEventLine['event'] as Map<String, Object?>?;
    if (inner?['type'] != 'content_block_delta') return null;
    final delta = inner!['delta'] as Map<String, Object?>?;
    if (delta?['type'] != 'text_delta') return null;
    return delta!['text'] as String?;
  }
}
