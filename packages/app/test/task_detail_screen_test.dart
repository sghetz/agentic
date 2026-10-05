import 'package:app/src/api/api_client.dart';
import 'package:app/src/api/api_client_provider.dart';
import 'package:app/src/state/org_providers.dart';
import 'package:app/src/ui/tasks/task_detail_screen.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeApiClient extends ApiClient {
  _FakeApiClient({
    required core.Task task,
    required List<core.TaskEvent> events,
  }) : _task = task,
       _events = events,
       super(baseUrl: Uri.parse('http://localhost'));

  core.Task _task;
  List<core.TaskEvent> _events;
  final appendedEvents = <core.CreateTaskEventRequest>[];

  @override
  Future<core.Task> getTask(
    String orgId,
    String taskId, {
    DateTime? at,
  }) async => _task;

  @override
  Future<List<core.TaskEvent>> listTaskEvents(
    String orgId,
    String taskId,
  ) async => _events;

  @override
  Future<List<core.Artifact>> listArtifacts(
    String orgId,
    String taskId,
  ) async => [];

  @override
  Future<core.TaskEvent> appendTaskEvent(
    String orgId,
    String taskId,
    core.CreateTaskEventRequest request,
  ) async {
    appendedEvents.add(request);
    final event = core.TaskEvent(
      id: 'evt-${appendedEvents.length}',
      taskId: taskId,
      ts: DateTime.now().toUtc(),
      actor: request.actor,
      eventType: request.eventType,
      payload: request.payload,
    );
    _events = [..._events, event];
    _task = _task.copyWith(currentStatus: core.deriveTask(_events).status);
    return event;
  }
}

core.TaskEvent _createdEvent() => core.TaskEvent(
  id: 'evt-0',
  taskId: 'task-1',
  ts: DateTime.utc(2026, 1, 1),
  actor: const core.Actor.user(),
  eventType: core.TaskEventType.created,
  payload: const {},
);

core.TaskEvent _statusEvent(int minute, String to) => core.TaskEvent(
  id: 'evt-$minute',
  taskId: 'task-1',
  ts: DateTime.utc(2026, 1, 1, 0, minute),
  actor: const core.Actor.user(),
  eventType: core.TaskEventType.statusChanged,
  payload: {'to': to},
);

Widget _buildApp(_FakeApiClient client) {
  return ProviderScope(
    overrides: [
      apiClientProvider.overrideWithValue(client),
      selectedOrgIdProvider.overrideWith(() => _FixedOrgId()),
    ],
    child: const MaterialApp(
      home: Scaffold(body: TaskDetailScreen(taskId: 'task-1')),
    ),
  );
}

class _FixedOrgId extends SelectedOrgId {
  @override
  String? build() => 'org-1';
}

void main() {
  testWidgets(
    'a new task shows a status menu offering only legal next statuses',
    (tester) async {
      final client = _FakeApiClient(
        task: core.Task(
          id: 'task-1',
          projectId: 'proj-1',
          title: 'Do the thing',
          currentStatus: core.TaskStatus.newTask,
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
        events: [_createdEvent()],
      );

      await tester.pumpWidget(_buildApp(client));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('statusMenu')), findsOneWidget);
      expect(find.byKey(const Key('reopenButton')), findsNothing);

      await tester.tap(find.byKey(const Key('statusMenu')));
      await tester.pumpAndSettle();

      // newTask may only legally move to specified or blocked.
      expect(
        find.widgetWithText(PopupMenuItem<core.TaskStatus>, 'specified'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(PopupMenuItem<core.TaskStatus>, 'blocked'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(PopupMenuItem<core.TaskStatus>, 'done'),
        findsNothing,
      );

      await tester.tap(
        find.widgetWithText(PopupMenuItem<core.TaskStatus>, 'specified'),
      );
      await tester.pumpAndSettle();

      expect(client.appendedEvents, hasLength(1));
      expect(
        client.appendedEvents.single.eventType,
        core.TaskEventType.statusChanged,
      );
      expect(client.appendedEvents.single.payload['to'], 'specified');
    },
  );

  testWidgets('a done task shows Reopen instead of a status menu', (
    tester,
  ) async {
    final events = [
      _createdEvent(),
      _statusEvent(1, 'specified'),
      _statusEvent(2, 'inDevelopment'),
      _statusEvent(3, 'inReview'),
      _statusEvent(4, 'awaitingApproval'),
      _statusEvent(5, 'done'),
    ];
    final client = _FakeApiClient(
      task: core.Task(
        id: 'task-1',
        projectId: 'proj-1',
        title: 'Shipped',
        currentStatus: core.TaskStatus.done,
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1, 0, 5),
      ),
      events: events,
    );

    await tester.pumpWidget(_buildApp(client));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('reopenButton')), findsOneWidget);
    expect(find.byKey(const Key('statusMenu')), findsNothing);

    await tester.tap(find.byKey(const Key('reopenButton')));
    await tester.pumpAndSettle();

    expect(client.appendedEvents, hasLength(1));
    expect(client.appendedEvents.single.eventType, core.TaskEventType.reopened);
  });

  testWidgets('blocked only offers the status it was blocked from', (
    tester,
  ) async {
    final events = [
      _createdEvent(),
      _statusEvent(1, 'specified'),
      _statusEvent(2, 'blocked'),
    ];
    final client = _FakeApiClient(
      task: core.Task(
        id: 'task-1',
        projectId: 'proj-1',
        title: 'Stuck',
        currentStatus: core.TaskStatus.blocked,
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1, 0, 2),
      ),
      events: events,
    );

    await tester.pumpWidget(_buildApp(client));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('statusMenu')));
    await tester.pumpAndSettle();

    expect(
      find.widgetWithText(PopupMenuItem<core.TaskStatus>, 'specified'),
      findsOneWidget,
    );
    expect(find.byType(PopupMenuItem<core.TaskStatus>), findsOneWidget);
  });
}
