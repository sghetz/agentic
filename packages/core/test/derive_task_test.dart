import 'package:core/core.dart';
import 'package:test/test.dart';

TaskEvent _event({
  required int minute,
  required TaskEventType eventType,
  Map<String, Object?> payload = const {},
}) {
  return TaskEvent(
    id: 'evt-$minute',
    taskId: 'task-1',
    ts: DateTime.utc(2026, 1, 1, 0, minute),
    actor: const Actor.user(),
    eventType: eventType,
    payload: payload,
  );
}

void main() {
  group('deriveTask', () {
    test('folds a full lifecycle, including a block/unblock round trip', () {
      final events = [
        _event(minute: 0, eventType: TaskEventType.created),
        _event(
          minute: 1,
          eventType: TaskEventType.statusChanged,
          payload: {'to': 'specified'},
        ),
        _event(
          minute: 2,
          eventType: TaskEventType.statusChanged,
          payload: {'to': 'inDevelopment'}, // skips inDesign
        ),
        _event(
          minute: 3,
          eventType: TaskEventType.statusChanged,
          payload: {'to': 'blocked'},
        ),
        _event(
          minute: 4,
          eventType: TaskEventType.statusChanged,
          payload: {'to': 'inDevelopment'}, // unblock, back to where it was
        ),
        _event(
          minute: 5,
          eventType: TaskEventType.statusChanged,
          payload: {'to': 'inReview'},
        ),
        _event(
          minute: 6,
          eventType: TaskEventType.statusChanged,
          payload: {'to': 'awaitingApproval'},
        ),
        _event(
          minute: 7,
          eventType: TaskEventType.statusChanged,
          payload: {'to': 'done'},
        ),
      ];

      expect(deriveTask(events).status, TaskStatus.done);
    });

    test('reopened always returns to specified, regardless of payload', () {
      final events = [
        _event(minute: 0, eventType: TaskEventType.created),
        _event(
          minute: 1,
          eventType: TaskEventType.statusChanged,
          payload: {'to': 'done'},
        ),
        _event(minute: 2, eventType: TaskEventType.reopened),
      ];

      expect(deriveTask(events).status, TaskStatus.specified);
    });

    test('comments, edits, and artifact attachments do not change status', () {
      final events = [
        _event(minute: 0, eventType: TaskEventType.created),
        _event(
          minute: 1,
          eventType: TaskEventType.statusChanged,
          payload: {'to': 'specified'},
        ),
        _event(
          minute: 2,
          eventType: TaskEventType.commented,
          payload: {'text': 'hi'},
        ),
        _event(
          minute: 3,
          eventType: TaskEventType.edited,
          payload: {'field': 'title'},
        ),
        _event(
          minute: 4,
          eventType: TaskEventType.artifactAttached,
          payload: {'artifactId': 'a1'},
        ),
      ];

      expect(deriveTask(events).status, TaskStatus.specified);
    });

    test(
      'out-of-order events are folded in timestamp order, not list order',
      () {
        final inOrder = [
          _event(minute: 0, eventType: TaskEventType.created),
          _event(
            minute: 1,
            eventType: TaskEventType.statusChanged,
            payload: {'to': 'specified'},
          ),
          _event(
            minute: 2,
            eventType: TaskEventType.statusChanged,
            payload: {'to': 'inDevelopment'},
          ),
        ];
        final shuffled = [inOrder[2], inOrder[0], inOrder[1]];

        expect(deriveTask(shuffled).status, deriveTask(inOrder).status);
      },
    );
  });

  group('deriveTaskAt', () {
    test(
      'reconstructs the status as of a past date, ignoring later events',
      () {
        final events = [
          _event(minute: 0, eventType: TaskEventType.created),
          _event(
            minute: 1,
            eventType: TaskEventType.statusChanged,
            payload: {'to': 'specified'},
          ),
          _event(
            minute: 2,
            eventType: TaskEventType.statusChanged,
            payload: {'to': 'inReview'},
          ),
          _event(
            minute: 3,
            eventType: TaskEventType.statusChanged,
            payload: {'to': 'done'},
          ),
        ];

        final asOfMinute2 = deriveTaskAt(
          events,
          DateTime.utc(2026, 1, 1, 0, 2),
        );
        expect(asOfMinute2.status, TaskStatus.inReview);

        expect(deriveTaskAt(events, null).status, TaskStatus.done);
      },
    );
  });
}
