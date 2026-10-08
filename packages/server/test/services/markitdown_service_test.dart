import 'dart:io';

import 'package:server/src/services/markitdown_service.dart';
import 'package:test/test.dart';

void main() {
  late Directory tmp;
  const service = MarkItDownService();

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('agentic_markitdown_test_');
  });

  tearDown(() => tmp.delete(recursive: true));

  test('converts a plain text file to markdown', () async {
    final file = File('${tmp.path}/note.txt');
    await file.writeAsString(
      '# Password Reset Feature (RF-07)\n\n'
      'Users must be able to reset their password via an emailed link.',
    );

    final markdown = await service.convertToMarkdown(file.path);

    expect(markdown, contains('Password Reset Feature'));
    expect(markdown, contains('RF-07'));
  });

  test('throws MarkItDownException for a nonexistent file', () async {
    expect(
      () => service.convertToMarkdown('${tmp.path}/does-not-exist.txt'),
      throwsA(isA<MarkItDownException>()),
    );
  });
}
