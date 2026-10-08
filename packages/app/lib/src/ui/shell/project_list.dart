import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/api_client.dart';
import '../../api/api_client_provider.dart';
import '../../state/inbox_providers.dart';
import '../../state/org_providers.dart';
import '../../state/project_providers.dart';
import '../common/empty_state.dart';
import '../common/error_state.dart';
import '../common/loading_state.dart';
import '../health/health_report_dialog.dart';
import '../inbox/task_spec_dialog.dart';
import 'health_indicator.dart';

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
                tooltip: 'Check all projects',
                icon: const Icon(Icons.health_and_safety_outlined),
                onPressed: () => _checkAll(context, ref, orgId),
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
                  final hasRepo = project.repos.isNotEmpty;

                  return ListTile(
                    selected: project.id == selectedProjectId,
                    leading: hasRepo
                        ? HealthIndicator(orgId: orgId, projectId: project.id)
                        : null,
                    title: Text(project.name),
                    subtitle: Text(_subtitleFor(project, isArchived)),
                    onTap: () {
                      ref
                          .read(selectedProjectIdProvider.notifier)
                          .select(project.id);
                      context.go('/tasks');
                    },
                    trailing: PopupMenuButton<String>(
                      onSelected: (action) async {
                        switch (action) {
                          case 'edit':
                            await _showEditProjectDialog(
                              context,
                              ref,
                              orgId,
                              project,
                            );
                          case 'onboard':
                            await _onboard(context, ref, orgId, project);
                          case 'health':
                            await showHealthReportDialog(
                              context,
                              orgId: orgId,
                              projectId: project.id,
                              projectName: project.name,
                            );
                          case 'task-specs':
                            await showTaskSpecDialog(
                              context,
                              orgId: orgId,
                              projectId: project.id,
                              projectName: project.name,
                            );
                          case 'import-erf':
                            await _importErf(context, ref, orgId, project);
                          case 'archive':
                            await ref
                                .read(apiClientProvider)
                                .archiveProject(orgId, project.id);
                            ref.invalidate(projectListProvider(orgId));
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        if (hasRepo)
                          const PopupMenuItem(
                            value: 'onboard',
                            child: Text('Clone & detect'),
                          ),
                        if (hasRepo)
                          const PopupMenuItem(
                            value: 'health',
                            child: Text('Health reports'),
                          ),
                        const PopupMenuItem(
                          value: 'task-specs',
                          child: Text('Task Specs'),
                        ),
                        const PopupMenuItem(
                          value: 'import-erf',
                          child: Text('Import ERF folder...'),
                        ),
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

  String _subtitleFor(core.Project project, bool isArchived) {
    final parts = <String>[
      if (isArchived) 'Archived',
      if (project.flutterVersion != null) 'Flutter ${project.flutterVersion}',
      if (project.repos.isEmpty) 'No repo configured',
    ];
    return parts.isEmpty ? project.slug : parts.join(' · ');
  }

  Future<void> _onboard(
    BuildContext context,
    WidgetRef ref,
    String orgId,
    core.Project project,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(apiClientProvider).onboardProject(orgId, project.id);
      ref.invalidate(projectListProvider(orgId));
      messenger.showSnackBar(
        SnackBar(content: Text('Onboarded ${project.name}')),
      );
    } on ApiException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Onboarding failed: ${e.body}')),
      );
    }
  }

  Future<void> _checkAll(
    BuildContext context,
    WidgetRef ref,
    String orgId,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Running health checks...')),
    );
    try {
      final results = await ref
          .read(apiClientProvider)
          .runOrgHealthCheck(orgId);
      messenger.showSnackBar(
        SnackBar(content: Text('Checked ${results.length} project(s)')),
      );
    } on ApiException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Health check run failed: ${e.body}')),
      );
    } finally {
      ref.invalidate(projectListProvider(orgId));
    }
  }

  Future<void> _showCreateProjectDialog(
    BuildContext context,
    WidgetRef ref,
    String orgId,
  ) async {
    final nameController = TextEditingController();
    final slugController = TextEditingController();
    final repoUrlController = TextEditingController();
    final branchController = TextEditingController(text: 'main');

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
            const SizedBox(height: 8),
            TextField(
              controller: repoUrlController,
              decoration: const InputDecoration(
                labelText: 'Repo URL (optional)',
              ),
            ),
            TextField(
              controller: branchController,
              decoration: const InputDecoration(labelText: 'Default branch'),
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

    final repoUrl = repoUrlController.text.trim();
    await ref
        .read(apiClientProvider)
        .createProject(
          orgId,
          core.CreateProjectRequest(
            name: nameController.text,
            slug: slugController.text,
            repos: repoUrl.isEmpty
                ? const []
                : [
                    core.RepoConfig(
                      url: repoUrl,
                      defaultBranch: branchController.text.trim().isEmpty
                          ? 'main'
                          : branchController.text.trim(),
                      path: '',
                    ),
                  ],
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
    final existingRepo = project.repos.isEmpty ? null : project.repos.first;
    final nameController = TextEditingController(text: project.name);
    final repoUrlController = TextEditingController(
      text: existingRepo?.url ?? '',
    );
    final branchController = TextEditingController(
      text: existingRepo?.defaultBranch ?? 'main',
    );

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: repoUrlController,
              decoration: const InputDecoration(
                labelText: 'Repo URL (optional)',
              ),
            ),
            TextField(
              controller: branchController,
              decoration: const InputDecoration(labelText: 'Default branch'),
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
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (shouldSave != true) return;

    final repoUrl = repoUrlController.text.trim();
    await ref
        .read(apiClientProvider)
        .updateProject(
          orgId,
          project.id,
          core.UpdateProjectRequest(
            name: nameController.text,
            repos: repoUrl.isEmpty
                ? const []
                : [
                    core.RepoConfig(
                      url: repoUrl,
                      defaultBranch: branchController.text.trim().isEmpty
                          ? 'main'
                          : branchController.text.trim(),
                      path: existingRepo?.path ?? '',
                    ),
                  ],
          ),
        );
    ref.invalidate(projectListProvider(orgId));
  }

  Future<void> _importErf(
    BuildContext context,
    WidgetRef ref,
    String orgId,
    core.Project project,
  ) async {
    final controller = TextEditingController();
    final shouldImport = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Import ERF folder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Folder path',
            hintText: '~/Documents/ERF/my-project',
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

    final folderPath = controller.text.trim();
    if (shouldImport != true || folderPath.isEmpty) return;
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final client = ref.read(apiClientProvider);
    try {
      // Reuse an existing erf source for this exact folder if one already
      // exists, so re-importing the same folder stays idempotent instead of
      // creating a fresh source (and re-importing every file) each time.
      final sources = await client.listSources(orgId, projectId: project.id);
      core.Source? existing;
      for (final source in sources) {
        if (source.kind == core.SourceKind.erf &&
            source.config['folderPath'] == folderPath) {
          existing = source;
          break;
        }
      }
      final source =
          existing ??
          await client.createSource(
            orgId,
            core.CreateSourceRequest(
              kind: core.SourceKind.erf,
              config: {'folderPath': folderPath},
              projectId: project.id,
            ),
          );

      final result = await client.scanErfSource(orgId, source.id);
      ref.invalidate(taskSpecsProvider(orgId, project.id));
      final failedFiles = result['failedFiles'] as List;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Scanned: ${result['newMessages']} new file(s), '
            '${result['specsCreated']} Task Spec(s) drafted'
            '${failedFiles.isEmpty ? '' : ', ${failedFiles.length} failed'}.',
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Import failed: $e')));
    }
  }
}
