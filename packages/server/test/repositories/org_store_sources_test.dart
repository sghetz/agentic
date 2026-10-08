import 'package:core/core.dart' as core;
import 'package:server/src/repositories/org_store.dart';
import 'package:server/src/storage/org_database.dart';
import 'package:test/test.dart';

void main() {
  late OrgDatabase db;
  late OrgStore store;

  setUp(() {
    db = OrgDatabase.memory();
    store = OrgStore('org-1', db);
  });

  tearDown(() => db.close());

  group('sources', () {
    test('creates a project-scoped source', () async {
      final project = await store.createProject(
        const core.CreateProjectRequest(name: 'P', slug: 'p'),
      );

      final source = await store.createSource(
        core.CreateSourceRequest(
          kind: core.SourceKind.erf,
          config: const {'folderPath': '/tmp/erf'},
          projectId: project.id,
        ),
      );

      expect(source.projectId, project.id);
      expect(source.config['folderPath'], '/tmp/erf');
      expect(await store.getSource(source.id), source);
    });

    test('creates an org-scoped source (needs routing)', () async {
      final source = await store.createSource(
        const core.CreateSourceRequest(kind: core.SourceKind.whatsappImport),
      );
      expect(source.projectId, isNull);
    });

    test('rejects an unknown projectId', () async {
      expect(
        () => store.createSource(
          const core.CreateSourceRequest(
            kind: core.SourceKind.erf,
            projectId: 'no-such-project',
          ),
        ),
        throwsA(isA<ProjectNotFound>()),
      );
    });

    test('listSources filters by projectId', () async {
      final project = await store.createProject(
        const core.CreateProjectRequest(name: 'P', slug: 'p'),
      );
      final scoped = await store.createSource(
        core.CreateSourceRequest(
          kind: core.SourceKind.erf,
          projectId: project.id,
        ),
      );
      await store.createSource(
        const core.CreateSourceRequest(kind: core.SourceKind.whatsappImport),
      );

      final filtered = await store.listSources(projectId: project.id);
      expect(filtered.map((s) => s.id), [scoped.id]);

      final all = await store.listSources();
      expect(all, hasLength(2));
    });
  });

  group('messages', () {
    test('getOrCreateMessage creates a new message', () async {
      final source = await store.createSource(
        const core.CreateSourceRequest(kind: core.SourceKind.erf),
      );

      final message = await store.getOrCreateMessage(
        sourceId: source.id,
        externalId: '/path/to/file.docx',
        sentAt: DateTime.utc(2026, 1, 1),
        body: 'hello',
        raw: const {'filePath': '/path/to/file.docx'},
      );

      expect(message.sourceId, source.id);
      expect(message.processedAt, isNull);
    });

    test(
      'getOrCreateMessage is idempotent for the same (sourceId, externalId)',
      () async {
        final source = await store.createSource(
          const core.CreateSourceRequest(kind: core.SourceKind.erf),
        );

        final first = await store.getOrCreateMessage(
          sourceId: source.id,
          externalId: '/path/to/file.docx',
          sentAt: DateTime.utc(2026, 1, 1),
          body: 'hello',
          raw: const {},
        );
        final second = await store.getOrCreateMessage(
          sourceId: source.id,
          externalId: '/path/to/file.docx',
          sentAt: DateTime.utc(2026, 1, 2),
          body: 'a different body, should be ignored',
          raw: const {},
        );

        expect(second.id, first.id);
        expect(second.body, 'hello');
      },
    );

    test('rejects an unknown sourceId', () async {
      expect(
        () => store.getOrCreateMessage(
          sourceId: 'no-such-source',
          externalId: 'x',
          sentAt: DateTime.utc(2026, 1, 1),
          body: 'x',
          raw: const {},
        ),
        throwsA(isA<SourceNotFound>()),
      );
    });

    test('markMessageProcessed sets processedAt', () async {
      final source = await store.createSource(
        const core.CreateSourceRequest(kind: core.SourceKind.erf),
      );
      final message = await store.getOrCreateMessage(
        sourceId: source.id,
        externalId: 'x',
        sentAt: DateTime.utc(2026, 1, 1),
        body: 'x',
        raw: const {},
      );
      expect(message.processedAt, isNull);

      await store.markMessageProcessed(message.id);

      final messages = await store.listMessages(sourceId: source.id);
      expect(messages.single.processedAt, isNotNull);
    });

    test('listMessages orders by sentAt ascending', () async {
      final source = await store.createSource(
        const core.CreateSourceRequest(kind: core.SourceKind.erf),
      );
      await store.getOrCreateMessage(
        sourceId: source.id,
        externalId: 'second',
        sentAt: DateTime.utc(2026, 1, 2),
        body: 'second',
        raw: const {},
      );
      await store.getOrCreateMessage(
        sourceId: source.id,
        externalId: 'first',
        sentAt: DateTime.utc(2026, 1, 1),
        body: 'first',
        raw: const {},
      );

      final messages = await store.listMessages(sourceId: source.id);
      expect(messages.map((m) => m.body).toList(), ['first', 'second']);
    });
  });
}
