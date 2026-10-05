import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerArtifactsRoutes(Router router, AppContext ctx) {
  router.get('/orgs/<orgId>/tasks/<taskId>/artifacts', (
    Request request,
    String orgId,
    String taskId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final artifacts = await store.listArtifacts(taskId);
      return jsonResponse(artifacts.map((a) => a.toJson()).toList());
    });
  });

  router.post('/orgs/<orgId>/tasks/<taskId>/artifacts', (
    Request request,
    String orgId,
    String taskId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final body = await readJsonBody(request);
      final created = await store.createArtifact(
        taskId,
        core.CreateArtifactRequest.fromJson(body),
      );
      return jsonResponse(created.toJson(), status: 201);
    });
  });
}
