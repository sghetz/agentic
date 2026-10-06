import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/failure_diagnosis_category.dart';
import '../enums/health_check_step_status.dart';

part 'health_report.freezed.dart';
part 'health_report.g.dart';

/// One step of the deterministic pipeline (`fvm flutter pub get` ->
/// `analyze` -> `test` -> `build apk` -> `build ios --no-codesign`).
/// A step after the first failure is recorded as `skipped`, not run.
@freezed
sealed class HealthCheckStep with _$HealthCheckStep {
  const factory HealthCheckStep({
    required String name,
    required HealthCheckStepStatus status,
    required int durationMs,
    required String output,
  }) = _HealthCheckStep;

  factory HealthCheckStep.fromJson(Map<String, Object?> json) =>
      _$HealthCheckStepFromJson(json);
}

/// Claude Code's best-effort classification of why a failed step failed.
/// Best-effort: a failed health check is still useful without one, so a
/// diagnosis error never fails the health check itself.
@freezed
sealed class FailureDiagnosis with _$FailureDiagnosis {
  const factory FailureDiagnosis({
    required FailureDiagnosisCategory category,
    required String summary,
    required String suggestedFix,
  }) = _FailureDiagnosis;

  factory FailureDiagnosis.fromJson(Map<String, Object?> json) =>
      _$FailureDiagnosisFromJson(json);
}

/// The full result of one health check run, stored as an [Artifact]'s
/// `content` (JSON) with kind `healthReport`, attached to the project.
@freezed
sealed class HealthReport with _$HealthReport {
  const factory HealthReport({
    required HealthCheckStepStatus status,
    required List<HealthCheckStep> steps,
    required DateTime startedAt,
    required DateTime finishedAt,
    FailureDiagnosis? diagnosis,
  }) = _HealthReport;

  factory HealthReport.fromJson(Map<String, Object?> json) =>
      _$HealthReportFromJson(json);
}
