import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;

const _screenSchema =
    '{"type":"object","properties":{'
    '"name":{"type":"string"},'
    '"purpose":{"type":"string"},'
    '"states":{"type":"array","items":{"type":"string","enum":["empty","loading","error","success"]}},'
    '"navigatesTo":{"type":"array","items":{"type":"string"}}'
    '},"required":["name","purpose","states","navigatesTo"]}';

const _jsonSchema =
    '{"type":"object","properties":{'
    '"screens":{"type":"array","items":$_screenSchema},'
    '"mermaid":{"type":"string"}'
    '},"required":["screens","mermaid"]}';

typedef CreativeClaudeInvoker = Future<String> Function(List<String> args);

Future<String> _defaultCreativeClaudeInvoker(List<String> args) async {
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

/// Result of one Creative generation: a [core.DesignSpec] and its companion
/// Mermaid flow diagram source, produced together so the diagram's screens
/// and navigation always agree with the spec's -- generating them
/// separately risks the two disagreeing with each other.
class CreativeGenerationResult {
  const CreativeGenerationResult({
    required this.designSpec,
    required this.mermaid,
  });
  final core.DesignSpec designSpec;
  final String mermaid;
}

/// Generates a [core.DesignSpec] and Mermaid user/screen flow diagram from
/// an existing [core.TaskSpec], using Claude Code CLI in non-interactive
/// mode -- the same one-shot `-p --json-schema --tools ""` pattern
/// `AnalystExtractionService` already uses, not a chat turn. [designSystemRef]
/// (from `Project.designSystemRef`, if set) is passed as plain prompt
/// context -- "only use components from this package" -- Agentic never
/// generates design-system code itself (see `docs/PHASE_4_SPEC.md`).
/// Best-effort: any failure here just means no Design Spec, not a broken
/// request.
class CreativeExtractionService {
  const CreativeExtractionService({
    CreativeClaudeInvoker invoker = _defaultCreativeClaudeInvoker,
    this.model = 'sonnet',
    this.timeout = const Duration(seconds: 60),
  }) : _invoker = invoker;

  final CreativeClaudeInvoker _invoker;
  final String model;
  final Duration timeout;

  Future<CreativeGenerationResult?> generate({
    required String projectId,
    required core.TaskSpec taskSpec,
    String? designSystemRef,
  }) async {
    final designSystemLine = designSystemRef == null
        ? ''
        : '\nOnly use components and tokens from the "$designSystemRef" '
              'design system package -- never invent a token or component '
              'outside it.';

    final prompt =
        'Design the screens needed for this Task Spec. For each screen, '
        'give its name, a one-line purpose, which of these UI states it '
        'needs (empty, loading, error, success -- only the ones that '
        'genuinely apply), and the names of other screens in your answer '
        'it navigates to. Then draw a Mermaid flowchart (`flowchart TD`) of '
        'the screen flow: one node per screen, labeled with that screen\'s '
        'requirement ID(s) in parentheses if it has any, edges for '
        'navigation.$designSystemLine\n\n'
        'Goal: ${taskSpec.goal}\n'
        'Requirement IDs: ${taskSpec.requirementIds.join(', ')}\n'
        'Acceptance criteria: ${taskSpec.acceptanceCriteria.join('; ')}\n'
        'Affected areas: ${taskSpec.affectedAreas.join(', ')}';

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

      final screens = (structured['screens'] as List)
          .map((s) => core.ScreenSpec.fromJson(s as Map<String, Object?>))
          .toList();
      final mermaid = structured['mermaid'] as String?;
      if (mermaid == null || mermaid.isEmpty) return null;

      return CreativeGenerationResult(
        designSpec: core.DesignSpec(
          projectId: projectId,
          screens: screens,
          requirementIds: taskSpec.requirementIds,
        ),
        mermaid: mermaid,
      );
    } catch (_) {
      return null;
    }
  }
}
