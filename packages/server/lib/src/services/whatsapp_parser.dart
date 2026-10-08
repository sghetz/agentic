/// One parsed entry from a WhatsApp chat export. [sentAt] assumes DD/MM/YY
/// dates (the more common international convention) -- WhatsApp's export
/// format doesn't carry the phone's locale, so a MM/DD/YY export will parse
/// with the day and month swapped. A known limitation, not handled here.
class ParsedWhatsAppMessage {
  const ParsedWhatsAppMessage({
    required this.sentAt,
    required this.author,
    required this.body,
  });

  final DateTime sentAt;
  final String author;
  final String body;
}

// iOS export: "[DD/MM/YY, HH:MM:SS] Author: message"
final _iosPattern = RegExp(
  r'^\[(\d{1,2}/\d{1,2}/\d{2,4}), (\d{1,2}:\d{2}:\d{2})\] (.*)$',
);

// Android export: "DD/MM/YY, HH:MM - Author: message"
final _androidPattern = RegExp(
  r'^(\d{1,2}/\d{1,2}/\d{2,4}), (\d{1,2}:\d{2}) - (.*)$',
);

final _authorAndBody = RegExp(r'^([^:]+): (.*)$');

/// Parses a WhatsApp "export chat" text file into individual messages.
/// Multi-line messages (no leading timestamp on continuation lines) are
/// joined onto the previous message's body. A timestamped line with no
/// `author: body` split (WhatsApp's own system notices, e.g. "Messages and
/// calls are end-to-end encrypted.") is skipped entirely -- it's not a
/// continuation of the previous message, and it's not a real message either.
List<ParsedWhatsAppMessage> parseWhatsAppExport(String text) {
  final messages = <ParsedWhatsAppMessage>[];

  for (final rawLine in text.split('\n')) {
    final line = rawLine.trimRight();
    if (line.isEmpty) continue;

    final iosMatch = _iosPattern.firstMatch(line);
    final androidMatch = iosMatch == null
        ? _androidPattern.firstMatch(line)
        : null;
    final match = iosMatch ?? androidMatch;

    if (match != null) {
      final dateStr = match.group(1)!;
      final timeStr = match.group(2)!;
      final rest = match.group(3)!;
      final sentAt = _parseDateTime(dateStr, timeStr);

      final authorBody = _authorAndBody.firstMatch(rest);
      if (sentAt != null && authorBody != null) {
        messages.add(
          ParsedWhatsAppMessage(
            sentAt: sentAt,
            author: authorBody.group(1)!.trim(),
            body: authorBody.group(2)!.trim(),
          ),
        );
      }
      // A timestamped line without an "author: body" split is a system
      // notice -- skip it, and don't treat it as a continuation either.
      continue;
    }

    // No timestamp prefix: a continuation of the previous real message.
    if (messages.isNotEmpty) {
      final previous = messages.removeLast();
      messages.add(
        ParsedWhatsAppMessage(
          sentAt: previous.sentAt,
          author: previous.author,
          body: '${previous.body}\n$line',
        ),
      );
    }
  }

  return messages;
}

DateTime? _parseDateTime(String dateStr, String timeStr) {
  final dateParts = dateStr.split('/');
  if (dateParts.length != 3) return null;
  final day = int.tryParse(dateParts[0]);
  final month = int.tryParse(dateParts[1]);
  var year = int.tryParse(dateParts[2]);
  if (day == null || month == null || year == null) return null;
  if (year < 100) year += 2000;

  final timeParts = timeStr.split(':');
  final hour = int.tryParse(timeParts[0]);
  final minute = int.tryParse(timeParts[1]);
  final second = timeParts.length > 2 ? int.tryParse(timeParts[2]) : 0;
  if (hour == null || minute == null || second == null) return null;

  if (month < 1 || month > 12 || day < 1 || day > 31) return null;
  return DateTime(year, month, day, hour, minute, second);
}
