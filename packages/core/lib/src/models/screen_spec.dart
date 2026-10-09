import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/screen_ui_state.dart';

part 'screen_spec.freezed.dart';
part 'screen_spec.g.dart';

/// One screen within a [DesignSpec]. [navigatesTo] names other screens in
/// the same spec (not arbitrary free text) -- together these edges are what
/// [DesignSpec]'s companion Mermaid diagram draws.
@freezed
sealed class ScreenSpec with _$ScreenSpec {
  const factory ScreenSpec({
    required String name,
    required String purpose,
    @Default([]) List<ScreenUiState> states,
    @Default([]) List<String> navigatesTo,
  }) = _ScreenSpec;

  factory ScreenSpec.fromJson(Map<String, Object?> json) =>
      _$ScreenSpecFromJson(json);
}
