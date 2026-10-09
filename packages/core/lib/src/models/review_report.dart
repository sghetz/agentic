import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_report.freezed.dart';
part 'review_report.g.dart';

/// The Reviewer's independent judgment of a Developer PR against its source
/// Task Spec (per `docs/AGENTS.md`'s Reviewer section), stored as the
/// task-scoped `review` artifact. Deliberately does not duplicate the
/// external pipeline's own static-analysis/security findings (Codacy,
/// Checkmarx, etc.) -- those are fetched live from GitHub's check runs
/// instead, since Reviewer's distinctive value is acceptance-criteria and
/// requirement-coverage judgment, not re-deriving what the pipeline already
/// does comprehensively.
@freezed
sealed class ReviewReport with _$ReviewReport {
  const factory ReviewReport({
    required String summary,
    @Default([]) List<String> acceptanceCriteriaMet,
    @Default([]) List<String> acceptanceCriteriaUnmet,
    @Default([]) List<String> requirementIdsCovered,
    @Default([]) List<String> requirementIdsMissing,
    @Default([]) List<String> codeQualityIssues,
    @Default([]) List<String> missingTests,
  }) = _ReviewReport;

  factory ReviewReport.fromJson(Map<String, Object?> json) =>
      _$ReviewReportFromJson(json);
}
