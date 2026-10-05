import 'package:app/src/api/api_client.dart';
import 'package:app/src/api/api_client_provider.dart';
import 'package:app/src/routing/app_router.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Returns canned, empty data instead of making real HTTP calls.
class _FakeApiClient extends ApiClient {
  _FakeApiClient() : super(baseUrl: Uri.parse('http://localhost'));

  @override
  Future<List<core.Organization>> listOrgs() async => [];
}

Widget _buildApp() {
  return ProviderScope(
    overrides: [apiClientProvider.overrideWithValue(_FakeApiClient())],
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(appRouterProvider);
        return MaterialApp.router(routerConfig: router);
      },
    ),
  );
}

void main() {
  testWidgets('shows the sidebar and the Tasks/Dashboard tabs', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Select organization'), findsOneWidget);
  });

  testWidgets('switching to the Dashboard tab navigates there', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard coming in the next slice'), findsOneWidget);
  });
}
