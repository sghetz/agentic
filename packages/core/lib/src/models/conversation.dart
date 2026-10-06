import 'package:freezed_annotation/freezed_annotation.dart';

import '../chat_channel.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

/// One chat thread, scoped to either an organization (`projectId` null) or
/// a project. `claudeSessionId` is set after the first turn and passed back
/// to the Claude Code CLI as `--session-id` on every later turn, so the
/// agent's own session persistence -- not this server -- holds the
/// conversation history.
@freezed
sealed class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    String? projectId,
    @ChatChannelConverter() required ChatChannel channel,
    String? claudeSessionId,
    required DateTime createdAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, Object?> json) =>
      _$ConversationFromJson(json);
}
