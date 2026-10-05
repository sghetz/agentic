// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskEvent _$TaskEventFromJson(Map<String, dynamic> json) => _TaskEvent(
  id: json['id'] as String,
  taskId: json['taskId'] as String,
  ts: DateTime.parse(json['ts'] as String),
  actor: const ActorConverter().fromJson(json['actor'] as String),
  eventType: $enumDecode(_$TaskEventTypeEnumMap, json['eventType']),
  payload: json['payload'] as Map<String, dynamic>,
);

Map<String, dynamic> _$TaskEventToJson(_TaskEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'ts': instance.ts.toIso8601String(),
      'actor': const ActorConverter().toJson(instance.actor),
      'eventType': _$TaskEventTypeEnumMap[instance.eventType]!,
      'payload': instance.payload,
    };

const _$TaskEventTypeEnumMap = {
  TaskEventType.created: 'created',
  TaskEventType.statusChanged: 'statusChanged',
  TaskEventType.commented: 'commented',
  TaskEventType.reopened: 'reopened',
  TaskEventType.artifactAttached: 'artifactAttached',
  TaskEventType.edited: 'edited',
};
