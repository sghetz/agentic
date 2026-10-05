import 'package:core/core.dart' as core;
import 'package:drift/drift.dart';
import 'package:sqlite3/sqlite3.dart' show SqliteException;

import '../storage/registry_database.dart';

class OrganizationNotFound implements Exception {
  OrganizationNotFound(this.id);
  final String id;

  @override
  String toString() => 'OrganizationNotFound($id)';
}

class DuplicateOrgSlug implements Exception {
  DuplicateOrgSlug(this.slug);
  final String slug;

  @override
  String toString() => 'DuplicateOrgSlug($slug)';
}

/// CRUD for organizations against `registry.db`. This is the only store
/// not scoped by orgId; everything else goes through [OrgStore].
class RegistryStore {
  RegistryStore(this._db);

  final RegistryDatabase _db;

  Future<core.Organization> create(
    core.CreateOrganizationRequest request,
  ) async {
    final id = core.newId();
    final now = DateTime.now().toUtc();
    try {
      await _db
          .into(_db.organizations)
          .insert(
            OrganizationsCompanion.insert(
              id: id,
              name: request.name,
              slug: request.slug,
              type: request.type,
              createdAt: now,
            ),
          );
    } on SqliteException catch (e) {
      if (e.message.contains('UNIQUE constraint failed')) {
        throw DuplicateOrgSlug(request.slug);
      }
      rethrow;
    }
    return (await get(id))!;
  }

  Future<core.Organization?> get(String id) async {
    final row = await (_db.select(
      _db.organizations,
    )..where((o) => o.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  Future<List<core.Organization>> list() async {
    final rows = await _db.select(_db.organizations).get();
    return rows.map(_toModel).toList();
  }

  Future<core.Organization> update(
    String id,
    core.UpdateOrganizationRequest request,
  ) async {
    if (await get(id) == null) throw OrganizationNotFound(id);

    try {
      await (_db.update(
        _db.organizations,
      )..where((o) => o.id.equals(id))).write(
        OrganizationsCompanion(
          name: request.name == null
              ? const Value.absent()
              : Value(request.name!),
          slug: request.slug == null
              ? const Value.absent()
              : Value(request.slug!),
        ),
      );
    } on SqliteException catch (e) {
      if (e.message.contains('UNIQUE constraint failed')) {
        throw DuplicateOrgSlug(request.slug!);
      }
      rethrow;
    }
    return (await get(id))!;
  }

  core.Organization _toModel(OrganizationRow row) => core.Organization(
    id: row.id,
    name: row.name,
    slug: row.slug,
    type: row.type,
    createdAt: row.createdAt,
    archivedAt: row.archivedAt,
  );
}
