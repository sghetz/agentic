// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Project _$ProjectFromJson(Map<String, dynamic> json) => _Project(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  repos: (json['repos'] as List<dynamic>)
      .map((e) => RepoConfig.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: $enumDecode(_$ProjectStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  flutterVersion: json['flutterVersion'] as String?,
  designSystemRef: json['designSystemRef'] as String?,
  archivedAt: json['archivedAt'] == null
      ? null
      : DateTime.parse(json['archivedAt'] as String),
);

Map<String, dynamic> _$ProjectToJson(_Project instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'repos': instance.repos.map((e) => e.toJson()).toList(),
  'status': _$ProjectStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'flutterVersion': instance.flutterVersion,
  'designSystemRef': instance.designSystemRef,
  'archivedAt': instance.archivedAt?.toIso8601String(),
};

const _$ProjectStatusEnumMap = {
  ProjectStatus.active: 'active',
  ProjectStatus.paused: 'paused',
  ProjectStatus.archived: 'archived',
};
