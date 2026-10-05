// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_project_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateProjectRequest _$UpdateProjectRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateProjectRequest(
  name: json['name'] as String?,
  slug: json['slug'] as String?,
  repos: (json['repos'] as List<dynamic>?)
      ?.map((e) => RepoConfig.fromJson(e as Map<String, dynamic>))
      .toList(),
  flutterVersion: json['flutterVersion'] as String?,
  designSystemRef: json['designSystemRef'] as String?,
  status: $enumDecodeNullable(_$ProjectStatusEnumMap, json['status']),
);

Map<String, dynamic> _$UpdateProjectRequestToJson(
  _UpdateProjectRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'slug': instance.slug,
  'repos': instance.repos?.map((e) => e.toJson()).toList(),
  'flutterVersion': instance.flutterVersion,
  'designSystemRef': instance.designSystemRef,
  'status': _$ProjectStatusEnumMap[instance.status],
};

const _$ProjectStatusEnumMap = {
  ProjectStatus.active: 'active',
  ProjectStatus.paused: 'paused',
  ProjectStatus.archived: 'archived',
};
