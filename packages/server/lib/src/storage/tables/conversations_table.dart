import 'package:drift/drift.dart';

import 'projects_table.dart';

/// `projectId` null means an org-scoped conversation (e.g. the org-level
/// General channel); set means it's scoped to that project. Uniqueness of
/// (projectId, channel) -- so "get or create" never creates a duplicate --
/// is enforced by [OrgStore] in a transaction, not a DB constraint, since
/// SQLite treats NULL as distinct from NULL in unique indexes and would
/// happily allow two org-scoped "general" rows otherwise.
@DataClassName('ConversationRow')
class Conversations extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().nullable().references(Projects, #id)();
  TextColumn get channel => text()();
  TextColumn get claudeSessionId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
