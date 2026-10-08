import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'org_switcher.dart';
import 'project_list.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: Row(
        children: [
          const SizedBox(
            width: 280,
            child: Column(
              children: [
                SizedBox(height: 8),
                OrgSwitcher(),
                Divider(height: 1),
                Expanded(child: ProjectList()),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                _MainTabs(currentPath: location),
                const Divider(height: 1),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MainTabs extends StatelessWidget {
  const _MainTabs({required this.currentPath});

  final String currentPath;

  @override
  Widget build(BuildContext context) {
    final isDashboard = currentPath.startsWith('/dashboard');
    final isChat = currentPath.startsWith('/chat');
    final isInbox = currentPath.startsWith('/inbox');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _TabButton(
            label: 'Tasks',
            selected: !isDashboard && !isChat && !isInbox,
            onTap: () => context.go('/tasks'),
          ),
          _TabButton(
            label: 'Chat',
            selected: isChat,
            onTap: () => context.go('/chat'),
          ),
          _TabButton(
            label: 'Inbox',
            selected: isInbox,
            onTap: () => context.go('/inbox'),
          ),
          _TabButton(
            label: 'Dashboard',
            selected: isDashboard,
            onTap: () => context.go('/dashboard'),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Theme.of(context).colorScheme.primary : null;
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(foregroundColor: color),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
