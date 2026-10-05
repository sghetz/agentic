import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerTasksRoutes(Router router, AppContext ctx) {
  router.get('/orgs/<orgId>/projects/<projectId>/tasks', (
    Request request,
    String orgId,
    String projectId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final params = request.url.queryParameters;
      final statusParam = params['status'];
      core.TaskStatus? status;
      if (statusParam != null) {
        try {
          status = core.TaskStatus.values.byName(statusParam);
        } on ArgumentError {
          return badRequestResponse('Unknown task status "$statusParam"');
        }
      }

      final tasks = await store.listTasks(
        projectId,
        status: status,
        from: params['from'] == null ? null : DateTime.parse(params['from']!),
        to: params['to'] == null ? null : DateTime.parse(params['to']!),
        query: params['q'],
      );
      return jsonResponse(tasks.map((t) => t.toJson()).toList());
    });
  });

  router.post('/orgs/<orgId>/projects/<projectId>/tasks', (
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
      final created = await store.createTask(
        projectId,
        core.CreateTaskRequest.fromJson(body),
      );
      return jsonResponse(created.toJson(), status: 201);
    });
  });

  router.get('/orgs/<orgId>/tasks/<taskId>', (
    Request request,
    String orgId,
    String taskId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final at = request.url.queryParameters['at'];
      final task = await store.getTask(
        taskId,
        at: at == null ? null : DateTime.parse(at),
      );
      if (task == null) return notFoundResponse('Task $taskId not found');
      return jsonResponse(task.toJson());
    });
  });
}
