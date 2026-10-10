/// `oauthConnector` covers every connector-framework source (Outlook,
/// meeting transcripts, and anything registered later) -- `Source.config`
/// carries `{"connectorId": "outlook"}` pointing at the specific
/// `ConnectorDefinition`, rather than each service getting its own
/// `SourceKind` value. `whatsappImport`/`erf` aren't OAuth-shaped, so they
/// stay as their own kinds.
enum SourceKind { oauthConnector, whatsappImport, erf }
