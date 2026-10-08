import 'dart:convert';

import 'package:app/src/api/api_client.dart';
import 'package:app/src/api/api_client_provider.dart';
import 'package:app/src/ui/inbox/task_spec_dialog.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

core.Artifact _specArtifact({
  required int version,
  required core.TaskSpec spec,
}) {
  return core.Artifact(
    id: 'artifact-$version',
    projectId: 'proj-1',
    kind: core.ArtifactKind.taskSpec,
    uri: 'task-spec:proj-1:v$version',
    content: jsonEncode(spec.toJson()),
    version: version,
    createdAt: DateTime.utc(2026, 1, 1),
  );
}

class _FakeApiClient extends ApiClient {
  _FakeApiClient(this.specs) : super(baseUrl: Uri.parse('http://localhost'));

  final List<core.Artifact> specs;

  @override
  Future<List<core.Artifact>> listTaskSpecs(
    String orgId,
    String projectId,
  ) async => specs;
}

Widget _buildApp(_FakeApiClient client) {
  return ProviderScope(
    overrides: [apiClientProvider.overrideWithValue(client)],
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showTaskSpecDialog(
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
  );
}

void main() {
  testWidgets('shows an empty state when there are no specs yet', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp(_FakeApiClient([])));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Example App Task Specs'), findsOneWidget);
    expect(find.text('No Task Specs drafted yet'), findsOneWidget);
  });

  testWidgets('shows the goal and expands to show open questions', (
    tester,
  ) async {
    const spec = core.TaskSpec(
      projectId: 'proj-1',
      goal: 'Let users reset their password via email',
      requirementIds: ['RF-07'],
      acceptanceCriteria: ['A reset link expires after 1 hour'],
      affectedAreas: ['Auth'],
      priority: core.TaskSpecPriority.high,
      openQuestions: ['Should the link be single-use?'],
    );
    final client = _FakeApiClient([_specArtifact(version: 1, spec: spec)]);

    await tester.pumpWidget(_buildApp(client));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(
      find.text('Let users reset their password via email'),
      findsOneWidget,
    );

    await tester.tap(find.text('Let users reset their password via email'));
    await tester.pumpAndSettle();

    expect(find.textContaining('RF-07'), findsOneWidget);
    expect(
      find.textContaining('A reset link expires after 1 hour'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Should the link be single-use?'),
      findsOneWidget,
    );
  });
}
