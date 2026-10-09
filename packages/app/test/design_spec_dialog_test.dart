import 'dart:convert';

import 'package:app/src/api/api_client.dart';
import 'package:app/src/api/api_client_provider.dart';
import 'package:app/src/ui/design/design_spec_dialog.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

core.Artifact _designSpecArtifact({
  required int version,
  required core.DesignSpec spec,
}) {
  return core.Artifact(
    id: 'design-spec-$version',
    projectId: 'proj-1',
    kind: core.ArtifactKind.designSpec,
    uri: 'design-spec:proj-1:v$version',
    content: jsonEncode(spec.toJson()),
    version: version,
    createdAt: DateTime.utc(2026, 1, 1),
  );
}

core.Artifact _diagramArtifact({required int version, String mermaid = ''}) {
  return core.Artifact(
    id: 'diagram-$version',
    projectId: 'proj-1',
    kind: core.ArtifactKind.diagram,
    uri: 'diagram:proj-1:v$version',
    content: mermaid,
    version: version,
    createdAt: DateTime.utc(2026, 1, 1),
  );
}

core.Artifact _taskSpecArtifact({required String id, required String goal}) {
  return core.Artifact(
    id: id,
    projectId: 'proj-1',
    kind: core.ArtifactKind.taskSpec,
    uri: 'task-spec:proj-1:$id',
    content: jsonEncode(
      core.TaskSpec(
        projectId: 'proj-1',
        goal: goal,
        priority: core.TaskSpecPriority.medium,
      ).toJson(),
    ),
    version: 1,
    createdAt: DateTime.utc(2026, 1, 1),
  );
}

class _FakeApiClient extends ApiClient {
  _FakeApiClient({
    List<core.Artifact>? designSpecs,
    List<core.Artifact>? diagrams,
    List<core.Artifact>? taskSpecs,
  }) : designSpecs = designSpecs ?? [],
       diagrams = diagrams ?? [],
       taskSpecs = taskSpecs ?? [],
       super(baseUrl: Uri.parse('http://localhost'));

  List<core.Artifact> designSpecs;
  List<core.Artifact> diagrams;
  final List<core.Artifact> taskSpecs;
  final generateCalls = <(String orgId, String projectId, String taskSpecId)>[];

  @override
  Future<List<core.Artifact>> listDesignSpecs(
    String orgId,
    String projectId,
  ) async => designSpecs;

  @override
  Future<List<core.Artifact>> listDiagrams(
    String orgId,
    String projectId,
  ) async => diagrams;

  @override
  Future<List<core.Artifact>> listTaskSpecs(
    String orgId,
    String projectId,
  ) async => taskSpecs;

  @override
  Future<({core.Artifact designSpec, core.Artifact diagram})>
  generateDesignSpec(
    String orgId,
    String projectId,
    String taskSpecArtifactId,
  ) async {
    generateCalls.add((orgId, projectId, taskSpecArtifactId));
    final version = designSpecs.length + 1;
    final newSpec = _designSpecArtifact(
      version: version,
      spec: const core.DesignSpec(
        projectId: 'proj-1',
        screens: [
          core.ScreenSpec(name: 'GeneratedScreen', purpose: 'Generated'),
        ],
      ),
    );
    final newDiagram = _diagramArtifact(version: version);
    designSpecs = [...designSpecs, newSpec];
    diagrams = [...diagrams, newDiagram];
    return (designSpec: newSpec, diagram: newDiagram);
  }
}

Widget _buildApp(_FakeApiClient client) {
  return ProviderScope(
    overrides: [apiClientProvider.overrideWithValue(client)],
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDesignSpecDialog(
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
    await tester.pumpWidget(_buildApp(_FakeApiClient()));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Example App Design Specs'), findsOneWidget);
    expect(find.text('No Design Specs generated yet'), findsOneWidget);
  });

  testWidgets('lists a generated spec by its screen names, collapsed', (
    tester,
  ) async {
    // Deliberately does not expand the tile: doing so would mount a
    // MermaidView, which constructs a real WebViewController -- not
    // supported in the widget-test environment (no platform channel
    // registered). MermaidView's own rendering is verified separately,
    // live, in the running macOS app (see docs/PHASE_4_SPEC.md slice 2).
    const spec = core.DesignSpec(
      projectId: 'proj-1',
      screens: [
        core.ScreenSpec(name: 'Login', purpose: 'Sign in'),
        core.ScreenSpec(name: 'Home', purpose: 'Dashboard'),
      ],
    );
    final client = _FakeApiClient(
      designSpecs: [_designSpecArtifact(version: 1, spec: spec)],
      diagrams: [_diagramArtifact(version: 1, mermaid: 'flowchart TD\nA-->B')],
    );

    await tester.pumpWidget(_buildApp(client));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Login'), findsOneWidget);
    expect(find.textContaining('Home'), findsOneWidget);
    expect(find.text('v1'), findsOneWidget);
  });

  testWidgets(
    'Generate from Task Spec... opens a picker and calls generateDesignSpec',
    (tester) async {
      final client = _FakeApiClient(
        taskSpecs: [
          _taskSpecArtifact(id: 'ts-1', goal: 'Reset password via email'),
        ],
      );

      await tester.pumpWidget(_buildApp(client));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Generate from Task Spec...'));
      await tester.pumpAndSettle();

      expect(find.text('Generate from which Task Spec?'), findsOneWidget);
      expect(find.text('Reset password via email'), findsOneWidget);

      await tester.tap(find.text('Reset password via email'));
      await tester.pumpAndSettle();

      expect(client.generateCalls, [('org-1', 'proj-1', 'ts-1')]);
      // The picker should be closed and the main dialog refreshed with the
      // newly generated spec.
      expect(find.text('Generate from which Task Spec?'), findsNothing);
      expect(find.textContaining('GeneratedScreen'), findsOneWidget);
    },
  );

  testWidgets('the picker shows an empty state with no Task Specs', (
    tester,
  ) async {
    final client = _FakeApiClient();

    await tester.pumpWidget(_buildApp(client));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generate from Task Spec...'));
    await tester.pumpAndSettle();

    expect(find.text('No Task Specs drafted yet'), findsOneWidget);
  });

  testWidgets('cancelling the picker does not call generateDesignSpec', (
    tester,
  ) async {
    final client = _FakeApiClient(
      taskSpecs: [_taskSpecArtifact(id: 'ts-1', goal: 'Some task')],
    );

    await tester.pumpWidget(_buildApp(client));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generate from Task Spec...'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(client.generateCalls, isEmpty);
  });
}
