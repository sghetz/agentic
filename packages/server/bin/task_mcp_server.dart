import 'dart:io';

import 'package:dart_mcp/stdio.dart';
import 'package:server/src/config.dart';
import 'package:server/src/mcp/task_board_mcp_server.dart';
import 'package:server/src/repositories/org_store.dart';
import 'package:server/src/storage/org_database.dart';

/// Spawned by the Claude Code CLI itself (via `--mcp-config`) for one
/// Orchestrator turn -- not a long-running service. Scoped to exactly one
/// org, passed via `--org-id`, matching every other access path's rule that
/// nothing ever sees two orgs' data in the same place.
Future<void> main(List<String> arguments) async {
  final orgIdIndex = arguments.indexOf('--org-id');
  if (orgIdIndex == -1 || orgIdIndex + 1 >= arguments.length) {
    stderr.writeln('Usage: task_mcp_server --org-id <orgId>');
    exit(64);
  }
  final orgId = arguments[orgIdIndex + 1];

  final paths = AgenticPaths.standard();
  final store = OrgStore(orgId, OrgDatabase.file(paths.orgDbPath(orgId)));
  final channel = stdioChannel(input: stdin, output: stdout);
  final server = TaskBoardMcpServer(channel: channel, store: store);
  await server.done;
  await store.close();
}
