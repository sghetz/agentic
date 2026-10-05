import 'package:core/core.dart' as core;
import 'package:server/src/repositories/org_store.dart';
import 'package:server/src/storage/org_database.dart';
import 'package:test/test.dart';

void main() {
  late OrgDatabase db;
  late OrgStore store;

  setUp(() {
    db = OrgDatabase.memory();
    store = OrgStore('org-1', db);
  });

  tearDown(() => db.close());

  group('projects', () {
    test('create then get round trips, including nested repos', () async {
      final project = await store.createProject(
        const core.CreateProjectRequest(
          name: 'Example App',
          slug: 'example-app',
          repos: [
            core.RepoConfig(
              url: 'git@github.com:org/example-app.git',
              defaultBranch: 'main',
              path: '~/Agentic/repos/employer/example-app',
            ),
          ],
          flutterVersion: '3.29.0',
        ),
      );

      expect(project.status, core.ProjectStatus.active);
      expect(project.repos, hasLength(1));
      expect(await store.getProject(project.id), project);
    });

    test('create rejects a duplicate slug', () async {
      await store.createProject(
        const core.CreateProjectRequest(name: 'A', slug: 'dup'),
      );
      expect(
        () => store.createProject(
          const core.CreateProjectRequest(name: 'B', slug: 'dup'),
        ),
        throwsA(isA<DuplicateProjectSlug>()),
      );
    });

    test(
      'archiveProject sets status and archivedAt, and excludes it by default',
      () async {
        final project = await store.createProject(
          const core.CreateProjectRequest(name: 'A', slug: 'a'),
        );
        final archived = await store.archiveProject(project.id);

        expect(archived.status, core.ProjectStatus.archived);
        expect(archived.archivedAt, isNotNull);
        expect(await store.listProjects(), isEmpty);
        expect(await store.listProjects(includeArchived: true), [archived]);
      },
    );

    test('updateProject on an unknown id throws', () async {
      expect(
        () => store.updateProject(
          'nope',
          const core.UpdateProjectRequest(name: 'x'),
        ),
        throwsA(isA<ProjectNotFound>()),
      );
    });
  });

  group('project links', () {
    test('links two projects in the same org', () async {
      final a = await store.createProject(
        const core.CreateProjectRequest(name: 'A', slug: 'a'),
      );
      final b = await store.createProject(
        const core.CreateProjectRequest(name: 'B', slug: 'b'),
      );

      final link = await store.createProjectLink(
        a.id,
        core.CreateProjectLinkRequest(
          toProjectId: b.id,
          relation: core.LinkRelation.dependsOn,
        ),
      );

      expect(await store.listProjectLinks(a.id), [link]);
    });

    test(
      'rejects a link to a project id that does not exist in this org',
      () async {
        final a = await store.createProject(
          const core.CreateProjectRequest(name: 'A', slug: 'a'),
        );
        expect(
          () => store.createProjectLink(
            a.id,
            const core.CreateProjectLinkRequest(
              toProjectId: 'unknown-project',
              relation: core.LinkRelation.related,
            ),
          ),
          throwsA(isA<CrossOrgLinkRejected>()),
        );
      },
    );

    test('delete removes the link', () async {
      final a = await store.createProject(
        const core.CreateProjectRequest(name: 'A', slug: 'a'),
      );
      final b = await store.createProject(
        const core.CreateProjectRequest(name: 'B', slug: 'b'),
      );
      final link = await store.createProjectLink(
        a.id,
        core.CreateProjectLinkRequest(
          toProjectId: b.id,
          relation: core.LinkRelation.related,
        ),
      );

      await store.deleteProjectLink(a.id, link.id);
      expect(await store.listProjectLinks(a.id), isEmpty);
    });
  });

  group('tasks and the event log', () {
    test('createTask starts at newTask and writes a created event', () async {
      final project = await store.createProject(
        const core.CreateProjectRequest(name: 'A', slug: 'a'),
      );
      final task = await store.createTask(
        project.id,
        const core.CreateTaskRequest(title: 'Do the thing'),
      );

      expect(task.currentStatus, core.TaskStatus.newTask);
      final events = await store.listTaskEvents(task.id);
      expect(events, hasLength(1));
      expect(events.single.eventType, core.TaskEventType.created);
    });

    test(
      'a full lifecycle updates the cached currentStatus as it goes',
      () async {
        final project = await store.createProject(
          const core.CreateProjectRequest(name: 'A', slug: 'a'),
        );
        final task = await store.createTask(
          project.id,
          const core.CreateTaskRequest(title: 'T'),
        );

        await store.appendTaskEvent(
          task.id,
          const core.CreateTaskEventRequest(
            actor: core.Actor.user(),
            eventType: core.TaskEventType.statusChanged,
            payload: {'to': 'specified'},
          ),
        );
        final afterSpecified = await store.getTask(task.id);
        expect(afterSpecified!.currentStatus, core.TaskStatus.specified);

        await store.appendTaskEvent(
          task.id,
          const core.CreateTaskEventRequest(
            actor: core.Actor.agent('developer'),
            eventType: core.TaskEventType.statusChanged,
            payload: {'to': 'inDevelopment'},
          ),
        );
        expect(
          (await store.getTask(task.id))!.currentStatus,
          core.TaskStatus.inDevelopment,
        );
      },
    );

    test('rejects an event that violates the state machine', () async {
      final project = await store.createProject(
        const core.CreateProjectRequest(name: 'A', slug: 'a'),
      );
      final task = await store.createTask(
        project.id,
        const core.CreateTaskRequest(title: 'T'),
      );

      // newTask -> done is not a legal one-step transition.
      expect(
        () => store.appendTaskEvent(
          task.id,
          const core.CreateTaskEventRequest(
            actor: core.Actor.user(),
            eventType: core.TaskEventType.statusChanged,
            payload: {'to': 'done'},
          ),
        ),
        throwsA(isA<InvalidTaskTransition>()),
      );
    });

    test(
      'block then unblock returns to the status it was blocked from',
      () async {
        final project = await store.createProject(
          const core.CreateProjectRequest(name: 'A', slug: 'a'),
        );
        final task = await store.createTask(
          project.id,
          const core.CreateTaskRequest(title: 'T'),
        );

        await store.appendTaskEvent(
          task.id,
          const core.CreateTaskEventRequest(
            actor: core.Actor.user(),
            eventType: core.TaskEventType.statusChanged,
            payload: {'to': 'specified'},
          ),
        );
        await store.appendTaskEvent(
          task.id,
          const core.CreateTaskEventRequest(
            actor: core.Actor.user(),
            eventType: core.TaskEventType.statusChanged,
            payload: {'to': 'blocked'},
          ),
        );
        expect(
          (await store.getTask(task.id))!.currentStatus,
          core.TaskStatus.blocked,
        );

        // Only the remembered prior status is a legal way out of blocked.
        expect(
          () => store.appendTaskEvent(
            task.id,
            const core.CreateTaskEventRequest(
              actor: core.Actor.user(),
              eventType: core.TaskEventType.statusChanged,
              payload: {'to': 'inReview'},
            ),
          ),
          throwsA(isA<InvalidTaskTransition>()),
        );

        await store.appendTaskEvent(
          task.id,
          const core.CreateTaskEventRequest(
            actor: core.Actor.user(),
            eventType: core.TaskEventType.statusChanged,
            payload: {'to': 'specified'},
          ),
        );
        expect(
          (await store.getTask(task.id))!.currentStatus,
          core.TaskStatus.specified,
        );
      },
    );

    test(
      'reopened is only legal from done, and always returns to specified',
      () async {
        final project = await store.createProject(
          const core.CreateProjectRequest(name: 'A', slug: 'a'),
        );
        final task = await store.createTask(
          project.id,
          const core.CreateTaskRequest(title: 'T'),
        );

        expect(
          () => store.appendTaskEvent(
            task.id,
            const core.CreateTaskEventRequest(
              actor: core.Actor.user(),
              eventType: core.TaskEventType.reopened,
            ),
          ),
          throwsA(isA<InvalidTaskTransition>()),
        );

        for (final to in [
          'specified',
          'inDevelopment',
          'inReview',
          'awaitingApproval',
          'done',
        ]) {
          await store.appendTaskEvent(
            task.id,
            core.CreateTaskEventRequest(
              actor: const core.Actor.user(),
              eventType: core.TaskEventType.statusChanged,
              payload: {'to': to},
            ),
          );
        }
        expect(
          (await store.getTask(task.id))!.currentStatus,
          core.TaskStatus.done,
        );

        await store.appendTaskEvent(
          task.id,
          const core.CreateTaskEventRequest(
            actor: core.Actor.user(),
            eventType: core.TaskEventType.reopened,
          ),
        );
        expect(
          (await store.getTask(task.id))!.currentStatus,
          core.TaskStatus.specified,
        );
      },
    );

    test('getTask(at:) reconstructs status as of a past date', () async {
      final project = await store.createProject(
        const core.CreateProjectRequest(name: 'A', slug: 'a'),
      );
      final task = await store.createTask(
        project.id,
        const core.CreateTaskRequest(title: 'T'),
      );

      await store.appendTaskEvent(
        task.id,
        const core.CreateTaskEventRequest(
          actor: core.Actor.user(),
          eventType: core.TaskEventType.statusChanged,
          payload: {'to': 'specified'},
        ),
      );
      final checkpoint = DateTime.now().toUtc();
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await store.appendTaskEvent(
        task.id,
        const core.CreateTaskEventRequest(
          actor: core.Actor.user(),
          eventType: core.TaskEventType.statusChanged,
          payload: {'to': 'inDevelopment'},
        ),
      );

      final asOfCheckpoint = await store.getTask(task.id, at: checkpoint);
      expect(asOfCheckpoint!.currentStatus, core.TaskStatus.specified);
      expect(
        (await store.getTask(task.id))!.currentStatus,
        core.TaskStatus.inDevelopment,
      );
    });

    test('listTasks filters by status and title query', () async {
      final project = await store.createProject(
        const core.CreateProjectRequest(name: 'A', slug: 'a'),
      );
      final t1 = await store.createTask(
        project.id,
        const core.CreateTaskRequest(title: 'Fix login bug'),
      );
      await store.createTask(
        project.id,
        const core.CreateTaskRequest(title: 'Write docs'),
      );

      await store.appendTaskEvent(
        t1.id,
        const core.CreateTaskEventRequest(
          actor: core.Actor.user(),
          eventType: core.TaskEventType.statusChanged,
          payload: {'to': 'specified'},
        ),
      );

      final specified = await store.listTasks(
        project.id,
        status: core.TaskStatus.specified,
      );
      expect(specified.map((t) => t.id), [t1.id]);

      final byQuery = await store.listTasks(project.id, query: 'login');
      expect(byQuery.map((t) => t.id), [t1.id]);
    });
  });

  group('artifacts', () {
    test('version auto-increments per kind', () async {
      final project = await store.createProject(
        const core.CreateProjectRequest(name: 'A', slug: 'a'),
      );
      final task = await store.createTask(
        project.id,
        const core.CreateTaskRequest(title: 'T'),
      );

      final v1 = await store.createArtifact(
        task.id,
        const core.CreateArtifactRequest(
          kind: core.ArtifactKind.diagram,
          uri: 'file://v1.mmd',
        ),
      );
      final v2 = await store.createArtifact(
        task.id,
        const core.CreateArtifactRequest(
          kind: core.ArtifactKind.diagram,
          uri: 'file://v2.mmd',
        ),
      );
      final otherKind = await store.createArtifact(
        task.id,
        const core.CreateArtifactRequest(
          kind: core.ArtifactKind.pr,
          uri: 'https://pr/1',
        ),
      );

      expect(v1.version, 1);
      expect(v2.version, 2);
      expect(otherKind.version, 1);
      expect(await store.listArtifacts(task.id), hasLength(3));
    });

    test('createArtifact on an unknown task throws', () async {
      expect(
        () => store.createArtifact(
          'nope',
          const core.CreateArtifactRequest(
            kind: core.ArtifactKind.pr,
            uri: 'https://pr/1',
          ),
        ),
        throwsA(isA<TaskNotFound>()),
      );
    });
  });
}
