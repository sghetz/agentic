// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Source _$SourceFromJson(Map<String, dynamic> json) => _Source(
  id: json['id'] as String,
  kind: $enumDecode(_$SourceKindEnumMap, json['kind']),
  config: json['config'] as Map<String, dynamic>,
  projectId: json['projectId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$SourceToJson(_Source instance) => <String, dynamic>{
  'id': instance.id,
  'kind': _$SourceKindEnumMap[instance.kind]!,
  'config': instance.config,
  'projectId': instance.projectId,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$SourceKindEnumMap = {
  SourceKind.slack: 'slack',
  SourceKind.gchat: 'gchat',
  SourceKind.outlook: 'outlook',
  SourceKind.whatsappImport: 'whatsappImport',
  SourceKind.meeting: 'meeting',
  SourceKind.erf: 'erf',
};
