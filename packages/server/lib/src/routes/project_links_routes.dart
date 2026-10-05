import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerProjectLinksRoutes(Router router, AppContext ctx) {
  router.get('/orgs/<orgId>/projects/<projectId>/links', (
    Request request,
    String orgId,
    String projectId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final links = await store.listProjectLinks(projectId);
      return jsonResponse(links.map((l) => l.toJson()).toList());
    });
  });

  router.post('/orgs/<orgId>/projects/<projectId>/links', (
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
      final created = await store.createProjectLink(
        projectId,
        core.CreateProjectLinkRequest.fromJson(body),
      );
      return jsonResponse(created.toJson(), status: 201);
    });
  });

  router.delete('/orgs/<orgId>/projects/<projectId>/links/<linkId>', (
    Request request,
    String orgId,
    String projectId,
    String linkId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      await store.deleteProjectLink(projectId, linkId);
      return Response(204);
    });
  });
}
