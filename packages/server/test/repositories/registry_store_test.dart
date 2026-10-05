import 'package:core/core.dart' as core;
import 'package:server/src/repositories/registry_store.dart';
import 'package:server/src/storage/registry_database.dart';
import 'package:test/test.dart';

void main() {
  late RegistryDatabase db;
  late RegistryStore store;

  setUp(() {
    db = RegistryDatabase.memory();
    store = RegistryStore(db);
  });

  tearDown(() => db.close());

  test('create then get round trips all fields', () async {
    final org = await store.create(
      const core.CreateOrganizationRequest(
        name: 'Employer',
        slug: 'employer',
        type: core.OrgType.employer,
      ),
    );

    expect(org.name, 'Employer');
    expect(org.slug, 'employer');
    expect(org.type, core.OrgType.employer);
    expect(org.archivedAt, isNull);

    final fetched = await store.get(org.id);
    expect(fetched, org);
  });

  test('get returns null for an unknown id', () async {
    expect(await store.get('does-not-exist'), isNull);
  });

  test('list returns every organization', () async {
    await store.create(
      const core.CreateOrganizationRequest(
        name: 'Employer',
        slug: 'employer',
        type: core.OrgType.employer,
      ),
    );
    await store.create(
      const core.CreateOrganizationRequest(
        name: 'Personal',
        slug: 'personal',
        type: core.OrgType.personal,
      ),
    );

    final all = await store.list();
    expect(all.map((o) => o.slug), containsAll(['employer', 'personal']));
  });

  test('create rejects a duplicate slug', () async {
    await store.create(
      const core.CreateOrganizationRequest(
        name: 'Employer',
        slug: 'employer',
        type: core.OrgType.employer,
      ),
    );

    expect(
      () => store.create(
        const core.CreateOrganizationRequest(
          name: 'Employer Again',
          slug: 'employer',
          type: core.OrgType.employer,
        ),
      ),
      throwsA(isA<DuplicateOrgSlug>()),
    );
  });

  test('update changes only the given fields', () async {
    final org = await store.create(
      const core.CreateOrganizationRequest(
        name: 'Employer',
        slug: 'employer',
        type: core.OrgType.employer,
      ),
    );

    final updated = await store.update(
      org.id,
      const core.UpdateOrganizationRequest(name: 'Acme'),
    );

    expect(updated.name, 'Acme');
    expect(updated.slug, 'employer');
    expect(updated.type, core.OrgType.employer);
  });

  test('update on an unknown id throws', () async {
    expect(
      () => store.update(
        'does-not-exist',
        const core.UpdateOrganizationRequest(name: 'x'),
      ),
      throwsA(isA<OrganizationNotFound>()),
    );
  });
}
