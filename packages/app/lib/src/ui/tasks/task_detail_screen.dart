import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client_provider.dart';
import '../../state/org_providers.dart';
import '../../state/task_providers.dart';
import '../common/empty_state.dart';
import '../common/error_state.dart';
import '../common/loading_state.dart';
import 'as_of_date_picker.dart';
import 'development_panel.dart';
import 'task_event_timeline.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  DateTime? _asOfDate;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orgId = ref.watch(selectedOrgIdProvider);
    if (orgId == null) {
      return const EmptyState(message: 'Select an organization first');
    }

    final taskAsync = ref.watch(
      taskDetailProvider(orgId, widget.taskId, at: _asOfDate),
    );
    final eventsAsync = ref.watch(taskEventsProvider(orgId, widget.taskId));

    return taskAsync.when(
      data: (task) => eventsAsync.when(
        data: (events) => _TaskDetailBody(
          orgId: orgId,
          taskId: widget.taskId,
          task: task,
          events: events,
          asOfDate: _asOfDate,
          onAsOfDateChanged: (date) => setState(() => _asOfDate = date),
          commentController: _commentController,
          onAppendEvent: (request) => _appendEvent(orgId, request),
        ),
        loading: () => const LoadingState(),
        error: (error, _) =>
            const ErrorState(message: 'Could not load the event log'),
      ),
      loading: () => const LoadingState(),
      error: (error, _) =>
          const ErrorState(message: 'Could not load this task'),
    );
  }

  Future<void> _appendEvent(
    String orgId,
    core.CreateTaskEventRequest request,
  ) async {
    await ref
        .read(apiClientProvider)
        .appendTaskEvent(orgId, widget.taskId, request);
    ref.invalidate(taskDetailProvider(orgId, widget.taskId, at: _asOfDate));
    ref.invalidate(taskEventsProvider(orgId, widget.taskId));
  }
}

class _TaskDetailBody extends ConsumerWidget {
  const _TaskDetailBody({
    required this.orgId,
    required this.taskId,
    required this.task,
    required this.events,
    required this.asOfDate,
    required this.onAsOfDateChanged,
    required this.commentController,
    required this.onAppendEvent,
  });

  final String orgId;
  final String taskId;
  final core.Task task;
  final List<core.TaskEvent> events;
  final DateTime? asOfDate;
  final ValueChanged<DateTime?> onAsOfDateChanged;
  final TextEditingController commentController;
  final Future<void> Function(core.CreateTaskEventRequest request)
  onAppendEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveState = core.deriveTask(events);
    final allowedNext = core.allowedNextStatuses(liveState);
    final artifactsAsync = ref.watch(taskArtifactsProvider(orgId, taskId));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              AsOfDatePicker(value: asOfDate, onChanged: onAsOfDateChanged),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Chip(label: Text('Status: ${task.currentStatus.name}')),
              const SizedBox(width: 12),
              if (asOfDate == null)
                _StatusControls(
                  liveState: liveState,
                  allowedNext: allowedNext,
                  onAppendEvent: onAppendEvent,
                )
              else
                Text(
                  'Viewing as of ${asOfDate!.toLocal()} -- actions disabled',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 220),
            child: SingleChildScrollView(
              child: DevelopmentPanel(
                orgId: orgId,
                projectId: task.projectId,
                taskId: taskId,
                task: task,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Activity',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Expanded(child: TaskEventTimeline(events: events)),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              decoration: const InputDecoration(
                                hintText: 'Add a comment',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              final text = commentController.text.trim();
                              if (text.isEmpty) return;
                              onAppendEvent(
                                core.CreateTaskEventRequest(
                                  actor: const core.Actor.user(),
                                  eventType: core.TaskEventType.commented,
                                  payload: {'text': text},
                                ),
                              );
                              commentController.clear();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Artifacts',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Attach artifact',
                            icon: const Icon(Icons.add),
                            onPressed: () =>
                                _showAttachArtifactDialog(context, ref),
                          ),
                        ],
                      ),
                      Expanded(
                        child: artifactsAsync.when(
                          data: (artifacts) {
                            if (artifacts.isEmpty) {
                              return const EmptyState(
                                message: 'No artifacts yet',
                              );
                            }
                            return ListView(
                              children: [
                                for (final artifact in artifacts)
                                  ListTile(
                                    dense: true,
                                    title: Text(
                                      '${artifact.kind.name} v${artifact.version}',
                                    ),
                                    subtitle: Text(artifact.uri),
                                  ),
                              ],
                            );
                          },
                          loading: () => const LoadingState(),
                          error: (error, _) => const ErrorState(
                            message: 'Could not load artifacts',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAttachArtifactDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final uriController = TextEditingController();
    var kind = core.ArtifactKind.diagram;

    final shouldAttach = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Attach artifact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: uriController,
                decoration: const InputDecoration(labelText: 'URI'),
              ),
              const SizedBox(height: 8),
              DropdownButton<core.ArtifactKind>(
                value: kind,
                items: [
                  for (final k in core.ArtifactKind.values)
                    DropdownMenuItem(value: k, child: Text(k.name)),
                ],
                onChanged: (value) => setState(() => kind = value ?? kind),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Attach'),
            ),
          ],
        ),
      ),
    );

    if (shouldAttach != true || uriController.text.trim().isEmpty) return;

    await ref
        .read(apiClientProvider)
        .createArtifact(
          orgId,
          taskId,
          core.CreateArtifactRequest(
            kind: kind,
            uri: uriController.text.trim(),
          ),
        );
    ref.invalidate(taskArtifactsProvider(orgId, taskId));
  }
}

class _StatusControls extends StatelessWidget {
  const _StatusControls({
    required this.liveState,
    required this.allowedNext,
    required this.onAppendEvent,
  });

  final core.TaskState liveState;
  final Set<core.TaskStatus> allowedNext;
  final Future<void> Function(core.CreateTaskEventRequest request)
  onAppendEvent;

  @override
  Widget build(BuildContext context) {
    if (liveState.status == core.TaskStatus.done) {
      return OutlinedButton.icon(
        key: const Key('reopenButton'),
        icon: const Icon(Icons.replay),
        label: const Text('Reopen'),
        onPressed: () => onAppendEvent(
          const core.CreateTaskEventRequest(
            actor: core.Actor.user(),
            eventType: core.TaskEventType.reopened,
          ),
        ),
      );
    }

    if (allowedNext.isEmpty) return const SizedBox.shrink();

    return PopupMenuButton<core.TaskStatus>(
      key: const Key('statusMenu'),
      onSelected: (status) => onAppendEvent(
        core.CreateTaskEventRequest(
          actor: const core.Actor.user(),
          eventType: core.TaskEventType.statusChanged,
          payload: {'to': status.name},
        ),
      ),
      itemBuilder: (context) => [
        for (final status in allowedNext)
          PopupMenuItem(value: status, child: Text(status.name)),
      ],
      child: const Chip(
        avatar: Icon(Icons.arrow_drop_down, size: 18),
        label: Text('Change status'),
      ),
    );
  }
}
