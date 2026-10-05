import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'api_client.dart';

part 'api_client_provider.g.dart';

/// Server address. Fixed for Phase 0 -- the backend only binds to
/// 127.0.0.1, per the non-negotiable local-only design.
@riverpod
ApiClient apiClient(Ref ref) {
  final client = ApiClient(baseUrl: Uri.parse('http://127.0.0.1:8787'));
  ref.onDispose(client.close);
  return client;
}
