import 'package:core/core.dart' as core;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client_provider.dart';

part 'project_providers.g.dart';

@riverpod
class ShowArchivedProjects extends _$ShowArchivedProjects {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

@riverpod
Future<List<core.Project>> projectList(Ref ref, String orgId) {
  final includeArchived = ref.watch(showArchivedProjectsProvider);
  return ref
      .watch(apiClientProvider)
      .listProjects(orgId, includeArchived: includeArchived);
}

@riverpod
class SelectedProjectId extends _$SelectedProjectId {
  @override
  String? build() => null;

  void select(String? projectId) => state = projectId;
}
