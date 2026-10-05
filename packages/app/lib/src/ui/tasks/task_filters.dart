import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../state/task_providers.dart';

class TaskFilters extends ConsumerStatefulWidget {
  const TaskFilters({super.key});

  @override
  ConsumerState<TaskFilters> createState() => _TaskFiltersState();
}

class _TaskFiltersState extends ConsumerState<TaskFilters> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(taskStatusFilterProvider);
    final (from, to) = ref.watch(taskDateRangeProvider);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 220,
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search tasks',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  ref.read(taskSearchQueryProvider.notifier).set(value),
            ),
          ),
          DropdownButton<core.TaskStatus?>(
            value: status,
            hint: const Text('All statuses'),
            items: [
              const DropdownMenuItem(value: null, child: Text('All statuses')),
              for (final s in core.TaskStatus.values)
                DropdownMenuItem(value: s, child: Text(s.name)),
            ],
            onChanged: (value) =>
                ref.read(taskStatusFilterProvider.notifier).set(value),
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.date_range),
            label: Text(
              from == null && to == null
                  ? 'Date range'
                  : '${from == null ? '…' : DateFormat.yMd().format(from)} - '
                        '${to == null ? '…' : DateFormat.yMd().format(to)}',
            ),
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: from != null && to != null
                    ? DateTimeRange(start: from, end: to)
                    : null,
              );
              if (range != null) {
                ref
                    .read(taskDateRangeProvider.notifier)
                    .set(range.start, range.end);
              }
            },
          ),
          if (status != null ||
              from != null ||
              to != null ||
              _searchController.text.isNotEmpty)
            TextButton(
              onPressed: () {
                _searchController.clear();
                ref.read(taskStatusFilterProvider.notifier).set(null);
                ref.read(taskDateRangeProvider.notifier).set(null, null);
                ref.read(taskSearchQueryProvider.notifier).set('');
              },
              child: const Text('Clear filters'),
            ),
        ],
      ),
    );
  }
}
