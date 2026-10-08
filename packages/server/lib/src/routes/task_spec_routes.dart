import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerTaskSpecRoutes(Router router, AppContext ctx) {
  // No sources/messages model yet (that's slice 2) -- this lets the
  // extraction service be built and tested in isolation first.
  router.post('/orgs/<orgId>/projects/<projectId>/task-specs/extract', (
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

      final body = await readJsonBody(request);
      final rawText = body['rawText'] as String?;
      if (rawText == null || rawText.trim().isEmpty) {
        return badRequestResponse('rawText is required');
      }

      final spec = await ctx.analystExtractionService.extract(
        projectId: projectId,
        rawText: rawText,
      );
      if (spec == null) {
        return upstreamErrorResponse('Task Spec extraction failed');
      }

      final artifact = await store.createProjectArtifact(
        projectId,
        kind: core.ArtifactKind.taskSpec,
        uri: 'task-spec:$projectId:${DateTime.now().toUtc().toIso8601String()}',
        content: jsonEncode(spec.toJson()),
      );
      return jsonResponse(artifact.toJson(), status: 201);
    });
  });

  router.get('/orgs/<orgId>/projects/<projectId>/task-specs', (
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

      final limitParam = request.url.queryParameters['limit'];
      final specs = await store.listProjectArtifacts(
        projectId,
        kind: core.ArtifactKind.taskSpec,
        limit: limitParam == null ? null : int.tryParse(limitParam),
      );
      return jsonResponse(specs.map((a) => a.toJson()).toList());
    });
  });
}
