import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';
import '../repositories/org_store.dart';

/// The artifact id most recently attached to [taskId] under [kind] (e.g.
/// `taskSpec`), per the `artifactAttached` events `develop()` records --
/// lets `review()` reuse whatever Task Spec/Design Spec Developer was
/// given without the owner re-picking it.
Future<String?> _latestAttachedArtifactId(
  OrgStore store,
  String taskId,
  String kind,
) async {
  final events = await store.listTaskEvents(taskId);
  for (final event in events.reversed) {
    if (event.eventType == core.TaskEventType.artifactAttached &&
        event.payload['kind'] == kind) {
      return event.payload['artifactId'] as String?;
    }
  }
  return null;
}

Future<core.Artifact?> _latestArtifact(
  OrgStore store,
  String taskId,
  core.ArtifactKind kind,
) async {
  final artifacts = (await store.listArtifacts(
    taskId,
  )).where((a) => a.kind == kind).toList();
  if (artifacts.isEmpty) return null;
  artifacts.sort((a, b) => b.version.compareTo(a.version));
  return artifacts.first;
}

void registerReviewerRoutes(Router router, AppContext ctx) {
  router.post('/orgs/<orgId>/projects/<projectId>/tasks/<taskId>/review', (
    Request request,
    String orgId,
    String projectId,
    String taskId,
  ) {
    return guarded(() async {
      final org = await ctx.registryStore.get(orgId);
      if (org == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      final project = await store.getProject(projectId);
      if (project == null) {
        return notFoundResponse('Project $projectId not found');
      }
      final task = await store.getTask(taskId);
      if (task == null || task.projectId != projectId) {
        return notFoundResponse('Task $taskId not found');
      }
      if (task.currentStatus != core.TaskStatus.inReview) {
        return badRequestResponse(
          'Task is not currently in review (status: ${task.currentStatus.name})',
        );
      }

      final taskSpecArtifactId = await _latestAttachedArtifactId(
        store,
        taskId,
        'taskSpec',
      );
      if (taskSpecArtifactId == null) {
        return badRequestResponse(
          'No Task Spec was attached to this task -- run develop first',
        );
      }
      final taskSpecArtifacts = await store.listProjectArtifacts(
        projectId,
        kind: core.ArtifactKind.taskSpec,
      );
      final taskSpecArtifact = taskSpecArtifacts
          .where((a) => a.id == taskSpecArtifactId)
          .firstOrNull;
      if (taskSpecArtifact == null) {
        return notFoundResponse('Task Spec $taskSpecArtifactId not found');
      }
      final taskSpec = core.TaskSpec.fromJson(
        jsonDecode(taskSpecArtifact.content!) as Map<String, Object?>,
      );

      core.DesignSpec? designSpec;
      final designSpecArtifactId = await _latestAttachedArtifactId(
        store,
        taskId,
        'designSpec',
      );
      if (designSpecArtifactId != null) {
        final designSpecArtifacts = await store.listProjectArtifacts(
          projectId,
          kind: core.ArtifactKind.designSpec,
        );
        final designSpecArtifact = designSpecArtifacts
            .where((a) => a.id == designSpecArtifactId)
            .firstOrNull;
        if (designSpecArtifact != null) {
          designSpec = core.DesignSpec.fromJson(
            jsonDecode(designSpecArtifact.content!) as Map<String, Object?>,
          );
        }
      }

      final report = await ctx.reviewService.review(
        orgSlug: org.slug,
        project: project,
        task: task,
        taskSpec: taskSpec,
        designSpec: designSpec,
      );
      if (report == null) {
        return upstreamErrorResponse('Review failed');
      }

      final reviewArtifact = await store.createArtifact(
        taskId,
        core.CreateArtifactRequest(
          kind: core.ArtifactKind.review,
          uri: 'review:$taskId:${DateTime.now().toUtc().toIso8601String()}',
          content: jsonEncode(report.toJson()),
        ),
      );
      await store.appendTaskEvent(
        taskId,
        core.CreateTaskEventRequest(
          actor: const core.Actor.agent('reviewer'),
          eventType: core.TaskEventType.artifactAttached,
          payload: {'artifactId': reviewArtifact.id, 'kind': 'review'},
        ),
      );
      await store.appendTaskEvent(
        taskId,
        const core.CreateTaskEventRequest(
          actor: core.Actor.agent('reviewer'),
          eventType: core.TaskEventType.statusChanged,
          payload: {'to': 'awaitingApproval'},
        ),
      );

      return jsonResponse({'review': reviewArtifact.toJson()});
    });
  });

  router.get('/orgs/<orgId>/projects/<projectId>/tasks/<taskId>/pr-checks', (
    Request request,
    String orgId,
    String projectId,
    String taskId,
  ) {
    return guarded(() async {
      final org = await ctx.registryStore.get(orgId);
      if (org == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      final project = await store.getProject(projectId);
      if (project == null) {
        return notFoundResponse('Project $projectId not found');
      }
      final task = await store.getTask(taskId);
      if (task == null || task.projectId != projectId) {
        return notFoundResponse('Task $taskId not found');
      }

      final prArtifact = await _latestArtifact(
        store,
        taskId,
        core.ArtifactKind.pr,
      );
      if (prArtifact == null) {
        return badRequestResponse('No PR exists for this task yet');
      }
      final pr = core.PullRequestInfo.fromJson(
        jsonDecode(prArtifact.content!) as Map<String, Object?>,
      );

      final checks = await ctx.githubService.getChecks(
        workingDirectory: ctx.paths.repoPath(org.slug, project.slug),
        prNumber: pr.number,
      );
      return jsonResponse(checks.map((c) => c.toJson()).toList());
    });
  });

  router.post('/orgs/<orgId>/projects/<projectId>/tasks/<taskId>/approve', (
    Request request,
    String orgId,
    String projectId,
    String taskId,
  ) {
    return guarded(() async {
      final org = await ctx.registryStore.get(orgId);
      if (org == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      final project = await store.getProject(projectId);
      if (project == null) {
        return notFoundResponse('Project $projectId not found');
      }
      final task = await store.getTask(taskId);
      if (task == null || task.projectId != projectId) {
        return notFoundResponse('Task $taskId not found');
      }
      if (task.currentStatus != core.TaskStatus.awaitingApproval) {
        return badRequestResponse(
          'Task is not awaiting approval (status: ${task.currentStatus.name})',
        );
      }

      final prArtifact = await _latestArtifact(
        store,
        taskId,
        core.ArtifactKind.pr,
      );
      if (prArtifact == null) {
        return badRequestResponse('No PR exists for this task yet');
      }
      final pr = core.PullRequestInfo.fromJson(
        jsonDecode(prArtifact.content!) as Map<String, Object?>,
      );

      final repoPath = ctx.paths.repoPath(org.slug, project.slug);
      await ctx.githubService.mergePr(
        workingDirectory: repoPath,
        prNumber: pr.number,
      );

      // This POST *is* the explicit human approval event rule 3 requires --
      // recorded as the owner, not an agent, since approving (not merging
      // itself) is the human decision being captured.
      await store.appendTaskEvent(
        taskId,
        const core.CreateTaskEventRequest(
          actor: core.Actor.user(),
          eventType: core.TaskEventType.statusChanged,
          payload: {'to': 'done'},
        ),
      );

      final worktreePath = ctx.paths.worktreePath(
        org.slug,
        project.slug,
        taskId,
      );
      await ctx.gitService.removeWorktree(
        repoPath: repoPath,
        worktreePath: worktreePath,
        branchName: pr.branch,
      );

      return jsonResponse({'status': 'merged'});
    });
  });
}
