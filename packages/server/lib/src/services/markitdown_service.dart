import 'dart:io';

class MarkItDownException implements Exception {
  MarkItDownException(this.message);
  final String message;

  @override
  String toString() => 'MarkItDownException: $message';
}

/// Thin wrapper over the `markitdown` CLI (pip package `markitdown`).
/// Deterministic, no LLM involvement -- converts a document (pdf, docx,
/// pptx, etc.) to plain markdown text. The Analyst's extraction is a
/// separate, later step over that text.
class MarkItDownService {
  const MarkItDownService();

  Future<String> convertToMarkdown(String filePath) async {
    final result = await Process.run('markitdown', [filePath]);
    if (result.exitCode != 0) {
      throw MarkItDownException(
        'markitdown failed for $filePath: ${result.stderr}',
      );
    }
    return result.stdout as String;
  }
}
