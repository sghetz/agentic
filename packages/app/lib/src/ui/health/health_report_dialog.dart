import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../api/api_client_provider.dart';
import '../../state/health_providers.dart';
import '../common/empty_state.dart';
import '../common/error_state.dart';
import '../common/loading_state.dart';
import 'health_status_icon.dart';

Future<void> showHealthReportDialog(
  BuildContext context, {
  required String orgId,
  required String projectId,
  required String projectName,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => HealthReportDialog(
      orgId: orgId,
      projectId: projectId,
      projectName: projectName,
    ),
  );
}

class HealthReportDialog extends ConsumerStatefulWidget {
  const HealthReportDialog({
    super.key,
    required this.orgId,
    required this.projectId,
    required this.projectName,
  });

  final String orgId;
  final String projectId;
  final String projectName;

  @override
  ConsumerState<HealthReportDialog> createState() => _HealthReportDialogState();
}

class _HealthReportDialogState extends ConsumerState<HealthReportDialog> {
  bool _running = false;

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(
      healthReportsProvider(widget.orgId, widget.projectId),
    );

    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text('${widget.projectName} health')),
          FilledButton.icon(
            icon: _running
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow),
            label: const Text('Run check'),
            onPressed: _running ? null : _runCheck,
          ),
        ],
      ),
      content: SizedBox(
        width: 520,
        height: 420,
        child: reportsAsync.when(
          data: (artifacts) {
            if (artifacts.isEmpty) {
              return const EmptyState(message: 'No health checks run yet');
            }
            return ListView.builder(
              itemCount: artifacts.length,
              itemBuilder: (context, index) =>
                  _ReportTile(artifact: artifacts[index]),
            );
          },
          loading: () => const LoadingState(),
          error: (error, _) => ErrorState(
            message: 'Could not load health reports',
            onRetry: () => ref.invalidate(
              healthReportsProvider(widget.orgId, widget.projectId),
            ),
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

  Future<void> _runCheck() async {
    setState(() => _running = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(apiClientProvider)
          .runProjectHealthCheck(widget.orgId, widget.projectId);
      ref.invalidate(healthReportsProvider(widget.orgId, widget.projectId));
      ref.invalidate(
        latestHealthReportProvider(widget.orgId, widget.projectId),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Health check failed to run: $e')),
      );
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({required this.artifact});

  final core.Artifact artifact;

  @override
  Widget build(BuildContext context) {
    final report = core.HealthReport.fromJson(
      jsonDecode(artifact.content!) as Map<String, Object?>,
    );

    return ExpansionTile(
      leading: HealthStatusIcon(status: report.status),
      title: Text(
        'v${artifact.version} · ${DateFormat.yMMMd().add_jm().format(report.startedAt.toLocal())}',
      ),
      subtitle: Text(report.status.name),
      children: [for (final step in report.steps) _StepTile(step: step)],
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.step});

  final core.HealthCheckStep step;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      dense: true,
      leading: HealthStatusIcon(status: step.status),
      title: Text('${step.name} (${step.durationMs}ms)'),
      children: [
        if (step.output.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SelectableText(
                step.output,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
