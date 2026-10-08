import 'dart:convert';

import 'package:core/core.dart' as core;

import '../repositories/org_store.dart';
import 'analyst_extraction_service.dart';
import 'message_routing_service.dart';
import 'whatsapp_parser.dart';

class WhatsAppImportResult {
  const WhatsAppImportResult({
    required this.newMessages,
    required this.routedMessages,
    required this.unroutedMessages,
    required this.specsCreated,
    required this.failedMessageIds,
  });

  /// Entries seen for the first time this import (a re-paste of the same
  /// export text never re-imports or re-routes an entry it already has a
  /// message for).
  final int newMessages;

  /// New entries that got a project assigned -- either the source was
  /// already project-scoped, or routing confidence met the threshold.
  final int routedMessages;

  /// New entries left unrouted (routing confidence below threshold, or
  /// routing failed) -- waiting on the owner to assign a project manually.
  final int unroutedMessages;

  final int specsCreated;
  final List<String> failedMessageIds;
}

/// Imports a manually-exported WhatsApp chat (paste or upload) into
/// [core.Message] rows, routing each new one to a project when the source
/// itself isn't already project-scoped, then drafting a Task Spec from
/// anything that ends up routed -- same extraction step `ErfImportService`
/// uses. A message below the confidence threshold is left unrouted rather
/// than guessed; the owner assigns a project to it manually (a later slice's
/// UI concern, not this service's).
class WhatsAppImportService {
  const WhatsAppImportService({
    MessageRoutingService routingService = const MessageRoutingService(),
    AnalystExtractionService extractionService =
        const AnalystExtractionService(),
    this.confidenceThreshold = 0.7,
  }) : _routingService = routingService,
       _extractionService = extractionService;

  final MessageRoutingService _routingService;
  final AnalystExtractionService _extractionService;
  final double confidenceThreshold;

  Future<WhatsAppImportResult> import({
    required core.Source source,
    required String exportText,
    required OrgStore store,
  }) async {
    if (source.kind != core.SourceKind.whatsappImport) {
      throw ArgumentError(
        'WhatsAppImportService.import only supports whatsappImport sources, '
        'got ${source.kind}',
      );
    }

    final parsed = parseWhatsAppExport(exportText);
    final existingExternalIds = (await store.listMessages(
      sourceId: source.id,
    )).map((m) => m.externalId).toSet();

    // Only fetch the project list (needed for routing) if this source
    // actually needs routing -- a project-scoped source never calls the
    // routing service at all.
    final projects = source.projectId == null
        ? await store.listProjects()
        : const <core.Project>[];

    var newMessages = 0;
    var routedMessages = 0;
    var unroutedMessages = 0;
    var specsCreated = 0;
    final failedMessageIds = <String>[];

    for (final entry in parsed) {
      final externalId =
          '${entry.sentAt.toIso8601String()}::${entry.author}::${entry.body}';
      final isNew = !existingExternalIds.contains(externalId);

      String? routedProjectId;
      double? confidence;
      if (isNew) {
        if (source.projectId != null) {
          routedProjectId = source.projectId;
        } else {
          final result = await _routingService.route(
            messageBody: entry.body,
            projects: projects,
          );
          if (result != null) {
            confidence = result.confidence;
            if (result.confidence >= confidenceThreshold) {
              routedProjectId = result.projectId;
            }
          }
        }
      }

      final message = await store.getOrCreateMessage(
        sourceId: source.id,
        externalId: externalId,
        author: entry.author,
        sentAt: entry.sentAt,
        body: entry.body,
        raw: const {},
        routedProjectId: routedProjectId,
        routingConfidence: confidence,
      );

      if (!isNew) continue;
      newMessages++;

      final effectiveProjectId = message.routedProjectId;
      if (effectiveProjectId == null) {
        unroutedMessages++;
        continue;
      }
      routedMessages++;

      final spec = await _extractionService.extract(
        projectId: effectiveProjectId,
        rawText: message.body,
      );
      if (spec == null) {
        failedMessageIds.add(message.id);
        continue;
      }

      await store.createProjectArtifact(
        effectiveProjectId,
        kind: core.ArtifactKind.taskSpec,
        uri:
            'task-spec:$effectiveProjectId:${DateTime.now().toUtc().toIso8601String()}',
        content: jsonEncode(
          spec.copyWith(sourceMessageId: message.id).toJson(),
        ),
      );
      await store.markMessageProcessed(message.id);
      specsCreated++;
    }

    return WhatsAppImportResult(
      newMessages: newMessages,
      routedMessages: routedMessages,
      unroutedMessages: unroutedMessages,
      specsCreated: specsCreated,
      failedMessageIds: failedMessageIds,
    );
  }
}
