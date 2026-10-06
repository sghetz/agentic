import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/artifact_kind.dart';

part 'artifact.freezed.dart';
part 'artifact.g.dart';

/// Exactly one of [taskId] / [projectId] is set, depending on [kind]:
/// task-scoped kinds (taskSpec, designSpec, pr, review, most diagrams)
/// use [taskId]; project-scoped kinds (healthReport) use [projectId].
/// [uri] points at an external reference (a PR link, a file); [content]
/// holds inline text for artifacts stored directly (a Health Report as
/// JSON, a Mermaid diagram) -- not every artifact needs both.
@freezed
sealed class Artifact with _$Artifact {
  const factory Artifact({
    required String id,
    String? taskId,
    String? projectId,
    required ArtifactKind kind,
    required String uri,
    String? content,
    required int version,
    required DateTime createdAt,
  }) = _Artifact;

  factory Artifact.fromJson(Map<String, Object?> json) =>
      _$ArtifactFromJson(json);
}
