import 'package:app/src/api/api_client.dart';
import 'package:app/src/api/api_client_provider.dart';
import 'package:app/src/ui/dashboard/dashboard_screen.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeApiClient extends ApiClient {
  _FakeApiClient(this._summary) : super(baseUrl: Uri.parse('http://localhost'));

  final core.DashboardSummary _summary;

  @override
  Future<core.DashboardSummary> dashboard() async => _summary;
}

Widget _wrap(core.DashboardSummary summary) {
  return ProviderScope(
    overrides: [apiClientProvider.overrideWithValue(_FakeApiClient(summary))],
    child: const MaterialApp(home: Scaffold(body: DashboardScreen())),
  );
}

void main() {
  testWidgets(
    'renders per-org counts and recent activity without mixing orgs',
    (tester) async {
      final summary = core.DashboardSummary(
        orgs: [
          core.DashboardOrgSummary(
            orgId: 'org-a',
            orgName: 'Org A',
            taskCountsByStatus: const {
              core.TaskStatus.newTask: 2,
              core.TaskStatus.done: 1,
            },
            recentActivity: [
              core.RecentActivityItem(
                taskId: 'task-a1',
                taskTitle: 'A task',
                projectId: 'proj-a',
                projectName: 'Project A',
                ts: DateTime.utc(2026, 1, 1),
                actor: const core.Actor.agent('developer'),
                eventType: core.TaskEventType.statusChanged,
              ),
            ],
          ),
          core.DashboardOrgSummary(
            orgId: 'org-b',
            orgName: 'Org B',
            taskCountsByStatus: const {core.TaskStatus.inReview: 1},
            recentActivity: const [],
          ),
        ],
      );

      await tester.pumpWidget(_wrap(summary));
      await tester.pumpAndSettle();

      expect(find.text('Org A'), findsOneWidget);
      expect(find.text('Org B'), findsOneWidget);
      expect(find.text('newTask: 2'), findsOneWidget);
      expect(find.text('done: 1'), findsOneWidget);
      expect(find.text('inReview: 1'), findsOneWidget);

      // Org A has activity, Org B doesn't -- each org's summary is independent.
      expect(find.textContaining('A task'), findsOneWidget);
      expect(find.text('No activity yet'), findsOneWidget);
    },
  );

  testWidgets('shows an empty state with no organizations', (tester) async {
    await tester.pumpWidget(_wrap(const core.DashboardSummary(orgs: [])));
    await tester.pumpAndSettle();

    expect(find.text('No organizations yet'), findsOneWidget);
  });
}
