// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_artifact_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateArtifactRequest _$CreateArtifactRequestFromJson(
  Map<String, dynamic> json,
) => _CreateArtifactRequest(
  kind: $enumDecode(_$ArtifactKindEnumMap, json['kind']),
  uri: json['uri'] as String,
  content: json['content'] as String?,
);

Map<String, dynamic> _$CreateArtifactRequestToJson(
  _CreateArtifactRequest instance,
) => <String, dynamic>{
  'kind': _$ArtifactKindEnumMap[instance.kind]!,
  'uri': instance.uri,
  'content': instance.content,
};

const _$ArtifactKindEnumMap = {
  ArtifactKind.taskSpec: 'taskSpec',
  ArtifactKind.designSpec: 'designSpec',
  ArtifactKind.diagram: 'diagram',
  ArtifactKind.healthReport: 'healthReport',
  ArtifactKind.pr: 'pr',
  ArtifactKind.review: 'review',
};
