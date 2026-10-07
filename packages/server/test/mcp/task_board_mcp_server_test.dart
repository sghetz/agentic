import 'package:core/core.dart' as core;
import 'package:dart_mcp/client.dart';
import 'package:server/src/mcp/task_board_mcp_server.dart';
import 'package:server/src/repositories/org_store.dart';
import 'package:server/src/storage/org_database.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

/// Drives [TaskBoardMcpServer] over a purely in-memory channel pair -- no
/// real subprocess or stdio needed, same trick as the chat stream hub tests.
(TaskBoardMcpServer, ServerConnection) _connect(OrgStore store) {
  final controller = StreamChannelController<String>();
  final server = TaskBoardMcpServer(channel: controller.local, store: store);
  final client = MCPClient(
    Implementation(name: 'test-client', version: '1.0.0'),
  );
  final connection = client.connectServer(controller.foreign);
  return (server, connection);
}

Future<ServerConnection> _initialized(ServerConnection connection) async {
  await connection.initialize(
    InitializeRequest(
      protocolVersion: ProtocolVersion.latestSupported,
      capabilities: ClientCapabilities(),
      clientInfo: Implementation(name: 'test-client', version: '1.0.0'),
    ),
  );
  connection.notifyInitialized();
  return connection;
}

void main() {
  late OrgDatabase db;
  late OrgStore store;

  setUp(() {
    db = OrgDatabase.memory();
    store = OrgStore('org-1', db);
  });

  tearDown(() => db.close());

  test('create_task creates a task on the given project', () async {
    final project = await store.createProject(
      const core.CreateProjectRequest(name: 'P', slug: 'p'),
    );
    final (server, connection) = _connect(store);
    await _initialized(connection);

    final result = await connection.callTool(
      CallToolRequest(
        name: 'create_task',
        arguments: {'project_id': project.id, 'title': 'Fix the login bug'},
      ),
    );

    expect(result.isError, isNot(true));
    final text = (result.content.single as TextContent).text;
    expect(text, contains('Fix the login bug'));

    final tasks = await store.listTasks(project.id);
    expect(tasks, hasLength(1));
    expect(tasks.single.title, 'Fix the login bug');

    await server.shutdown();
  });

  test('create_task on an unknown project returns an error result', () async {
    final (server, connection) = _connect(store);
    await _initialized(connection);

    final result = await connection.callTool(
      CallToolRequest(
        name: 'create_task',
        arguments: {'project_id': 'no-such-project', 'title': 'T'},
      ),
    );

    expect(result.isError, true);
    await server.shutdown();
  });

  test('list_tasks returns tasks filtered by status', () async {
    final project = await store.createProject(
      const core.CreateProjectRequest(name: 'P', slug: 'p'),
    );
    final task = await store.createTask(
      project.id,
      const core.CreateTaskRequest(title: 'A task'),
    );
    final (server, connection) = _connect(store);
    await _initialized(connection);

    final result = await connection.callTool(
      CallToolRequest(
        name: 'list_tasks',
        arguments: {'project_id': project.id, 'status': 'newTask'},
      ),
    );

    expect(result.isError, isNot(true));
    final text = (result.content.single as TextContent).text;
    expect(text, contains('A task'));
    expect(text, contains(task.id));

    final doneResult = await connection.callTool(
      CallToolRequest(
        name: 'list_tasks',
        arguments: {'project_id': project.id, 'status': 'done'},
      ),
    );
    expect((doneResult.content.single as TextContent).text, 'No tasks found.');

    await server.shutdown();
  });

  test('assign_task appends an assigned event with the given role', () async {
    final project = await store.createProject(
      const core.CreateProjectRequest(name: 'P', slug: 'p'),
    );
    final task = await store.createTask(
      project.id,
      const core.CreateTaskRequest(title: 'A task'),
    );
    final (server, connection) = _connect(store);
    await _initialized(connection);

    final result = await connection.callTool(
      CallToolRequest(
        name: 'assign_task',
        arguments: {'task_id': task.id, 'role': 'developer'},
      ),
    );

    expect(result.isError, isNot(true));
    final events = await store.listTaskEvents(task.id);
    final assigned = events.where(
      (e) => e.eventType == core.TaskEventType.assigned,
    );
    expect(assigned, hasLength(1));
    expect(assigned.single.payload['role'], 'developer');
    expect(assigned.single.actor, const core.Actor.agent('orchestrator'));

    await server.shutdown();
  });

  test('assign_task on an unknown task returns an error result', () async {
    final (server, connection) = _connect(store);
    await _initialized(connection);

    final result = await connection.callTool(
      CallToolRequest(
        name: 'assign_task',
        arguments: {'task_id': 'no-such-task', 'role': 'developer'},
      ),
    );

    expect(result.isError, true);
    await server.shutdown();
  });
}
