import 'dart:convert';

import 'package:core/core.dart' as core;

import '../repositories/org_store.dart';
import 'analyst_extraction_service.dart';
import 'connector_oauth_service.dart';
import 'connector_registry.dart';
import 'message_routing_service.dart';

class NotConnected implements Exception {
  NotConnected(this.connectorId);

  final String connectorId;

  @override
  String toString() => 'NotConnected($connectorId)';
}

class ConnectorSyncResult {
  const ConnectorSyncResult({
    required this.newMessages,
    required this.routedMessages,
    required this.unroutedMessages,
    required this.specsCreated,
    required this.failedMessageIds,
  });

  /// Entries fetched for the first time this sync (re-running never
  /// re-imports or re-routes a message it already has).
  final int newMessages;

  /// New messages that got a project assigned -- either the source was
  /// already project-scoped, or routing confidence met the threshold.
  final int routedMessages;

  /// New messages left unrouted (confidence below threshold, or routing
  /// failed) -- waiting on the owner to assign a project manually.
  final int unroutedMessages;

  final int specsCreated;
  final List<String> failedMessageIds;
}

/// Syncs one `oauthConnector` [core.Source]: fetches whatever's new via its
/// adapter, routes/extracts exactly like `WhatsAppImportService` does with
/// its own raw format, and stores the result as [core.Message]s. The only
/// connector-specific step is the adapter call -- everything after that is
/// the same generic pipeline every message source in this codebase shares.
class ConnectorSyncService {
  const ConnectorSyncService({
    required ConnectorRegistry registry,
    required ConnectorOAuthService oauth,
    MessageRoutingService routingService = const MessageRoutingService(),
    AnalystExtractionService extractionService =
        const AnalystExtractionService(),
    this.confidenceThreshold = 0.7,
  }) : _registry = registry,
       _oauth = oauth,
       _routingService = routingService,
       _extractionService = extractionService;

  final ConnectorRegistry _registry;
  final ConnectorOAuthService _oauth;
  final MessageRoutingService _routingService;
  final AnalystExtractionService _extractionService;
  final double confidenceThreshold;

  Future<ConnectorSyncResult> sync({
    required String orgId,
    required core.Source source,
    required OrgStore store,
  }) async {
    if (source.kind != core.SourceKind.oauthConnector) {
      throw ArgumentError(
        'ConnectorSyncService.sync only supports oauthConnector sources, '
        'got ${source.kind}',
      );
    }
    final connectorId = source.config['connectorId'] as String?;
    if (connectorId == null) {
      throw ArgumentError(
        'oauthConnector source config is missing connectorId',
      );
    }
    final adapter = _registry.adapterFor(connectorId);
    if (adapter == null) throw UnknownConnector(connectorId);

    final accessToken = await _oauth.getValidAccessToken(
      orgId: orgId,
      connectorId: connectorId,
    );
    if (accessToken == null) throw NotConnected(connectorId);

    final existing = await store.listMessages(sourceId: source.id);
    final existingExternalIds = existing.map((m) => m.externalId).toSet();
    DateTime? since;
    for (final message in existing) {
      if (since == null || message.sentAt.isAfter(since)) {
        since = message.sentAt;
      }
    }

    final fetched = await adapter.fetchSince(accessToken, since);

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

    for (final entry in fetched) {
      final isNew = !existingExternalIds.contains(entry.externalId);

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
        externalId: entry.externalId,
        author: entry.author,
        sentAt: entry.sentAt,
        body: entry.body,
        raw: entry.raw,
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

    return ConnectorSyncResult(
      newMessages: newMessages,
      routedMessages: routedMessages,
      unroutedMessages: unroutedMessages,
      specsCreated: specsCreated,
      failedMessageIds: failedMessageIds,
    );
  }
}
