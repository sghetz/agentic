// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTaskEventRequest _$CreateTaskEventRequestFromJson(
  Map<String, dynamic> json,
) => _CreateTaskEventRequest(
  actor: const ActorConverter().fromJson(json['actor'] as String),
  eventType: $enumDecode(_$TaskEventTypeEnumMap, json['eventType']),
  payload: json['payload'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$CreateTaskEventRequestToJson(
  _CreateTaskEventRequest instance,
) => <String, dynamic>{
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
  TaskEventType.assigned: 'assigned',
};
