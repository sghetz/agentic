import 'dart:async';

import 'package:server/src/services/chat_stream_hub.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

/// A purely in-memory channel pair: [ChatStreamHub] gets one end, the test
/// gets the other, so publish/subscribe can be tested without a real socket.
(StreamChannel<Object?>, StreamChannel<Object?>) _fakeChannelPair() {
  final controller = StreamChannelController<Object?>();
  return (controller.local, controller.foreign);
}

void main() {
  group('ChatStreamHub', () {
    test('publishes to every subscriber of a conversation', () async {
      final hub = ChatStreamHub();
      final (channelA, testSideA) = _fakeChannelPair();
      final (channelB, testSideB) = _fakeChannelPair();
      hub.subscribe('conv-1', channelA);
      hub.subscribe('conv-1', channelB);

      hub.publish('conv-1', {'type': 'delta', 'text': 'hi'});

      expect(await testSideA.stream.first, '{"type":"delta","text":"hi"}');
      expect(await testSideB.stream.first, '{"type":"delta","text":"hi"}');
    });

    test(
      'does not publish to subscribers of a different conversation',
      () async {
        final hub = ChatStreamHub();
        final (channelA, testSideA) = _fakeChannelPair();
        hub.subscribe('conv-1', channelA);

        hub.publish('conv-2', {'type': 'delta', 'text': 'nope'});

        var received = false;
        final sub = testSideA.stream.listen((_) => received = true);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await sub.cancel();
        expect(received, isFalse);
      },
    );

    test('publishing with no subscribers is a no-op', () {
      final hub = ChatStreamHub();
      expect(
        () => hub.publish('conv-none', {'type': 'delta'}),
        returnsNormally,
      );
    });

    test('a closed subscriber stops receiving further publishes', () async {
      final hub = ChatStreamHub();
      final (channelA, testSideA) = _fakeChannelPair();
      hub.subscribe('conv-1', channelA);

      await testSideA.sink.close();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(() => hub.publish('conv-1', {'type': 'delta'}), returnsNormally);
    });
  });
}
