import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'connection.dart';
import 'tables/artifacts_table.dart';
import 'tables/project_links_table.dart';
import 'tables/projects_table.dart';
import 'tables/task_events_table.dart';
import 'tables/tasks_table.dart';

part 'org_database.g.dart';

/// `orgs/<orgId>/data.db`: everything for one organization. One of these
/// per org; [OrgStore] opens exactly one at a time and never two at once.
@DriftDatabase(tables: [Projects, ProjectLinks, Tasks, TaskEvents, Artifacts])
class OrgDatabase extends _$OrgDatabase {
  OrgDatabase(super.executor);

  factory OrgDatabase.file(String path) => OrgDatabase(openSqliteFile(path));

  factory OrgDatabase.memory() => OrgDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;
}
