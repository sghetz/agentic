import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'connection.dart';
import 'tables/artifacts_table.dart';
import 'tables/chat_messages_table.dart';
import 'tables/conversations_table.dart';
import 'tables/project_links_table.dart';
import 'tables/projects_table.dart';
import 'tables/task_events_table.dart';
import 'tables/tasks_table.dart';

part 'org_database.g.dart';

/// `orgs/<orgId>/data.db`: everything for one organization. One of these
/// per org; [OrgStore] opens exactly one at a time and never two at once.
@DriftDatabase(
  tables: [
    Projects,
    ProjectLinks,
    Tasks,
    TaskEvents,
    Artifacts,
    Conversations,
    ChatMessages,
  ],
)
class OrgDatabase extends _$OrgDatabase {
  OrgDatabase(super.executor);

  factory OrgDatabase.file(String path) => OrgDatabase(openSqliteFile(path));

  factory OrgDatabase.memory() => OrgDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // v2: artifacts become project-scoped-or-task-scoped (taskId went
        // nullable, projectId + content were added). No real artifact data
        // exists yet in any deployment, so a drop-and-recreate is safe.
        await m.deleteTable(artifacts.actualTableName);
        await m.createTable(artifacts);
      }
      if (from < 3) {
        // v3: conversations/chat_messages (Phase 2 chat).
        await m.createTable(conversations);
        await m.createTable(chatMessages);
      }
    },
  );
}
