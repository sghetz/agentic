import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/project_status.dart';
import 'repo_config.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
sealed class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    required String slug,
    required List<RepoConfig> repos,
    required ProjectStatus status,
    required DateTime createdAt,
    String? flutterVersion,
    String? designSystemRef,
    DateTime? archivedAt,
  }) = _Project;

  factory Project.fromJson(Map<String, Object?> json) =>
      _$ProjectFromJson(json);
}
