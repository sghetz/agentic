import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerDashboardRoutes(Router router, AppContext ctx) {
  router.get('/dashboard', (Request request) {
    return guarded(() async {
      final orgs = await ctx.registryStore.list();
      final summaries = <core.DashboardOrgSummary>[];

      for (final org in orgs) {
        final store = await ctx.orgStore(org.id);
        if (store == null) continue; // org vanished between list() and here

        final tasks = await store.listAllTasks();
        final counts = <core.TaskStatus, int>{};
        for (final task in tasks) {
          counts[task.currentStatus] = (counts[task.currentStatus] ?? 0) + 1;
        }

        final recentActivity = <core.RecentActivityItem>[];
        for (final event in await store.listRecentEvents(limit: 10)) {
          final task = await store.getTask(event.taskId);
          if (task == null) continue;
          final project = await store.getProject(task.projectId);
          if (project == null) continue;
          recentActivity.add(
            core.RecentActivityItem(
              taskId: task.id,
              taskTitle: task.title,
              projectId: project.id,
              projectName: project.name,
              ts: event.ts,
              actor: event.actor,
              eventType: event.eventType,
            ),
          );
        }

        summaries.add(
          core.DashboardOrgSummary(
            orgId: org.id,
            orgName: org.name,
            taskCountsByStatus: counts,
            recentActivity: recentActivity,
          ),
        );
      }

      return jsonResponse(core.DashboardSummary(orgs: summaries).toJson());
    });
  });
}
