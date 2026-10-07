import 'dart:async';

import 'package:core/core.dart' as core;
import 'package:dart_mcp/server.dart';
import 'package:stream_channel/stream_channel.dart';

import '../repositories/org_store.dart';

/// Exposes a narrow task-board action set to the Orchestrator's Claude Code
/// CLI turn via MCP: `create_task`, `list_tasks`, `assign_task`. Each tool
/// is a thin wrapper around the same [OrgStore] methods the HTTP routes
/// use -- no new business logic lives here. Scoped to exactly one org's
/// [OrgStore], same as every other access path in this codebase; the
/// Claude Code CLI spawns one of these per turn via `--mcp-config`, pointed
/// at this org specifically (see `task_board_mcp_config.dart`).
final class TaskBoardMcpServer extends MCPServer with ToolsSupport {
  TaskBoardMcpServer({
    required StreamChannel<String> channel,
    required this.store,
  }) : super.fromStreamChannel(
         channel,
         implementation: Implementation(
           name: 'agentic-task-board',
           version: '1.0.0',
         ),
         instructions: 'Task-board actions for the Agentic Orchestrator.',
       );

  final OrgStore store;

  @override
  FutureOr<InitializeResult> initialize(InitializeRequest request) async {
    final result = await super.initialize(request);
    _registerTools();
    return result;
  }

  void _registerTools() {
    registerTool(
      Tool(
        name: 'create_task',
        description: "Create a new task on a project's task board.",
        inputSchema: ObjectSchema(
          properties: {
            'project_id': StringSchema(
              description: 'The id of the project this task belongs to.',
            ),
            'title': StringSchema(description: 'A short, specific task title.'),
          },
          required: ['project_id', 'title'],
        ),
      ),
      _handleCreateTask,
    );

    registerTool(
      Tool(
        name: 'list_tasks',
        description:
            "List tasks on a project's task board, optionally filtered by "
            'status.',
        inputSchema: ObjectSchema(
          properties: {
            'project_id': StringSchema(
              description: 'The id of the project to list tasks for.',
            ),
            'status': StringSchema(
              description:
                  'Optional status filter: newTask, specified, inDesign, '
                  'inDevelopment, inReview, awaitingApproval, done, or '
                  'blocked.',
            ),
          },
          required: ['project_id'],
        ),
      ),
      _handleListTasks,
    );

    registerTool(
      Tool(
        name: 'assign_task',
        description:
            'Record which agent role (or the owner) a task is assigned to.',
        inputSchema: ObjectSchema(
          properties: {
            'task_id': StringSchema(
              description: 'The id of the task to assign.',
            ),
            'role': StringSchema(
              description:
                  'The agent role to assign it to, e.g. "developer", '
                  '"analyst".',
            ),
          },
          required: ['task_id', 'role'],
        ),
      ),
      _handleAssignTask,
    );
  }

  Future<CallToolResult> _handleCreateTask(CallToolRequest request) async {
    final args = request.arguments ?? const {};
    final projectId = args['project_id'] as String?;
    final title = args['title'] as String?;
    if (projectId == null || title == null) {
      return _error('project_id and title are required.');
    }
    try {
      final task = await store.createTask(
        projectId,
        core.CreateTaskRequest(title: title),
      );
      return _ok(
        'Created task "${task.title}" (id: ${task.id}) in status '
        '${task.currentStatus.name}.',
      );
    } on ProjectNotFound {
      return _error('No project with id "$projectId" in this organization.');
    }
  }

  Future<CallToolResult> _handleListTasks(CallToolRequest request) async {
    final args = request.arguments ?? const {};
    final projectId = args['project_id'] as String?;
    if (projectId == null) return _error('project_id is required.');

    core.TaskStatus? status;
    final statusArg = args['status'] as String?;
    if (statusArg != null) {
      try {
        status = core.TaskStatus.values.byName(statusArg);
      } on ArgumentError {
        return _error('Unknown status "$statusArg".');
      }
    }

    final tasks = await store.listTasks(projectId, status: status);
    if (tasks.isEmpty) return _ok('No tasks found.');
    return _ok(
      tasks
          .map(
            (t) =>
                '- ${t.title} (id: ${t.id}, status: ${t.currentStatus.name})',
          )
          .join('\n'),
    );
  }

  Future<CallToolResult> _handleAssignTask(CallToolRequest request) async {
    final args = request.arguments ?? const {};
    final taskId = args['task_id'] as String?;
    final role = args['role'] as String?;
    if (taskId == null || role == null) {
      return _error('task_id and role are required.');
    }
    try {
      await store.appendTaskEvent(
        taskId,
        core.CreateTaskEventRequest(
          actor: const core.Actor.agent('orchestrator'),
          eventType: core.TaskEventType.assigned,
          payload: {'role': role},
        ),
      );
      return _ok('Assigned task $taskId to $role.');
    } on TaskNotFound {
      return _error('No task with id "$taskId" in this organization.');
    }
  }

  CallToolResult _ok(String text) =>
      CallToolResult(content: [TextContent(text: text)]);

  CallToolResult _error(String text) =>
      CallToolResult(content: [TextContent(text: text)], isError: true);
}
