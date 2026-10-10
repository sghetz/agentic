import 'dart:convert';

import 'package:app/src/api/api_client.dart';
import 'package:app/src/api/api_client_provider.dart';
import 'package:app/src/ui/tasks/development_panel.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

core.Task _task(core.TaskStatus status) => core.Task(
  id: 'task-1',
  projectId: 'proj-1',
  title: 'Reset password via email',
  currentStatus: status,
  createdAt: DateTime.utc(2026, 1, 1),
  updatedAt: DateTime.utc(2026, 1, 1),
);

core.Artifact _prArtifact() => core.Artifact(
  id: 'pr-1',
  taskId: 'task-1',
  kind: core.ArtifactKind.pr,
  uri: 'https://github.com/org/repo/pull/1',
  content: jsonEncode(
    const core.PullRequestInfo(
      number: 1,
      url: 'https://github.com/org/repo/pull/1',
      branch: 'agentic/task-task-1',
      baseBranch: 'main',
    ).toJson(),
  ),
  version: 1,
  createdAt: DateTime.utc(2026, 1, 1),
);

core.Artifact _reviewArtifact({List<String> missingTests = const []}) =>
    core.Artifact(
      id: 'review-1',
      taskId: 'task-1',
      kind: core.ArtifactKind.review,
      uri: 'review:task-1:v1',
      content: jsonEncode(
        core.ReviewReport(
          summary: 'Covers the happy path.',
          missingTests: missingTests,
        ).toJson(),
      ),
      version: 1,
      createdAt: DateTime.utc(2026, 1, 1),
    );

core.Artifact _taskSpecArtifact() => core.Artifact(
  id: 'spec-1',
  projectId: 'proj-1',
  kind: core.ArtifactKind.taskSpec,
  uri: 'task-spec:proj-1:v1',
  content: jsonEncode(
    const core.TaskSpec(
      projectId: 'proj-1',
      goal: 'Let users reset their password via email',
      priority: core.TaskSpecPriority.high,
    ).toJson(),
  ),
  version: 1,
  createdAt: DateTime.utc(2026, 1, 1),
);

class _FakeApiClient extends ApiClient {
  _FakeApiClient({
    List<core.Artifact>? artifacts,
    List<core.Artifact>? taskSpecs,
  }) : artifacts = artifacts ?? [],
       taskSpecs = taskSpecs ?? [],
       super(baseUrl: Uri.parse('http://localhost'));

  List<core.Artifact> artifacts;
  final List<core.Artifact> taskSpecs;
  List<core.PullRequestCheck> checks = [];
  core.DeveloperOutcome nextDevelopOutcome = core.DeveloperOutcome.prOpened;

  final developCalls =
      <(String orgId, String projectId, String taskId, String specId)>[];
  final reviewCalls = <(String orgId, String projectId, String taskId)>[];
  final approveCalls = <(String orgId, String projectId, String taskId)>[];

  @override
  Future<List<core.Artifact>> listArtifacts(
    String orgId,
    String taskId,
  ) async => artifacts;

  @override
  Future<List<core.Artifact>> listTaskSpecs(
    String orgId,
    String projectId,
  ) async => taskSpecs;

  @override
  Future<({core.DeveloperRunResult result, core.Artifact? pr})> developTask(
    String orgId,
    String projectId,
    String taskId,
    String taskSpecArtifactId,
  ) async {
    developCalls.add((orgId, projectId, taskId, taskSpecArtifactId));
    final result = core.DeveloperRunResult(
      outcome: nextDevelopOutcome,
      summary: 'did the work',
    );
    core.Artifact? pr;
    if (nextDevelopOutcome == core.DeveloperOutcome.prOpened) {
      pr = _prArtifact();
      artifacts = [...artifacts, pr];
    }
    return (result: result, pr: pr);
  }

  @override
  Future<core.Artifact> reviewTask(
    String orgId,
    String projectId,
    String taskId,
  ) async {
    reviewCalls.add((orgId, projectId, taskId));
    final review = _reviewArtifact();
    artifacts = [...artifacts, review];
    return review;
  }

  @override
  Future<void> approveTask(
    String orgId,
    String projectId,
    String taskId,
  ) async {
    approveCalls.add((orgId, projectId, taskId));
  }

  @override
  Future<List<core.PullRequestCheck>> getPrChecks(
    String orgId,
    String projectId,
    String taskId,
  ) async => checks;
}

