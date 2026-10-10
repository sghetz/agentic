// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_source_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateSourceRequest _$CreateSourceRequestFromJson(Map<String, dynamic> json) =>
    _CreateSourceRequest(
      kind: $enumDecode(_$SourceKindEnumMap, json['kind']),
      config: json['config'] as Map<String, dynamic>? ?? const {},
      projectId: json['projectId'] as String?,
    );

Map<String, dynamic> _$CreateSourceRequestToJson(
  _CreateSourceRequest instance,
) => <String, dynamic>{
  'kind': _$SourceKindEnumMap[instance.kind]!,
  'config': instance.config,
  'projectId': instance.projectId,
};

const _$SourceKindEnumMap = {
  SourceKind.oauthConnector: 'oauthConnector',
  SourceKind.whatsappImport: 'whatsappImport',
  SourceKind.erf: 'erf',
};
