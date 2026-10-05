import 'package:freezed_annotation/freezed_annotation.dart';

part 'repo_config.freezed.dart';
part 'repo_config.g.dart';

/// One git repository backing a [Project]. Matches the `repos:` entries in
/// a project manifest (see `manifests/example-project.yaml`).
@freezed
sealed class RepoConfig with _$RepoConfig {
  const factory RepoConfig({
    required String url,
    required String defaultBranch,
    required String path,
  }) = _RepoConfig;

  factory RepoConfig.fromJson(Map<String, Object?> json) =>
      _$RepoConfigFromJson(json);
}
