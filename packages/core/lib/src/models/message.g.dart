// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: json['id'] as String,
  sourceId: json['sourceId'] as String,
  externalId: json['externalId'] as String,
  author: json['author'] as String?,
  sentAt: DateTime.parse(json['sentAt'] as String),
  body: json['body'] as String,
  raw: json['raw'] as Map<String, dynamic>,
  routedProjectId: json['routedProjectId'] as String?,
  routingConfidence: (json['routingConfidence'] as num?)?.toDouble(),
  processedAt: json['processedAt'] == null
      ? null
      : DateTime.parse(json['processedAt'] as String),
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'sourceId': instance.sourceId,
  'externalId': instance.externalId,
  'author': instance.author,
  'sentAt': instance.sentAt.toIso8601String(),
  'body': instance.body,
  'raw': instance.raw,
  'routedProjectId': instance.routedProjectId,
  'routingConfidence': instance.routingConfidence,
  'processedAt': instance.processedAt?.toIso8601String(),
};
