import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/empty_state.dart';

/// Full event history for a task, newest first. Comments and edits show
/// their text; status changes show the before/after; attachments and
/// creation get a short description.
class TaskEventTimeline extends StatelessWidget {
  const TaskEventTimeline({super.key, required this.events});

  final List<core.TaskEvent> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const EmptyState(message: 'No activity yet');
    }

    final newestFirst = [...events]..sort((a, b) => b.ts.compareTo(a.ts));

    return ListView.separated(
      itemCount: newestFirst.length,
      separatorBuilder: (context, _) => const Divider(height: 1),
      itemBuilder: (context, index) => _TimelineTile(event: newestFirst[index]),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.event});

  final core.TaskEvent event;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_iconFor(event.eventType)),
      title: Text(_summaryFor(event)),
      subtitle: Text(
        '${_actorLabel(event.actor)} · ${DateFormat.yMMMd().add_jm().format(event.ts.toLocal())}',
      ),
    );
  }

  static IconData _iconFor(core.TaskEventType type) => switch (type) {
    core.TaskEventType.created => Icons.flag_outlined,
    core.TaskEventType.statusChanged => Icons.swap_horiz,
    core.TaskEventType.commented => Icons.chat_bubble_outline,
    core.TaskEventType.reopened => Icons.replay,
    core.TaskEventType.artifactAttached => Icons.attach_file,
    core.TaskEventType.edited => Icons.edit_outlined,
  };

  static String _summaryFor(core.TaskEvent event) {
    switch (event.eventType) {
      case core.TaskEventType.created:
        return 'Task created';
      case core.TaskEventType.statusChanged:
        final to = event.payload['to'] as String?;
        return to == null ? 'Status changed' : 'Status changed to $to';
      case core.TaskEventType.commented:
        return (event.payload['text'] as String?) ?? 'Commented';
      case core.TaskEventType.reopened:
        return 'Reopened';
      case core.TaskEventType.artifactAttached:
        final artifactId = event.payload['artifactId'] as String?;
        return artifactId == null
            ? 'Artifact attached'
            : 'Artifact attached ($artifactId)';
      case core.TaskEventType.edited:
        final field = event.payload['field'] as String?;
        return field == null ? 'Edited' : 'Edited $field';
    }
  }

  static String _actorLabel(core.Actor actor) => switch (actor) {
    core.ActorUser() => 'You',
    core.ActorAgent(role: final role) => role,
  };
}
