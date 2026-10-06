import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart' as core;

import '../config.dart';
import '../repositories/org_store.dart';
import 'flutter_version_detector.dart';
import 'git_service.dart';
import 'health_runner.dart';
import 'onboarding_service.dart';

/// Pulls the repo, re-detects the Flutter version, runs the deterministic
/// pipeline, and stores the result as a project-scoped `healthReport`
/// artifact. All checks across every org/project share one queue, so
/// "Builds run one project at a time" holds process-wide, not just
/// per-project.
class HealthCheckService {
  HealthCheckService({
    required this.paths,
    required GitService gitService,
    required FlutterVersionDetector detector,
    required HealthRunner runner,
  }) : _gitService = gitService,
       _detector = detector,
       _runner = runner;

  final AgenticPaths paths;
  final GitService _gitService;
  final FlutterVersionDetector _detector;
  final HealthRunner _runner;

  Future<void> _queueTail = Future.value();

  Future<core.Artifact> check({
    required String orgSlug,
    required core.Project project,
    required OrgStore orgStore,
  }) {
    final completer = Completer<core.Artifact>();
    _queueTail = _queueTail.then((_) async {
      try {
        completer.complete(
          await _runOne(orgSlug: orgSlug, project: project, orgStore: orgStore),
        );
      } catch (e, st) {
        completer.completeError(e, st);
      }
    });
    return completer.future;
  }

  Future<core.Artifact> _runOne({
    required String orgSlug,
    required core.Project project,
    required OrgStore orgStore,
  }) async {
    if (project.repos.isEmpty) {
      throw NoRepoConfigured(project.id);
    }

    final repo = project.repos.first;
    final targetPath = paths.repoPath(orgSlug, project.slug);

    await _gitService.cloneOrPull(
      repoUrl: repo.url,
      targetPath: targetPath,
      branch: repo.defaultBranch,
    );

    final detectedVersion =
        await _detector.detect(targetPath) ?? project.flutterVersion;
    if (detectedVersion != project.flutterVersion) {
      await orgStore.updateProject(
        project.id,
        core.UpdateProjectRequest(flutterVersion: detectedVersion),
      );
    }

    final report = await _runner.run(
      targetPath,
      flutterVersion: detectedVersion,
    );

    return orgStore.createProjectArtifact(
      project.id,
      kind: core.ArtifactKind.healthReport,
      uri:
          'health-report:${project.id}:${DateTime.now().toUtc().toIso8601String()}',
      content: jsonEncode(report.toJson()),
    );
  }
}
