import 'package:core/core.dart' as core;

import '../config.dart';
import '../repositories/org_store.dart';
import 'flutter_version_detector.dart';
import 'git_service.dart';

class NoRepoConfigured implements Exception {
  NoRepoConfigured(this.projectId);

  final String projectId;

  @override
  String toString() => 'NoRepoConfigured($projectId)';
}

/// Clones (or pulls) a project's repo and detects its Flutter version --
/// the deterministic half of "Adding a project" from the architecture doc.
/// No LLM involvement.
class OnboardingService {
  OnboardingService({
    required this.paths,
    required GitService gitService,
    required FlutterVersionDetector detector,
  }) : _gitService = gitService,
       _detector = detector;

  final AgenticPaths paths;
  final GitService _gitService;
  final FlutterVersionDetector _detector;

  Future<core.Project> onboard({
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
    final detectedVersion = await _detector.detect(targetPath);

    final updatedRepo = repo.copyWith(path: targetPath);
    return orgStore.updateProject(
      project.id,
      core.UpdateProjectRequest(
        repos: [updatedRepo, ...project.repos.skip(1)],
        flutterVersion: detectedVersion ?? project.flutterVersion,
      ),
    );
  }
}
