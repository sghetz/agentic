import 'package:app/src/api/api_client.dart';
import 'package:app/src/api/api_client_provider.dart';
import 'package:app/src/state/org_providers.dart';
import 'package:app/src/ui/connections/connections_screen.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _outlook = core.ConnectorDefinition(
  id: 'outlook',
  displayName: 'Outlook',
  authorizeUrl:
      'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
  tokenUrl: 'https://login.microsoftonline.com/common/oauth2/v2.0/token',
  scopes: ['Mail.Read', 'offline_access'],
);

const _zoom = core.ConnectorDefinition(
  id: 'zoom',
  displayName: 'Zoom (meeting transcripts)',
  authorizeUrl: 'https://zoom.us/oauth/authorize',
  tokenUrl: 'https://zoom.us/oauth/token',
  scopes: ['cloud_recording:read:list_user_recordings'],
);

core.Source _oauthSource({required String id, required String connectorId}) =>
    core.Source(
      id: id,
      kind: core.SourceKind.oauthConnector,
      config: {'connectorId': connectorId},
      createdAt: DateTime.utc(2026, 1, 1),
    );

class _FakeApiClient extends ApiClient {
  _FakeApiClient({
    List<core.ConnectorDefinition>? definitions,
    List<core.Source>? sources,
  }) : definitions = definitions ?? const [],
       sources = sources ?? const [],
       super(baseUrl: Uri.parse('http://localhost'));

  final List<core.ConnectorDefinition> definitions;
  final List<core.Source> sources;
  final connectCalls =
      <
        (String orgId, String connectorId, String clientId, String clientSecret)
      >[];
  final syncCalls = <(String orgId, String sourceId)>[];
  String authorizeUrlToReturn = 'https://example.com/authorize?state=abc';

  @override
  Future<List<core.ConnectorDefinition>> listConnectors() async => definitions;

  @override
  Future<List<core.Source>> listSources(
    String orgId, {
    String? projectId,
  }) async => sources;

  @override
  Future<String> beginConnectorConnect(
    String orgId,
    String connectorId, {
    required String clientId,
    required String clientSecret,
  }) async {
    connectCalls.add((orgId, connectorId, clientId, clientSecret));
    return authorizeUrlToReturn;
  }

  @override
  Future<Map<String, Object?>> syncSource(String orgId, String sourceId) async {
    syncCalls.add((orgId, sourceId));
    return {
      'newMessages': 2,
      'routedMessages': 1,
      'unroutedMessages': 1,
      'specsCreated': 1,
    };
  }
}

Widget _buildApp(_FakeApiClient client) {
  return ProviderScope(
    overrides: [
      apiClientProvider.overrideWithValue(client),
      selectedOrgIdProvider.overrideWith(() => _FixedOrgId()),
    ],
    child: const MaterialApp(home: Scaffold(body: ConnectionsScreen())),
  );
}

class _FixedOrgId extends SelectedOrgId {
  @override
  String? build() => 'org-1';
}

void main() {
  testWidgets('shows an empty state with no connectors at all', (tester) async {
    await tester.pumpWidget(_buildApp(_FakeApiClient()));
    await tester.pumpAndSettle();

    expect(find.text('No connectors available'), findsOneWidget);
  });

  testWidgets('lists available connectors not yet connected', (tester) async {
    final client = _FakeApiClient(definitions: [_outlook, _zoom]);

    await tester.pumpWidget(_buildApp(client));
    await tester.pumpAndSettle();

    expect(find.text('Available'), findsOneWidget);
    expect(find.text('Outlook'), findsOneWidget);
    expect(find.text('Zoom (meeting transcripts)'), findsOneWidget);
    expect(find.text('Connected'), findsNothing);
  });

  testWidgets(
    'a connected connector is excluded from Available and shown under Connected',
    (tester) async {
      final client = _FakeApiClient(
        definitions: [_outlook, _zoom],
        sources: [_oauthSource(id: 'src-1', connectorId: 'outlook')],
      );

      await tester.pumpWidget(_buildApp(client));
      await tester.pumpAndSettle();

      expect(find.text('Connected'), findsOneWidget);
      // "Outlook" appears once under Connected; Available only has Zoom.
      expect(find.text('Outlook'), findsOneWidget);
      expect(find.text('Zoom (meeting transcripts)'), findsOneWidget);

      final availableHeader = find.text('Available');
      final connectedHeader = find.text('Connected');
      expect(availableHeader, findsOneWidget);
      expect(connectedHeader, findsOneWidget);
    },
  );

  testWidgets(
    'Connect opens a dialog and calls beginConnectorConnect with the entered credentials',
    (tester) async {
      final client = _FakeApiClient(definitions: [_outlook]);

      await tester.pumpWidget(_buildApp(client));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Connect'));
      await tester.pumpAndSettle();

      expect(find.text('Connect Outlook'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextField, 'Client ID'),
        'my-id',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Client secret'),
        'my-secret',
      );
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(client.connectCalls, [('org-1', 'outlook', 'my-id', 'my-secret')]);
    },
  );

  testWidgets(
    'cancelling the connect dialog does not call beginConnectorConnect',
    (tester) async {
      final client = _FakeApiClient(definitions: [_outlook]);

      await tester.pumpWidget(_buildApp(client));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Connect'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(client.connectCalls, isEmpty);
    },
  );

  testWidgets('Sync now calls syncSource and shows a result snackbar', (
    tester,
  ) async {
    final client = _FakeApiClient(
      definitions: [_outlook],
      sources: [_oauthSource(id: 'src-1', connectorId: 'outlook')],
    );

    await tester.pumpWidget(_buildApp(client));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sync now'));
    await tester.pumpAndSettle();

    expect(client.syncCalls, [('org-1', 'src-1')]);
    expect(find.textContaining('2 new'), findsOneWidget);
  });
}
