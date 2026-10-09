import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;

import '../config.dart';
import 'git_service.dart';
import 'github_service.dart';
import 'health_runner.dart';
import 'onboarding_service.dart';

typedef DeveloperClaudeInvoker =
    Future<String> Function(
      List<String> args, {
      required String workingDirectory,
    });

Future<String> _defaultDeveloperClaudeInvoker(
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

/// Implements a Task Spec (and Design Spec, when UI is involved) in a
/// task-keyed git worktree. Claude Code gets `Edit` and
/// `flutter`/`dart`/`fvm` bash access only -- no `git` or `gh` tool at all,
/// so it cannot commit, push, or open a PR itself. This service performs
/// every git/GitHub operation deterministically, after independently
/// re-running the Health pipeline to verify the branch actually builds.
///
/// Unlike `TrivialFixService`'s disposable per-attempt worktree, the
/// worktree here is keyed by task id and kept alive (never discarded on
/// success or on a failed verification) so Reviewer can reuse the exact
/// same checkout afterward, and so a retried `develop()` call continues
/// from where the last attempt left off instead of starting over.
class DeveloperService {
  DeveloperService({
    required this.paths,
    required GitService gitService,
    required GitHubService githubService,
    required HealthRunner runner,
    DeveloperClaudeInvoker invoker = _defaultDeveloperClaudeInvoker,
    this.model = 'sonnet',
  }) : _gitService = gitService,
       _githubService = githubService,
       _runner = runner,
       _invoker = invoker;

  final AgenticPaths paths;
  final GitService _gitService;
  final GitHubService _githubService;
  final HealthRunner _runner;
  final DeveloperClaudeInvoker _invoker;
  final String model;

  Future<core.DeveloperRunResult> develop({
    required String orgSlug,
    required core.Project project,
    required core.Task task,
    required core.TaskSpec taskSpec,
    core.DesignSpec? designSpec,
  }) async {
    if (project.repos.isEmpty) {
      throw NoRepoConfigured(project.id);
    }
    final repo = project.repos.first;
    final repoPath = paths.repoPath(orgSlug, project.slug);
    final branchName = 'agentic/task-${task.id}';
    final worktreePath = paths.worktreePath(orgSlug, project.slug, task.id);

    await _gitService.cloneOrPull(
      repoUrl: repo.url,
      targetPath: repoPath,
      branch: repo.defaultBranch,
    );

    // A retried develop() call reuses the same worktree/branch left by a
    // prior verificationFailed attempt rather than failing on `git worktree
    // add` for a path/branch that already exists.
    if (!await Directory(worktreePath).exists()) {
      await _gitService.createWorktree(
        repoPath: repoPath,
        branchName: branchName,
        worktreePath: worktreePath,
      );
    }

    String summary;
    try {
      final raw = await _invoker([
        '-p',
        _buildPrompt(task, taskSpec, designSpec),
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
        '10.00',
      ], workingDirectory: worktreePath).timeout(const Duration(minutes: 15));
      summary = _extractSummary(raw);
    } catch (e) {
      final changed = await _gitService.hasUncommittedChanges(worktreePath);
      if (!changed) {
        await _discard(repoPath, worktreePath, branchName);
      }
      return core.DeveloperRunResult(
        outcome: core.DeveloperOutcome.sessionFailed,
        summary: 'Developer session failed: $e',
      );
    }

    final changed = await _gitService.hasUncommittedChanges(worktreePath);
    if (!changed) {
      await _discard(repoPath, worktreePath, branchName);
      return core.DeveloperRunResult(
        outcome: core.DeveloperOutcome.noChanges,
        summary: summary,
      );
    }

    final verification = await _runner.run(
      worktreePath,
      flutterVersion: project.flutterVersion,
    );
    // Committed either way: unlike a trivial fix, real implementation work
    // is too valuable to discard just because the pipeline didn't pass --
    // the owner (or a retried develop() call) can inspect/continue it
    // instead of losing it.
    await _gitService.commitAll(worktreePath, _commitMessage(task, taskSpec));

    if (verification.status != core.HealthCheckStepStatus.passed) {
      return core.DeveloperRunResult(
        outcome: core.DeveloperOutcome.verificationFailed,
        branchName: branchName,
        summary: summary,
        verificationReport: verification,
      );
    }

    await _githubService.pushBranch(
      worktreePath: worktreePath,
      branchName: branchName,
    );
    final pr = await _githubService.createPr(
      worktreePath: worktreePath,
      branchName: branchName,
      baseBranch: repo.defaultBranch,
      title: task.title,
      body: _prBody(taskSpec, designSpec),
    );

    return core.DeveloperRunResult(
      outcome: core.DeveloperOutcome.prOpened,
      branchName: branchName,
      summary: summary,
      verificationReport: verification,
      pullRequest: pr,
    );
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

  String _commitMessage(core.Task task, core.TaskSpec taskSpec) {
    final ids = taskSpec.requirementIds;
    return ids.isEmpty
        ? 'Agentic: ${task.title}'
        : 'Agentic: ${task.title} (${ids.join(', ')})';
  }

  String _buildPrompt(
    core.Task task,
    core.TaskSpec taskSpec,
    core.DesignSpec? designSpec,
  ) {
    final criteria = taskSpec.acceptanceCriteria.isEmpty
        ? '(none specified)'
        : taskSpec.acceptanceCriteria.map((c) => '- $c').join('\n');
    final requirementIds = taskSpec.requirementIds.isEmpty
        ? '(none)'
        : taskSpec.requirementIds.join(', ');
    final screens = designSpec == null || designSpec.screens.isEmpty
        ? ''
        : '\n\nDesign Spec screens:\n'
              '${designSpec.screens.map((s) => '- ${s.name}: ${s.purpose} (states: ${s.states.map((st) => st.name).join(', ')})').join('\n')}';

    return '''
You are implementing this task in a dedicated git worktree on a dedicated branch.

Task: ${task.title}
Requirement IDs: $requirementIds

Goal: ${taskSpec.goal}

Acceptance criteria:
$criteria$screens

Implement this fully, following the project's existing conventions. Write or update
tests covering the acceptance criteria above. Do not attempt anything outside this
task's scope. You have no `git` tool access -- do not attempt to commit, push, or
open a PR; that happens automatically after you finish.
''';
  }

  String _prBody(core.TaskSpec taskSpec, core.DesignSpec? designSpec) {
    final criteria = taskSpec.acceptanceCriteria.isEmpty
        ? '(none specified)'
        : taskSpec.acceptanceCriteria.map((c) => '- $c').join('\n');
    final requirementIds = taskSpec.requirementIds.isEmpty
        ? '(none)'
        : taskSpec.requirementIds.join(', ');

    return '''
## Goal
${taskSpec.goal}

## Requirement IDs
$requirementIds

## Acceptance criteria
$criteria

---
Opened automatically by Agentic's Developer agent.
''';
  }
}
