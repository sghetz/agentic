import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client_provider.dart';
import '../../state/design_spec_providers.dart';
import '../../state/inbox_providers.dart';
import '../common/empty_state.dart';
import '../common/error_state.dart';
import '../common/loading_state.dart';
import '../common/mermaid_view.dart';

Future<void> showDesignSpecDialog(
  BuildContext context, {
  required String orgId,
  required String projectId,
  required String projectName,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => DesignSpecDialog(
      orgId: orgId,
      projectId: projectId,
      projectName: projectName,
    ),
  );
}

class DesignSpecDialog extends ConsumerWidget {
  const DesignSpecDialog({
    super.key,
    required this.orgId,
    required this.projectId,
    required this.projectName,
  });

  final String orgId;
  final String projectId;
  final String projectName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specsAsync = ref.watch(designSpecsProvider(orgId, projectId));
    final diagramsAsync = ref.watch(diagramsProvider(orgId, projectId));

    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text('$projectName Design Specs')),
          FilledButton.icon(
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate from Task Spec...'),
            onPressed: () => _showGenerateDialog(context, ref),
          ),
        ],
      ),
      content: SizedBox(
        width: 640,
        height: 560,
        child: specsAsync.when(
          data: (specArtifacts) {
            if (specArtifacts.isEmpty) {
              return const EmptyState(message: 'No Design Specs generated yet');
            }
            return diagramsAsync.when(
              data: (diagramArtifacts) {
                // A generate call always creates exactly one Design Spec and
                // one diagram artifact together, so the two version counters
                // stay in lockstep -- pairing by version is a simple,
                // reliable way to find each spec's companion diagram.
                final diagramByVersion = {
                  for (final d in diagramArtifacts) d.version: d,
                };
                return ListView.builder(
                  itemCount: specArtifacts.length,
                  itemBuilder: (context, index) {
                    final spec = specArtifacts[index];
                    return _DesignSpecTile(
                      artifact: spec,
                      diagramArtifact: diagramByVersion[spec.version],
                    );
                  },
                );
              },
              loading: () => const LoadingState(),
              error: (error, _) => ErrorState(
                message: 'Could not load diagrams',
                onRetry: () =>
                    ref.invalidate(diagramsProvider(orgId, projectId)),
              ),
            );
          },
          loading: () => const LoadingState(),
          error: (error, _) => ErrorState(
            message: 'Could not load Design Specs',
            onRetry: () =>
                ref.invalidate(designSpecsProvider(orgId, projectId)),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Future<void> _showGenerateDialog(BuildContext context, WidgetRef ref) async {
    final taskSpecArtifactId = await showDialog<String>(
      context: context,
      builder: (dialogContext) =>
          _TaskSpecPickerDialog(orgId: orgId, projectId: projectId),
    );
    if (taskSpecArtifactId == null) return;
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(apiClientProvider)
          .generateDesignSpec(orgId, projectId, taskSpecArtifactId);
      ref.invalidate(designSpecsProvider(orgId, projectId));
      ref.invalidate(diagramsProvider(orgId, projectId));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Design Spec generation failed: $e')),
      );
    }
  }
}

/// A sub-dialog listing the project's drafted Task Specs (from Phase 3) so
/// the owner can pick which one to generate a Design Spec from. Pops with
/// the chosen artifact id, or `null` if cancelled.
class _TaskSpecPickerDialog extends ConsumerWidget {
  const _TaskSpecPickerDialog({required this.orgId, required this.projectId});

  final String orgId;
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskSpecsAsync = ref.watch(taskSpecsProvider(orgId, projectId));

    return AlertDialog(
      title: const Text('Generate from which Task Spec?'),
      content: SizedBox(
        width: 480,
        height: 360,
        child: taskSpecsAsync.when(
          data: (artifacts) {
            if (artifacts.isEmpty) {
              return const EmptyState(message: 'No Task Specs drafted yet');
            }
            return ListView.builder(
              itemCount: artifacts.length,
              itemBuilder: (context, index) {
                final artifact = artifacts[index];
                final spec = core.TaskSpec.fromJson(
                  jsonDecode(artifact.content!) as Map<String, Object?>,
                );
                return ListTile(
                  title: Text(spec.goal),
                  subtitle: Text('v${artifact.version}'),
                  onTap: () => Navigator.of(context).pop(artifact.id),
                );
              },
            );
          },
          loading: () => const LoadingState(),
          error: (error, _) =>
              const ErrorState(message: 'Could not load Task Specs'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class _DesignSpecTile extends StatelessWidget {
  const _DesignSpecTile({
    required this.artifact,
    required this.diagramArtifact,
  });

  final core.Artifact artifact;
  final core.Artifact? diagramArtifact;

  @override
  Widget build(BuildContext context) {
    final spec = core.DesignSpec.fromJson(
      jsonDecode(artifact.content!) as Map<String, Object?>,
    );

    return ExpansionTile(
      title: Text(
        spec.screens.isEmpty
            ? 'v${artifact.version}'
            : '${spec.screens.length} screen'
                  '${spec.screens.length == 1 ? '' : 's'}: '
                  '${spec.screens.map((s) => s.name).join(', ')}',
      ),
      subtitle: Text('v${artifact.version}'),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final screen in spec.screens) _ScreenTile(screen: screen),
              if (diagramArtifact?.content != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Flow diagram',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 320,
                  child: MermaidView(source: diagramArtifact!.content!),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ScreenTile extends StatelessWidget {
  const _ScreenTile({required this.screen});

  final core.ScreenSpec screen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(screen.name, style: Theme.of(context).textTheme.titleSmall),
          Text(screen.purpose),
          if (screen.states.isNotEmpty)
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final state in screen.states)
                  Chip(
                    label: Text(state.name),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          if (screen.navigatesTo.isNotEmpty)
            Text(
              '→ ${screen.navigatesTo.join(', ')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}
