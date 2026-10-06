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
}
