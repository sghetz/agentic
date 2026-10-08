import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart' as core;

import '../repositories/org_store.dart';
import 'analyst_extraction_service.dart';
import 'markitdown_service.dart';

class ErfImportResult {
  const ErfImportResult({
    required this.newMessages,
    required this.specsCreated,
    required this.failedFiles,
  });

  /// Files seen for the first time this scan (already-imported files are
  /// skipped without incrementing this, even if their extraction is retried).
  final int newMessages;
  final int specsCreated;
  final List<String> failedFiles;
}

/// Scans an `erf`-kind [core.Source]'s configured folder, converts each file
/// to markdown via `markitdown`, and drafts a Task Spec from it. One file ->
/// one message -> one Task Spec for this first cut, even though a real ERF
/// document often contains several distinct requirements -- splitting one
/// document into multiple specs is a reasonable later refinement, not
/// needed to meet this phase's "Done when" bar.
///
/// Idempotent: re-running a scan never re-imports a file it already has a
/// message for, and never re-drafts a spec for a message it already
/// successfully processed -- but it *does* retry extraction for a message
/// whose previous extraction attempt failed, since nothing was persisted for
/// it then.
class ErfImportService {
  const ErfImportService({
    MarkItDownService markItDown = const MarkItDownService(),
    AnalystExtractionService extractionService =
        const AnalystExtractionService(),
  }) : _markItDown = markItDown,
       _extractionService = extractionService;

  final MarkItDownService _markItDown;
  final AnalystExtractionService _extractionService;

  Future<ErfImportResult> scan({
    required core.Source source,
    required OrgStore store,
  }) async {
    if (source.kind != core.SourceKind.erf) {
      throw ArgumentError(
        'ErfImportService.scan only supports erf sources, got ${source.kind}',
      );
    }
    final projectId = source.projectId;
    if (projectId == null) {
      throw ArgumentError('ERF sources must be project-scoped');
    }
    final folderPath = source.config['folderPath'] as String?;
    if (folderPath == null || folderPath.isEmpty) {
      throw ArgumentError('ERF source config is missing folderPath');
    }

    final dir = Directory(folderPath);
    if (!await dir.exists()) {
      throw ArgumentError('ERF folder does not exist: $folderPath');
    }

    final existingExternalIds = (await store.listMessages(
      sourceId: source.id,
    )).map((m) => m.externalId).toSet();

    var newMessages = 0;
    var specsCreated = 0;
    final failedFiles = <String>[];

    final files = await dir
        .list()
        .where((entry) => entry is File)
        .cast<File>()
        .toList();

    for (final file in files) {
      String markdown;
      try {
        markdown = await _markItDown.convertToMarkdown(file.path);
      } catch (_) {
        failedFiles.add(file.path);
        continue;
      }

      final isNew = !existingExternalIds.contains(file.path);
      final stat = await file.stat();
      final message = await store.getOrCreateMessage(
        sourceId: source.id,
        externalId: file.path,
        sentAt: stat.modified.toUtc(),
        body: markdown,
        raw: {'filePath': file.path, 'fileSizeBytes': stat.size},
      );
      if (isNew) newMessages++;
      if (message.processedAt != null) continue;

      final spec = await _extractionService.extract(
        projectId: projectId,
        rawText: markdown,
      );
      if (spec == null) {
        failedFiles.add(file.path);
        continue;
      }

      await store.createProjectArtifact(
        projectId,
        kind: core.ArtifactKind.taskSpec,
        uri: 'task-spec:$projectId:${DateTime.now().toUtc().toIso8601String()}',
        content: jsonEncode(
          spec.copyWith(sourceMessageId: message.id).toJson(),
        ),
      );
      await store.markMessageProcessed(message.id);
      specsCreated++;
    }

    return ErfImportResult(
      newMessages: newMessages,
      specsCreated: specsCreated,
      failedFiles: failedFiles,
    );
  }
}
