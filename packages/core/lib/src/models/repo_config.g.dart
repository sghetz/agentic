// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RepoConfig _$RepoConfigFromJson(Map<String, dynamic> json) => _RepoConfig(
  url: json['url'] as String,
  defaultBranch: json['defaultBranch'] as String,
  path: json['path'] as String,
);

Map<String, dynamic> _$RepoConfigToJson(_RepoConfig instance) =>
    <String, dynamic>{
      'url': instance.url,
      'defaultBranch': instance.defaultBranch,
      'path': instance.path,
    };
