import 'package:flutter/material.dart';

import '../common/empty_state.dart';

/// Placeholder for Phase 0 slice 4; the event timeline, status controls,
/// and as-of-date view are built in slice 5.
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.construction,
      message: 'Task $taskId detail coming in the next slice',
    );
  }
}
