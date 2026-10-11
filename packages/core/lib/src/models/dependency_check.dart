import 'package:freezed_annotation/freezed_annotation.dart';

part 'dependency_check.freezed.dart';
part 'dependency_check.g.dart';

/// Whether one external CLI dependency (`git`, `flutter`, `claude`, ...) was
/// found and runnable on this machine, checked deterministically via
/// `Process.run` -- never an LLM call. Shown on first run (and whenever the
/// owner re-checks) so a missing dependency surfaces as a clear message
/// instead of a confusing failure deep inside a Health check or agent run.
@freezed
sealed class DependencyCheck with _$DependencyCheck {
  const factory DependencyCheck({
    required String name,
    required bool found,
    String? version,
    String? error,
  }) = _DependencyCheck;

  factory DependencyCheck.fromJson(Map<String, Object?> json) =>
      _$DependencyCheckFromJson(json);
}
