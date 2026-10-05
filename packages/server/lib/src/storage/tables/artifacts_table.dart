import 'package:core/core.dart';
import 'package:drift/drift.dart';

import 'tasks_table.dart';

@DataClassName('ArtifactRow')
class Artifacts extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get kind => textEnum<ArtifactKind>()();
  TextColumn get uri => text()();
  IntColumn get version => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
