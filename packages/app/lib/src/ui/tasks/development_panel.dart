import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client_provider.dart';
import '../../state/inbox_providers.dart';
import '../../state/task_providers.dart';
import '../common/empty_state.dart';
import '../common/error_state.dart';
import '../common/loading_state.dart';

core.Artifact? _latestOfKind(
  List<core.Artifact> artifacts,
  core.ArtifactKind kind,
) {
  final matches = artifacts.where((a) => a.kind == kind).toList();
  if (matches.isEmpty) return null;
  matches.sort((a, b) => b.version.compareTo(a.version));
  return matches.first;
}

/// The Developer/Reviewer/approval surface on the task detail screen (Phase
/// 5): lets the owner kick off Development, request Review, see the PR and
/// Review Report once they exist, watch the PR's live external check
/// status, and approve (which merges). Reads `taskArtifactsProvider`, which
/// `TaskDetailScreen`'s own Artifacts panel already watches -- Riverpod
/// shares the one underlying fetch.
class DevelopmentPanel extends ConsumerWidget {
  const DevelopmentPanel({
    super.key,
    required this.orgId,
    required this.projectId,
    required this.taskId,
    required this.task,
  });

  final String orgId;
  final String projectId;
  final String taskId;
  final core.Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artifactsAsync = ref.watch(taskArtifactsProvider(orgId, taskId));

    return artifactsAsync.when(
      data: (artifacts) {
        final prArtifact = _latestOfKind(artifacts, core.ArtifactKind.pr);
        final reviewArtifact = _latestOfKind(
          artifacts,
          core.ArtifactKind.review,
        );
        final pr = prArtifact == null
            ? null
            : core.PullRequestInfo.fromJson(
                jsonDecode(prArtifact.content!) as Map<String, Object?>,
              );
        final review = reviewArtifact == null
            ? null
            : core.ReviewReport.fromJson(
                jsonDecode(reviewArtifact.content!) as Map<String, Object?>,
              );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Development', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _ActionRow(
              orgId: orgId,
              projectId: projectId,
              taskId: taskId,
              task: task,
            ),
            if (pr != null) ...[const SizedBox(height: 12), _PrLink(pr: pr)],
            if (review != null) ...[
              const SizedBox(height: 12),
              _ReviewSummary(review: review),
            ],
            if (pr != null &&
                (task.currentStatus == core.TaskStatus.awaitingApproval ||
                    task.currentStatus == core.TaskStatus.done)) ...[
              const SizedBox(height: 12),
              _PrChecksPanel(
                orgId: orgId,
                projectId: projectId,
                taskId: taskId,
              ),
            ],
          ],
        );
      },
      loading: () => const LoadingState(),
      error: (error, _) =>
          const ErrorState(message: 'Could not load artifacts'),
    );
  }
}

class _ActionRow extends ConsumerWidget {
  const _ActionRow({
    required this.orgId,
    required this.projectId,
    required this.taskId,
    required this.task,
  });

