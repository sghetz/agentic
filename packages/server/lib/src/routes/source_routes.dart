import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerSourceRoutes(Router router, AppContext ctx) {
  router.post('/orgs/<orgId>/sources', (Request request, String orgId) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final body = await readJsonBody(request);
      final source = await store.createSource(
        core.CreateSourceRequest.fromJson(body),
      );
      return jsonResponse(source.toJson(), status: 201);
    });
  });

  router.get('/orgs/<orgId>/sources', (Request request, String orgId) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final projectId = request.url.queryParameters['projectId'];
      final sources = await store.listSources(projectId: projectId);
      return jsonResponse(sources.map((s) => s.toJson()).toList());
    });
  });

  router.get('/orgs/<orgId>/sources/<sourceId>/messages', (
    Request request,
    String orgId,
    String sourceId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      if (await store.getSource(sourceId) == null) {
        return notFoundResponse('Source $sourceId not found');
      }

      final messages = await store.listMessages(sourceId: sourceId);
      return jsonResponse(messages.map((m) => m.toJson()).toList());
    });
  });

  router.post('/orgs/<orgId>/sources/<sourceId>/scan', (
    Request request,
    String orgId,
    String sourceId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      final source = await store.getSource(sourceId);
      if (source == null) {
        return notFoundResponse('Source $sourceId not found');
      }
      if (source.kind != core.SourceKind.erf) {
        return badRequestResponse(
          'Only erf sources can be scanned so far (got ${source.kind.name})',
        );
      }

      try {
        final result = await ctx.erfImportService.scan(
          source: source,
          store: store,
        );
        return jsonResponse({
          'newMessages': result.newMessages,
          'specsCreated': result.specsCreated,
          'failedFiles': result.failedFiles,
        });
      } on ArgumentError catch (e) {
        return badRequestResponse(e.message as String);
      }
    });
  });
}
