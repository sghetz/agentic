import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerDeveloperRoutes(Router router, AppContext ctx) {
  router.post('/orgs/<orgId>/projects/<projectId>/tasks/<taskId>/develop', (
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

      final body = await readJsonBody(request);
      final taskSpecArtifactId = body['taskSpecArtifactId'] as String?;
      if (taskSpecArtifactId == null) {
        return badRequestResponse('taskSpecArtifactId is required');
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
      final designSpecArtifactId = body['designSpecArtifactId'] as String?;
      if (designSpecArtifactId != null) {
        final designSpecArtifacts = await store.listProjectArtifacts(
          projectId,
          kind: core.ArtifactKind.designSpec,
        );
        final designSpecArtifact = designSpecArtifacts
            .where((a) => a.id == designSpecArtifactId)
            .firstOrNull;
        if (designSpecArtifact == null) {
          return notFoundResponse(
            'Design Spec $designSpecArtifactId not found',
          );
        }
        designSpec = core.DesignSpec.fromJson(
          jsonDecode(designSpecArtifact.content!) as Map<String, Object?>,
        );
      }

      // Already inDevelopment means this is a retry continuing the same
      // worktree -- no new transition to record. Any other starting status
      // that can't reach inDevelopment throws InvalidTaskTransition, which
      // `guarded()` turns into a 409 listing the allowed transitions.
      if (task.currentStatus != core.TaskStatus.inDevelopment) {
        await store.appendTaskEvent(
          taskId,
          const core.CreateTaskEventRequest(
            actor: core.Actor.agent('developer'),
            eventType: core.TaskEventType.statusChanged,
            payload: {'to': 'inDevelopment'},
          ),
        );
      }
      await store.appendTaskEvent(
        taskId,
        core.CreateTaskEventRequest(
          actor: const core.Actor.agent('developer'),
          eventType: core.TaskEventType.artifactAttached,
          payload: {'artifactId': taskSpecArtifactId, 'kind': 'taskSpec'},
        ),
      );
      if (designSpecArtifactId != null) {
        await store.appendTaskEvent(
          taskId,
          core.CreateTaskEventRequest(
            actor: const core.Actor.agent('developer'),
            eventType: core.TaskEventType.artifactAttached,
            payload: {'artifactId': designSpecArtifactId, 'kind': 'designSpec'},
          ),
        );
      }

      final result = await ctx.developerService.develop(
        orgSlug: org.slug,
        project: project,
        task: task,
        taskSpec: taskSpec,
        designSpec: designSpec,
      );

      core.Artifact? prArtifact;
      if (result.outcome == core.DeveloperOutcome.prOpened &&
          result.pullRequest != null) {
        prArtifact = await store.createArtifact(
          taskId,
          core.CreateArtifactRequest(
            kind: core.ArtifactKind.pr,
            uri: result.pullRequest!.url,
            content: jsonEncode(result.pullRequest!.toJson()),
          ),
        );
        await store.appendTaskEvent(
          taskId,
          core.CreateTaskEventRequest(
            actor: const core.Actor.agent('developer'),
            eventType: core.TaskEventType.artifactAttached,
            payload: {'artifactId': prArtifact.id, 'kind': 'pr'},
          ),
        );
        await store.appendTaskEvent(
          taskId,
          const core.CreateTaskEventRequest(
            actor: core.Actor.agent('developer'),
            eventType: core.TaskEventType.statusChanged,
            payload: {'to': 'inReview'},
          ),
        );
      }

      return jsonResponse({
        'result': result.toJson(),
        if (prArtifact != null) 'pr': prArtifact.toJson(),
      });
    });
  });
}
