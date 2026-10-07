import 'package:core/core.dart' as core;
import 'package:server/src/services/role_prompts.dart';
import 'package:test/test.dart';

void main() {
  test('healthSystemPrompt mentions Health and the build pipeline', () {
    final prompt = healthSystemPrompt();
    expect(prompt, contains('Health agent'));
  });

  group('agentRoleSystemPrompt', () {
    test('returns a non-empty prompt for every wired role', () {
      for (final role in [
        'health',
        'analyst',
        'creative',
        'developer',
        'reviewer',
        'librarian',
      ]) {
        final prompt = agentRoleSystemPrompt(role);
        expect(prompt, isNotNull, reason: 'role: $role');
        expect(prompt, isNotEmpty, reason: 'role: $role');
      }
    });

    test('returns null for an unrecognized role', () {
      expect(agentRoleSystemPrompt('some-future-role'), isNull);
    });

    test('health goes through healthSystemPrompt specifically', () {
      expect(agentRoleSystemPrompt('health'), healthSystemPrompt());
    });
  });

  group('orchestratorSystemPrompt', () {
    test('lists every project with its id', () {
      final projects = [
        core.Project(
          id: 'proj-1',
          name: 'Expense Manager',
          slug: 'expense-manager',
          repos: const [],
          status: core.ProjectStatus.active,
          createdAt: DateTime.utc(2026, 1, 1),
        ),
        core.Project(
          id: 'proj-2',
          name: 'Habit Tracker',
          slug: 'habit-tracker',
          repos: const [],
          status: core.ProjectStatus.active,
          createdAt: DateTime.utc(2026, 1, 1),
        ),
      ];

      final prompt = orchestratorSystemPrompt(projects: projects);

      expect(prompt, contains('Expense Manager'));
      expect(prompt, contains('proj-1'));
      expect(prompt, contains('Habit Tracker'));
      expect(prompt, contains('proj-2'));
    });

    test('mentions no projects when the org has none yet', () {
      final prompt = orchestratorSystemPrompt(projects: const []);
      expect(prompt, contains('no projects yet'));
    });

    test('names the current project when scoped to one', () {
      final project = core.Project(
        id: 'proj-1',
        name: 'Expense Manager',
        slug: 'expense-manager',
        repos: const [],
        status: core.ProjectStatus.active,
        createdAt: DateTime.utc(2026, 1, 1),
      );

      final prompt = orchestratorSystemPrompt(
        projects: [project],
        currentProject: project,
      );

      expect(
        prompt,
        contains('This conversation is scoped to "Expense Manager"'),
      );
    });
  });
}
