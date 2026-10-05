/// Lifecycle states for a [Task]. See `task_state_machine.dart` for the
/// allowed-transition rules between these states.
enum TaskStatus {
  newTask,
  specified,
  inDesign,
  inDevelopment,
  inReview,
  awaitingApproval,
  done,
  blocked,
}
