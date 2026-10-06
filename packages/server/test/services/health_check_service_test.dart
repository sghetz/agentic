import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;
import 'package:server/src/config.dart';
import 'package:server/src/repositories/org_store.dart';
import 'package:server/src/services/flutter_version_detector.dart';
import 'package:server/src/services/git_service.dart';
import 'package:server/src/services/health_check_service.dart';
import 'package:server/src/services/health_runner.dart';
import 'package:server/src/services/onboarding_service.dart';
import 'package:server/src/storage/org_database.dart';
import 'package:test/test.dart';

Future<void> _git(List<String> args, {String? cwd}) async {
  final result = await Process.run('git', args, workingDirectory: cwd);
  if (result.exitCode != 0) {
    fail('git ${args.join(' ')} failed: ${result.stderr}');
  }
}

Future<ProcessResult> _alwaysPasses(
  String executable,
  List<String> args, {
  required String workingDirectory,
}) async {
  return ProcessResult(0, 0, '', '');
}

void main() {
  late Directory tmp;
  late String remotePath;
  late OrgDatabase db;
  late OrgStore store;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('agentic_healthcheck_test_');
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
  });

  tearDown(() async {
    await db.close();
    await tmp.delete(recursive: true);
  });

  test(
    'clones, detects the version, runs the pipeline, and stores a project artifact',
    () async {
      final service = HealthCheckService(
        paths: AgenticPaths('${tmp.path}/data', '${tmp.path}/repos'),
        gitService: const GitService(),
        detector: const FlutterVersionDetector(),
        runner: HealthRunner(processRunner: _alwaysPasses),
      );

      final project = await store.createProject(
        core.CreateProjectRequest(
          name: 'Example',
          slug: 'example',
          repos: [
            core.RepoConfig(url: remotePath, defaultBranch: 'main', path: ''),
          ],
        ),
      );

      final artifact = await service.check(
        orgSlug: 'employer',
        project: project,
        orgStore: store,
      );

      expect(artifact.kind, core.ArtifactKind.healthReport);
      expect(artifact.projectId, project.id);
      expect(artifact.taskId, isNull);
      expect(artifact.version, 1);

      final report = core.HealthReport.fromJson(
        jsonDecode(artifact.content!) as Map<String, Object?>,
      );
      expect(report.status, core.HealthCheckStepStatus.passed);

      final updatedProject = await store.getProject(project.id);
      expect(updatedProject!.flutterVersion, '3.29.0');
    },
  );

  test('a second check increments the artifact version', () async {
    final service = HealthCheckService(
      paths: AgenticPaths('${tmp.path}/data', '${tmp.path}/repos'),
      gitService: const GitService(),
      detector: const FlutterVersionDetector(),
      runner: HealthRunner(processRunner: _alwaysPasses),
    );

    final project = await store.createProject(
      core.CreateProjectRequest(
        name: 'Example',
        slug: 'example',
        repos: [
          core.RepoConfig(url: remotePath, defaultBranch: 'main', path: ''),
        ],
      ),
    );

    await service.check(orgSlug: 'employer', project: project, orgStore: store);
    final second = await service.check(
      orgSlug: 'employer',
      project: project,
      orgStore: store,
    );

    expect(second.version, 2);
  });

  test('throws NoRepoConfigured when the project has no repos', () async {
    final service = HealthCheckService(
      paths: AgenticPaths('${tmp.path}/data', '${tmp.path}/repos'),
      gitService: const GitService(),
      detector: const FlutterVersionDetector(),
      runner: HealthRunner(processRunner: _alwaysPasses),
    );

    final project = await store.createProject(
      const core.CreateProjectRequest(name: 'Bare', slug: 'bare'),
    );

    expect(
      () =>
          service.check(orgSlug: 'employer', project: project, orgStore: store),
      throwsA(isA<NoRepoConfigured>()),
    );
  });

  test('two concurrent checks run one at a time, not interleaved', () async {
    final order = <String>[];
    Future<ProcessResult> trackingRunner(
      String executable,
      List<String> args, {
      required String workingDirectory,
    }) async {
      order.add('${workingDirectory.split('/').last}:start');
      await Future<void>.delayed(const Duration(milliseconds: 20));
      order.add('${workingDirectory.split('/').last}:end');
      return ProcessResult(0, 0, '', '');
    }

    final service = HealthCheckService(
      paths: AgenticPaths('${tmp.path}/data', '${tmp.path}/repos'),
      gitService: const GitService(),
      detector: const FlutterVersionDetector(),
      runner: HealthRunner(processRunner: trackingRunner),
    );

    final projectA = await store.createProject(
      core.CreateProjectRequest(
        name: 'A',
        slug: 'a',
        repos: [
          core.RepoConfig(url: remotePath, defaultBranch: 'main', path: ''),
        ],
      ),
    );
    final projectB = await store.createProject(
      core.CreateProjectRequest(
        name: 'B',
        slug: 'b',
        repos: [
          core.RepoConfig(url: remotePath, defaultBranch: 'main', path: ''),
        ],
      ),
    );

    await Future.wait([
      service.check(orgSlug: 'employer', project: projectA, orgStore: store),
      service.check(orgSlug: 'employer', project: projectB, orgStore: store),
    ]);

    // If they ran concurrently, we'd see both "start" events before either
    // "end". Sequential execution means each project's start is always
    // immediately followed by its own end.
    for (var i = 0; i < order.length; i += 2) {
      final project = order[i].split(':').first;
      expect(order[i], '$project:start');
      expect(order[i + 1], '$project:end');
    }
  });
}
