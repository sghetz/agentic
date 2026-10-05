import 'package:app/src/ui/tasks/task_event_timeline.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

core.TaskEvent _event({
  required int minute,
  required core.TaskEventType eventType,
  core.Actor actor = const core.Actor.user(),
  Map<String, Object?> payload = const {},
}) {
  return core.TaskEvent(
    id: 'evt-$minute',
    taskId: 'task-1',
    ts: DateTime.utc(2026, 1, 1, 0, minute),
    actor: actor,
    eventType: eventType,
    payload: payload,
  );
}

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('renders events newest first', (tester) async {
    final events = [
      _event(minute: 0, eventType: core.TaskEventType.created),
      _event(
        minute: 1,
        eventType: core.TaskEventType.statusChanged,
        payload: const {'to': 'specified'},
      ),
      _event(
        minute: 2,
        eventType: core.TaskEventType.commented,
        actor: const core.Actor.agent('developer'),
        payload: const {'text': 'opened a PR'},
      ),
    ];

    await tester.pumpWidget(_wrap(TaskEventTimeline(events: events)));

    expect(find.text('Task created'), findsOneWidget);
    expect(find.text('Status changed to specified'), findsOneWidget);
    expect(find.text('opened a PR'), findsOneWidget);

    // Newest (the comment) should appear above the oldest (creation).
    final commentPosition = tester.getTopLeft(find.text('opened a PR')).dy;
    final createdPosition = tester.getTopLeft(find.text('Task created')).dy;
    expect(commentPosition, lessThan(createdPosition));
  });

  testWidgets('shows an empty state with no events', (tester) async {
    await tester.pumpWidget(_wrap(const TaskEventTimeline(events: [])));
    expect(find.text('No activity yet'), findsOneWidget);
  });

  testWidgets('labels the actor for user vs agent events', (tester) async {
    final events = [
      _event(
        minute: 0,
        eventType: core.TaskEventType.created,
        actor: const core.Actor.user(),
      ),
      _event(
        minute: 1,
        eventType: core.TaskEventType.commented,
        actor: const core.Actor.agent('reviewer'),
        payload: const {'text': 'looks good'},
      ),
    ];

    await tester.pumpWidget(_wrap(TaskEventTimeline(events: events)));

    expect(find.textContaining('You ·'), findsOneWidget);
    expect(find.textContaining('reviewer ·'), findsOneWidget);
  });
}
