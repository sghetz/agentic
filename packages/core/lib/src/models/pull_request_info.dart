import 'package:freezed_annotation/freezed_annotation.dart';

part 'pull_request_info.freezed.dart';
part 'pull_request_info.g.dart';

/// Metadata for a PR the Developer opened, stored as the task-scoped `pr`
/// artifact's `content`. [branch]/[baseBranch] let later steps (Reviewer,
/// merge) find the same worktree/checkout without re-deriving them from the
/// PR number via another GitHub call.
@freezed
sealed class PullRequestInfo with _$PullRequestInfo {
  const factory PullRequestInfo({
    required int number,
    required String url,
    required String branch,
    required String baseBranch,
  }) = _PullRequestInfo;

  factory PullRequestInfo.fromJson(Map<String, Object?> json) =>
      _$PullRequestInfoFromJson(json);
}
