import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerHealthCheckRoutes(Router router, AppContext ctx) {
  router.post('/orgs/<orgId>/projects/<projectId>/health-check', (
    Request request,
    String orgId,
    String projectId,
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

      final artifact = await ctx.healthCheckService.check(
        orgSlug: org.slug,
        project: project,
        orgStore: store,
      );
      return jsonResponse(artifact.toJson(), status: 201);
    });
  });

  router.post('/orgs/<orgId>/health-check', (Request request, String orgId) {
    return guarded(() async {
      final org = await ctx.registryStore.get(orgId);
      if (org == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final projects = await store.listProjects();
      final artifacts = <core.Artifact>[];
      for (final project in projects) {
        if (project.repos.isEmpty) {
          continue; // nothing to check; skip silently in a bulk run
        }
        artifacts.add(
          await ctx.healthCheckService.check(
            orgSlug: org.slug,
            project: project,
            orgStore: store,
          ),
        );
      }
      return jsonResponse(artifacts.map((a) => a.toJson()).toList());
    });
  });

  router.get('/orgs/<orgId>/projects/<projectId>/health-reports', (
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
      final reports = await store.listProjectArtifacts(
        projectId,
        kind: core.ArtifactKind.healthReport,
        limit: limitParam == null ? null : int.tryParse(limitParam),
      );
      return jsonResponse(reports.map((a) => a.toJson()).toList());
    });
  });
}
