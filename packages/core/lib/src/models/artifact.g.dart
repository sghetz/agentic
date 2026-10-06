// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artifact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Artifact _$ArtifactFromJson(Map<String, dynamic> json) => _Artifact(
  id: json['id'] as String,
  taskId: json['taskId'] as String?,
  projectId: json['projectId'] as String?,
  kind: $enumDecode(_$ArtifactKindEnumMap, json['kind']),
  uri: json['uri'] as String,
  content: json['content'] as String?,
  version: (json['version'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ArtifactToJson(_Artifact instance) => <String, dynamic>{
  'id': instance.id,
  'taskId': instance.taskId,
  'projectId': instance.projectId,
  'kind': _$ArtifactKindEnumMap[instance.kind]!,
  'uri': instance.uri,
  'content': instance.content,
  'version': instance.version,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$ArtifactKindEnumMap = {
  ArtifactKind.taskSpec: 'taskSpec',
  ArtifactKind.designSpec: 'designSpec',
  ArtifactKind.diagram: 'diagram',
  ArtifactKind.healthReport: 'healthReport',
  ArtifactKind.pr: 'pr',
  ArtifactKind.review: 'review',
};
