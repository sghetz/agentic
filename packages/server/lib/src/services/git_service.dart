import 'dart:io';

class GitOperationException implements Exception {
  GitOperationException(this.message);

  final String message;

  @override
  String toString() => 'GitOperationException: $message';
}

class GitCloneResult {
  const GitCloneResult({required this.path, required this.pulled});

  final String path;

  /// true if the repo already existed locally and was pulled; false if this
  /// was a fresh clone.
  final bool pulled;
}

/// Thin wrapper over the `git` CLI. Deterministic, no LLM involvement --
/// clone if the target doesn't exist yet, otherwise fast-forward pull.
class GitService {
  const GitService();

  Future<GitCloneResult> cloneOrPull({
    required String repoUrl,
    required String targetPath,
    String? branch,
  }) async {
    final gitDir = Directory('$targetPath/.git');
    if (await gitDir.exists()) {
      final result = await Process.run('git', [
        'pull',
        '--ff-only',
      ], workingDirectory: targetPath);
      if (result.exitCode != 0) {
        throw GitOperationException('git pull failed: ${result.stderr}');
      }
      return GitCloneResult(path: targetPath, pulled: true);
    }

    await Directory(targetPath).parent.create(recursive: true);
    final result = await Process.run('git', [
      'clone',
      if (branch != null) ...['--branch', branch],
      repoUrl,
      targetPath,
    ]);
    if (result.exitCode != 0) {
      throw GitOperationException('git clone failed: ${result.stderr}');
    }
    return GitCloneResult(path: targetPath, pulled: false);
  }

  /// Creates a new branch and a disposable worktree for it, off the repo's
  /// current HEAD. All git history for the fix attempt lives here, isolated
  /// from the repo's primary checkout.
  Future<void> createWorktree({
    required String repoPath,
    required String branchName,
    required String worktreePath,
  }) async {
    await Directory(worktreePath).parent.create(recursive: true);
    final result = await Process.run('git', [
      'worktree',
      'add',
      '-b',
      branchName,
      worktreePath,
    ], workingDirectory: repoPath);
    if (result.exitCode != 0) {
      throw GitOperationException('git worktree add failed: ${result.stderr}');
    }
  }

  /// Removes a worktree and its branch. Used to discard a fix attempt that
  /// either made no changes or still failed verification -- never leaves
  /// stale half-fixes lying around.
  Future<void> removeWorktree({
    required String repoPath,
    required String worktreePath,
    required String branchName,
  }) async {
    await Process.run('git', [
      'worktree',
      'remove',
      worktreePath,
      '--force',
    ], workingDirectory: repoPath);
    await Process.run('git', [
      'branch',
      '-D',
      branchName,
    ], workingDirectory: repoPath);
  }

  /// The diff between where [branchName] diverged from [baseBranch] and its
  /// current `HEAD` (`base...HEAD`, not `base..HEAD`) -- i.e. just what this
  /// branch added, unaffected by anything [baseBranch] has moved onto since.
  /// Used to show Reviewer exactly what Developer changed without giving it
  /// any `git` tool access of its own.
  Future<String> diff({
    required String worktreePath,
    required String baseBranch,
  }) async {
    final result = await Process.run('git', [
      'diff',
      '$baseBranch...HEAD',
    ], workingDirectory: worktreePath);
    if (result.exitCode != 0) {
      throw GitOperationException('git diff failed: ${result.stderr}');
    }
    return result.stdout as String;
  }

  Future<bool> hasUncommittedChanges(String worktreePath) async {
    final result = await Process.run('git', [
      'status',
      '--porcelain',
    ], workingDirectory: worktreePath);
    return (result.stdout as String).trim().isNotEmpty;
  }

  /// Stages and commits everything in the worktree. The only git operation
  /// in this whole fix-attempt flow that Claude Code itself never performs
  /// -- it has no `git` tool access at all, only `Edit` and
  /// `flutter`/`dart`/`fvm` bash commands.
  Future<void> commitAll(String worktreePath, String message) async {
    final add = await Process.run('git', [
      'add',
      '-A',
    ], workingDirectory: worktreePath);
    if (add.exitCode != 0) {
      throw GitOperationException('git add failed: ${add.stderr}');
    }
    final commit = await Process.run('git', [
      'commit',
      '-m',
      message,
    ], workingDirectory: worktreePath);
    if (commit.exitCode != 0) {
      throw GitOperationException('git commit failed: ${commit.stderr}');
    }
  }
}
