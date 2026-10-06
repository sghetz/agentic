import 'package:json_annotation/json_annotation.dart';

/// Which channel a [Conversation] belongs to: the shared "general" channel,
/// or a 1:1 channel with one agent role. Stored as plain text ("general" /
/// "agent:`<role>`") since the set of agent roles is open-ended -- mirrors
/// [Actor].
sealed class ChatChannel {
  const ChatChannel();

  const factory ChatChannel.general() = ChatChannelGeneral;

  const factory ChatChannel.agent(String role) = ChatChannelAgent;

  String toStorageString() => switch (this) {
    ChatChannelGeneral() => 'general',
    ChatChannelAgent(role: final role) => 'agent:$role',
  };

  static ChatChannel parse(String value) {
    if (value == 'general') return const ChatChannelGeneral();
    const prefix = 'agent:';
    if (value.startsWith(prefix)) {
      return ChatChannelAgent(value.substring(prefix.length));
    }
    throw FormatException('Not a valid ChatChannel: "$value"');
  }
}

final class ChatChannelGeneral extends ChatChannel {
  const ChatChannelGeneral();

  @override
  bool operator ==(Object other) => other is ChatChannelGeneral;

  @override
  int get hashCode => 'general'.hashCode;
}

final class ChatChannelAgent extends ChatChannel {
  const ChatChannelAgent(this.role);

  final String role;

  @override
  bool operator ==(Object other) =>
      other is ChatChannelAgent && other.role == role;

  @override
  int get hashCode => Object.hash('agent', role);
}

/// json_serializable converter so freezed models can declare a `ChatChannel`
/// field directly and serialize it as the "general" / "agent:`<role>`" string.
class ChatChannelConverter implements JsonConverter<ChatChannel, String> {
  const ChatChannelConverter();

  @override
  ChatChannel fromJson(String json) => ChatChannel.parse(json);

  @override
  String toJson(ChatChannel object) => object.toStorageString();
}
