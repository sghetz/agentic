import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../ui/dashboard/dashboard_screen.dart';
import '../ui/shell/app_shell.dart';
import '../ui/tasks/task_detail_screen.dart';
import '../ui/tasks/task_list_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/tasks',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const TaskListScreen(),
          ),
          GoRoute(
            path: '/tasks/:taskId',
            builder: (context, state) =>
                TaskDetailScreen(taskId: state.pathParameters['taskId']!),
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
        ],
      ),
    ],
  );
}
