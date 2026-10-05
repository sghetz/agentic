import 'dart:io';

import 'package:path/path.dart' as p;

/// Where Agentic stores its SQLite databases. Injectable so tests use a
/// temp directory instead of the real `~/Library/Application Support/Agentic/`.
class AgenticPaths {
  const AgenticPaths(this.dataDir);

  factory AgenticPaths.standard() {
    final home = Platform.environment['HOME'];
    if (home == null) {
      throw StateError('HOME environment variable is not set');
    }
    return AgenticPaths(
      p.join(home, 'Library', 'Application Support', 'Agentic'),
    );
  }

  final String dataDir;

  String get registryDbPath => p.join(dataDir, 'registry.db');

  String orgDbPath(String orgId) => p.join(dataDir, 'orgs', orgId, 'data.db');
}
