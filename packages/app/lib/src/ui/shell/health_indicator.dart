import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/health_providers.dart';
import '../health/health_status_icon.dart';

/// Small leading icon on a project list row showing its latest health
/// check status, without the user having to open the full report.
class HealthIndicator extends ConsumerWidget {
  const HealthIndicator({
    super.key,
    required this.orgId,
    required this.projectId,
  });

  final String orgId;
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestAsync = ref.watch(latestHealthReportProvider(orgId, projectId));

    return latestAsync.when(
      data: (artifact) {
        if (artifact == null) return const HealthStatusIcon(status: null);
        final report = core.HealthReport.fromJson(
          jsonDecode(artifact.content!) as Map<String, Object?>,
        );
        return HealthStatusIcon(status: report.status);
      },
      loading: () => const SizedBox(
        width: 20,
        height: 20,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (error, _) => const HealthStatusIcon(status: null),
    );
  }
}
