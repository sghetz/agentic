import 'dart:convert';

import 'package:stream_channel/stream_channel.dart';

/// In-memory pub/sub between the conversation WebSocket route and the
/// message-posting route: when a chat turn is running, delta/done events
/// get published here and forwarded to whichever sockets are currently
/// subscribed to that conversation. Nothing here is persisted -- streaming
/// only improves the live UX, per the Phase 2 decision that the full reply
/// is always written to `chat_messages` regardless of whether anyone is
/// watching. One instance is shared process-wide via [AppContext], since a
/// conversation's subscribers and its in-flight turn are handled by
/// different HTTP requests.
class ChatStreamHub {
  final _subscribers = <String, Set<StreamChannel<dynamic>>>{};

  /// [channel] is typed as the generic [StreamChannel] rather than
  /// `WebSocketChannel` specifically (which satisfies this interface) so
  /// tests can subscribe a purely in-memory channel pair instead of a real
  /// socket.
  void subscribe(String conversationId, StreamChannel<dynamic> channel) {
    final set = _subscribers.putIfAbsent(conversationId, () => {});
    set.add(channel);
    channel.stream.listen(
      (_) {},
      onDone: () => _unsubscribe(conversationId, channel),
      onError: (_) => _unsubscribe(conversationId, channel),
    );
  }

  void _unsubscribe(String conversationId, StreamChannel<dynamic> channel) {
    final set = _subscribers[conversationId];
    if (set == null) return;
    set.remove(channel);
    if (set.isEmpty) _subscribers.remove(conversationId);
  }

  void publish(String conversationId, Map<String, Object?> event) {
    final set = _subscribers[conversationId];
    if (set == null || set.isEmpty) return;
    final payload = jsonEncode(event);
    for (final channel in set) {
      channel.sink.add(payload);
    }
  }
}
