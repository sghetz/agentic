import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerProjectsRoutes(Router router, AppContext ctx) {
  router.get('/orgs/<orgId>/projects', (Request request, String orgId) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final includeArchived =
          request.url.queryParameters['includeArchived'] == 'true';
      final projects = await store.listProjects(
        includeArchived: includeArchived,
      );
      return jsonResponse(projects.map((p) => p.toJson()).toList());
    });
  });

  router.post('/orgs/<orgId>/projects', (Request request, String orgId) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final body = await readJsonBody(request);
      final created = await store.createProject(
        core.CreateProjectRequest.fromJson(body),
      );
      return jsonResponse(created.toJson(), status: 201);
    });
  });

  router.get('/orgs/<orgId>/projects/<projectId>', (
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
      return jsonResponse(project.toJson());
    });
  });

  router.patch('/orgs/<orgId>/projects/<projectId>', (
    Request request,
    String orgId,
    String projectId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final body = await readJsonBody(request);
      final updated = await store.updateProject(
        projectId,
        core.UpdateProjectRequest.fromJson(body),
      );
      return jsonResponse(updated.toJson());
    });
  });

  router.post('/orgs/<orgId>/projects/<projectId>/archive', (
    Request request,
    String orgId,
    String projectId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final archived = await store.archiveProject(projectId);
      return jsonResponse(archived.toJson());
    });
  });
}
