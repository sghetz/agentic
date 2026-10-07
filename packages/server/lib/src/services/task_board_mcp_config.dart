import 'dart:convert';
import 'dart:io';

/// Name this MCP server is registered under in the `--mcp-config` value --
/// shared with [taskBoardAllowedTools], since the CLI's tool-permission
/// names are `mcp__<serverName>__<toolName>`.
const taskBoardMcpServerName = 'task-board';

const _taskBoardToolNames = ['create_task', 'list_tasks', 'assign_task'];

/// Builds the `--mcp-config` value for an Orchestrator turn: an inline JSON
/// string (the CLI accepts a literal string or a file path there) pointing
/// at `bin/task_mcp_server.dart`, scoped to one org via `--org-id`.
/// Resolved relative to the running script's own location (not the process
/// cwd), so it works regardless of where the server was launched from.
String taskBoardMcpConfigJson(String orgId) {
  final serverScript = Platform.script
      .resolve('task_mcp_server.dart')
      .toFilePath();
  return jsonEncode({
    'mcpServers': {
      taskBoardMcpServerName: {
        'type': 'stdio',
        'command': 'dart',
        'args': ['run', serverScript, '--org-id', orgId],
      },
    },
  });
}

/// MCP tools, even from a `--strict-mcp-config`-scoped server, still go
/// through the CLI's normal permission system -- confirmed live: without
/// this, every call_tool is silently blocked in non-interactive `-p` mode
/// (there's no human to approve it). `--allowedTools` with the
/// `mcp__<server>__<tool>` name is what actually grants it.
List<String> taskBoardAllowedTools() => [
  for (final tool in _taskBoardToolNames)
    'mcp__${taskBoardMcpServerName}__$tool',
];
