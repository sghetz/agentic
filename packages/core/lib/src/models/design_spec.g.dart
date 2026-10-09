// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DesignSpec _$DesignSpecFromJson(Map<String, dynamic> json) => _DesignSpec(
  projectId: json['projectId'] as String,
  screens:
      (json['screens'] as List<dynamic>?)
          ?.map((e) => ScreenSpec.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  requirementIds:
      (json['requirementIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  sourceTaskSpecArtifactId: json['sourceTaskSpecArtifactId'] as String?,
);

Map<String, dynamic> _$DesignSpecToJson(_DesignSpec instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'screens': instance.screens.map((e) => e.toJson()).toList(),
      'requirementIds': instance.requirementIds,
      'sourceTaskSpecArtifactId': instance.sourceTaskSpecArtifactId,
    };
