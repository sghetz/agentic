import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;

const _jsonSchema =
    '{"type":"object","properties":{'
    '"projectId":{"type":"string"},'
    '"confidence":{"type":"number"}'
    '},"required":["projectId","confidence"]}';

typedef RoutingClaudeInvoker = Future<String> Function(List<String> args);

Future<String> _defaultRoutingClaudeInvoker(List<String> args) async {
  final process = await Process.start('claude', args);
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

class MessageRoutingResult {
  const MessageRoutingResult({
    required this.projectId,
    required this.confidence,
  });
  final String projectId;
  final double confidence;
}

/// Classifies which project an org-level source's message is about, with a
/// confidence score -- the same one-shot Claude Code CLI pattern as
/// `FailureDiagnosisService`/`AnalystExtractionService`, not a chat turn.
/// Best-effort: any failure (bad output, timeout, CLI not installed, or the
/// model naming a project that isn't actually in [projects]) just means no
/// routing result, not a broken import -- the caller treats that message as
/// unrouted, same as a genuinely low-confidence result.
class MessageRoutingService {
  const MessageRoutingService({
    RoutingClaudeInvoker invoker = _defaultRoutingClaudeInvoker,
    this.model = 'sonnet',
    this.timeout = const Duration(seconds: 60),
  }) : _invoker = invoker;

  final RoutingClaudeInvoker _invoker;
  final String model;
  final Duration timeout;

  Future<MessageRoutingResult?> route({
    required String messageBody,
    required List<core.Project> projects,
  }) async {
    if (projects.isEmpty) return null;

    final projectList = projects
        .map((p) => '- ${p.name} (id: ${p.id})')
        .join('\n');
    final prompt =
        'Which of the following projects is this message about? Respond '
        'with that project\'s id and a confidence from 0.0 to 1.0. If '
        'nothing in the message clearly points to one project over the '
        'others, give a low confidence rather than guessing.\n\n'
        'Projects:\n$projectList\n\n'
        'Message:\n$messageBody';

    try {
      final raw = await _invoker([
        '-p',
        prompt,
        '--output-format',
        'json',
        '--json-schema',
        _jsonSchema,
        '--tools',
        '',
        '--model',
        model,
        '--no-session-persistence',
        '--max-budget-usd',
        '0.50',
      ]).timeout(timeout);

      final envelope = jsonDecode(raw) as Map<String, Object?>;
      final structured = envelope['structured_output'] as Map<String, Object?>?;
      if (structured == null) return null;

      final projectId = structured['projectId'] as String?;
      final confidence = (structured['confidence'] as num?)?.toDouble();
      if (projectId == null || confidence == null) return null;
      if (!projects.any((p) => p.id == projectId)) return null;

      return MessageRoutingResult(projectId: projectId, confidence: confidence);
    } catch (_) {
      return null;
    }
  }
}
