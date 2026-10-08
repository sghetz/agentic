import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

/// One raw incoming item from a [Source] -- a chat message, or a document
/// (an ERF file's extracted text stands in for a message body). Unrouted
/// ([routedProjectId] null) means either the source already ties it to a
/// project directly, or it's still waiting on routing/manual assignment.
/// [processedAt] is set once a Task Spec has been drafted from it, so a
/// repeat scan of the same source never redrafts a spec for the same item.
@freezed
sealed class Message with _$Message {
  const factory Message({
    required String id,
    required String sourceId,
    required String externalId,
    String? author,
    required DateTime sentAt,
    required String body,
    required Map<String, Object?> raw,
    String? routedProjectId,
    double? routingConfidence,
    DateTime? processedAt,
  }) = _Message;

  factory Message.fromJson(Map<String, Object?> json) =>
      _$MessageFromJson(json);
}
