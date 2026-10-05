import 'package:core/core.dart';
import 'package:drift/drift.dart';

import 'tasks_table.dart';

@DataClassName('TaskEventRow')
class TaskEvents extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id)();
  DateTimeColumn get ts => dateTime()();

  /// "user" or "agent:`<role>`" -- see `core.Actor.toStorageString()`.
  TextColumn get actor => text()();
  TextColumn get eventType => textEnum<TaskEventType>()();
  TextColumn get payloadJson => text()();

  @override
  Set<Column> get primaryKey => {id};

  // Append-only by convention: OrgStore exposes no update or delete for
  // this table.
}
