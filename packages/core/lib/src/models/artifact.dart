import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/artifact_kind.dart';

part 'artifact.freezed.dart';
part 'artifact.g.dart';

@freezed
sealed class Artifact with _$Artifact {
  const factory Artifact({
    required String id,
    required String taskId,
    required ArtifactKind kind,
    required String uri,
    required int version,
    required DateTime createdAt,
  }) = _Artifact;

  factory Artifact.fromJson(Map<String, Object?> json) =>
      _$ArtifactFromJson(json);
}
