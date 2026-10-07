import 'dart:io';

import 'package:path/path.dart' as p;

/// Where Agentic stores its SQLite databases and cloned repos. Injectable
/// so tests use a temp directory instead of the real locations.
class AgenticPaths {
  const AgenticPaths(this.dataDir, this.reposBaseDir);

  factory AgenticPaths.standard() {
    final home = Platform.environment['HOME'];
    if (home == null) {
      throw StateError('HOME environment variable is not set');
    }
    return AgenticPaths(
      p.join(home, 'Library', 'Application Support', 'Agentic'),
      p.join(home, 'Agentic', 'repos'),
    );
  }

  final String dataDir;

  /// Where cloned project repos live, per the architecture doc:
  /// `~/Agentic/repos/<org_slug>/<project_slug>/`.
  final String reposBaseDir;

  String get registryDbPath => p.join(dataDir, 'registry.db');

  String orgDbPath(String orgId) => p.join(dataDir, 'orgs', orgId, 'data.db');

  String repoPath(String orgSlug, String projectSlug) =>
      p.join(reposBaseDir, orgSlug, projectSlug);

  /// A neutral, file-free directory for org-scoped chat turns (e.g. the
  /// Orchestrator's General channel) that aren't tied to one project's repo.
  /// Claude Code auto-includes cwd/git-status/CLAUDE.md context by default,
  /// so this must never be the Agentic server's own source tree.
  String chatScratchDir(String orgId) =>
      p.join(dataDir, 'orgs', orgId, 'chat-scratch');

  /// A disposable worktree for one fix attempt. [suffix] should be unique
  /// per attempt (e.g. a timestamp) -- callers also use it to build the
  /// matching branch name, so the two stay associated.
  String worktreePath(String orgSlug, String projectSlug, String suffix) =>
      p.join(reposBaseDir, orgSlug, '$projectSlug-worktrees', suffix);
}
