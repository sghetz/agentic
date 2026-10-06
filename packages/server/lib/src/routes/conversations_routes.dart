import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerConversationsRoutes(Router router, AppContext ctx) {
  // Channels are a fixed set the app already knows about (General + one per
  // agent role), so "fetch the conversation for this scope" doubles as
  // "create it if this is the first time" -- there's no separate create step.
  router.get('/orgs/<orgId>/conversations', (Request request, String orgId) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final channelParam = request.url.queryParameters['channel'];
      if (channelParam == null) {
        return badRequestResponse('channel query parameter is required');
      }
      final projectId = request.url.queryParameters['projectId'];

      final conversation = await store.getOrCreateConversation(
        projectId: projectId,
        channel: core.ChatChannel.parse(channelParam),
      );
      return jsonResponse(conversation.toJson());
    });
  });

  router.get('/orgs/<orgId>/conversations/<conversationId>/messages', (
    Request request,
    String orgId,
    String conversationId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      if (await store.getConversation(conversationId) == null) {
        return notFoundResponse('Conversation $conversationId not found');
      }

      final messages = await store.listChatMessages(conversationId);
      return jsonResponse(messages.map((m) => m.toJson()).toList());
    });
  });

  router.post('/orgs/<orgId>/conversations/<conversationId>/messages', (
    Request request,
    String orgId,
    String conversationId,
  ) {
    return guarded(() async {
      final store = await ctx.orgStore(orgId);
      if (store == null) {
        return notFoundResponse('Organization $orgId not found');
      }

      final body = await readJsonBody(request);
      final created = await store.postChatMessage(
        conversationId,
        core.CreateChatMessageRequest.fromJson(body),
      );
      return jsonResponse(created.toJson(), status: 201);
    });
  });
}
