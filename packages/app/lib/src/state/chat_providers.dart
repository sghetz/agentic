import 'package:core/core.dart' as core;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/api_client_provider.dart';

part 'chat_providers.g.dart';

/// Agent roles with their own 1:1 channel. The Orchestrator doesn't get a
/// separate entry here -- it owns the `general` channel instead.
const agentChannelRoles = [
  'health',
  'analyst',
  'creative',
  'developer',
  'reviewer',
  'librarian',
];

@riverpod
Future<core.Conversation> conversation(
  Ref ref,
  String orgId, {
  String? projectId,
  required String channel,
}) {
  return ref
      .watch(apiClientProvider)
      .getOrCreateConversation(orgId, projectId: projectId, channel: channel);
}

@riverpod
Future<List<core.ChatMessage>> chatMessages(
  Ref ref,
  String orgId,
  String conversationId,
) {
  return ref.watch(apiClientProvider).listChatMessages(orgId, conversationId);
}
