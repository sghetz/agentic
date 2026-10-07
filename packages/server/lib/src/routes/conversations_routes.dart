import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

import '../app_context.dart';
import '../http_utils.dart';
import '../services/claude_conversation_service.dart';

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
      final conversation = await store.getConversation(conversationId);
      if (conversation == null) {
        return notFoundResponse('Conversation $conversationId not found');
      }

      final body = await readJsonBody(request);
      final created = await store.postChatMessage(
        conversationId,
        core.CreateChatMessageRequest.fromJson(body),
      );

      // Only Health's project-scoped channel is wired to a real agent turn
      // so far (Phase 2 slice 2); the rest follow in a later slice.
      final channel = conversation.channel;
      final projectId = conversation.projectId;
      if (channel is core.ChatChannelAgent &&
          channel.role == 'health' &&
          projectId != null) {
        final org = await ctx.registryStore.get(orgId);
        final project = await store.getProject(projectId);
        if (org != null && project != null) {
          ClaudeStreamResult? result;
          final stream = ctx.conversationService.replyStream(
            role: 'health',
            userMessage: created.content,
            workingDirectory: ctx.paths.repoPath(org.slug, project.slug),
            existingSessionId: conversation.claudeSessionId,
          );
          await for (final event in stream) {
            switch (event) {
              case ClaudeStreamTextDelta(text: final text):
                ctx.chatStreamHub.publish(conversationId, {
                  'type': 'delta',
                  'text': text,
                });
              case ClaudeStreamResult():
                result = event;
            }
          }

          if (result != null) {
            final agentMessage = await store.postAgentChatMessage(
              conversationId,
              role: 'health',
              content: result.content,
            );
            if (conversation.claudeSessionId == null) {
              await store.setConversationSessionId(
                conversationId,
                result.sessionId,
              );
            }
            ctx.chatStreamHub.publish(conversationId, {
              'type': 'done',
              'message': agentMessage.toJson(),
            });
          } else {
            ctx.chatStreamHub.publish(conversationId, {
              'type': 'done',
              'message': null,
            });
          }
        }
      }

      return jsonResponse(created.toJson(), status: 201);
    });
  });

  router.get('/orgs/<orgId>/conversations/<conversationId>/stream', (
    Request request,
    String orgId,
    String conversationId,
  ) {
    final handler = webSocketHandler((channel, protocol) {
      ctx.chatStreamHub.subscribe(conversationId, channel);
    });
    return handler(request);
  });
}
