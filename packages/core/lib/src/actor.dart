import 'package:json_annotation/json_annotation.dart';

/// Who performed a [TaskEvent]: either the owner, or an agent acting under
/// a role name (e.g. "developer", "reviewer"). Stored as plain text
/// ("user" / "agent:`<role>`") rather than a DB enum, since the set of agent
/// roles is open-ended.
sealed class Actor {
  const Actor();

  const factory Actor.user() = ActorUser;

  const factory Actor.agent(String role) = ActorAgent;

  String toStorageString() => switch (this) {
    ActorUser() => 'user',
    ActorAgent(role: final role) => 'agent:$role',
  };

  static Actor parse(String value) {
    if (value == 'user') return const ActorUser();
    final prefix = 'agent:';
    if (value.startsWith(prefix)) {
      return ActorAgent(value.substring(prefix.length));
    }
    throw FormatException('Not a valid Actor: "$value"');
  }
}

final class ActorUser extends Actor {
  const ActorUser();

  @override
  bool operator ==(Object other) => other is ActorUser;

  @override
  int get hashCode => 'user'.hashCode;
}

final class ActorAgent extends Actor {
  const ActorAgent(this.role);

  final String role;

  @override
  bool operator ==(Object other) => other is ActorAgent && other.role == role;

  @override
  int get hashCode => Object.hash('agent', role);
}

/// json_serializable converter so freezed models can declare an `Actor`
/// field directly and serialize it as the "user" / "agent:`<role>`" string.
class ActorConverter implements JsonConverter<Actor, String> {
  const ActorConverter();

  @override
  Actor fromJson(String json) => Actor.parse(json);

  @override
  String toJson(Actor object) => object.toStorageString();
}
