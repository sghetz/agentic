import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;

const _jsonSchema =
    '{"type":"object","properties":{'
    '"category":{"type":"string","enum":["dependency","sdkMismatch","codeBreak","flakyTest","environment"]},'
    '"summary":{"type":"string"},'
    '"suggestedFix":{"type":"string"}'
    '},"required":["category","summary","suggestedFix"]}';

typedef ClaudeInvoker = Future<String> Function(List<String> args);

Future<String> _defaultClaudeInvoker(List<String> args) async {
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

/// Diagnoses a failed health check step using Claude Code CLI in
/// non-interactive mode -- reuses whatever Claude Code auth is already on
/// the machine instead of a second metered Anthropic API key. `--tools ""`
/// means it only ever reads the failure text we hand it: no repo access.
/// Best-effort: any failure here (bad CLI output, timeout, CLI not
/// installed) just means no diagnosis, not a broken health check.
class FailureDiagnosisService {
  const FailureDiagnosisService({
    ClaudeInvoker invoker = _defaultClaudeInvoker,
    this.model = 'haiku',
    this.timeout = const Duration(seconds: 60),
  }) : _invoker = invoker;

  final ClaudeInvoker _invoker;
  final String model;
  final Duration timeout;

  Future<core.FailureDiagnosis?> diagnose(
    core.HealthCheckStep failedStep,
  ) async {
    final prompt =
        'A Flutter project health check failed at step "${failedStep.name}". Output:\n'
        '${failedStep.output}\n\n'
        'Classify this failure and summarize it with a suggested fix.';

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
      return core.FailureDiagnosis.fromJson(structured);
    } catch (_) {
      return null;
    }
  }
}
