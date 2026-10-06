import 'package:drift/drift.dart';

import 'conversations_table.dart';

@DataClassName('ChatMessageRow')
class ChatMessages extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text().references(Conversations, #id)();
  DateTimeColumn get ts => dateTime()();

  /// "user" or "agent:`<role>`" -- see `core.Actor.toStorageString()`.
  TextColumn get sender => text()();
  TextColumn get content => text()();

  @override
  Set<Column> get primaryKey => {id};
}
