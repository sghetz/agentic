import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/health_fix_outcome.dart';
import 'health_report.dart';

part 'health_fix_result.freezed.dart';
part 'health_fix_result.g.dart';

/// The result of one attempt to auto-fix a trivial health check failure.
/// Never represents a push or merge -- `branchName` (only set when
/// [outcome] is `fixed`) names a local branch left for the owner to review.
@freezed
sealed class HealthFixResult with _$HealthFixResult {
  const factory HealthFixResult({
    required HealthFixOutcome outcome,
    String? branchName,
    required String summary,
    HealthReport? verificationReport,
  }) = _HealthFixResult;

  factory HealthFixResult.fromJson(Map<String, Object?> json) =>
      _$HealthFixResultFromJson(json);
}
