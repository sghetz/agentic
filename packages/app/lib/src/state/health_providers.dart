import 'package:core/core.dart' as core;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client_provider.dart';

part 'health_providers.g.dart';

@riverpod
Future<List<core.Artifact>> healthReports(
  Ref ref,
  String orgId,
  String projectId,
) {
  return ref.watch(apiClientProvider).listHealthReports(orgId, projectId);
}

@riverpod
Future<core.Artifact?> latestHealthReport(
  Ref ref,
  String orgId,
  String projectId,
) async {
  final reports = await ref
      .watch(apiClientProvider)
      .listHealthReports(orgId, projectId, limit: 1);
  return reports.isEmpty ? null : reports.first;
}
