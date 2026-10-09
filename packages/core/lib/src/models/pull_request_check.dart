import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/pr_check_conclusion.dart';

part 'pull_request_check.freezed.dart';
part 'pull_request_check.g.dart';

/// One external check on a PR's head commit (a GitHub Actions check run, or
/// a legacy commit status posted by something like Jenkins or Codacy).
/// Always fetched live from GitHub, never persisted -- see `PHASE_5_SPEC.md`
/// for why.
@freezed
sealed class PullRequestCheck with _$PullRequestCheck {
  const factory PullRequestCheck({
    required String name,
    required PrCheckConclusion conclusion,
    String? detailsUrl,
  }) = _PullRequestCheck;

  factory PullRequestCheck.fromJson(Map<String, Object?> json) =>
      _$PullRequestCheckFromJson(json);
}
