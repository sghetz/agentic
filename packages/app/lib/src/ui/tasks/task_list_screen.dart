import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/api_client_provider.dart';
import '../../state/org_providers.dart';
import '../../state/project_providers.dart';
import '../../state/task_providers.dart';
import '../common/empty_state.dart';
import '../common/error_state.dart';
import '../common/loading_state.dart';
import 'task_filters.dart';

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

    final tasksAsync = ref.watch(taskListProvider(orgId, projectId));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Row(
            children: [
              const Expanded(child: TaskFilters()),
              FilledButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('New task'),
                onPressed: () =>
                    _showCreateTaskDialog(context, ref, orgId, projectId),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: tasksAsync.when(
            data: (tasks) {
              if (tasks.isEmpty) {
                return const EmptyState(
                  message: 'No tasks match these filters',
                );
              }
              return ListView.separated(
                itemCount: tasks.length,
                separatorBuilder: (context, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text('Updated ${task.updatedAt.toLocal()}'),
                    trailing: Chip(label: Text(task.currentStatus.name)),
                    onTap: () => context.go('/tasks/${task.id}'),
                  );
                },
              );
            },
            loading: () => const LoadingState(),
            error: (error, _) => ErrorState(
              message: 'Could not load tasks',
              onRetry: () => ref.invalidate(taskListProvider(orgId, projectId)),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateTaskDialog(
    BuildContext context,
    WidgetRef ref,
    String orgId,
    String projectId,
  ) async {
    final titleController = TextEditingController();

    final shouldCreate = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New task'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (shouldCreate != true || titleController.text.trim().isEmpty) return;

    await ref
        .read(apiClientProvider)
        .createTask(
          orgId,
          projectId,
          core.CreateTaskRequest(title: titleController.text.trim()),
        );
    ref.invalidate(taskListProvider(orgId, projectId));
  }
}
