import 'package:core/core.dart' as core;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client_provider.dart';

part 'dashboard_providers.g.dart';

@riverpod
Future<core.DashboardSummary> dashboard(Ref ref) {
  return ref.watch(apiClientProvider).dashboard();
}
