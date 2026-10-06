import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('JSON round trips', () {
    test('Organization', () {
      final org = Organization(
        id: 'org-1',
        name: 'Employer',
        slug: 'employer',
        type: OrgType.employer,
        createdAt: DateTime.utc(2026, 1, 1),
      );
      expect(Organization.fromJson(org.toJson()), org);
    });

    test('Project with nested RepoConfig list', () {
      final project = Project(
        id: 'proj-1',
        name: 'Example App',
        slug: 'example-app',
        repos: const [
          RepoConfig(
            url: 'git@github.com:org/example-app.git',
            defaultBranch: 'main',
            path: '~/Agentic/repos/employer/example-app',
          ),
        ],
        status: ProjectStatus.active,
        createdAt: DateTime.utc(2026, 1, 1),
        flutterVersion: '3.29.0',
      );
      expect(Project.fromJson(project.toJson()), project);
    });

    test('ProjectLink', () {
      final link = ProjectLink(
        id: 'link-1',
        fromProjectId: 'proj-1',
        toProjectId: 'proj-2',
        relation: LinkRelation.dependsOn,
      );
      expect(ProjectLink.fromJson(link.toJson()), link);
    });

    test('Task', () {
      final task = Task(
        id: 'task-1',
        projectId: 'proj-1',
        title: 'Wire up login',
        currentStatus: TaskStatus.inDevelopment,
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 2),
      );
      expect(Task.fromJson(task.toJson()), task);
    });

    test('TaskEvent with Actor.user()', () {
      final event = TaskEvent(
        id: 'evt-1',
        taskId: 'task-1',
        ts: DateTime.utc(2026, 1, 1, 12),
        actor: const Actor.user(),
        eventType: TaskEventType.statusChanged,
        payload: const {'to': 'specified'},
      );
      final roundTripped = TaskEvent.fromJson(event.toJson());
      expect(roundTripped, event);
      expect(roundTripped.actor, const Actor.user());
    });

    test('TaskEvent with Actor.agent(role)', () {
      final event = TaskEvent(
        id: 'evt-2',
        taskId: 'task-1',
        ts: DateTime.utc(2026, 1, 1, 12),
        actor: const Actor.agent('developer'),
        eventType: TaskEventType.commented,
        payload: const {'text': 'opened a PR'},
      );
      final json = event.toJson();
      expect(json['actor'], 'agent:developer');

      final roundTripped = TaskEvent.fromJson(json);
      expect(roundTripped.actor, const Actor.agent('developer'));
    });

    test('Artifact', () {
      final artifact = Artifact(
        id: 'artifact-1',
        taskId: 'task-1',
        kind: ArtifactKind.pr,
        uri: 'https://github.com/org/repo/pull/1',
        version: 1,
        createdAt: DateTime.utc(2026, 1, 1),
      );
      expect(Artifact.fromJson(artifact.toJson()), artifact);
    });

    test('Artifact scoped to a project instead of a task', () {
      final artifact = Artifact(
        id: 'artifact-2',
        projectId: 'proj-1',
        kind: ArtifactKind.healthReport,
        uri: 'health-report:proj-1:v1',
        content: '{"status":"passed"}',
        version: 1,
        createdAt: DateTime.utc(2026, 1, 1),
      );
      final roundTripped = Artifact.fromJson(artifact.toJson());
      expect(roundTripped, artifact);
      expect(roundTripped.taskId, isNull);
    });

    test('HealthReport', () {
      final report = HealthReport(
        status: HealthCheckStepStatus.failed,
        steps: [
          const HealthCheckStep(
            name: 'pub_get',
            status: HealthCheckStepStatus.passed,
            durationMs: 1200,
            output: 'Got dependencies!',
          ),
          const HealthCheckStep(
            name: 'analyze',
            status: HealthCheckStepStatus.failed,
            durationMs: 800,
            output: 'error • lib/main.dart',
          ),
          const HealthCheckStep(
            name: 'test',
            status: HealthCheckStepStatus.skipped,
            durationMs: 0,
            output: '',
          ),
        ],
        startedAt: DateTime.utc(2026, 1, 1, 12),
        finishedAt: DateTime.utc(2026, 1, 1, 12, 2),
      );
      expect(HealthReport.fromJson(report.toJson()), report);
    });

    test('DashboardSummary with enum-keyed map and nested activity', () {
      final summary = DashboardSummary(
        orgs: [
          DashboardOrgSummary(
            orgId: 'org-1',
            orgName: 'Employer',
            taskCountsByStatus: const {
              TaskStatus.inDevelopment: 2,
              TaskStatus.done: 5,
            },
            recentActivity: [
              RecentActivityItem(
                taskId: 'task-1',
                taskTitle: 'Wire up login',
                projectId: 'proj-1',
                projectName: 'Example App',
                ts: DateTime.utc(2026, 1, 1),
                actor: const Actor.agent('developer'),
                eventType: TaskEventType.statusChanged,
              ),
            ],
          ),
        ],
      );
      expect(DashboardSummary.fromJson(summary.toJson()), summary);
    });
  });

  group('Actor', () {
    test('parse and toStorageString round trip', () {
      expect(Actor.parse('user'), const Actor.user());
      expect(Actor.parse('agent:reviewer'), const Actor.agent('reviewer'));
      expect(const Actor.user().toStorageString(), 'user');
      expect(const Actor.agent('reviewer').toStorageString(), 'agent:reviewer');
    });

    test('parse rejects malformed values', () {
      expect(() => Actor.parse('nope'), throwsFormatException);
    });
  });
}
