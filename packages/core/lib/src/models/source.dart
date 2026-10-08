import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/source_kind.dart';

part 'source.freezed.dart';
part 'source.g.dart';

/// Where incoming work messages come from. [projectId] is set when this
/// source is already tied to one project (e.g. an ERF folder configured for
/// that project) and null when it's an org-level source whose messages need
/// per-message routing (e.g. a shared chat spanning multiple projects).
@freezed
sealed class Source with _$Source {
  const factory Source({
    required String id,
    required SourceKind kind,
    required Map<String, Object?> config,
    String? projectId,
    required DateTime createdAt,
  }) = _Source;

  factory Source.fromJson(Map<String, Object?> json) => _$SourceFromJson(json);
}
