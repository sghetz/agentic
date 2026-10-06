import 'package:core/core.dart';
import 'package:drift/drift.dart';

import 'projects_table.dart';
import 'tasks_table.dart';

/// Exactly one of [taskId] / [projectId] is set, depending on `kind` (see
/// `core.Artifact`'s doc comment). Enforced in [OrgStore], not here.
@DataClassName('ArtifactRow')
class Artifacts extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().nullable().references(Tasks, #id)();
  TextColumn get projectId => text().nullable().references(Projects, #id)();
  TextColumn get kind => textEnum<ArtifactKind>()();
  TextColumn get uri => text()();
  TextColumn get content => text().nullable()();
  IntColumn get version => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
