import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client_provider.dart';
import '../../state/chat_providers.dart';
import '../../state/org_providers.dart';
import '../../state/project_providers.dart';
import '../common/empty_state.dart';
import '../common/error_state.dart';
import '../common/loading_state.dart';

class _ChannelEntry {
  const _ChannelEntry({
    required this.label,
    required this.projectId,
    required this.channel,
  });

  final String label;
  final String? projectId;
  final String channel;
}

List<_ChannelEntry> _channelsFor(String? projectId) => [
  const _ChannelEntry(
    label: 'General (org)',
    projectId: null,
    channel: 'general',
  ),
  if (projectId != null) ...[
    _ChannelEntry(
      label: 'General (project)',
      projectId: projectId,
      channel: 'general',
    ),
    for (final role in agentChannelRoles)
      _ChannelEntry(
        label: role[0].toUpperCase() + role.substring(1),
        projectId: projectId,
        channel: 'agent:$role',
      ),
  ],
];

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  _ChannelEntry? _selected;

  @override
  Widget build(BuildContext context) {
    final orgId = ref.watch(selectedOrgIdProvider);
    if (orgId == null) {
      return const EmptyState(message: 'Select an organization');
    }

    final projectId = ref.watch(selectedProjectIdProvider);
    final channels = _channelsFor(projectId);
    if (_selected == null ||
        !channels.any(
          (c) =>
              c.projectId == _selected!.projectId &&
              c.channel == _selected!.channel,
        )) {
      _selected = channels.first;
    }

    return Row(
      children: [
        SizedBox(
          width: 220,
          child: ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final entry = channels[index];
              return ListTile(
                selected:
                    entry.projectId == _selected!.projectId &&
                    entry.channel == _selected!.channel,
                title: Text(entry.label),
                onTap: () => setState(() => _selected = entry),
              );
            },
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _ChannelThread(
            key: ValueKey('${_selected!.projectId}:${_selected!.channel}'),
            orgId: orgId,
            projectId: _selected!.projectId,
            channel: _selected!.channel,
          ),
        ),
      ],
    );
  }
}

class _ChannelThread extends ConsumerStatefulWidget {
  const _ChannelThread({
    super.key,
    required this.orgId,
    required this.projectId,
    required this.channel,
  });

  final String orgId;
  final String? projectId;
  final String channel;

  @override
  ConsumerState<_ChannelThread> createState() => _ChannelThreadState();
}

class _ChannelThreadState extends ConsumerState<_ChannelThread> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversationAsync = ref.watch(
      conversationProvider(
        widget.orgId,
        projectId: widget.projectId,
        channel: widget.channel,
      ),
    );

    return conversationAsync.when(
      data: (conversation) => _buildThread(context, conversation),
      loading: () => const LoadingState(),
      error: (error, _) => ErrorState(
        message: 'Could not open this channel',
        onRetry: () => ref.invalidate(
          conversationProvider(
            widget.orgId,
            projectId: widget.projectId,
            channel: widget.channel,
          ),
        ),
      ),
    );
  }

  Widget _buildThread(BuildContext context, core.Conversation conversation) {
    final messagesAsync = ref.watch(
      chatMessagesProvider(widget.orgId, conversation.id),
    );

    return Column(
      children: [
        Expanded(
          child: messagesAsync.when(
            data: (messages) {
              if (messages.isEmpty) {
                return const EmptyState(message: 'No messages yet');
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) =>
                    _MessageBubble(message: messages[index]),
              );
            },
            loading: () => const LoadingState(),
            error: (error, _) => ErrorState(
              message: 'Could not load messages',
              onRetry: () => ref.invalidate(
                chatMessagesProvider(widget.orgId, conversation.id),
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('chatInput'),
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Message...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _send(conversation.id),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                key: const Key('sendButton'),
                icon: const Icon(Icons.send),
                onPressed: _sending ? null : () => _send(conversation.id),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _send(String conversationId) async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    setState(() => _sending = true);
    try {
      await ref
          .read(apiClientProvider)
          .postChatMessage(
            widget.orgId,
            conversationId,
            core.CreateChatMessageRequest(content: content),
          );
      _controller.clear();
      ref.invalidate(chatMessagesProvider(widget.orgId, conversationId));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final core.ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == const core.Actor.user();
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message.content),
      ),
    );
  }
}
