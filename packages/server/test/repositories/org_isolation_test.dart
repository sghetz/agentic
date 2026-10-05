import 'package:core/core.dart' as core;
import 'package:server/src/repositories/org_store.dart';
import 'package:server/src/storage/org_database.dart';
import 'package:test/test.dart';

/// Proves the non-negotiable rule: "No query, retrieval, or agent context
/// may ever combine data from two organizations." There is no API that
/// takes two org ids, so these tests exercise two independently-opened
/// [OrgStore]s and show one can never see the other's data -- not even by
/// guessing its real IDs.
void main() {
  late OrgDatabase dbA;
  late OrgDatabase dbB;
  late OrgStore storeA;
  late OrgStore storeB;

  setUp(() {
    dbA = OrgDatabase.memory();
    dbB = OrgDatabase.memory();
    storeA = OrgStore('org-a', dbA);
    storeB = OrgStore('org-b', dbB);
  });

  tearDown(() async {
    await dbA.close();
    await dbB.close();
  });

  test(
    'org A cannot read org B\'s project or task, even by guessing their real IDs',
    () async {
      final projectB = await storeB.createProject(
        const core.CreateProjectRequest(name: 'B Project', slug: 'b-project'),
      );
      final taskB = await storeB.createTask(
        projectB.id,
        const core.CreateTaskRequest(title: 'B Task'),
      );

      expect(await storeA.getProject(projectB.id), isNull);
      expect(await storeA.getTask(taskB.id), isNull);
      expect(await storeA.listTaskEvents(taskB.id), isEmpty);
      expect(await storeA.listArtifacts(taskB.id), isEmpty);
    },
  );

  test('org A\'s own data is unaffected by org B existing at all', () async {
    await storeB.createProject(
      const core.CreateProjectRequest(name: 'B', slug: 'b'),
    );

    final projectA = await storeA.createProject(
      const core.CreateProjectRequest(name: 'A', slug: 'a'),
    );

    expect(await storeA.listProjects(), [projectA]);
    expect(await storeB.listProjects(), isNot(contains(projectA)));
  });

  test('a project link can never target a project in another org', () async {
    final projectA = await storeA.createProject(
      const core.CreateProjectRequest(name: 'A', slug: 'a'),
    );
    final projectB = await storeB.createProject(
      const core.CreateProjectRequest(name: 'B', slug: 'b'),
    );

    // storeA resolves toProjectId against its own database only, so
    // org B's real project id is indistinguishable from a typo.
    expect(
      () => storeA.createProjectLink(
        projectA.id,
        core.CreateProjectLinkRequest(
          toProjectId: projectB.id,
          relation: core.LinkRelation.related,
        ),
      ),
      throwsA(isA<CrossOrgLinkRejected>()),
    );
  });

  test(
    'appending an event under org A\'s taskId guess against org B fails closed',
    () async {
      final projectA = await storeA.createProject(
        const core.CreateProjectRequest(name: 'A', slug: 'a'),
      );
      final taskA = await storeA.createTask(
        projectA.id,
        const core.CreateTaskRequest(title: 'T'),
      );

      // Same task id string, asked of org B's store, where it was never created.
      expect(
        () => storeB.appendTaskEvent(
          taskA.id,
          const core.CreateTaskEventRequest(
            actor: core.Actor.user(),
            eventType: core.TaskEventType.statusChanged,
            payload: {'to': 'specified'},
          ),
        ),
        throwsA(isA<TaskNotFound>()),
      );
    },
  );

  test(
    'dashboard-style aggregation reads each org separately without mixing records',
    () async {
      final projectA = await storeA.createProject(
        const core.CreateProjectRequest(name: 'A', slug: 'a'),
      );
      await storeA.createTask(
        projectA.id,
        const core.CreateTaskRequest(title: 'A1'),
      );
      await storeA.createTask(
        projectA.id,
        const core.CreateTaskRequest(title: 'A2'),
      );

      final projectB = await storeB.createProject(
        const core.CreateProjectRequest(name: 'B', slug: 'b'),
      );
      await storeB.createTask(
        projectB.id,
        const core.CreateTaskRequest(title: 'B1'),
      );

      // This is exactly the pattern `GET /dashboard` will use: read each
      // org's store independently and merge in memory, never in a query.
      final tasksA = await storeA.listTasks(projectA.id);
      final tasksB = await storeB.listTasks(projectB.id);

      expect(tasksA.map((t) => t.title).toSet(), {'A1', 'A2'});
      expect(tasksB.map((t) => t.title).toSet(), {'B1'});
    },
  );
}
