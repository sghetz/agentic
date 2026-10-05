// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  title: json['title'] as String,
  currentStatus: $enumDecode(_$TaskStatusEnumMap, json['currentStatus']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'title': instance.title,
  'currentStatus': _$TaskStatusEnumMap[instance.currentStatus]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$TaskStatusEnumMap = {
  TaskStatus.newTask: 'newTask',
  TaskStatus.specified: 'specified',
  TaskStatus.inDesign: 'inDesign',
  TaskStatus.inDevelopment: 'inDevelopment',
  TaskStatus.inReview: 'inReview',
  TaskStatus.awaitingApproval: 'awaitingApproval',
  TaskStatus.done: 'done',
  TaskStatus.blocked: 'blocked',
};
