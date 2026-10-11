import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerSystemCheckRoutes(Router router, AppContext ctx) {
  router.get('/system/check', (Request request) {
    return guarded(() async {
      final results = await ctx.systemCheckService.checkAll();
      return jsonResponse(results.map((r) => r.toJson()).toList());
    });
  });
}
