import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;

class GitHubOperationException implements Exception {
  GitHubOperationException(this.message);

  final String message;

  @override
  String toString() => 'GitHubOperationException: $message';
}

/// How a merged PR's commits land on the base branch. Squash is the default
/// since most tasks here are one self-contained change; exposed as a
/// parameter rather than hard-coded in case a particular task warrants
/// something else.
enum GitHubMergeMethod { merge, squash, rebase }

typedef GhProcessRunner =
    Future<ProcessResult> Function(
      String executable,
      List<String> args, {
      String? workingDirectory,
    });

Future<ProcessResult> _defaultGhProcessRunner(
  String executable,
  List<String> args, {
  String? workingDirectory,
}) => Process.run(executable, args, workingDirectory: workingDirectory);

/// Thin wrapper over the `git`/`gh` CLIs for everything after a Developer or
/// Reviewer Claude Code session finishes editing a worktree. Deterministic,
/// no LLM involvement -- mirrors `GitService`'s role: Claude Code itself
/// never gets a `git` or `gh` tool, so every push/PR/merge operation in this
/// phase happens here instead.
class GitHubService {
  const GitHubService({GhProcessRunner runner = _defaultGhProcessRunner})
    : _runner = runner;

  final GhProcessRunner _runner;

  Future<void> pushBranch({
    required String worktreePath,
    required String branchName,
  }) async {
    final result = await _runner('git', [
      'push',
      '-u',
      'origin',
      branchName,
    ], workingDirectory: worktreePath);
    if (result.exitCode != 0) {
      throw GitHubOperationException('git push failed: ${result.stderr}');
    }
  }

  /// Opens a PR from [branchName] onto [baseBranch]. `gh pr create` has no
  /// `--json` output; on success it prints the new PR's URL as the last
  /// line of stdout, so the PR number is parsed back out of that URL.
  Future<core.PullRequestInfo> createPr({
    required String worktreePath,
    required String branchName,
    required String baseBranch,
    required String title,
    required String body,
  }) async {
    final result = await _runner('gh', [
      'pr',
      'create',
      '--base',
      baseBranch,
      '--head',
      branchName,
      '--title',
      title,
      '--body',
      body,
    ], workingDirectory: worktreePath);
    if (result.exitCode != 0) {
      throw GitHubOperationException('gh pr create failed: ${result.stderr}');
    }

    final url = (result.stdout as String).trim().split('\n').last.trim();
    final number = int.tryParse(url.split('/').last);
    if (number == null) {
      throw GitHubOperationException(
        'Could not parse a PR number from gh pr create output: "$url"',
      );
    }

    return core.PullRequestInfo(
      number: number,
      url: url,
      branch: branchName,
      baseBranch: baseBranch,
    );
  }

  /// Fetches the PR head commit's checks (GitHub Actions check runs and
  /// legacy commit statuses alike -- `statusCheckRollup` covers both) live
  /// from GitHub. Never cached: see `PHASE_5_SPEC.md` for why.
  Future<List<core.PullRequestCheck>> getChecks({
    required String workingDirectory,
    required int prNumber,
  }) async {
    final result = await _runner('gh', [
      'pr',
      'view',
      '$prNumber',
      '--json',
      'statusCheckRollup',
    ], workingDirectory: workingDirectory);
    if (result.exitCode != 0) {
      throw GitHubOperationException('gh pr view failed: ${result.stderr}');
    }

    final decoded = jsonDecode(result.stdout as String) as Map<String, Object?>;
    final rollup = decoded['statusCheckRollup'] as List<Object?>? ?? const [];
    return rollup
        .map((entry) => _parseCheck(entry as Map<String, Object?>))
        .toList();
  }

  core.PullRequestCheck _parseCheck(Map<String, Object?> json) {
    final name = (json['name'] ?? json['context']) as String? ?? 'unknown';
    final status = json['status'] as String?;
    final conclusion = json['conclusion'] as String?;
    final state = json['state'] as String?; // legacy commit-status shape

    return core.PullRequestCheck(
      name: name,
      conclusion: _resolveConclusion(
        status: status,
        conclusion: conclusion,
        state: state,
      ),
      detailsUrl: json['detailsUrl'] as String? ?? json['targetUrl'] as String?,
    );
  }

  core.PrCheckConclusion _resolveConclusion({
    String? status,
    String? conclusion,
    String? state,
  }) {
    if (state != null) {
      // Legacy commit status: state is PENDING/SUCCESS/FAILURE/ERROR.
      switch (state.toUpperCase()) {
        case 'SUCCESS':
          return core.PrCheckConclusion.success;
        case 'FAILURE':
        case 'ERROR':
          return core.PrCheckConclusion.failure;
        default:
          return core.PrCheckConclusion.pending;
      }
    }

    if (status != null && status.toUpperCase() != 'COMPLETED') {
      return core.PrCheckConclusion.pending;
    }
    switch ((conclusion ?? '').toUpperCase()) {
      case 'SUCCESS':
        return core.PrCheckConclusion.success;
      case 'NEUTRAL':
      case 'SKIPPED':
        return core.PrCheckConclusion.neutral;
      case '':
        return core.PrCheckConclusion.pending;
      default:
        return core.PrCheckConclusion.failure;
    }
  }

  Future<void> mergePr({
    required String workingDirectory,
    required int prNumber,
    GitHubMergeMethod method = GitHubMergeMethod.squash,
  }) async {
    final flag = switch (method) {
      GitHubMergeMethod.merge => '--merge',
      GitHubMergeMethod.squash => '--squash',
      GitHubMergeMethod.rebase => '--rebase',
    };
    final result = await _runner('gh', [
      'pr',
      'merge',
      '$prNumber',
      flag,
      '--delete-branch',
    ], workingDirectory: workingDirectory);
    if (result.exitCode != 0) {
      throw GitHubOperationException('gh pr merge failed: ${result.stderr}');
    }
  }
}
