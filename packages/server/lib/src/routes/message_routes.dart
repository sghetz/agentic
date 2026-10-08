import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerMessageRoutes(Router router, AppContext ctx) {
  // Org-wide: a message is unrouted when its source needs per-message
  // routing and nothing has assigned it a project yet (confidence was below
  // threshold, or routing failed outright). Project-scoped sources never
  // appear here -- their messages are routed at creation time.
  router.get('/orgs/<orgId>/messages/unrouted', (
    Request request,
    String orgId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final messages = await store.listUnroutedMessages();
      return jsonResponse(messages.map((m) => m.toJson()).toList());
    });
  });

  router.post('/orgs/<orgId>/messages/<messageId>/assign', (
    Request request,
    String orgId,
    String messageId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final body = await readJsonBody(request);
      final projectId = body['projectId'] as String?;
      if (projectId == null) {
        return badRequestResponse('projectId is required');
      }

      final before = await store.getMessage(messageId);
      final message = await store.assignMessageProject(messageId, projectId);

      // Mirrors what auto-routing does once a message has a project: draft
      // a Task Spec from it. Only for a message that hasn't been processed
      // yet -- re-assigning an already-drafted message's project doesn't
      // retroactively redraft anything.
      if (before?.processedAt == null) {
        final spec = await ctx.analystExtractionService.extract(
          projectId: projectId,
          rawText: message.body,
        );
        if (spec != null) {
          await store.createProjectArtifact(
            projectId,
            kind: core.ArtifactKind.taskSpec,
            uri:
                'task-spec:$projectId:${DateTime.now().toUtc().toIso8601String()}',
            content: jsonEncode(
              spec.copyWith(sourceMessageId: message.id).toJson(),
            ),
          );
          await store.markMessageProcessed(message.id);
        }
      }

      return jsonResponse((await store.getMessage(messageId))!.toJson());
    });
  });
}
