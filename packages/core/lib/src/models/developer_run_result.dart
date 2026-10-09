import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/developer_outcome.dart';
import 'health_report.dart';
import 'pull_request_info.dart';

part 'developer_run_result.freezed.dart';
part 'developer_run_result.g.dart';

/// The result of one Developer attempt to implement a task. [branchName] is
/// set whenever a commit happened (`prOpened` or `verificationFailed`), even
/// though [pullRequest] is only set for `prOpened` -- a `verificationFailed`
/// branch stays local for inspection.
@freezed
sealed class DeveloperRunResult with _$DeveloperRunResult {
  const factory DeveloperRunResult({
    required DeveloperOutcome outcome,
    String? branchName,
    required String summary,
    HealthReport? verificationReport,
    PullRequestInfo? pullRequest,
  }) = _DeveloperRunResult;

  factory DeveloperRunResult.fromJson(Map<String, Object?> json) =>
      _$DeveloperRunResultFromJson(json);
}
