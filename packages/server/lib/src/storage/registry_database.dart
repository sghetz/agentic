import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'connection.dart';
import 'tables/organizations_table.dart';
import 'tables/settings_table.dart';

part 'registry_database.g.dart';

/// `registry.db`: organizations and global settings only. No project
/// content ever lives here.
@DriftDatabase(tables: [Organizations, Settings])
class RegistryDatabase extends _$RegistryDatabase {
  RegistryDatabase(super.executor);

  factory RegistryDatabase.file(String path) =>
      RegistryDatabase(openSqliteFile(path));

  factory RegistryDatabase.memory() =>
      RegistryDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;
}
