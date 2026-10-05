// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_project_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateProjectRequest _$CreateProjectRequestFromJson(
  Map<String, dynamic> json,
) => _CreateProjectRequest(
  name: json['name'] as String,
  slug: json['slug'] as String,
  repos:
      (json['repos'] as List<dynamic>?)
          ?.map((e) => RepoConfig.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  flutterVersion: json['flutterVersion'] as String?,
  designSystemRef: json['designSystemRef'] as String?,
);

Map<String, dynamic> _$CreateProjectRequestToJson(
  _CreateProjectRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'slug': instance.slug,
  'repos': instance.repos.map((e) => e.toJson()).toList(),
  'flutterVersion': instance.flutterVersion,
  'designSystemRef': instance.designSystemRef,
};
