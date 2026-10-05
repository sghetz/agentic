import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/repo_config.dart';

part 'create_project_request.freezed.dart';
part 'create_project_request.g.dart';

@freezed
sealed class CreateProjectRequest with _$CreateProjectRequest {
  const factory CreateProjectRequest({
    required String name,
    required String slug,
    @Default([]) List<RepoConfig> repos,
    String? flutterVersion,
    String? designSystemRef,
  }) = _CreateProjectRequest;

  factory CreateProjectRequest.fromJson(Map<String, Object?> json) =>
      _$CreateProjectRequestFromJson(json);
}
