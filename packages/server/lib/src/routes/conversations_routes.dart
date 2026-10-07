import 'dart:io';

import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

import '../app_context.dart';
import '../http_utils.dart';
import '../repositories/org_store.dart';
import '../services/claude_conversation_service.dart';
import '../services/role_prompts.dart';
import '../services/task_board_mcp_config.dart';

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

      final channel = conversation.channel;
      if (channel is core.ChatChannelAgent) {
        await _runAgentRoleTurn(
          ctx,
          store,
          orgId,
          conversation,
          channel.role,
          created.content,
        );
      } else if (channel is core.ChatChannelGeneral) {
        await _runOrchestratorTurn(
          ctx,
          store,
          orgId,
          conversation,
          created.content,
        );
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

/// Every per-agent channel (Health, Analyst, Creative, Developer, Reviewer,
/// Librarian) runs the same way: a project-scoped, tool-free Q&A turn in
/// that project's own repo. [agentRoleSystemPrompt] returning `null` means
/// that role isn't wired to a real turn yet.
Future<void> _runAgentRoleTurn(
  AppContext ctx,
  OrgStore store,
  String orgId,
  core.Conversation conversation,
  String role,
  String userMessage,
) async {
  final systemPrompt = agentRoleSystemPrompt(role);
  if (systemPrompt == null) return;

  final projectId = conversation.projectId;
  if (projectId == null) return;
  final org = await ctx.registryStore.get(orgId);
  final project = await store.getProject(projectId);
  if (org == null || project == null) return;

  await _runTurn(
    ctx: ctx,
    store: store,
    conversation: conversation,
    senderRole: role,
    userMessage: userMessage,
    systemPrompt: systemPrompt,
    workingDirectory: ctx.paths.repoPath(org.slug, project.slug),
  );
}

Future<void> _runOrchestratorTurn(
  AppContext ctx,
  OrgStore store,
  String orgId,
  core.Conversation conversation,
  String userMessage,
) async {
  final projects = await store.listProjects();
  final currentProject = conversation.projectId == null
      ? null
      : await store.getProject(conversation.projectId!);

  // Orchestrator only ever takes task-board actions, never touches a repo --
  // a neutral, file-free directory so Claude Code's default cwd/git-status/
  // CLAUDE.md context never leaks in (confirmed necessary live in slice 2).
  final scratchDir = ctx.paths.chatScratchDir(orgId);
  await Directory(scratchDir).create(recursive: true);

  await _runTurn(
    ctx: ctx,
    store: store,
    conversation: conversation,
    senderRole: 'orchestrator',
    userMessage: userMessage,
    systemPrompt: orchestratorSystemPrompt(
      projects: projects,
      currentProject: currentProject,
    ),
    workingDirectory: scratchDir,
    mcpConfigJson: taskBoardMcpConfigJson(orgId),
    allowedTools: taskBoardAllowedTools(),
  );
}

/// Runs one Claude Code CLI turn, forwarding deltas to any open WebSocket
/// for this conversation as they arrive, then persisting the full reply
/// (or nothing, if the turn failed) exactly as slice 2/3 established.
Future<void> _runTurn({
  required AppContext ctx,
  required OrgStore store,
  required core.Conversation conversation,
  required String senderRole,
  required String userMessage,
  required String systemPrompt,
  required String workingDirectory,
  String? mcpConfigJson,
  List<String>? allowedTools,
}) async {
  final conversationId = conversation.id;
  ClaudeStreamResult? result;
  final stream = ctx.conversationService.replyStream(
    systemPrompt: systemPrompt,
    userMessage: userMessage,
    workingDirectory: workingDirectory,
    existingSessionId: conversation.claudeSessionId,
    mcpConfigJson: mcpConfigJson,
    allowedTools: allowedTools,
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
      role: senderRole,
      content: result.content,
    );
    if (conversation.claudeSessionId == null) {
      await store.setConversationSessionId(conversationId, result.sessionId);
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
