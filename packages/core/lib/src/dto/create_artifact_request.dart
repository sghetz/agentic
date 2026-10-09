import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/artifact_kind.dart';

part 'create_artifact_request.freezed.dart';
part 'create_artifact_request.g.dart';

/// `version` is assigned server-side (next version for this task + kind).
@freezed
sealed class CreateArtifactRequest with _$CreateArtifactRequest {
  const factory CreateArtifactRequest({
    required ArtifactKind kind,
    required String uri,
    String? content,
  }) = _CreateArtifactRequest;

  factory CreateArtifactRequest.fromJson(Map<String, Object?> json) =>
      _$CreateArtifactRequestFromJson(json);
}
