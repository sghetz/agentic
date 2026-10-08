import 'package:drift/drift.dart';

import 'projects_table.dart';
import 'sources_table.dart';

/// (sourceId, externalId) is the natural dedupe key -- a repeat scan of the
/// same source (e.g. re-running an ERF folder scan) must never create a
/// second row for a file/item it already imported. Enforced in [OrgStore],
/// not here, same convention as the rest of this schema.
@DataClassName('MessageRow')
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get sourceId => text().references(Sources, #id)();
  TextColumn get externalId => text()();
  TextColumn get author => text().nullable()();
  DateTimeColumn get sentAt => dateTime()();
  TextColumn get body => text()();
  TextColumn get rawJson => text()();
  TextColumn get routedProjectId =>
      text().nullable().references(Projects, #id)();
  RealColumn get routingConfidence => real().nullable()();
  DateTimeColumn get processedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
