// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependency_check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DependencyCheck _$DependencyCheckFromJson(Map<String, dynamic> json) =>
    _DependencyCheck(
      name: json['name'] as String,
      found: json['found'] as bool,
      version: json['version'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$DependencyCheckToJson(_DependencyCheck instance) =>
    <String, dynamic>{
      'name': instance.name,
      'found': instance.found,
      'version': instance.version,
      'error': instance.error,
    };
