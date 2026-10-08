// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskSpec _$TaskSpecFromJson(Map<String, dynamic> json) => _TaskSpec(
  projectId: json['projectId'] as String,
  goal: json['goal'] as String,
  requirementIds:
      (json['requirementIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  acceptanceCriteria:
      (json['acceptanceCriteria'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  affectedAreas:
      (json['affectedAreas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  priority: $enumDecode(_$TaskSpecPriorityEnumMap, json['priority']),
  openQuestions:
      (json['openQuestions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$TaskSpecToJson(_TaskSpec instance) => <String, dynamic>{
  'projectId': instance.projectId,
  'goal': instance.goal,
  'requirementIds': instance.requirementIds,
  'acceptanceCriteria': instance.acceptanceCriteria,
  'affectedAreas': instance.affectedAreas,
  'priority': _$TaskSpecPriorityEnumMap[instance.priority]!,
  'openQuestions': instance.openQuestions,
};

const _$TaskSpecPriorityEnumMap = {
  TaskSpecPriority.low: 'low',
  TaskSpecPriority.medium: 'medium',
  TaskSpecPriority.high: 'high',
};
