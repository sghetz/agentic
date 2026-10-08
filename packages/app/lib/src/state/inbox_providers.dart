import 'package:core/core.dart' as core;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client_provider.dart';

part 'inbox_providers.g.dart';

@riverpod
Future<List<core.Message>> unroutedMessages(Ref ref, String orgId) {
  return ref.watch(apiClientProvider).listUnroutedMessages(orgId);
}

@riverpod
Future<List<core.Artifact>> taskSpecs(Ref ref, String orgId, String projectId) {
  return ref.watch(apiClientProvider).listTaskSpecs(orgId, projectId);
}
