import 'dart:convert';

import 'package:app/src/api/api_client.dart';
import 'package:app/src/api/api_client_provider.dart';
import 'package:app/src/ui/health/health_report_dialog.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

core.Artifact _reportArtifact({
  required int version,
  required core.HealthCheckStepStatus status,
  core.FailureDiagnosis? diagnosis,
}) {
  final report = core.HealthReport(
    status: status,
    steps: [
      core.HealthCheckStep(
        name: 'pub_get',
        status: core.HealthCheckStepStatus.passed,
        durationMs: 500,
        output: 'Got dependencies!',
      ),
      core.HealthCheckStep(
        name: 'analyze',
        status: status,
        durationMs: 300,
        output: status == core.HealthCheckStepStatus.failed
            ? 'error • lib/main.dart'
            : '',
      ),
    ],
    startedAt: DateTime.utc(2026, 1, 1),
    finishedAt: DateTime.utc(2026, 1, 1, 0, 1),
    diagnosis: diagnosis,
  );
  return core.Artifact(
    id: 'artifact-$version',
    projectId: 'proj-1',
    kind: core.ArtifactKind.healthReport,
    uri: 'health-report:proj-1:v$version',
    content: jsonEncode(report.toJson()),
    version: version,
    createdAt: DateTime.utc(2026, 1, 1),
  );
}

class _FakeApiClient extends ApiClient {
  _FakeApiClient(this.reports) : super(baseUrl: Uri.parse('http://localhost'));

  List<core.Artifact> reports;
  int runCount = 0;

  @override
  Future<List<core.Artifact>> listHealthReports(
    String orgId,
    String projectId, {
    int? limit,
  }) async {
    return limit == null ? reports : reports.take(limit).toList();
  }

  @override
  Future<core.Artifact> runProjectHealthCheck(
    String orgId,
    String projectId,
  ) async {
    runCount++;
    final newest = _reportArtifact(
      version: reports.length + 1,
      status: core.HealthCheckStepStatus.passed,
    );
    reports = [newest, ...reports];
    return newest;
  }
}

void main() {
  testWidgets('shows past reports newest first with step detail', (
    tester,
  ) async {
    final client = _FakeApiClient([
      _reportArtifact(version: 2, status: core.HealthCheckStepStatus.failed),
      _reportArtifact(version: 1, status: core.HealthCheckStepStatus.passed),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiClientProvider.overrideWithValue(client)],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showHealthReportDialog(
                  context,
                  orgId: 'org-1',
                  projectId: 'proj-1',
                  projectName: 'Example App',
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Example App health'), findsOneWidget);
    expect(find.textContaining('v2'), findsOneWidget);
    expect(find.textContaining('v1'), findsOneWidget);

    await tester.tap(find.textContaining('v2'));
    await tester.pumpAndSettle();
    expect(find.text('analyze (300ms)'), findsOneWidget);
  });

  testWidgets('Run check calls the API and refreshes the list', (tester) async {
    final client = _FakeApiClient([]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiClientProvider.overrideWithValue(client)],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showHealthReportDialog(
                  context,
                  orgId: 'org-1',
                  projectId: 'proj-1',
                  projectName: 'Example App',
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('No health checks run yet'), findsOneWidget);

    await tester.tap(find.text('Run check'));
    await tester.pumpAndSettle();

    expect(client.runCount, 1);
    expect(find.textContaining('v1'), findsOneWidget);
  });

  testWidgets('shows the diagnosis when a report has one', (tester) async {
    final client = _FakeApiClient([
      _reportArtifact(
        version: 1,
        status: core.HealthCheckStepStatus.failed,
        diagnosis: const core.FailureDiagnosis(
          category: core.FailureDiagnosisCategory.sdkMismatch,
          summary: 'Pre-null-safety SDK constraint.',
          suggestedFix: "Update the sdk constraint to '>=2.12.0 <4.0.0'.",
        ),
      ),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiClientProvider.overrideWithValue(client)],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showHealthReportDialog(
                  context,
                  orgId: 'org-1',
                  projectId: 'proj-1',
                  projectName: 'Example App',
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('v1'));
    await tester.pumpAndSettle();

    expect(find.text('SDK mismatch'), findsOneWidget);
    expect(find.text('Pre-null-safety SDK constraint.'), findsOneWidget);
    expect(find.textContaining('>=2.12.0 <4.0.0'), findsOneWidget);
  });
}
