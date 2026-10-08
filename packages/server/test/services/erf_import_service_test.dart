import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;
import 'package:server/src/repositories/org_store.dart';
import 'package:server/src/services/analyst_extraction_service.dart';
import 'package:server/src/services/erf_import_service.dart';
import 'package:server/src/storage/org_database.dart';
import 'package:test/test.dart';

const _structuredOutput = {
  'structured_output': {
    'goal': 'Let users reset their password via email',
    'requirementIds': ['RF-07'],
    'acceptanceCriteria': <String>[],
    'affectedAreas': <String>[],
    'priority': 'medium',
    'openQuestions': <String>[],
  },
};

void main() {
  late OrgDatabase db;
  late OrgStore store;
  late Directory erfDir;
  late core.Project project;
  late core.Source source;

  setUp(() async {
    db = OrgDatabase.memory();
    store = OrgStore('org-1', db);
    erfDir = await Directory.systemTemp.createTemp('agentic_erf_test_');
    project = await store.createProject(
      const core.CreateProjectRequest(name: 'P', slug: 'p'),
    );
    source = await store.createSource(
      core.CreateSourceRequest(
        kind: core.SourceKind.erf,
        config: {'folderPath': erfDir.path},
        projectId: project.id,
      ),
    );
  });

  tearDown(() async {
    await db.close();
    await erfDir.delete(recursive: true);
  });

  test('scans a folder, converts each file, and drafts a Task Spec', () async {
    await File('${erfDir.path}/RF-07.txt').writeAsString(
      'Users must be able to reset their password via an emailed link.',
    );

    final service = ErfImportService(
      extractionService: AnalystExtractionService(
        invoker: (_) async => jsonEncode(_structuredOutput),
      ),
    );

    final result = await service.scan(source: source, store: store);

    expect(result.newMessages, 1);
    expect(result.specsCreated, 1);
    expect(result.failedFiles, isEmpty);

    final specs = await store.listProjectArtifacts(
      project.id,
      kind: core.ArtifactKind.taskSpec,
    );
    expect(specs, hasLength(1));
    final content = jsonDecode(specs.single.content!) as Map<String, Object?>;
    expect(content['goal'], 'Let users reset their password via email');
    expect(content['sourceMessageId'], isNotNull);

    final messages = await store.listMessages(sourceId: source.id);
    expect(messages, hasLength(1));
    expect(messages.single.processedAt, isNotNull);
  });

  test('a repeat scan does not re-import or re-draft', () async {
    await File('${erfDir.path}/RF-07.txt').writeAsString('some content');
    var calls = 0;
    final service = ErfImportService(
      extractionService: AnalystExtractionService(
        invoker: (_) async {
          calls++;
          return jsonEncode(_structuredOutput);
        },
      ),
    );

    final first = await service.scan(source: source, store: store);
    final second = await service.scan(source: source, store: store);

    expect(first.newMessages, 1);
    expect(first.specsCreated, 1);
    expect(second.newMessages, 0);
    expect(second.specsCreated, 0);
    expect(calls, 1);

    final specs = await store.listProjectArtifacts(
      project.id,
      kind: core.ArtifactKind.taskSpec,
    );
    expect(specs, hasLength(1));
  });

  test(
    'a message whose extraction failed before is retried on rescan',
    () async {
      await File('${erfDir.path}/RF-07.txt').writeAsString('some content');
      var calls = 0;
      final service = ErfImportService(
        extractionService: AnalystExtractionService(
          invoker: (_) async {
            calls++;
            return calls == 1
                ? jsonEncode({'result': 'no schema used'}) // fails
                : jsonEncode(_structuredOutput); // succeeds
          },
        ),
      );

      final first = await service.scan(source: source, store: store);
      expect(first.specsCreated, 0);
      expect(first.failedFiles, [contains('RF-07.txt')]);

      final second = await service.scan(source: source, store: store);
      expect(second.newMessages, 0);
      expect(second.specsCreated, 1);
    },
  );

  test(
    'a file markitdown cannot convert is reported as a failure, not a crash',
    () async {
      // A directory entry with no read permission-independent failure mode:
      // use a path that doesn't exist by the time markitdown runs isn't
      // reachable via dir.list(), so instead exercise a file type markitdown
      // legitimately can't parse -- an empty binary-ish extension-less file
      // is accepted as text by markitdown, so assert on the happy path
      // instead: a genuinely unreadable file via permissions.
      final file = File('${erfDir.path}/locked.txt');
      await file.writeAsString('content');
      await Process.run('chmod', ['000', file.path]);

      final service = ErfImportService(
        extractionService: AnalystExtractionService(
          invoker: (_) async => jsonEncode(_structuredOutput),
        ),
      );

      final result = await service.scan(source: source, store: store);

      expect(result.failedFiles, [file.path]);
      expect(result.specsCreated, 0);

      await Process.run('chmod', ['644', file.path]); // allow cleanup
    },
  );

  test('throws ArgumentError for a non-erf source', () async {
    final otherSource = await store.createSource(
      const core.CreateSourceRequest(kind: core.SourceKind.whatsappImport),
    );
    final service = ErfImportService(
      extractionService: AnalystExtractionService(
        invoker: (_) async => jsonEncode(_structuredOutput),
      ),
    );

    expect(
      () => service.scan(source: otherSource, store: store),
      throwsArgumentError,
    );
  });

  test('throws ArgumentError when the folder does not exist', () async {
    final missingFolderSource = await store.createSource(
      core.CreateSourceRequest(
        kind: core.SourceKind.erf,
        config: const {'folderPath': '/no/such/folder'},
        projectId: project.id,
      ),
    );
    final service = ErfImportService(
      extractionService: AnalystExtractionService(
        invoker: (_) async => jsonEncode(_structuredOutput),
      ),
    );

    expect(
      () => service.scan(source: missingFolderSource, store: store),
      throwsArgumentError,
    );
  });
}
