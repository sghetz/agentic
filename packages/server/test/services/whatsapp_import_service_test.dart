import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:server/src/repositories/org_store.dart';
import 'package:server/src/services/analyst_extraction_service.dart';
import 'package:server/src/services/message_routing_service.dart';
import 'package:server/src/services/whatsapp_import_service.dart';
import 'package:server/src/storage/org_database.dart';
import 'package:test/test.dart';

const _structuredOutput = {
  'structured_output': {
    'goal': 'Fix the export bug',
    'requirementIds': <String>[],
    'acceptanceCriteria': <String>[],
    'affectedAreas': <String>[],
    'priority': 'medium',
    'openQuestions': <String>[],
  },
};

const _export =
    '[1/3/26, 09:15:00] Alice: can someone look at the export bug?\n'
    '[1/3/26, 09:16:30] Bob: sure, on it';

void main() {
  late OrgDatabase db;
  late OrgStore store;
  late core.Project project;

  setUp(() async {
    db = OrgDatabase.memory();
    store = OrgStore('org-1', db);
    project = await store.createProject(
      const core.CreateProjectRequest(name: 'P', slug: 'p'),
    );
  });

  tearDown(() => db.close());

  test('a project-scoped source routes directly, no routing call', () async {
    final source = await store.createSource(
      core.CreateSourceRequest(
        kind: core.SourceKind.whatsappImport,
        projectId: project.id,
      ),
    );
    var routingCalls = 0;
    final service = WhatsAppImportService(
      routingService: MessageRoutingService(
        invoker: (_) async {
          routingCalls++;
          return '{}';
        },
      ),
      extractionService: AnalystExtractionService(
        invoker: (_) async => jsonEncode(_structuredOutput),
      ),
    );

    final result = await service.import(
      source: source,
      exportText: _export,
      store: store,
    );

    expect(result.newMessages, 2);
    expect(result.routedMessages, 2);
    expect(result.unroutedMessages, 0);
    expect(result.specsCreated, 2);
    expect(routingCalls, 0);

    final specs = await store.listProjectArtifacts(
      project.id,
      kind: core.ArtifactKind.taskSpec,
    );
    expect(specs, hasLength(2));
  });

  test(
    'an org-scoped source above the confidence threshold auto-routes and drafts a spec',
    () async {
      final source = await store.createSource(
        const core.CreateSourceRequest(kind: core.SourceKind.whatsappImport),
      );
      final service = WhatsAppImportService(
        routingService: MessageRoutingService(
          invoker: (_) async => jsonEncode({
            'structured_output': {'projectId': project.id, 'confidence': 0.9},
          }),
        ),
        extractionService: AnalystExtractionService(
          invoker: (_) async => jsonEncode(_structuredOutput),
        ),
      );

      final result = await service.import(
        source: source,
        exportText: '[1/3/26, 09:15:00] Alice: can we export as PDF?',
        store: store,
      );

      expect(result.newMessages, 1);
      expect(result.routedMessages, 1);
      expect(result.unroutedMessages, 0);
      expect(result.specsCreated, 1);

      final messages = await store.listMessages(sourceId: source.id);
      expect(messages.single.routedProjectId, project.id);
      expect(messages.single.routingConfidence, 0.9);
    },
  );

  test(
    'an org-scoped source below the confidence threshold stays unrouted, no spec drafted',
    () async {
      final source = await store.createSource(
        const core.CreateSourceRequest(kind: core.SourceKind.whatsappImport),
      );
      var extractionCalls = 0;
      final service = WhatsAppImportService(
        routingService: MessageRoutingService(
          invoker: (_) async => jsonEncode({
            'structured_output': {'projectId': project.id, 'confidence': 0.4},
          }),
        ),
        extractionService: AnalystExtractionService(
          invoker: (_) async {
            extractionCalls++;
            return jsonEncode(_structuredOutput);
          },
        ),
      );

      final result = await service.import(
        source: source,
        exportText: '[1/3/26, 09:15:00] Alice: hey what\'s up',
        store: store,
      );

      expect(result.newMessages, 1);
      expect(result.routedMessages, 0);
      expect(result.unroutedMessages, 1);
      expect(result.specsCreated, 0);
      expect(extractionCalls, 0);

      final messages = await store.listMessages(sourceId: source.id);
      expect(messages.single.routedProjectId, isNull);
      expect(messages.single.routingConfidence, 0.4);
    },
  );

  test('a repeat import of the same export text does no new work', () async {
    final source = await store.createSource(
      core.CreateSourceRequest(
        kind: core.SourceKind.whatsappImport,
        projectId: project.id,
      ),
    );
    var extractionCalls = 0;
    final service = WhatsAppImportService(
      extractionService: AnalystExtractionService(
        invoker: (_) async {
          extractionCalls++;
          return jsonEncode(_structuredOutput);
        },
      ),
    );

    final first = await service.import(
      source: source,
      exportText: _export,
      store: store,
    );
    final second = await service.import(
      source: source,
      exportText: _export,
      store: store,
    );

    expect(first.newMessages, 2);
    expect(second.newMessages, 0);
    expect(second.specsCreated, 0);
    expect(extractionCalls, 2);
  });

  test('throws ArgumentError for a non-whatsappImport source', () async {
    final source = await store.createSource(
      core.CreateSourceRequest(
        kind: core.SourceKind.erf,
        projectId: project.id,
      ),
    );
    final service = WhatsAppImportService(
      extractionService: AnalystExtractionService(
        invoker: (_) async => jsonEncode(_structuredOutput),
      ),
    );

    expect(
      () => service.import(source: source, exportText: _export, store: store),
      throwsArgumentError,
    );
  });
}
