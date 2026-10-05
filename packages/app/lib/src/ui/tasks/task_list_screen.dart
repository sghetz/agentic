import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/org_providers.dart';
import '../../state/project_providers.dart';
import '../common/empty_state.dart';

/// Placeholder for Phase 0 slice 4; the filterable task list and create-task
/// flow are built in slice 5.
class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgId = ref.watch(selectedOrgIdProvider);
    final projectId = ref.watch(selectedProjectIdProvider);

    if (orgId == null) {
      return const EmptyState(
        message: 'Select or create an organization to get started',
      );
    }
    if (projectId == null) {
      return const EmptyState(
        message: 'Select or create a project to see its tasks',
      );
    }
    return const EmptyState(
      icon: Icons.construction,
      message: 'Task list coming in the next slice',
    );
  }
}
