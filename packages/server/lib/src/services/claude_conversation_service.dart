import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;

typedef ChatClaudeInvoker =
    Future<String> Function(
      List<String> args, {
      required String workingDirectory,
    });

Future<String> _defaultChatClaudeInvoker(
  List<String> args, {
  required String workingDirectory,
}) async {
  final process = await Process.start(
    'claude',
    args,
    workingDirectory: workingDirectory,
  );
  unawaited(process.stdin.close());
  final stdoutFuture = process.stdout.transform(utf8.decoder).join();
  final stderrFuture = process.stderr.transform(utf8.decoder).join();
  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    final stderr = await stderrFuture;
    throw ProcessException('claude', args, stderr, exitCode);
  }
  return stdoutFuture;
}

class ClaudeConversationReply {
  const ClaudeConversationReply({
    required this.content,
    required this.sessionId,
  });

  final String content;
  final String sessionId;
}

/// One turn of a chat conversation with an agent role, via Claude Code CLI.
///
/// Session continuity (confirmed empirically against the real CLI): the
/// *first* turn passes `--session-id <uuid>` to create the session; every
/// later turn passes `--resume <uuid>` instead -- `--session-id` on an id
/// that already exists is a hard error, it does not resume. The CLI's own
/// session persistence holds prior turns, so only the latest user message is
/// ever sent, never a manually-assembled transcript.
///
/// The role's system prompt does **not** carry over across `--resume` (also
/// confirmed empirically), so it's re-sent via `--append-system-prompt` on
/// every turn. `workingDirectory` must be the target project's own repo (or
/// a neutral, file-free directory for an org-scoped conversation) --
/// Claude Code auto-includes cwd/git-status/CLAUDE.md context by default, and
/// running from Agentic's own source tree would leak Agentic's dev context
/// into a conversation about a user project. No tool access (`--tools ""`):
/// this is a read-only Q&A turn, not a file-editing session.
/// Best-effort: any failure here (bad output, timeout, CLI not installed)
/// just means no reply, not a broken chat.
class ClaudeConversationService {
  const ClaudeConversationService({
    ChatClaudeInvoker invoker = _defaultChatClaudeInvoker,
    this.model = 'sonnet',
    this.timeout = const Duration(seconds: 60),
  }) : _invoker = invoker;

  final ChatClaudeInvoker _invoker;
  final String model;
  final Duration timeout;

  Future<ClaudeConversationReply?> reply({
    required String role,
    required String userMessage,
    required String workingDirectory,
    String? existingSessionId,
  }) async {
    final sessionId = existingSessionId ?? core.newId();
    try {
      final raw = await _invoker([
        '-p',
        userMessage,
        '--output-format',
        'json',
        '--append-system-prompt',
        _systemPromptFor(role),
        '--tools',
        '',
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
      ], workingDirectory: workingDirectory).timeout(timeout);

      final envelope = jsonDecode(raw) as Map<String, Object?>;
      final content = envelope['result'] as String?;
      if (content == null || content.isEmpty) return null;
      return ClaudeConversationReply(content: content, sessionId: sessionId);
    } catch (_) {
      return null;
    }
  }

  String _systemPromptFor(String role) => switch (role) {
    'health' =>
      'You are the Health agent in Agentic, a personal AI dev-team tool. '
          'You know this project\'s build/lint/test pipeline and recent Health '
          'Reports. Answer the owner\'s questions about this project\'s health '
          'concisely; you are not editing any files in this conversation.',
    _ => 'You are an AI agent assisting the owner with this project.',
  };
}
