import 'package:flutter/material.dart';

import '../common/empty_state.dart';

/// Placeholder for Phase 0 slice 4; the all-orgs read-only dashboard is
/// built in slice 6.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.construction,
      message: 'Dashboard coming in the next slice',
    );
  }
}