  final String orgId;
  final String projectId;
  final String taskId;
  final core.Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (task.currentStatus) {
      case core.TaskStatus.specified:
      case core.TaskStatus.inDesign:
        return FilledButton.icon(
          icon: const Icon(Icons.code),
          label: const Text('Start Development'),
          onPressed: () => _startDevelopment(context, ref),
        );
      case core.TaskStatus.inDevelopment:
        return FilledButton.icon(
          icon: const Icon(Icons.replay),
          label: const Text('Continue Development'),
          onPressed: () => _startDevelopment(context, ref),
        );
      case core.TaskStatus.inReview:
        return FilledButton.icon(
          icon: const Icon(Icons.rate_review),
          label: const Text('Request Review'),
          onPressed: () => _requestReview(context, ref),
        );
      case core.TaskStatus.awaitingApproval:
        return FilledButton.icon(
          icon: const Icon(Icons.check_circle),
          label: const Text('Approve & Merge'),
          onPressed: () => _approve(context, ref),
        );
      case core.TaskStatus.newTask:
      case core.TaskStatus.done:
      case core.TaskStatus.blocked:
        return const SizedBox.shrink();
    }
  }

  Future<void> _startDevelopment(BuildContext context, WidgetRef ref) async {
    final taskSpecArtifactId = await showDialog<String>(
      context: context,
      builder: (dialogContext) =>
          _TaskSpecPickerDialog(orgId: orgId, projectId: projectId),
    );
    if (taskSpecArtifactId == null) return;
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      final outcome = await ref
          .read(apiClientProvider)
          .developTask(orgId, projectId, taskId, taskSpecArtifactId);
      _invalidate(ref);
      messenger.showSnackBar(
        SnackBar(
          content: Text(_developerOutcomeMessage(outcome.result.outcome)),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Development failed: $e')));
    }
  }

  Future<void> _requestReview(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(apiClientProvider).reviewTask(orgId, projectId, taskId);
      _invalidate(ref);
      messenger.showSnackBar(const SnackBar(content: Text('Review complete.')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Review failed: $e')));
    }
  }

  Future<void> _approve(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(apiClientProvider).approveTask(orgId, projectId, taskId);
      _invalidate(ref);
      messenger.showSnackBar(const SnackBar(content: Text('Merged.')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Approval failed: $e')));
    }
  }

  void _invalidate(WidgetRef ref) {
    ref.invalidate(taskDetailProvider(orgId, taskId));
    ref.invalidate(taskEventsProvider(orgId, taskId));
    ref.invalidate(taskArtifactsProvider(orgId, taskId));
    ref.invalidate(prChecksProvider(orgId, projectId, taskId));
  }

  String _developerOutcomeMessage(core.DeveloperOutcome outcome) =>
      switch (outcome) {
        core.DeveloperOutcome.prOpened => 'Opened a PR.',
        core.DeveloperOutcome.verificationFailed =>
          'Verification failed -- committed locally for review, not pushed.',
        core.DeveloperOutcome.noChanges => 'Developer made no changes.',
        core.DeveloperOutcome.sessionFailed => 'Developer session failed.',
      };
}

/// A sub-dialog listing the project's drafted Task Specs so the owner can
/// pick which one Developer should implement. Pops with the chosen
/// artifact id, or `null` if cancelled.
class _TaskSpecPickerDialog extends ConsumerWidget {
  const _TaskSpecPickerDialog({required this.orgId, required this.projectId});

  final String orgId;
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskSpecsAsync = ref.watch(taskSpecsProvider(orgId, projectId));

    return AlertDialog(
      title: const Text('Implement which Task Spec?'),
      content: SizedBox(
        width: 480,
        height: 360,
        child: taskSpecsAsync.when(
          data: (artifacts) {
            if (artifacts.isEmpty) {
              return const EmptyState(message: 'No Task Specs drafted yet');
            }
            return ListView.builder(
              itemCount: artifacts.length,
              itemBuilder: (context, index) {
                final artifact = artifacts[index];
                final spec = core.TaskSpec.fromJson(
                  jsonDecode(artifact.content!) as Map<String, Object?>,
                );
                return ListTile(
                  title: Text(spec.goal),
                  subtitle: Text('v${artifact.version}'),
                  onTap: () => Navigator.of(context).pop(artifact.id),
                );
              },
            );
          },
          loading: () => const LoadingState(),
          error: (error, _) =>
              const ErrorState(message: 'Could not load Task Specs'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class _PrLink extends StatelessWidget {
  const _PrLink({required this.pr});

  final core.PullRequestInfo pr;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.merge_type, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'PR #${pr.number}: ${pr.branch} -> ${pr.baseBranch}\n${pr.url}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _ReviewSummary extends StatelessWidget {
  const _ReviewSummary({required this.review});

  final core.ReviewReport review;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(review.summary),
        if (review.acceptanceCriteriaUnmet.isNotEmpty)
          Text(
            'Unmet: ${review.acceptanceCriteriaUnmet.join('; ')}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (review.missingTests.isNotEmpty)
          Text(
            'Missing tests: ${review.missingTests.join('; ')}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (review.codeQualityIssues.isNotEmpty)
          Text(
            'Code quality: ${review.codeQualityIssues.join('; ')}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}

class _PrChecksPanel extends ConsumerWidget {
  const _PrChecksPanel({
    required this.orgId,
    required this.projectId,
    required this.taskId,
  });

  final String orgId;
  final String projectId;
  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checksAsync = ref.watch(prChecksProvider(orgId, projectId, taskId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Pipeline checks',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            IconButton(
              iconSize: 16,
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  ref.invalidate(prChecksProvider(orgId, projectId, taskId)),
            ),
          ],
        ),
        checksAsync.when(
          data: (checks) {
            if (checks.isEmpty) {
              return const Text('No checks reported yet.');
            }
            return Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final check in checks) _CheckChip(check: check)],
            );
          },
          loading: () => const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (error, _) => const Text('Could not load check status.'),
        ),
      ],
    );
  }
}

class _CheckChip extends StatelessWidget {
  const _CheckChip({required this.check});

  final core.PullRequestCheck check;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (check.conclusion) {
      core.PrCheckConclusion.success => (Icons.check_circle, Colors.green),
      core.PrCheckConclusion.failure => (Icons.cancel, Colors.red),
      core.PrCheckConclusion.pending => (Icons.hourglass_top, Colors.orange),
      core.PrCheckConclusion.neutral => (
        Icons.remove_circle_outline,
        Colors.grey,
      ),
    };
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(check.name),
      visualDensity: VisualDensity.compact,
    );
  }
}