Widget _buildApp(_FakeApiClient client, core.Task task) {
  return ProviderScope(
    overrides: [apiClientProvider.overrideWithValue(client)],
    child: MaterialApp(
      home: Scaffold(
        body: DevelopmentPanel(
          orgId: 'org-1',
          projectId: 'proj-1',
          taskId: 'task-1',
          task: task,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('specified shows Start Development', (tester) async {
    await tester.pumpWidget(
      _buildApp(_FakeApiClient(), _task(core.TaskStatus.specified)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Start Development'), findsOneWidget);
  });

  testWidgets('inDevelopment shows Continue Development', (tester) async {
    await tester.pumpWidget(
      _buildApp(_FakeApiClient(), _task(core.TaskStatus.inDevelopment)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Continue Development'), findsOneWidget);
  });

  testWidgets('newTask and blocked show no action button', (tester) async {
    for (final status in [core.TaskStatus.newTask, core.TaskStatus.blocked]) {
      await tester.pumpWidget(_buildApp(_FakeApiClient(), _task(status)));
      await tester.pumpAndSettle();

      expect(find.byType(FilledButton), findsNothing);
    }
  });

  testWidgets(
    'Start Development opens a Task Spec picker and calls developTask',
    (tester) async {
      final client = _FakeApiClient(taskSpecs: [_taskSpecArtifact()]);

      await tester.pumpWidget(
        _buildApp(client, _task(core.TaskStatus.specified)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Development'));
      await tester.pumpAndSettle();

      expect(find.text('Implement which Task Spec?'), findsOneWidget);
      expect(
        find.text('Let users reset their password via email'),
        findsOneWidget,
      );

      await tester.tap(find.text('Let users reset their password via email'));
      await tester.pumpAndSettle();

      expect(client.developCalls, [('org-1', 'proj-1', 'task-1', 'spec-1')]);
      expect(find.text('Opened a PR.'), findsOneWidget);
      expect(find.textContaining('PR #1'), findsOneWidget);
    },
  );

  testWidgets('a verificationFailed outcome is reported without a PR link', (
    tester,
  ) async {
    final client = _FakeApiClient(taskSpecs: [_taskSpecArtifact()])
      ..nextDevelopOutcome = core.DeveloperOutcome.verificationFailed;

    await tester.pumpWidget(
      _buildApp(client, _task(core.TaskStatus.specified)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Development'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Let users reset their password via email'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Verification failed -- committed locally for review, not pushed.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('PR #'), findsNothing);
  });

  testWidgets('inReview shows Request Review and calls reviewTask', (
    tester,
  ) async {
    final client = _FakeApiClient(artifacts: [_prArtifact()]);

    await tester.pumpWidget(_buildApp(client, _task(core.TaskStatus.inReview)));
    await tester.pumpAndSettle();

    expect(find.text('Request Review'), findsOneWidget);
    expect(find.textContaining('PR #1'), findsOneWidget);

    await tester.tap(find.text('Request Review'));
    await tester.pumpAndSettle();

    expect(client.reviewCalls, [('org-1', 'proj-1', 'task-1')]);
    expect(find.text('Review complete.'), findsOneWidget);
    expect(find.text('Covers the happy path.'), findsOneWidget);
  });

  testWidgets(
    'awaitingApproval shows the PR, review, pipeline checks, and approves',
    (tester) async {
      final client =
          _FakeApiClient(
              artifacts: [
                _prArtifact(),
                _reviewArtifact(missingTests: const ['expired-link case']),
              ],
            )
            ..checks = const [
              core.PullRequestCheck(
                name: 'build',
                conclusion: core.PrCheckConclusion.success,
              ),
              core.PullRequestCheck(
                name: 'codacy',
                conclusion: core.PrCheckConclusion.pending,
              ),
            ];

      await tester.pumpWidget(
        _buildApp(client, _task(core.TaskStatus.awaitingApproval)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Approve & Merge'), findsOneWidget);
      expect(find.textContaining('PR #1'), findsOneWidget);
      expect(find.text('Covers the happy path.'), findsOneWidget);
      expect(find.textContaining('expired-link case'), findsOneWidget);
      expect(find.text('build'), findsOneWidget);
      expect(find.text('codacy'), findsOneWidget);

      await tester.tap(find.text('Approve & Merge'));
      await tester.pumpAndSettle();

      expect(client.approveCalls, [('org-1', 'proj-1', 'task-1')]);
      expect(find.text('Merged.'), findsOneWidget);
    },
  );

  testWidgets('done shows the PR and review read-only, no action button', (
    tester,
  ) async {
    final client = _FakeApiClient(
      artifacts: [_prArtifact(), _reviewArtifact()],
    );

    await tester.pumpWidget(_buildApp(client, _task(core.TaskStatus.done)));
    await tester.pumpAndSettle();

    expect(find.byType(FilledButton), findsNothing);
    expect(find.textContaining('PR #1'), findsOneWidget);
    expect(find.text('Covers the happy path.'), findsOneWidget);
  });
}
