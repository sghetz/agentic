import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import 'app_context.dart';
import 'routes/artifacts_routes.dart';
import 'routes/conversations_routes.dart';
import 'routes/dashboard_routes.dart';
import 'routes/health_check_routes.dart';
import 'routes/health_routes.dart';
import 'routes/orgs_routes.dart';
import 'routes/project_links_routes.dart';
import 'routes/projects_routes.dart';
import 'routes/source_routes.dart';
import 'routes/task_events_routes.dart';
import 'routes/task_spec_routes.dart';
import 'routes/tasks_routes.dart';

Router buildRouter(AppContext ctx) {
  final router = Router();

  registerHealthRoutes(router);
  registerOrgsRoutes(router, ctx);
  registerProjectsRoutes(router, ctx);
  registerProjectLinksRoutes(router, ctx);
  registerTasksRoutes(router, ctx);
  registerTaskEventsRoutes(router, ctx);
  registerArtifactsRoutes(router, ctx);
  registerDashboardRoutes(router, ctx);
  registerHealthCheckRoutes(router, ctx);
  registerConversationsRoutes(router, ctx);
  registerTaskSpecRoutes(router, ctx);
  registerSourceRoutes(router, ctx);

  return router;
}

Handler buildHandler(AppContext ctx) {
  return const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(buildRouter(ctx).call);
}

/// Binds to 127.0.0.1 only -- this is a personal, local-only backend.
Future<void> serve(AppContext ctx, {int port = 8787}) async {
  final server = await shelf_io.serve(buildHandler(ctx), '127.0.0.1', port);
  // ignore: avoid_print
  print(
    'Agentic server listening on http://${server.address.host}:${server.port}',
  );
}
