import 'package:core/core.dart' as core;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client_provider.dart';

part 'design_spec_providers.g.dart';

@riverpod
Future<List<core.Artifact>> designSpecs(
  Ref ref,
  String orgId,
  String projectId,
) {
  return ref.watch(apiClientProvider).listDesignSpecs(orgId, projectId);
}

@riverpod
Future<List<core.Artifact>> diagrams(Ref ref, String orgId, String projectId) {
  return ref.watch(apiClientProvider).listDiagrams(orgId, projectId);
}
