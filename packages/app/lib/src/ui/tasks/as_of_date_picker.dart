import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Lets the owner pick a past date to see a task's derived state as of
/// that moment. `value == null` means "now" (the live state).
class AsOfDatePicker extends StatelessWidget {
  const AsOfDatePicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.history),
          label: Text(
            value == null ? 'Now' : DateFormat.yMMMd().format(value!.toLocal()),
          ),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (picked != null) onChanged(picked);
          },
        ),
        if (value != null)
          IconButton(
            tooltip: 'Back to now',
            icon: const Icon(Icons.close),
            onPressed: () => onChanged(null),
          ),
      ],
    );
  }
}
