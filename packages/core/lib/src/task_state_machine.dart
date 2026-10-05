import 'enums/task_event_type.dart';
import 'enums/task_status.dart';
import 'models/task_event.dart';

/// A task's derived status plus the one piece of history the state machine
/// needs beyond the current status: what to return to when unblocked.
/// Only meaningful while [status] is [TaskStatus.blocked].
final class TaskState {
  const TaskState(this.status, this.statusBeforeBlocked);

  final TaskStatus status;
  final TaskStatus? statusBeforeBlocked;

  @override
  bool operator ==(Object other) =>
      other is TaskState &&
      other.status == status &&
      other.statusBeforeBlocked == statusBeforeBlocked;

  @override
  int get hashCode => Object.hash(status, statusBeforeBlocked);

  @override
  String toString() => 'TaskState($status, before: $statusBeforeBlocked)';
}

const _forwardOrder = [
  TaskStatus.newTask,
  TaskStatus.specified,
  TaskStatus.inDesign,
  TaskStatus.inDevelopment,
  TaskStatus.inReview,
  TaskStatus.awaitingApproval,
  TaskStatus.done,
];

/// Statuses one forward step away from [from], honoring "inDesign may be
/// skipped" (specified can go straight to inDevelopment).
Set<TaskStatus> _forwardTargets(TaskStatus from) {
  final i = _forwardOrder.indexOf(from);
  if (i == -1 || i == _forwardOrder.length - 1) return const {};
  if (from == TaskStatus.specified) {
    return const {TaskStatus.inDesign, TaskStatus.inDevelopment};
  }
  return {_forwardOrder[i + 1]};
}

/// Valid next statuses for a plain `statusChanged` event from [state].
/// `done` only changes via a `reopened` event, so it has no entries here.
/// `blocked` only ever returns to whatever status preceded it.
Set<TaskStatus> allowedNextStatuses(TaskState state) {
  if (state.status == TaskStatus.done) return const {};
  if (state.status == TaskStatus.blocked) {
    return {state.statusBeforeBlocked ?? TaskStatus.specified};
  }
  return {..._forwardTargets(state.status), TaskStatus.blocked};
}

bool canTransition(TaskState state, TaskStatus to) =>
    allowedNextStatuses(state).contains(to);

/// Folds a task's full event history into its current [TaskState].
TaskState deriveTask(List<TaskEvent> events) => deriveTaskAt(events, null);

/// Folds a task's event history up to and including [at] into the
/// [TaskState] it had at that moment. `at == null` means "now" (all events).
TaskState deriveTaskAt(List<TaskEvent> events, DateTime? at) {
  final relevant = events.where((e) => at == null || !e.ts.isAfter(at)).toList()
    ..sort((a, b) => a.ts.compareTo(b.ts));

  var state = const TaskState(TaskStatus.newTask, null);
  for (final event in relevant) {
    state = switch (event.eventType) {
      TaskEventType.created => const TaskState(TaskStatus.newTask, null),
      TaskEventType.reopened => const TaskState(TaskStatus.specified, null),
      TaskEventType.statusChanged => _applyStatusChanged(state, event),
      TaskEventType.commented ||
      TaskEventType.artifactAttached ||
      TaskEventType.edited => state,
    };
  }
  return state;
}

TaskState _applyStatusChanged(TaskState state, TaskEvent event) {
  final to = TaskStatus.values.byName(event.payload['to'] as String);
  if (state.status == TaskStatus.blocked) {
    // Leaving `blocked` always clears the remembered prior status.
    return TaskState(to, null);
  }
  if (to == TaskStatus.blocked) {
    return TaskState(TaskStatus.blocked, state.status);
  }
  return TaskState(to, null);
}
