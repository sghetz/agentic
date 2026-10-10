import 'package:freezed_annotation/freezed_annotation.dart';

part 'connector_definition.freezed.dart';
part 'connector_definition.g.dart';

/// Static OAuth metadata for one connector type (e.g. "outlook"), served by
/// `GET /connectors` so the UI can offer a picker. The owner-supplied
/// client id/secret and the issued access/refresh tokens are never part of
/// this -- those live in Keychain, namespaced per (org, connector), never
/// in a database or over this API.
@freezed
sealed class ConnectorDefinition with _$ConnectorDefinition {
  const factory ConnectorDefinition({
    required String id,
    required String displayName,
    required String authorizeUrl,
    required String tokenUrl,
    required List<String> scopes,
  }) = _ConnectorDefinition;

  factory ConnectorDefinition.fromJson(Map<String, Object?> json) =>
      _$ConnectorDefinitionFromJson(json);
}
