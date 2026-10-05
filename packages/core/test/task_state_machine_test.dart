import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('allowedNextStatuses / canTransition', () {
    test('newTask can only move to specified', () {
      const state = TaskState(TaskStatus.newTask, null);
      expect(allowedNextStatuses(state), {
        TaskStatus.specified,
        TaskStatus.blocked,
      });
    });

    test('specified may skip inDesign and go straight to inDevelopment', () {
      const state = TaskState(TaskStatus.specified, null);
      expect(allowedNextStatuses(state), {
        TaskStatus.inDesign,
        TaskStatus.inDevelopment,
        TaskStatus.blocked,
      });
    });

    test('inDesign moves forward to inDevelopment', () {
      const state = TaskState(TaskStatus.inDesign, null);
      expect(allowedNextStatuses(state), {
        TaskStatus.inDevelopment,
        TaskStatus.blocked,
      });
    });

    test('done has no outgoing statusChanged transitions', () {
      const state = TaskState(TaskStatus.done, null);
      expect(allowedNextStatuses(state), isEmpty);
      expect(canTransition(state, TaskStatus.specified), isFalse);
    });

    test('blocked only returns to the status it was blocked from', () {
      const state = TaskState(TaskStatus.blocked, TaskStatus.inDevelopment);
      expect(allowedNextStatuses(state), {TaskStatus.inDevelopment});
      expect(canTransition(state, TaskStatus.inReview), isFalse);
    });

    test('blocked is reachable from any non-done state', () {
      for (final status in TaskStatus.values) {
        if (status == TaskStatus.done || status == TaskStatus.blocked) continue;
        expect(
          canTransition(TaskState(status, null), TaskStatus.blocked),
          isTrue,
        );
      }
    });
  });
}
