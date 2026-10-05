import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/api_client_provider.dart';
import '../../state/org_providers.dart';
import '../../state/project_providers.dart';
import '../common/empty_state.dart';
import '../common/error_state.dart';
import '../common/loading_state.dart';

class ProjectList extends ConsumerWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgId = ref.watch(selectedOrgIdProvider);
    if (orgId == null) {
      return const EmptyState(message: 'Select an organization');
    }

    final projectsAsync = ref.watch(projectListProvider(orgId));
    final showArchived = ref.watch(showArchivedProjectsProvider);
    final selectedProjectId = ref.watch(selectedProjectIdProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Projects',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              IconButton(
                tooltip: 'New project',
                icon: const Icon(Icons.add),
                onPressed: () => _showCreateProjectDialog(context, ref, orgId),
              ),
            ],
          ),
        ),
        SwitchListTile(
          dense: true,
          title: const Text('Show archived'),
          value: showArchived,
          onChanged: (_) =>
              ref.read(showArchivedProjectsProvider.notifier).toggle(),
        ),
        Expanded(
          child: projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return const EmptyState(message: 'No projects yet');
              }
              return ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  final isArchived =
                      project.status == core.ProjectStatus.archived;
                  return ListTile(
                    selected: project.id == selectedProjectId,
                    title: Text(project.name),
                    subtitle: isArchived ? const Text('Archived') : null,
                    onTap: () {
                      ref
                          .read(selectedProjectIdProvider.notifier)
                          .select(project.id);
                      context.go('/tasks');
                    },
                    trailing: PopupMenuButton<String>(
                      onSelected: (action) async {
                        if (action == 'edit') {
                          await _showEditProjectDialog(
                            context,
                            ref,
                            orgId,
                            project,
                          );
                        } else if (action == 'archive') {
                          await ref
                              .read(apiClientProvider)
                              .archiveProject(orgId, project.id);
                          ref.invalidate(projectListProvider(orgId));
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        if (!isArchived)
                          const PopupMenuItem(
                            value: 'archive',
                            child: Text('Archive'),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const LoadingState(),
            error: (error, _) => ErrorState(
              message: 'Could not load projects',
              onRetry: () => ref.invalidate(projectListProvider(orgId)),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateProjectDialog(
    BuildContext context,
    WidgetRef ref,
    String orgId,
  ) async {
    final nameController = TextEditingController();
    final slugController = TextEditingController();

    final shouldCreate = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: slugController,
              decoration: const InputDecoration(labelText: 'Slug'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (shouldCreate != true) return;

    await ref
        .read(apiClientProvider)
        .createProject(
          orgId,
          core.CreateProjectRequest(
            name: nameController.text,
            slug: slugController.text,
          ),
        );
    ref.invalidate(projectListProvider(orgId));
  }

  Future<void> _showEditProjectDialog(
    BuildContext context,
    WidgetRef ref,
    String orgId,
    core.Project project,
  ) async {
    final nameController = TextEditingController(text: project.name);

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit project'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (shouldSave != true) return;

    await ref
        .read(apiClientProvider)
        .updateProject(
          orgId,
          project.id,
          core.UpdateProjectRequest(name: nameController.text),
        );
    ref.invalidate(projectListProvider(orgId));
  }
}
