import 'package:core/core.dart' as core;

import 'connector_adapter.dart';
import 'outlook_adapter.dart';
import 'zoom_adapter.dart';

/// The built-in set of connectors Agentic ships support for. Adding a new
/// service means appending one `core.ConnectorDefinition` here plus one
/// `ConnectorAdapter` below, not a new ingestion subsystem.
const List<core.ConnectorDefinition> builtInConnectorDefinitions = [
  core.ConnectorDefinition(
    id: 'outlook',
    displayName: 'Outlook',
    authorizeUrl:
        'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
    tokenUrl: 'https://login.microsoftonline.com/common/oauth2/v2.0/token',
    scopes: ['Mail.Read', 'offline_access'],
  ),
  core.ConnectorDefinition(
    id: 'zoom',
    displayName: 'Zoom (meeting transcripts)',
    authorizeUrl: 'https://zoom.us/oauth/authorize',
    tokenUrl: 'https://zoom.us/oauth/token',
    scopes: ['cloud_recording:read:list_user_recordings'],
  ),
];

// Not `const`: OutlookAdapter/ZoomAdapter each hold an `http.Client`, which
// can't be constructed at compile time.
final Map<String, ConnectorAdapter> builtInConnectorAdapters = {
  'outlook': OutlookAdapter(),
  'zoom': ZoomAdapter(),
};

/// Holds the registered connector definitions (served to the UI via
/// `GET /connectors`) and their adapters (used by the sync step). Injectable
/// so tests can register fake connectors without touching the real
/// built-in list. Not `const`-constructible, since the built-in adapters
/// default isn't a compile-time constant.
class ConnectorRegistry {
  ConnectorRegistry({
    List<core.ConnectorDefinition>? definitions,
    Map<String, ConnectorAdapter>? adapters,
  }) : definitions = definitions ?? builtInConnectorDefinitions,
       adapters = adapters ?? builtInConnectorAdapters;

  final List<core.ConnectorDefinition> definitions;
  final Map<String, ConnectorAdapter> adapters;

  core.ConnectorDefinition? definitionFor(String connectorId) =>
      definitions.where((d) => d.id == connectorId).firstOrNull;

  ConnectorAdapter? adapterFor(String connectorId) => adapters[connectorId];
}
