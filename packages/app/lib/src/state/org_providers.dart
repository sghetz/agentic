import 'package:core/core.dart' as core;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client_provider.dart';

part 'org_providers.g.dart';

@riverpod
Future<List<core.Organization>> orgList(Ref ref) {
  return ref.watch(apiClientProvider).listOrgs();
}

@riverpod
class SelectedOrgId extends _$SelectedOrgId {
  @override
  String? build() => null;

  void select(String? orgId) => state = orgId;
}
