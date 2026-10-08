import 'package:core/core.dart';
import 'package:drift/drift.dart';

import 'projects_table.dart';

/// `projectId` null means this is an org-level source whose messages need
/// per-message routing (see `messages_table.dart`); set means it's already
/// tied to one project.
@DataClassName('SourceRow')
class Sources extends Table {
  TextColumn get id => text()();
  TextColumn get kind => textEnum<SourceKind>()();
  TextColumn get configJson => text()();
  TextColumn get projectId => text().nullable().references(Projects, #id)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
