import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Opens (creating parent directories as needed) a file-backed sqlite
/// connection for a drift database. Shared by [RegistryDatabase] and
/// [OrgDatabase] so both open the same way.
LazyDatabase openSqliteFile(String path) {
  return LazyDatabase(() async {
    final file = File(path);
    await file.parent.create(recursive: true);
    return NativeDatabase.createInBackground(file);
  });
}
