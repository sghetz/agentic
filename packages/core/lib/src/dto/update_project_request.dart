import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/project_status.dart';
import '../models/repo_config.dart';

part 'update_project_request.freezed.dart';
part 'update_project_request.g.dart';

/// All fields optional; omitted fields are left unchanged. Archiving goes
/// through `POST .../archive`, not this endpoint.
@freezed
sealed class UpdateProjectRequest with _$UpdateProjectRequest {
  const factory UpdateProjectRequest({
    String? name,
    String? slug,
    List<RepoConfig>? repos,
    String? flutterVersion,
    String? designSystemRef,
    ProjectStatus? status,
  }) = _UpdateProjectRequest;

  factory UpdateProjectRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateProjectRequestFromJson(json);
}
