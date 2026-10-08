import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;

const _jsonSchema =
    '{"type":"object","properties":{'
    '"goal":{"type":"string"},'
    '"requirementIds":{"type":"array","items":{"type":"string"}},'
    '"acceptanceCriteria":{"type":"array","items":{"type":"string"}},'
    '"affectedAreas":{"type":"array","items":{"type":"string"}},'
    '"priority":{"type":"string","enum":["low","medium","high"]},'
    '"openQuestions":{"type":"array","items":{"type":"string"}}'
    '},"required":["goal","requirementIds","acceptanceCriteria","affectedAreas","priority","openQuestions"]}';

typedef AnalystClaudeInvoker = Future<String> Function(List<String> args);

Future<String> _defaultAnalystClaudeInvoker(List<String> args) async {
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

/// Extracts a structured [core.TaskSpec] from raw text (a message body, or
/// markdown converted from an ERF document) using Claude Code CLI in
/// non-interactive mode -- the same one-shot, `--tools ""`, `--json-schema`
/// pattern `FailureDiagnosisService` already proved in Phase 1, not the
/// multi-turn conversation mechanism from Phase 2: a message arriving is a
/// background/on-demand event, not a back-and-forth with no conversation to
/// resume. Best-effort: any failure here (bad CLI output, timeout, CLI not
/// installed) just means no spec, not a broken request.
class AnalystExtractionService {
  const AnalystExtractionService({
    AnalystClaudeInvoker invoker = _defaultAnalystClaudeInvoker,
    this.model = 'sonnet',
    this.timeout = const Duration(seconds: 60),
  }) : _invoker = invoker;

  final AnalystClaudeInvoker _invoker;
  final String model;
  final Duration timeout;

  Future<core.TaskSpec?> extract({
    required String projectId,
    required String rawText,
  }) async {
    final prompt =
        'Extract a Task Spec from the following raw text (a work message or '
        'a document). Identify the goal, any explicitly-stated requirement '
        'IDs (e.g. "RF-07" -- leave empty if none are present, never invent '
        'one), acceptance criteria, affected areas/screens/modules, a '
        'priority, and open questions. Never invent a requirement, '
        'acceptance criterion, or detail that isn\'t actually in the text -- '
        'anything unclear or missing belongs in openQuestions instead.\n\n'
        'Text:\n$rawText';

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
      return core.TaskSpec.fromJson({...structured, 'projectId': projectId});
    } catch (_) {
      return null;
    }
  }
}
