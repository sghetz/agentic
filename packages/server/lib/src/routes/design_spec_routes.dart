import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerDesignSpecRoutes(Router router, AppContext ctx) {
  router.post('/orgs/<orgId>/projects/<projectId>/design-specs/generate', (
    Request request,
    String orgId,
    String projectId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      final project = await store.getProject(projectId);
      if (project == null) {
        return notFoundResponse('Project $projectId not found');
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

      final result = await ctx.creativeExtractionService.generate(
        projectId: projectId,
        taskSpec: taskSpec,
        designSystemRef: project.designSystemRef,
      );
      if (result == null) {
        return upstreamErrorResponse('Design Spec generation failed');
      }

      final now = DateTime.now().toUtc().toIso8601String();
      final designSpecArtifact = await store.createProjectArtifact(
        projectId,
        kind: core.ArtifactKind.designSpec,
        uri: 'design-spec:$projectId:$now',
        content: jsonEncode(
          result.designSpec
              .copyWith(sourceTaskSpecArtifactId: taskSpecArtifactId)
              .toJson(),
        ),
      );
      final diagramArtifact = await store.createProjectArtifact(
        projectId,
        kind: core.ArtifactKind.diagram,
        uri: 'diagram:$projectId:$now',
        content: result.mermaid,
      );

      return jsonResponse({
        'designSpec': designSpecArtifact.toJson(),
        'diagram': diagramArtifact.toJson(),
      }, status: 201);
    });
  });

  router.get('/orgs/<orgId>/projects/<projectId>/design-specs', (
    Request request,
    String orgId,
    String projectId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      if (await store.getProject(projectId) == null) {
        return notFoundResponse('Project $projectId not found');
      }

      final specs = await store.listProjectArtifacts(
        projectId,
        kind: core.ArtifactKind.designSpec,
      );
      return jsonResponse(specs.map((a) => a.toJson()).toList());
    });
  });

  router.get('/orgs/<orgId>/projects/<projectId>/diagrams', (
    Request request,
    String orgId,
    String projectId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      if (await store.getProject(projectId) == null) {
        return notFoundResponse('Project $projectId not found');
      }

      final diagrams = await store.listProjectArtifacts(
        projectId,
        kind: core.ArtifactKind.diagram,
      );
      return jsonResponse(diagrams.map((a) => a.toJson()).toList());
    });
  });
}
