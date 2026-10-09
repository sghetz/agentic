import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;
import 'package:server/src/services/github_service.dart';
import 'package:test/test.dart';

typedef _Call = ({String executable, List<String> args, String? cwd});

ProcessResult _ok(String stdout) => ProcessResult(0, 0, stdout, '');
ProcessResult _fail(String stderr) => ProcessResult(0, 1, '', stderr);

void main() {
  late List<_Call> calls;

  GitHubService serviceReturning(ProcessResult Function(_Call call) respond) {
    calls = [];
    return GitHubService(
      runner: (executable, args, {workingDirectory}) async {
        final call = (
          executable: executable,
          args: args,
          cwd: workingDirectory,
        );
        calls.add(call);
        return respond(call);
      },
    );
  }

  group('pushBranch', () {
    test('pushes the branch with upstream tracking', () async {
      final service = serviceReturning((_) => _ok(''));

      await service.pushBranch(
        worktreePath: '/repo/worktree',
        branchName: 'agentic/task-1',
      );

      expect(calls.single.executable, 'git');
      expect(calls.single.args, ['push', '-u', 'origin', 'agentic/task-1']);
      expect(calls.single.cwd, '/repo/worktree');
    });

    test('throws GitHubOperationException when the push fails', () async {
      final service = serviceReturning((_) => _fail('rejected'));

      expect(
        () => service.pushBranch(
          worktreePath: '/repo/worktree',
          branchName: 'agentic/task-1',
        ),
        throwsA(isA<GitHubOperationException>()),
      );
    });
  });

  group('createPr', () {
    test('parses the PR number from the printed URL', () async {
      final service = serviceReturning(
        (_) =>
            _ok('Creating pull request\nhttps://github.com/org/repo/pull/42\n'),
      );

      final pr = await service.createPr(
        worktreePath: '/repo/worktree',
        branchName: 'agentic/task-1',
        baseBranch: 'main',
        title: 'Reset password via email',
        body: 'Implements RF-07.',
      );

      expect(pr.number, 42);
      expect(pr.url, 'https://github.com/org/repo/pull/42');
      expect(pr.branch, 'agentic/task-1');
      expect(pr.baseBranch, 'main');
      expect(calls.single.executable, 'gh');
      expect(calls.single.args, [
        'pr',
        'create',
        '--base',
        'main',
        '--head',
        'agentic/task-1',
        '--title',
        'Reset password via email',
        '--body',
        'Implements RF-07.',
      ]);
    });

    test('throws GitHubOperationException when gh pr create fails', () async {
      final service = serviceReturning(
        (_) => _fail('no commits between main and HEAD'),
      );

      expect(
        () => service.createPr(
          worktreePath: '/repo/worktree',
          branchName: 'agentic/task-1',
          baseBranch: 'main',
          title: 't',
          body: 'b',
        ),
        throwsA(isA<GitHubOperationException>()),
      );
    });

    test('throws when the output has no parseable PR number', () async {
      final service = serviceReturning((_) => _ok('something unexpected'));

      expect(
        () => service.createPr(
          worktreePath: '/repo/worktree',
          branchName: 'agentic/task-1',
          baseBranch: 'main',
          title: 't',
          body: 'b',
        ),
        throwsA(isA<GitHubOperationException>()),
      );
    });
  });

  group('getChecks', () {
    test('maps completed check runs by conclusion', () async {
      final service = serviceReturning(
        (_) => _ok(
          jsonEncode({
            'statusCheckRollup': [
              {
                'name': 'build',
                'status': 'COMPLETED',
                'conclusion': 'SUCCESS',
                'detailsUrl': 'https://ci/1',
              },
              {'name': 'tests', 'status': 'COMPLETED', 'conclusion': 'FAILURE'},
              {'name': 'lint', 'status': 'IN_PROGRESS', 'conclusion': null},
            ],
          }),
        ),
      );

      final checks = await service.getChecks(
        workingDirectory: '/repo/worktree',
        prNumber: 42,
      );

      expect(checks, [
        const core.PullRequestCheck(
          name: 'build',
          conclusion: core.PrCheckConclusion.success,
          detailsUrl: 'https://ci/1',
        ),
        const core.PullRequestCheck(
          name: 'tests',
          conclusion: core.PrCheckConclusion.failure,
        ),
        const core.PullRequestCheck(
          name: 'lint',
          conclusion: core.PrCheckConclusion.pending,
        ),
      ]);
      expect(calls.single.args, [
        'pr',
        'view',
        '42',
        '--json',
        'statusCheckRollup',
      ]);
    });

    test(
      'maps legacy commit statuses (Jenkins/Codacy style) by context',
      () async {
        final service = serviceReturning(
          (_) => _ok(
            jsonEncode({
              'statusCheckRollup': [
                {
                  'context': 'codacy/pr',
                  'state': 'SUCCESS',
                  'targetUrl': 'https://codacy/1',
                },
                {'context': 'checkmarx', 'state': 'PENDING'},
              ],
            }),
          ),
        );

        final checks = await service.getChecks(
          workingDirectory: '/repo/worktree',
          prNumber: 42,
        );

        expect(checks, [
          const core.PullRequestCheck(
            name: 'codacy/pr',
            conclusion: core.PrCheckConclusion.success,
            detailsUrl: 'https://codacy/1',
          ),
          const core.PullRequestCheck(
            name: 'checkmarx',
            conclusion: core.PrCheckConclusion.pending,
          ),
        ]);
      },
    );

    test('returns an empty list when there are no checks yet', () async {
      final service = serviceReturning(
        (_) => _ok(jsonEncode({'statusCheckRollup': <Object?>[]})),
      );

      final checks = await service.getChecks(
        workingDirectory: '/repo/worktree',
        prNumber: 42,
      );

      expect(checks, isEmpty);
    });

    test('throws GitHubOperationException when gh pr view fails', () async {
      final service = serviceReturning((_) => _fail('no such PR'));

      expect(
        () =>
            service.getChecks(workingDirectory: '/repo/worktree', prNumber: 42),
        throwsA(isA<GitHubOperationException>()),
      );
    });
  });

  group('mergePr', () {
    test('merges with the requested method and deletes the branch', () async {
      final service = serviceReturning((_) => _ok(''));

      await service.mergePr(
        workingDirectory: '/repo/worktree',
        prNumber: 42,
        method: GitHubMergeMethod.rebase,
      );

      expect(calls.single.executable, 'gh');
      expect(calls.single.args, [
        'pr',
        'merge',
        '42',
        '--rebase',
        '--delete-branch',
      ]);
    });

    test('defaults to squash', () async {
      final service = serviceReturning((_) => _ok(''));

      await service.mergePr(workingDirectory: '/repo/worktree', prNumber: 42);

      expect(calls.single.args, contains('--squash'));
    });

    test('throws GitHubOperationException when the merge is blocked', () async {
      final service = serviceReturning(
        (_) => _fail('required status check "build" is failing'),
      );

      expect(
        () => service.mergePr(workingDirectory: '/repo/worktree', prNumber: 42),
        throwsA(isA<GitHubOperationException>()),
      );
    });
  });
}
