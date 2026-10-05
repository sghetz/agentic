import 'config.dart';
import 'repositories/org_store.dart';
import 'repositories/registry_store.dart';
import 'storage/org_database.dart';
import 'storage/registry_database.dart';

/// Holds the registry store plus a cache of opened [OrgStore]s. Resolving
/// an orgId always checks the registry first, so an unknown orgId -- or
/// one that belongs to a database that was never opened -- behaves exactly
/// like a nonexistent id (`null`), never like a second organization's data.
class AppContext {
  AppContext({
    required this.registryStore,
    required OrgDatabase Function(String orgId) openOrgDatabase,
  }) : _openOrgDatabase = openOrgDatabase;

  factory AppContext.standard(AgenticPaths paths) {
    return AppContext(
      registryStore: RegistryStore(RegistryDatabase.file(paths.registryDbPath)),
      openOrgDatabase: (orgId) => OrgDatabase.file(paths.orgDbPath(orgId)),
    );
  }

  final RegistryStore registryStore;
  final OrgDatabase Function(String orgId) _openOrgDatabase;
  final Map<String, OrgStore> _orgStores = {};

  Future<OrgStore?> orgStore(String orgId) async {
    final cached = _orgStores[orgId];
    if (cached != null) return cached;

    if (await registryStore.get(orgId) == null) return null;

    final store = OrgStore(orgId, _openOrgDatabase(orgId));
    _orgStores[orgId] = store;
    return store;
  }

  Future<void> close() async {
    for (final store in _orgStores.values) {
      await store.close();
    }
  }
}
