import 'package:core/core.dart';
import 'package:drift/drift.dart';

import 'projects_table.dart';

@DataClassName('ProjectLinkRow')
class ProjectLinks extends Table {
  TextColumn get id => text()();
  TextColumn get fromProjectId => text().references(Projects, #id)();
  TextColumn get toProjectId => text().references(Projects, #id)();
  TextColumn get relation => textEnum<LinkRelation>()();

  @override
  Set<Column> get primaryKey => {id};
}
