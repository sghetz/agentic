import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';

class HealthStatusIcon extends StatelessWidget {
  const HealthStatusIcon({super.key, required this.status});

  final core.HealthCheckStepStatus? status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      null => const Icon(Icons.help_outline, color: Colors.grey),
      core.HealthCheckStepStatus.passed => const Icon(
        Icons.check_circle,
        color: Colors.green,
      ),
      core.HealthCheckStepStatus.failed => const Icon(
        Icons.cancel,
        color: Colors.red,
      ),
      core.HealthCheckStepStatus.skipped => const Icon(
        Icons.remove_circle_outline,
        color: Colors.grey,
      ),
    };
  }
}
