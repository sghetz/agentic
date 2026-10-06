// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Conversation _$ConversationFromJson(Map<String, dynamic> json) =>
    _Conversation(
      id: json['id'] as String,
      projectId: json['projectId'] as String?,
      channel: const ChatChannelConverter().fromJson(json['channel'] as String),
      claudeSessionId: json['claudeSessionId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ConversationToJson(_Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'channel': const ChatChannelConverter().toJson(instance.channel),
      'claudeSessionId': instance.claudeSessionId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
