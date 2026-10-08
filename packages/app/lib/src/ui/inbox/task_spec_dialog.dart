import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/inbox_providers.dart';
import '../common/empty_state.dart';
import '../common/error_state.dart';
import '../common/loading_state.dart';

Future<void> showTaskSpecDialog(
  BuildContext context, {
  required String orgId,
  required String projectId,
  required String projectName,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => TaskSpecDialog(
      orgId: orgId,
      projectId: projectId,
      projectName: projectName,
    ),
  );
}

class TaskSpecDialog extends ConsumerWidget {
  const TaskSpecDialog({
    super.key,
    required this.orgId,
    required this.projectId,
    required this.projectName,
  });

  final String orgId;
  final String projectId;
  final String projectName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specsAsync = ref.watch(taskSpecsProvider(orgId, projectId));

    return AlertDialog(
      title: Text('$projectName Task Specs'),
      content: SizedBox(
        width: 560,
        height: 480,
        child: specsAsync.when(
          data: (artifacts) {
            if (artifacts.isEmpty) {
              return const EmptyState(message: 'No Task Specs drafted yet');
            }
            return ListView.builder(
              itemCount: artifacts.length,
              itemBuilder: (context, index) =>
                  _TaskSpecTile(artifact: artifacts[index]),
            );
          },
          loading: () => const LoadingState(),
          error: (error, _) => ErrorState(
            message: 'Could not load Task Specs',
            onRetry: () => ref.invalidate(taskSpecsProvider(orgId, projectId)),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _TaskSpecTile extends StatelessWidget {
  const _TaskSpecTile({required this.artifact});

  final core.Artifact artifact;

  @override
  Widget build(BuildContext context) {
    final spec = core.TaskSpec.fromJson(
      jsonDecode(artifact.content!) as Map<String, Object?>,
    );

    return ExpansionTile(
      leading: _PriorityBadge(priority: spec.priority),
      title: Text(spec.goal),
      subtitle: Text('v${artifact.version}'),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (spec.requirementIds.isNotEmpty)
                _Section(title: 'Requirement IDs', items: spec.requirementIds),
              if (spec.acceptanceCriteria.isNotEmpty)
                _Section(
                  title: 'Acceptance criteria',
                  items: spec.acceptanceCriteria,
                ),
              if (spec.affectedAreas.isNotEmpty)
                _Section(title: 'Affected areas', items: spec.affectedAreas),
              if (spec.openQuestions.isNotEmpty)
                _Section(
                  title: 'Open questions',
                  items: spec.openQuestions,
                  emphasize: true,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.items,
    this.emphasize = false,
  });

  final String title;
  final List<String> items;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final color = emphasize ? Theme.of(context).colorScheme.error : null;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: color),
          ),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text('• $item', style: TextStyle(color: color)),
            ),
        ],
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});

  final core.TaskSpecPriority priority;

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      core.TaskSpecPriority.high => Colors.red,
      core.TaskSpecPriority.medium => Colors.orange,
      core.TaskSpecPriority.low => Colors.blueGrey,
    };
    return CircleAvatar(
      radius: 12,
      backgroundColor: color.withValues(alpha: 0.2),
      child: Icon(Icons.flag, size: 14, color: color),
    );
  }
}
