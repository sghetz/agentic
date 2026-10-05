import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerTaskEventsRoutes(Router router, AppContext ctx) {
  router.get('/orgs/<orgId>/tasks/<taskId>/events', (
    Request request,
    String orgId,
    String taskId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      if (await store.getTask(taskId) == null) {
        return notFoundResponse('Task $taskId not found');
      }

      final events = await store.listTaskEvents(taskId);
      return jsonResponse(events.map((e) => e.toJson()).toList());
    });
  });

  router.post('/orgs/<orgId>/tasks/<taskId>/events', (
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
      final created = await store.appendTaskEvent(
        taskId,
        core.CreateTaskEventRequest.fromJson(body),
      );
      return jsonResponse(created.toJson(), status: 201);
    });
  });
}
