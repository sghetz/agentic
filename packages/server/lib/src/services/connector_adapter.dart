/// One message/transcript fetched from a connector, normalized just enough
/// to become a `core.Message` -- the generic sync step (not the adapter)
/// assigns `id`, `sourceId`, and handles routing, same as ERF/WhatsApp
/// ingestion already does with their own raw formats.
class ConnectorMessage {
  const ConnectorMessage({
    required this.externalId,
    this.author,
    required this.sentAt,
    required this.body,
    this.raw = const {},
  });

  final String externalId;
  final String? author;
  final DateTime sentAt;
  final String body;
  final Map<String, Object?> raw;
}

/// The only service-specific piece of a connector: given a valid access
/// token, fetch whatever's new since [since] (`null` means "everything
/// available, first sync") and normalize it. Everything else -- OAuth,
/// token storage/refresh, turning these into stored `Message`s -- is
/// shared, generic framework code.
abstract class ConnectorAdapter {
  String get connectorId;

  Future<List<ConnectorMessage>> fetchSince(
    String accessToken,
    DateTime? since,
  );
}
