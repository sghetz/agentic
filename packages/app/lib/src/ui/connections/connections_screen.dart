import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../../api/api_client_provider.dart';
import '../../state/connector_providers.dart';
import '../../state/org_providers.dart';
import '../common/empty_state.dart';
import '../common/error_state.dart';
import '../common/loading_state.dart';

/// Lets the owner connect a built-in connector (Outlook, Zoom, ...) via its
/// OAuth flow and sync already-connected ones on demand. The actual
/// `Source` is created server-side once the OAuth callback lands in the
/// system browser -- this screen has no "finish connecting" step of its
/// own, just a manual refresh once the owner comes back.
class ConnectionsScreen extends ConsumerWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgId = ref.watch(selectedOrgIdProvider);
    if (orgId == null) {
      return const EmptyState(message: 'Select an organization');
    }

    final definitionsAsync = ref.watch(connectorDefinitionsProvider);
    final sourcesAsync = ref.watch(connectorSourcesProvider(orgId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Connections',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ref.invalidate(connectorDefinitionsProvider);
                  ref.invalidate(connectorSourcesProvider(orgId));
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: definitionsAsync.when(
            data: (definitions) => sourcesAsync.when(
              data: (sources) => _ConnectionsBody(
                orgId: orgId,
                definitions: definitions,
                sources: sources,
              ),
              loading: () => const LoadingState(),
              error: (error, _) => ErrorState(
                message: 'Could not load connections',
                onRetry: () => ref.invalidate(connectorSourcesProvider(orgId)),
              ),
            ),
            loading: () => const LoadingState(),
            error: (error, _) => ErrorState(
              message: 'Could not load connector types',
              onRetry: () => ref.invalidate(connectorDefinitionsProvider),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConnectionsBody extends StatelessWidget {
  const _ConnectionsBody({
    required this.orgId,
    required this.definitions,
    required this.sources,
  });

  final String orgId;
  final List<core.ConnectorDefinition> definitions;
  final List<core.Source> sources;

  @override
  Widget build(BuildContext context) {
    final definitionById = {for (final d in definitions) d.id: d};
    final connectedIds = sources
        .map((s) => s.config['connectorId'] as String?)
        .whereType<String>()
        .toSet();
    final available = definitions.where((d) => !connectedIds.contains(d.id));

    if (sources.isEmpty && available.isEmpty) {
      return const EmptyState(message: 'No connectors available');
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (sources.isNotEmpty) ...[
          Text('Connected', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          for (final source in sources)
            _ConnectedSourceTile(
              orgId: orgId,
              source: source,
              definition:
                  definitionById[source.config['connectorId'] as String?],
            ),
          const SizedBox(height: 16),
        ],
        if (available.isNotEmpty) ...[
          Text('Available', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          for (final definition in available)
            _AvailableConnectorTile(orgId: orgId, definition: definition),
        ],
      ],
    );
  }
}

class _ConnectedSourceTile extends ConsumerStatefulWidget {
  const _ConnectedSourceTile({
    required this.orgId,
    required this.source,
    required this.definition,
  });

  final String orgId;
  final core.Source source;
  final core.ConnectorDefinition? definition;

  @override
  ConsumerState<_ConnectedSourceTile> createState() =>
      _ConnectedSourceTileState();
}

class _ConnectedSourceTileState extends ConsumerState<_ConnectedSourceTile> {
  bool _syncing = false;

  @override
  Widget build(BuildContext context) {
    final label =
        widget.definition?.displayName ??
        (widget.source.config['connectorId'] as String? ?? 'Unknown');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(label),
        trailing: FilledButton.icon(
          icon: _syncing
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.sync),
          label: const Text('Sync now'),
          onPressed: _syncing ? null : _sync,
        ),
      ),
    );
  }

  Future<void> _sync() async {
    setState(() => _syncing = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await ref
          .read(apiClientProvider)
          .syncSource(widget.orgId, widget.source.id);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Synced: ${result['newMessages']} new, '
            '${result['routedMessages']} routed, '
            '${result['specsCreated']} Task Spec(s) drafted.',
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Sync failed: $e')));
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }
}

class _AvailableConnectorTile extends ConsumerWidget {
  const _AvailableConnectorTile({
    required this.orgId,
    required this.definition,
  });

  final String orgId;
  final core.ConnectorDefinition definition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.link),
        title: Text(definition.displayName),
        trailing: FilledButton(
          onPressed: () => _showConnectDialog(context, ref),
          child: const Text('Connect'),
        ),
      ),
    );
  }

  Future<void> _showConnectDialog(BuildContext context, WidgetRef ref) async {
    final clientIdController = TextEditingController();
    final clientSecretController = TextEditingController();

    final shouldConnect = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Connect ${definition.displayName}'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: clientIdController,
                decoration: const InputDecoration(labelText: 'Client ID'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: clientSecretController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Client secret'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    if (shouldConnect != true) return;
    final clientId = clientIdController.text.trim();
    final clientSecret = clientSecretController.text.trim();
    if (clientId.isEmpty || clientSecret.isEmpty) return;
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      final authorizeUrl = await ref
          .read(apiClientProvider)
          .beginConnectorConnect(
            orgId,
            definition.id,
            clientId: clientId,
            clientSecret: clientSecret,
          );
      await url_launcher.launchUrl(Uri.parse(authorizeUrl));
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Complete sign-in in your browser, then refresh this screen.',
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Connect failed: $e')));
    }
  }
}
