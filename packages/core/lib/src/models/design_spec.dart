import 'package:freezed_annotation/freezed_annotation.dart';

import 'screen_spec.dart';

part 'design_spec.freezed.dart';
part 'design_spec.g.dart';

/// Creative's structured output (per `docs/AGENTS.md`): the screens a
/// feature needs, each with its states and navigation, generated from an
/// existing [core.TaskSpec] artifact. [requirementIds] is carried over from
/// that source spec for traceability, not re-derived. [sourceTaskSpecArtifactId]
/// is the Task Spec artifact this was generated from.
@freezed
sealed class DesignSpec with _$DesignSpec {
  const factory DesignSpec({
    required String projectId,
    @Default([]) List<ScreenSpec> screens,
    @Default([]) List<String> requirementIds,
    String? sourceTaskSpecArtifactId,
  }) = _DesignSpec;

  factory DesignSpec.fromJson(Map<String, Object?> json) =>
      _$DesignSpecFromJson(json);
}
