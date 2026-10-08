import 'package:app/src/api/api_client.dart';
import 'package:app/src/api/api_client_provider.dart';
import 'package:app/src/state/org_providers.dart';
import 'package:app/src/ui/inbox/inbox_screen.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeApiClient extends ApiClient {
  _FakeApiClient({List<core.Message>? messages, List<core.Project>? projects})
    : messages = messages ?? [],
      projects = projects ?? [],
      super(baseUrl: Uri.parse('http://localhost'));

  List<core.Message> messages;
  List<core.Project> projects;
  final assignedCalls = <(String messageId, String projectId)>[];
  final sources = <core.Source>[];

  @override
  Future<List<core.Message>> listUnroutedMessages(String orgId) async =>
      messages;

  @override
  Future<List<core.Project>> listProjects(
    String orgId, {
    bool includeArchived = false,
  }) async => projects;

  @override
  Future<core.Message> assignMessageProject(
    String orgId,
    String messageId,
    String projectId,
  ) async {
    assignedCalls.add((messageId, projectId));
    messages = messages.where((m) => m.id != messageId).toList();
    return core.Message(
      id: messageId,
      sourceId: 'source-1',
      externalId: messageId,
      sentAt: DateTime.utc(2026, 1, 1),
      body: 'x',
      raw: const {},
      routedProjectId: projectId,
    );
  }

  @override
  Future<List<core.Source>> listSources(
    String orgId, {
    String? projectId,
  }) async => sources;

  @override
  Future<core.Source> createSource(
    String orgId,
    core.CreateSourceRequest request,
  ) async {
    final source = core.Source(
      id: 'source-new',
      kind: request.kind,
      config: request.config,
      projectId: request.projectId,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    sources.add(source);
    return source;
  }

  @override
  Future<Map<String, Object?>> importWhatsApp(
    String orgId,
    String sourceId,
    String exportText,
  ) async => {
    'newMessages': 1,
    'routedMessages': 0,
    'unroutedMessages': 1,
    'specsCreated': 0,
    'failedMessageIds': <String>[],
  };
}

core.Message _message(String id, {double? confidence}) => core.Message(
  id: id,
  sourceId: 'source-1',
  externalId: id,
  author: 'Alice',
  sentAt: DateTime.utc(2026, 1, 1),
  body: 'can someone look at the export bug?',
  raw: const {},
  routingConfidence: confidence,
);

class _FixedOrgId extends SelectedOrgId {
  @override
  String? build() => 'org-1';
}

Widget _buildApp(_FakeApiClient client) {
  return ProviderScope(
    overrides: [
      apiClientProvider.overrideWithValue(client),
      selectedOrgIdProvider.overrideWith(() => _FixedOrgId()),
    ],
    child: const MaterialApp(home: Scaffold(body: InboxScreen())),
  );
}

void main() {
  testWidgets('shows an empty state when nothing is unrouted', (tester) async {
    await tester.pumpWidget(_buildApp(_FakeApiClient()));
    await tester.pumpAndSettle();

    expect(find.text('Nothing waiting on routing right now.'), findsOneWidget);
  });

  testWidgets('shows an unrouted message with its routing confidence', (
    tester,
  ) async {
    final client = _FakeApiClient(
      messages: [_message('msg-1', confidence: 0.4)],
    );
    await tester.pumpWidget(_buildApp(client));
    await tester.pumpAndSettle();

    expect(find.text('Alice'), findsOneWidget);
    expect(find.textContaining('can someone look'), findsOneWidget);
    expect(find.textContaining('40%'), findsOneWidget);
  });

  testWidgets('assigning a project removes the message from the list', (
    tester,
  ) async {
    final client = _FakeApiClient(
      messages: [_message('msg-1')],
      projects: [
        core.Project(
          id: 'proj-1',
          name: 'Expense Manager',
          slug: 'expense-manager',
          repos: const [],
          status: core.ProjectStatus.active,
          createdAt: DateTime.utc(2026, 1, 1),
        ),
      ],
    );
    await tester.pumpWidget(_buildApp(client));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Expense Manager').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('assignButton')));
    await tester.pumpAndSettle();

    expect(client.assignedCalls, [('msg-1', 'proj-1')]);
    expect(find.text('Nothing waiting on routing right now.'), findsOneWidget);
  });

  testWidgets('importing WhatsApp text creates a source and refreshes', (
    tester,
  ) async {
    final client = _FakeApiClient();
    await tester.pumpWidget(_buildApp(client));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Import WhatsApp chat...'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField),
      '[1/3/26, 09:15:00] Alice: hello',
    );
    await tester.tap(find.text('Import'));
    await tester.pumpAndSettle();

    expect(client.sources, hasLength(1));
    expect(client.sources.single.kind, core.SourceKind.whatsappImport);
    expect(find.textContaining('Imported 1 message'), findsOneWidget);
  });
}
