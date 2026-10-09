import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;

import '../config.dart';
import 'git_service.dart';
import 'github_service.dart';
import 'health_runner.dart';

class NoWorktreeFound implements Exception {
  NoWorktreeFound(this.taskId);

  final String taskId;

  @override
  String toString() => 'NoWorktreeFound($taskId)';
}

const _reviewReportSchema =
    '{"type":"object","properties":{'
    '"summary":{"type":"string"},'
    '"acceptanceCriteriaMet":{"type":"array","items":{"type":"string"}},'
    '"acceptanceCriteriaUnmet":{"type":"array","items":{"type":"string"}},'
    '"requirementIdsCovered":{"type":"array","items":{"type":"string"}},'
    '"requirementIdsMissing":{"type":"array","items":{"type":"string"}},'
    '"codeQualityIssues":{"type":"array","items":{"type":"string"}},'
    '"missingTests":{"type":"array","items":{"type":"string"}}'
    '},"required":["summary","acceptanceCriteriaMet","acceptanceCriteriaUnmet",'
    '"requirementIdsCovered","requirementIdsMissing","codeQualityIssues","missingTests"]}';

typedef ReviewClaudeInvoker =
    Future<String> Function(
      List<String> args, {
      required String workingDirectory,
    });

Future<String> _defaultReviewClaudeInvoker(
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

/// An independent check of a Developer PR against its source Task Spec, run
/// as a second Claude Code session in the *same* worktree/branch Developer
/// left behind (never a fresh checkout) -- Reviewer gets the same `Edit` +
/// `flutter`/`dart`/`fvm` bash access and the same lack of any `git`/`gh`
/// tool. It never runs `git diff` itself either: the diff against the base
/// branch is computed deterministically beforehand and inlined into the
/// prompt, so Reviewer needs no git access at all to see what changed.
/// If Reviewer adds anything (e.g. a missing test), the server commits and
/// pushes it, same division of responsibility as Developer.
class ReviewService {
  ReviewService({
    required this.paths,
    required GitService gitService,
    required GitHubService githubService,
    required HealthRunner runner,
    ReviewClaudeInvoker invoker = _defaultReviewClaudeInvoker,
    this.model = 'sonnet',
  }) : _gitService = gitService,
       _githubService = githubService,
       _runner = runner,
       _invoker = invoker;

  final AgenticPaths paths;
  final GitService _gitService;
  final GitHubService _githubService;
  final HealthRunner _runner;
  final ReviewClaudeInvoker _invoker;
  final String model;

  Future<core.ReviewReport?> review({
    required String orgSlug,
    required core.Project project,
    required core.Task task,
    required core.TaskSpec taskSpec,
    core.DesignSpec? designSpec,
  }) async {
    final worktreePath = paths.worktreePath(orgSlug, project.slug, task.id);
    if (!await Directory(worktreePath).exists()) {
      throw NoWorktreeFound(task.id);
    }
    final baseBranch = project.repos.first.defaultBranch;
    final branchName = 'agentic/task-${task.id}';

    final diff = await _gitService.diff(
      worktreePath: worktreePath,
      baseBranch: baseBranch,
    );

    String raw;
    try {
      raw = await _invoker([
        '-p',
        _buildPrompt(task, taskSpec, designSpec, diff),
        '--output-format',
        'json',
        '--json-schema',
        _reviewReportSchema,
        '--permission-mode',
        'acceptEdits',
        '--allowedTools',
        'Edit Bash(flutter *) Bash(dart *) Bash(fvm *)',
        '--model',
        model,
        '--no-session-persistence',
        '--max-budget-usd',
        '5.00',
      ], workingDirectory: worktreePath).timeout(const Duration(minutes: 10));
    } catch (_) {
      return null;
    }

    final report = _parseReport(raw);
    if (report == null) return null;

    // If Reviewer wrote anything (e.g. a missing test), only push it once
    // re-verified -- never push something that doesn't build, even if the
    // Review Report itself is still valid either way.
    if (await _gitService.hasUncommittedChanges(worktreePath)) {
      final verification = await _runner.run(
        worktreePath,
        flutterVersion: project.flutterVersion,
      );
      if (verification.status == core.HealthCheckStepStatus.passed) {
        await _gitService.commitAll(
          worktreePath,
          'Agentic: review additions for ${task.title}',
        );
        await _githubService.pushBranch(
          worktreePath: worktreePath,
          branchName: branchName,
        );
      }
    }

    return report;
  }

  core.ReviewReport? _parseReport(String raw) {
    try {
      final envelope = jsonDecode(raw) as Map<String, Object?>;
      final structured = envelope['structured_output'] as Map<String, Object?>?;
      if (structured == null) return null;
      return core.ReviewReport.fromJson(structured);
    } catch (_) {
      return null;
    }
  }

  String _buildPrompt(
    core.Task task,
    core.TaskSpec taskSpec,
    core.DesignSpec? designSpec,
    String diff,
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
              '${designSpec.screens.map((s) => '- ${s.name}: ${s.purpose}').join('\n')}';

    return '''
You are independently reviewing another agent's implementation of this task. You did not
write this code yourself.

Task: ${task.title}
Requirement IDs: $requirementIds

Goal: ${taskSpec.goal}

Acceptance criteria:
$criteria$screens

The diff (against the base branch) is below. Judge which acceptance criteria are met and
which aren't, which requirement IDs are actually covered, any code quality issues, and any
missing test coverage. Do not comment on static analysis, security scanning, or build/lint
tooling -- that is handled separately. If you find a genuinely missing test for one of the
acceptance criteria above, you may add it yourself using your Edit/Bash tools; otherwise make
no changes. You have no `git` tool access -- do not attempt to commit, push, or merge
anything; that happens automatically after you finish.

```diff
$diff
```
''';
  }
}
