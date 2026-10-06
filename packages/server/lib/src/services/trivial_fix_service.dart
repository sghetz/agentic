import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;

import '../config.dart';
import 'git_service.dart';
import 'health_runner.dart';

typedef FixClaudeInvoker =
    Future<String> Function(
      List<String> args, {
      required String workingDirectory,
    });

Future<String> _defaultFixClaudeInvoker(
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

/// Attempts to auto-fix a trivial health check failure in a disposable git
/// worktree on a dedicated branch. Claude Code gets `Edit` and
/// `flutter`/`dart`/`fvm` bash access only -- no `git` tool at all, so it
/// cannot commit, push, or merge anything. This service performs every git
/// operation itself, deterministically, and only after independently
/// re-running the full pipeline to confirm the fix actually works. Nothing
/// is ever pushed or merged; a successful fix is left as a local branch for
/// the owner to review.
class TrivialFixService {
  TrivialFixService({
    required this.paths,
    required GitService gitService,
    required HealthRunner runner,
    FixClaudeInvoker invoker = _defaultFixClaudeInvoker,
    this.model = 'sonnet',
  }) : _gitService = gitService,
       _runner = runner,
       _invoker = invoker;

  final AgenticPaths paths;
  final GitService _gitService;
  final HealthRunner _runner;
  final FixClaudeInvoker _invoker;
  final String model;

  Future<core.HealthFixResult> attemptFix({
    required String orgSlug,
    required core.Project project,
    required core.FailureDiagnosis diagnosis,
    required core.HealthCheckStep failedStep,
  }) async {
    final repoPath = paths.repoPath(orgSlug, project.slug);
    final suffix = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    final branchName = 'agentic/health-fix-$suffix';
    final worktreePath = paths.worktreePath(orgSlug, project.slug, suffix);

    await _gitService.createWorktree(
      repoPath: repoPath,
      branchName: branchName,
      worktreePath: worktreePath,
    );

    try {
      final raw = await _invoker([
        '-p',
        _buildPrompt(failedStep, diagnosis),
        '--output-format',
        'json',
        '--permission-mode',
        'acceptEdits',
        '--allowedTools',
        'Edit Bash(flutter *) Bash(dart *) Bash(fvm *)',
        '--model',
        model,
        '--no-session-persistence',
        '--max-budget-usd',
        '2.00',
      ], workingDirectory: worktreePath).timeout(const Duration(minutes: 5));

      final summary = _extractSummary(raw);
      final changed = await _gitService.hasUncommittedChanges(worktreePath);

      if (!changed) {
        await _discard(repoPath, worktreePath, branchName);
        return core.HealthFixResult(
          outcome: core.HealthFixOutcome.notTrivial,
          summary: summary,
        );
      }

      final verification = await _runner.run(
        worktreePath,
        flutterVersion: project.flutterVersion,
      );
      if (verification.status != core.HealthCheckStepStatus.passed) {
        await _discard(repoPath, worktreePath, branchName);
        return core.HealthFixResult(
          outcome: core.HealthFixOutcome.stillFailing,
          summary: summary,
          verificationReport: verification,
        );
      }

      await _gitService.commitAll(
        worktreePath,
        'Agentic: fix ${failedStep.name} (${diagnosis.category.name})',
      );
      return core.HealthFixResult(
        outcome: core.HealthFixOutcome.fixed,
        branchName: branchName,
        summary: summary,
        verificationReport: verification,
      );
    } catch (e) {
      await _discard(repoPath, worktreePath, branchName);
      return core.HealthFixResult(
        outcome: core.HealthFixOutcome.notTrivial,
        summary: 'Fix attempt failed: $e',
      );
    }
  }

  Future<void> _discard(
    String repoPath,
    String worktreePath,
    String branchName,
  ) {
    return _gitService.removeWorktree(
      repoPath: repoPath,
      worktreePath: worktreePath,
      branchName: branchName,
    );
  }

  String _extractSummary(String raw) {
    try {
      final envelope = jsonDecode(raw) as Map<String, Object?>;
      return (envelope['result'] as String?) ?? '';
    } catch (_) {
      return '';
    }
  }

  String _buildPrompt(
    core.HealthCheckStep failedStep,
    core.FailureDiagnosis diagnosis,
  ) {
    return '''
A Flutter project's health check failed at step "${failedStep.name}".

Diagnosis: ${diagnosis.category.name} -- ${diagnosis.summary}
Suggested fix: ${diagnosis.suggestedFix}

Original failure output:
${failedStep.output}

You are in a disposable git worktree on a dedicated branch. Only make a change if this is
genuinely trivial: a dependency or SDK version constraint bump in pubspec.yaml, or
regenerating stale generated code (e.g. `dart run build_runner build
--delete-conflicting-outputs`). Do NOT attempt to fix real application logic bugs, broken
tests that need code changes, or anything outside this narrow scope -- if it doesn't fit,
make no changes and explain why in your final response.
''';
  }
}
