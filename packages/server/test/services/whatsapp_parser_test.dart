import 'package:server/src/services/whatsapp_parser.dart';
import 'package:test/test.dart';

void main() {
  group('parseWhatsAppExport', () {
    test('parses iOS-style timestamped lines', () {
      final messages = parseWhatsAppExport(
        '[1/3/26, 09:15:00] Alice: can someone look at the export bug?\n'
        '[1/3/26, 09:16:30] Bob: sure, on it',
      );

      expect(messages, hasLength(2));
      expect(messages[0].author, 'Alice');
      expect(messages[0].body, 'can someone look at the export bug?');
      expect(messages[0].sentAt, DateTime(2026, 3, 1, 9, 15, 0));
      expect(messages[1].author, 'Bob');
      expect(messages[1].sentAt, DateTime(2026, 3, 1, 9, 16, 30));
    });

    test('parses Android-style timestamped lines', () {
      final messages = parseWhatsAppExport(
        '1/3/26, 09:15 - Alice: can someone look at the export bug?',
      );

      expect(messages, hasLength(1));
      expect(messages.single.author, 'Alice');
      expect(messages.single.sentAt, DateTime(2026, 3, 1, 9, 15, 0));
    });

    test('joins continuation lines onto the previous message', () {
      final messages = parseWhatsAppExport(
        '[1/3/26, 09:15:00] Alice: here is the issue:\n'
        'it crashes on export\n'
        'every time',
      );

      expect(messages, hasLength(1));
      expect(
        messages.single.body,
        'here is the issue:\nit crashes on export\nevery time',
      );
    });

    test('skips a timestamped system notice without an author:body split', () {
      final messages = parseWhatsAppExport(
        '[1/3/26, 09:00:00] Messages and calls are end-to-end encrypted.\n'
        '[1/3/26, 09:15:00] Alice: can someone look at the export bug?',
      );

      expect(messages, hasLength(1));
      expect(messages.single.author, 'Alice');
    });

    test(
      'a system notice between two real messages is not merged into either',
      () {
        final messages = parseWhatsAppExport(
          '[1/3/26, 09:15:00] Alice: first message\n'
          '[1/3/26, 09:16:00] Bob created group "Project"\n'
          '[1/3/26, 09:17:00] Alice: second message',
        );

        expect(messages, hasLength(2));
        expect(messages[0].body, 'first message');
        expect(messages[1].body, 'second message');
      },
    );

    test('ignores blank lines', () {
      final messages = parseWhatsAppExport(
        '[1/3/26, 09:15:00] Alice: hello\n\n\n[1/3/26, 09:16:00] Bob: hi',
      );
      expect(messages, hasLength(2));
    });

    test('an author name containing no colon is handled', () {
      final messages = parseWhatsAppExport(
        '[1/3/26, 09:15:00] Alice Smith: hello there',
      );
      expect(messages.single.author, 'Alice Smith');
      expect(messages.single.body, 'hello there');
    });

    test('returns an empty list for an empty export', () {
      expect(parseWhatsAppExport(''), isEmpty);
    });

    test('a leading continuation line with no prior message is dropped', () {
      final messages = parseWhatsAppExport(
        'stray line with no timestamp\n'
        '[1/3/26, 09:15:00] Alice: hello',
      );
      expect(messages, hasLength(1));
      expect(messages.single.body, 'hello');
    });
  });
}
