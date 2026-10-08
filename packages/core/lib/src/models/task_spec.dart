import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/task_spec_priority.dart';

part 'task_spec.freezed.dart';
part 'task_spec.g.dart';

/// Structured output of the Analyst's extraction, stored as a versioned
/// project-scoped `Artifact` (`kind: taskSpec`) -- see `docs/AGENTS.md`'s
/// Analyst section for the shape. The Analyst never invents a missing
/// requirement; anything unclear or absent from the source text becomes an
/// [openQuestions] entry instead of a guess.
@freezed
sealed class TaskSpec with _$TaskSpec {
  const factory TaskSpec({
    required String projectId,
    required String goal,
    @Default([]) List<String> requirementIds,
    @Default([]) List<String> acceptanceCriteria,
    @Default([]) List<String> affectedAreas,
    required TaskSpecPriority priority,
    @Default([]) List<String> openQuestions,

    /// The [Message] this spec was drafted from, if any -- unset for specs
    /// extracted via the manual-trigger route (no message exists yet).
    String? sourceMessageId,
  }) = _TaskSpec;

  factory TaskSpec.fromJson(Map<String, Object?> json) =>
      _$TaskSpecFromJson(json);
}
