import 'package:core/core.dart';
import 'package:drift/drift.dart';

@DataClassName('OrganizationRow')
class Organizations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get slug => text().unique()();
  TextColumn get type => textEnum<OrgType>()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
