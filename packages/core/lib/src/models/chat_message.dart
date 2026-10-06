import 'package:freezed_annotation/freezed_annotation.dart';

import '../actor.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
sealed class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String conversationId,
    required DateTime ts,
    @ActorConverter() required Actor sender,
    required String content,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, Object?> json) =>
      _$ChatMessageFromJson(json);
}
