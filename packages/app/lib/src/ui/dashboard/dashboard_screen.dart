import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../state/dashboard_providers.dart';
import '../common/empty_state.dart';
import '../common/error_state.dart';
import '../common/loading_state.dart';

/// All-organizations dashboard: read-only counts by status and recent
/// activity per org. Each org's numbers come from a separate read of that
/// org's own database (see `GET /dashboard` on the server) -- this screen
/// never combines records across orgs, only renders summaries side by side.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh),
                onPressed: () => ref.invalidate(dashboardProvider),
              ),
            ],
          ),
        ),
        Expanded(
          child: dashboardAsync.when(
            data: (summary) {
              if (summary.orgs.isEmpty) {
                return const EmptyState(message: 'No organizations yet');
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final org in summary.orgs) _OrgSummaryCard(summary: org),
                ],
              );
            },
            loading: () => const LoadingState(),
            error: (error, _) => ErrorState(
              message: 'Could not load the dashboard',
              onRetry: () => ref.invalidate(dashboardProvider),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrgSummaryCard extends StatelessWidget {
  const _OrgSummaryCard({required this.summary});

  final core.DashboardOrgSummary summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              summary.orgName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _StatusCounts(counts: summary.taskCountsByStatus),
            const SizedBox(height: 16),
            Text(
              'Recent activity',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            if (summary.recentActivity.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No activity yet'),
              )
            else
              Column(
                children: [
                  for (final item in summary.recentActivity)
                    _ActivityRow(item: item),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusCounts extends StatelessWidget {
  const _StatusCounts({required this.counts});

  final Map<core.TaskStatus, int> counts;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final status in core.TaskStatus.values)
          Chip(label: Text('${status.name}: ${counts[status] ?? 0}')),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item});

  final core.RecentActivityItem item;

  @override
  Widget build(BuildContext context) {
    final actorLabel = switch (item.actor) {
      core.ActorUser() => 'You',
      core.ActorAgent(role: final role) => role,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$actorLabel ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '${_verbFor(item.eventType)} '),
                  TextSpan(
                    text: item.taskTitle,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  TextSpan(text: ' in ${item.projectName}'),
                ],
              ),
            ),
          ),
          Text(
            DateFormat.yMMMd().add_jm().format(item.ts.toLocal()),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  static String _verbFor(core.TaskEventType type) => switch (type) {
    core.TaskEventType.created => 'created',
    core.TaskEventType.statusChanged => 'changed the status of',
    core.TaskEventType.commented => 'commented on',
    core.TaskEventType.reopened => 'reopened',
    core.TaskEventType.artifactAttached => 'attached an artifact to',
    core.TaskEventType.edited => 'edited',
    core.TaskEventType.assigned => 'assigned',
  };
}
