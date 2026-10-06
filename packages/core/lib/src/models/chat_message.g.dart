// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  ts: DateTime.parse(json['ts'] as String),
  sender: const ActorConverter().fromJson(json['sender'] as String),
  content: json['content'] as String,
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'ts': instance.ts.toIso8601String(),
      'sender': const ActorConverter().toJson(instance.sender),
      'content': instance.content,
    };
