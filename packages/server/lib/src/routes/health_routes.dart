import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../http_utils.dart';

void registerHealthRoutes(Router router) {
  router.get('/health', (Request request) => jsonResponse({'status': 'ok'}));
}
