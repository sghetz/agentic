import 'package:core/core.dart' as core;

import 'connector_adapter.dart';

/// The built-in set of connectors Agentic ships support for. Empty for now
/// -- Outlook (and later a meeting-transcript connector) are added here in
/// a later slice. Adding a new service means appending one
/// `core.ConnectorDefinition` plus one `ConnectorAdapter`, not a new
/// ingestion subsystem.
const List<core.ConnectorDefinition> builtInConnectorDefinitions = [];

const Map<String, ConnectorAdapter> builtInConnectorAdapters = {};

/// Holds the registered connector definitions (served to the UI via
/// `GET /connectors`) and their adapters (used by the sync step). Injectable
/// so tests can register fake connectors without touching the real
/// built-in list.
class ConnectorRegistry {
  const ConnectorRegistry({
    this.definitions = builtInConnectorDefinitions,
    this.adapters = builtInConnectorAdapters,
  });

  final List<core.ConnectorDefinition> definitions;
  final Map<String, ConnectorAdapter> adapters;

  core.ConnectorDefinition? definitionFor(String connectorId) =>
      definitions.where((d) => d.id == connectorId).firstOrNull;

  ConnectorAdapter? adapterFor(String connectorId) => adapters[connectorId];
}
