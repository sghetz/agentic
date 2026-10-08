import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/source_kind.dart';

part 'create_source_request.freezed.dart';
part 'create_source_request.g.dart';

@freezed
sealed class CreateSourceRequest with _$CreateSourceRequest {
  const factory CreateSourceRequest({
    required SourceKind kind,
    @Default({}) Map<String, Object?> config,
    String? projectId,
  }) = _CreateSourceRequest;

  factory CreateSourceRequest.fromJson(Map<String, Object?> json) =>
      _$CreateSourceRequestFromJson(json);
}
