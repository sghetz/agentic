import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerOrgsRoutes(Router router, AppContext ctx) {
  router.get('/orgs', (Request request) {
    return guarded(() async {
      final orgs = await ctx.registryStore.list();
      return jsonResponse(orgs.map((o) => o.toJson()).toList());
    });
  });

  router.post('/orgs', (Request request) {
    return guarded(() async {
      final body = await readJsonBody(request);
      final created = await ctx.registryStore.create(
        core.CreateOrganizationRequest.fromJson(body),
      );
      return jsonResponse(created.toJson(), status: 201);
    });
  });

  router.get('/orgs/<orgId>', (Request request, String orgId) {
    return guarded(() async {
      final org = await ctx.registryStore.get(orgId);
      if (org == null) return notFoundResponse('Organization $orgId not found');
      return jsonResponse(org.toJson());
    });
  });

  router.patch('/orgs/<orgId>', (Request request, String orgId) {
    return guarded(() async {
      final body = await readJsonBody(request);
      final updated = await ctx.registryStore.update(
        orgId,
        core.UpdateOrganizationRequest.fromJson(body),
      );
      return jsonResponse(updated.toJson());
    });
  });
}
