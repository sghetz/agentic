import 'package:core/core.dart';
import 'package:drift/drift.dart';

@DataClassName('ProjectRow')
class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get slug => text().unique()();
  TextColumn get reposJson => text()();
  TextColumn get flutterVersion => text().nullable()();
  TextColumn get designSystemRef => text().nullable()();
  TextColumn get status => textEnum<ProjectStatus>()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
