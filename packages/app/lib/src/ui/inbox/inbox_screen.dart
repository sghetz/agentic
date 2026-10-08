import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client.dart';
import '../../api/api_client_provider.dart';
import '../../state/inbox_providers.dart';
import '../../state/org_providers.dart';
import '../../state/project_providers.dart';
import '../common/empty_state.dart';
import '../common/error_state.dart';
import '../common/loading_state.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgId = ref.watch(selectedOrgIdProvider);
    if (orgId == null) {
      return const EmptyState(message: 'Select an organization');
    }

    final messagesAsync = ref.watch(unroutedMessagesProvider(orgId));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Unrouted messages',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              FilledButton.icon(
                icon: const Icon(Icons.upload_outlined),
                label: const Text('Import WhatsApp chat...'),
                onPressed: () => _showImportDialog(context, ref, orgId),
              ),
            ],
          ),
        ),
        Expanded(
          child: messagesAsync.when(
            data: (messages) {
              if (messages.isEmpty) {
                return const EmptyState(
                  message: 'Nothing waiting on routing right now.',
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) => _UnroutedMessageTile(
                  orgId: orgId,
                  message: messages[index],
                ),
              );
            },
            loading: () => const LoadingState(),
            error: (error, _) => ErrorState(
              message: 'Could not load unrouted messages',
              onRetry: () => ref.invalidate(unroutedMessagesProvider(orgId)),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showImportDialog(
    BuildContext context,
    WidgetRef ref,
    String orgId,
  ) async {
    final controller = TextEditingController();
    final shouldImport = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Import WhatsApp chat'),
        content: SizedBox(
          width: 480,
          child: TextField(
            controller: controller,
            maxLines: 10,
            decoration: const InputDecoration(
              hintText: 'Paste the exported chat text here...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Import'),
          ),
        ],
      ),
    );

    if (shouldImport != true || controller.text.trim().isEmpty) return;
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      final client = ref.read(apiClientProvider);
      final source = await _sharedWhatsAppSource(client, orgId);
      final result = await client.importWhatsApp(
        orgId,
        source.id,
        controller.text,
      );
      ref.invalidate(unroutedMessagesProvider(orgId));
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Imported ${result['newMessages']} message(s): '
            '${result['routedMessages']} auto-routed, '
            '${result['unroutedMessages']} need a project, '
            '${result['specsCreated']} Task Spec(s) drafted.',
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Import failed: $e')));
    }
  }

  /// One shared org-level WhatsApp source backs every import from this
  /// screen -- simplest mental model for an "Inbox" (every pasted chat
  /// funnels into the same unrouted pool), and keeps re-pasting a growing
  /// export idempotent instead of re-importing everything under a fresh
  /// source each time.
  Future<core.Source> _sharedWhatsAppSource(
    ApiClient client,
    String orgId,
  ) async {
    final sources = await client.listSources(orgId);
    for (final source in sources) {
      if (source.kind == core.SourceKind.whatsappImport &&
          source.projectId == null) {
        return source;
      }
    }
    return client.createSource(
      orgId,
      const core.CreateSourceRequest(kind: core.SourceKind.whatsappImport),
    );
  }
}

class _UnroutedMessageTile extends ConsumerStatefulWidget {
  const _UnroutedMessageTile({required this.orgId, required this.message});

  final String orgId;
  final core.Message message;

  @override
  ConsumerState<_UnroutedMessageTile> createState() =>
      _UnroutedMessageTileState();
}

class _UnroutedMessageTileState extends ConsumerState<_UnroutedMessageTile> {
  String? _selectedProjectId;
  bool _assigning = false;

  @override
  Widget build(BuildContext context) {
    final orgId = widget.orgId;
    final projectsAsync = ref.watch(projectListProvider(orgId));

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.message.author ?? 'Unknown',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(widget.message.body),
            if (widget.message.routingConfidence != null) ...[
              const SizedBox(height: 4),
              Text(
                'Routing confidence: '
                '${(widget.message.routingConfidence! * 100).round()}%',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: projectsAsync.when(
                    data: (projects) => DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Assign to project...'),
                      value: _selectedProjectId,
                      items: [
                        for (final project in projects)
                          DropdownMenuItem(
                            value: project.id,
                            child: Text(project.name),
                          ),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedProjectId = value),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: const Key('assignButton'),
                  onPressed: _selectedProjectId == null || _assigning
                      ? null
                      : _assign,
                  child: const Text('Assign'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _assign() async {
    final projectId = _selectedProjectId;
    if (projectId == null) return;

    setState(() => _assigning = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(apiClientProvider)
          .assignMessageProject(widget.orgId, widget.message.id, projectId);
      ref.invalidate(unroutedMessagesProvider(widget.orgId));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Assign failed: $e')));
      if (mounted) setState(() => _assigning = false);
    }
  }
}
