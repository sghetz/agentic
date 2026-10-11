import 'package:core/core.dart' as core;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client_provider.dart';

part 'connector_providers.g.dart';

@riverpod
Future<List<core.ConnectorDefinition>> connectorDefinitions(Ref ref) {
  return ref.watch(apiClientProvider).listConnectors();
}

@riverpod
Future<List<core.Source>> connectorSources(Ref ref, String orgId) async {
  final sources = await ref.watch(apiClientProvider).listSources(orgId);
  return sources
      .where((s) => s.kind == core.SourceKind.oauthConnector)
      .toList();
}
