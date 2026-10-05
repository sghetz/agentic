import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_client_provider.dart';
import '../../state/org_providers.dart';
import '../common/error_state.dart';
import '../common/loading_state.dart';

class OrgSwitcher extends ConsumerWidget {
  const OrgSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgsAsync = ref.watch(orgListProvider);
    final selectedOrgId = ref.watch(selectedOrgIdProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: orgsAsync.when(
        data: (orgs) {
          // Auto-select the first org once orgs load, if nothing is picked yet.
          if (selectedOrgId == null && orgs.isNotEmpty) {
            Future.microtask(
              () => ref
                  .read(selectedOrgIdProvider.notifier)
                  .select(orgs.first.id),
            );
          }
          final validSelection = orgs.any((o) => o.id == selectedOrgId)
              ? selectedOrgId
              : null;

          return Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: validSelection,
                  hint: const Text('Select organization'),
                  items: [
                    for (final org in orgs)
                      DropdownMenuItem(
                        value: org.id,
                        child: Text(org.name, overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  onChanged: (orgId) =>
                      ref.read(selectedOrgIdProvider.notifier).select(orgId),
                ),
              ),
              IconButton(
                tooltip: 'New organization',
                icon: const Icon(Icons.add),
                onPressed: () => _showCreateOrgDialog(context, ref),
              ),
            ],
          );
        },
        loading: () => const LoadingState(),
        error: (error, _) => ErrorState(
          message: 'Could not load organizations',
          onRetry: () => ref.invalidate(orgListProvider),
        ),
      ),
    );
  }

  Future<void> _showCreateOrgDialog(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final slugController = TextEditingController();
    var type = core.OrgType.personal;

    final shouldCreate = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text('New organization'),
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
                  DropdownButton<core.OrgType>(
                    value: type,
                    items: [
                      for (final t in core.OrgType.values)
                        DropdownMenuItem(value: t, child: Text(t.name)),
                    ],
                    onChanged: (value) => setState(() => type = value ?? type),
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
            );
          },
        );
      },
    );

    if (shouldCreate != true) return;

    final client = ref.read(apiClientProvider);
    final org = await client.createOrg(
      core.CreateOrganizationRequest(
        name: nameController.text,
        slug: slugController.text,
        type: type,
      ),
    );
    ref.invalidate(orgListProvider);
    ref.read(selectedOrgIdProvider.notifier).select(org.id);
  }
}
