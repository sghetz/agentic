import 'dart:io';

import 'package:core/core.dart' as core;
import 'package:server/src/config.dart';
import 'package:server/src/repositories/org_store.dart';
import 'package:server/src/services/flutter_version_detector.dart';
import 'package:server/src/services/git_service.dart';
import 'package:server/src/services/onboarding_service.dart';
import 'package:server/src/storage/org_database.dart';
import 'package:test/test.dart';

Future<void> _git(List<String> args, {String? cwd}) async {
  final result = await Process.run('git', args, workingDirectory: cwd);
  if (result.exitCode != 0) {
    fail('git ${args.join(' ')} failed: ${result.stderr}');
  }
}

void main() {
  late Directory tmp;
  late String remotePath;
  late OrgDatabase db;
  late OrgStore store;
  late OnboardingService service;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('agentic_onboard_test_');
    remotePath = '${tmp.path}/remote.git';
    await _git(['init', '--bare', remotePath]);

    final seedPath = '${tmp.path}/seed';
    await _git(['clone', remotePath, seedPath]);
    await File('$seedPath/.fvmrc').writeAsString('{"flutter": "3.29.0"}');
    await File('$seedPath/README.md').writeAsString('hello');
    await _git(['add', '.'], cwd: seedPath);
    await _git([
      '-c',
      'user.email=test@example.com',
      '-c',
      'user.name=Test',
      'commit',
      '-m',
      'initial',
    ], cwd: seedPath);
    await _git(['push', 'origin', 'HEAD:main'], cwd: seedPath);

    db = OrgDatabase.memory();
    store = OrgStore('org-1', db);
    service = OnboardingService(
      paths: AgenticPaths('${tmp.path}/data', '${tmp.path}/repos'),
      gitService: const GitService(),
      detector: const FlutterVersionDetector(),
    );
  });

  tearDown(() async {
    await db.close();
    await tmp.delete(recursive: true);
  });

  test(
    'clones the repo, detects the Flutter version, and persists both',
    () async {
      final project = await store.createProject(
        core.CreateProjectRequest(
          name: 'Example',
          slug: 'example',
          repos: [
            core.RepoConfig(url: remotePath, defaultBranch: 'main', path: ''),
          ],
        ),
      );

      final onboarded = await service.onboard(
        orgSlug: 'employer',
        project: project,
        orgStore: store,
      );

      expect(onboarded.flutterVersion, '3.29.0');
      expect(onboarded.repos.single.path, '${tmp.path}/repos/employer/example');
      expect(
        await File('${onboarded.repos.single.path}/README.md').exists(),
        isTrue,
      );
    },
  );

  test('throws NoRepoConfigured when the project has no repos', () async {
    final project = await store.createProject(
      const core.CreateProjectRequest(name: 'Bare', slug: 'bare'),
    );

    expect(
      () => service.onboard(
        orgSlug: 'employer',
        project: project,
        orgStore: store,
      ),
      throwsA(isA<NoRepoConfigured>()),
    );
  });
}
