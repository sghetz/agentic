import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_chat_message_request.freezed.dart';
part 'create_chat_message_request.g.dart';

/// Sent by the owner from the chat UI. `id`, `ts`, and `sender` (always
/// [Actor.user] for this request -- an agent's reply is never posted
/// through this endpoint) are assigned server-side.
@freezed
sealed class CreateChatMessageRequest with _$CreateChatMessageRequest {
  const factory CreateChatMessageRequest({required String content}) =
      _CreateChatMessageRequest;

  factory CreateChatMessageRequest.fromJson(Map<String, Object?> json) =>
      _$CreateChatMessageRequestFromJson(json);
}
