import 'package:core/core.dart' as core;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client_provider.dart';

part 'task_providers.g.dart';

// ---- List filters ----

@riverpod
class TaskStatusFilter extends _$TaskStatusFilter {
  @override
  core.TaskStatus? build() => null;

  void set(core.TaskStatus? status) => state = status;
}

@riverpod
class TaskSearchQuery extends _$TaskSearchQuery {
  @override
  String build() => '';

  void set(String query) => state = query;
}

@riverpod
class TaskDateRange extends _$TaskDateRange {
  @override
  (DateTime?, DateTime?) build() => (null, null);

  void set(DateTime? from, DateTime? to) => state = (from, to);
}

@riverpod
Future<List<core.Task>> taskList(Ref ref, String orgId, String projectId) {
  final status = ref.watch(taskStatusFilterProvider);
  final query = ref.watch(taskSearchQueryProvider);
  final (from, to) = ref.watch(taskDateRangeProvider);
  return ref
      .watch(apiClientProvider)
      .listTasks(
        orgId,
        projectId,
        status: status,
        from: from,
        to: to,
        query: query,
      );
}

// ---- Detail ----

@riverpod
Future<core.Task> taskDetail(
  Ref ref,
  String orgId,
  String taskId, {
  DateTime? at,
}) {
  return ref.watch(apiClientProvider).getTask(orgId, taskId, at: at);
}

@riverpod
Future<List<core.TaskEvent>> taskEvents(Ref ref, String orgId, String taskId) {
  return ref.watch(apiClientProvider).listTaskEvents(orgId, taskId);
}

@riverpod
Future<List<core.Artifact>> taskArtifacts(
  Ref ref,
  String orgId,
  String taskId,
) {
  return ref.watch(apiClientProvider).listArtifacts(orgId, taskId);
}

/// The task's current PR's live external check status. Only call this once
/// a PR artifact actually exists -- the server 400s otherwise.
@riverpod
Future<List<core.PullRequestCheck>> prChecks(
  Ref ref,
  String orgId,
  String projectId,
  String taskId,
) {
  return ref.watch(apiClientProvider).getPrChecks(orgId, projectId, taskId);
}
