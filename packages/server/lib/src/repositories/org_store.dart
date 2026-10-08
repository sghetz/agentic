import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:drift/drift.dart';
import 'package:sqlite3/sqlite3.dart' show SqliteException;

import '../storage/org_database.dart';

class ProjectNotFound implements Exception {
  ProjectNotFound(this.id);
  final String id;

  @override
  String toString() => 'ProjectNotFound($id)';
}

class TaskNotFound implements Exception {
  TaskNotFound(this.id);
  final String id;

  @override
  String toString() => 'TaskNotFound($id)';
}

class ConversationNotFound implements Exception {
  ConversationNotFound(this.id);
  final String id;

  @override
  String toString() => 'ConversationNotFound($id)';
}

class SourceNotFound implements Exception {
  SourceNotFound(this.id);
  final String id;

  @override
  String toString() => 'SourceNotFound($id)';
}

class MessageNotFound implements Exception {
  MessageNotFound(this.id);
  final String id;

  @override
  String toString() => 'MessageNotFound($id)';
}

class DuplicateProjectSlug implements Exception {
  DuplicateProjectSlug(this.slug);
  final String slug;

  @override
  String toString() => 'DuplicateProjectSlug($slug)';
}

/// A project link named a `toProjectId` that doesn't exist in this org's
/// database -- either a typo, or (per the non-negotiable isolation rule) a
/// project that belongs to a different organization. Both look identical
/// from here, which is the point: this store has no way to even see
/// another org's projects.
class CrossOrgLinkRejected implements Exception {
  CrossOrgLinkRejected(this.toProjectId);
  final String toProjectId;

  @override
  String toString() => 'CrossOrgLinkRejected($toProjectId)';
}

class InvalidTaskTransition implements Exception {
  InvalidTaskTransition(this.from, this.attempted, this.allowed);
  final core.TaskStatus from;
  final core.TaskStatus attempted;
  final Set<core.TaskStatus> allowed;

  @override
  String toString() =>
      'InvalidTaskTransition($from -> $attempted, allowed: $allowed)';
}

/// Everything scoped to one organization, opened against that org's own
/// `orgs/<orgId>/data.db`. No method here (or anywhere) accepts a second
/// orgId -- cross-org access is structurally impossible, not just checked.
class OrgStore {
  OrgStore(this.orgId, this._db);

  final String orgId;
  final OrgDatabase _db;

  Future<void> close() => _db.close();

  // ---- Projects ----

  Future<core.Project> createProject(core.CreateProjectRequest request) async {
    final id = core.newId();
    final now = DateTime.now().toUtc();
    try {
      await _db
          .into(_db.projects)
          .insert(
            ProjectsCompanion.insert(
              id: id,
              name: request.name,
              slug: request.slug,
              reposJson: jsonEncode(
                request.repos.map((r) => r.toJson()).toList(),
              ),
              status: core.ProjectStatus.active,
              createdAt: now,
              flutterVersion: Value(request.flutterVersion),
              designSystemRef: Value(request.designSystemRef),
            ),
          );
    } on SqliteException catch (e) {
      if (e.message.contains('UNIQUE constraint failed')) {
        throw DuplicateProjectSlug(request.slug);
      }
      rethrow;
    }
    return (await getProject(id))!;
  }

  Future<core.Project?> getProject(String id) async {
    final row = await (_db.select(
      _db.projects,
    )..where((p) => p.id.equals(id))).getSingleOrNull();
    return row == null ? null : _projectToModel(row);
  }

  Future<List<core.Project>> listProjects({
    bool includeArchived = false,
  }) async {
    final select = _db.select(_db.projects);
    if (!includeArchived) {
      select.where(
        (p) => p.status.equalsValue(core.ProjectStatus.archived).not(),
      );
    }
    final rows = await select.get();
    return rows.map(_projectToModel).toList();
  }

  Future<core.Project> updateProject(
    String id,
    core.UpdateProjectRequest request,
  ) async {
    if (await getProject(id) == null) throw ProjectNotFound(id);

    try {
      await (_db.update(_db.projects)..where((p) => p.id.equals(id))).write(
        ProjectsCompanion(
          name: request.name == null
              ? const Value.absent()
              : Value(request.name!),
          slug: request.slug == null
              ? const Value.absent()
              : Value(request.slug!),
          reposJson: request.repos == null
              ? const Value.absent()
              : Value(
                  jsonEncode(request.repos!.map((r) => r.toJson()).toList()),
                ),
          flutterVersion: request.flutterVersion == null
              ? const Value.absent()
              : Value(request.flutterVersion),
          designSystemRef: request.designSystemRef == null
              ? const Value.absent()
              : Value(request.designSystemRef),
          status: request.status == null
              ? const Value.absent()
              : Value(request.status!),
        ),
      );
    } on SqliteException catch (e) {
      if (e.message.contains('UNIQUE constraint failed')) {
        throw DuplicateProjectSlug(request.slug!);
      }
      rethrow;
    }
    return (await getProject(id))!;
  }

  Future<core.Project> archiveProject(String id) async {
    if (await getProject(id) == null) throw ProjectNotFound(id);

    final now = DateTime.now().toUtc();
    await (_db.update(_db.projects)..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(
        status: Value(core.ProjectStatus.archived),
        archivedAt: Value(now),
      ),
    );
    return (await getProject(id))!;
  }

  // ---- Project links ----

  Future<core.ProjectLink> createProjectLink(
    String fromProjectId,
    core.CreateProjectLinkRequest request,
  ) async {
    if (await getProject(fromProjectId) == null) {
      throw ProjectNotFound(fromProjectId);
    }
    if (await getProject(request.toProjectId) == null) {
      throw CrossOrgLinkRejected(request.toProjectId);
    }

    final id = core.newId();
    await _db
        .into(_db.projectLinks)
        .insert(
          ProjectLinksCompanion.insert(
            id: id,
            fromProjectId: fromProjectId,
            toProjectId: request.toProjectId,
            relation: request.relation,
          ),
        );
    final row = await (_db.select(
      _db.projectLinks,
    )..where((l) => l.id.equals(id))).getSingle();
    return _linkToModel(row);
  }

  Future<List<core.ProjectLink>> listProjectLinks(String projectId) async {
    final rows = await (_db.select(
      _db.projectLinks,
    )..where((l) => l.fromProjectId.equals(projectId))).get();
    return rows.map(_linkToModel).toList();
  }

  Future<void> deleteProjectLink(String projectId, String linkId) async {
    final deleted =
        await (_db.delete(_db.projectLinks)..where(
              (l) => l.id.equals(linkId) & l.fromProjectId.equals(projectId),
            ))
            .go();
    if (deleted == 0) throw ProjectNotFound(linkId);
  }

  // ---- Tasks ----

  Future<core.Task> createTask(
    String projectId,
    core.CreateTaskRequest request,
  ) async {
    if (await getProject(projectId) == null) throw ProjectNotFound(projectId);

    final id = core.newId();
    final now = DateTime.now().toUtc();
    await _db.transaction(() async {
      await _db
          .into(_db.tasks)
          .insert(
            TasksCompanion.insert(
              id: id,
              projectId: projectId,
              title: request.title,
              currentStatus: core.TaskStatus.newTask,
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _insertEvent(
        taskId: id,
        ts: now,
        actor: const core.Actor.user(),
        eventType: core.TaskEventType.created,
        payload: const {},
      );
    });
    return (await getTask(id))!;
  }

  Future<core.Task?> getTask(String id, {DateTime? at}) async {
    final row = await (_db.select(
      _db.tasks,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    if (at == null) return _taskToModel(row);

    final events = await listTaskEvents(id);
    final state = core.deriveTaskAt(events, at);
    return core.Task(
      id: row.id,
      projectId: row.projectId,
      title: row.title,
      currentStatus: state.status,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  /// All tasks in this org, across every project. Used by the dashboard,
  /// which needs org-wide counts rather than a single project's tasks.
  Future<List<core.Task>> listAllTasks() async {
    final rows = await _db.select(_db.tasks).get();
    return rows.map(_taskToModel).toList();
  }

  /// Most recent events across every task in this org, newest first. Used
  /// to build the dashboard's recent-activity feed.
  Future<List<core.TaskEvent>> listRecentEvents({int limit = 20}) async {
    final rows =
        await (_db.select(_db.taskEvents)
              ..orderBy([(e) => OrderingTerm.desc(e.ts)])
              ..limit(limit))
            .get();
    return rows.map(_eventToModel).toList();
  }

  Future<List<core.Task>> listTasks(
    String projectId, {
    core.TaskStatus? status,
    DateTime? from,
    DateTime? to,
    String? query,
  }) async {
    final select = _db.select(_db.tasks)
      ..where((t) => t.projectId.equals(projectId));
    if (status != null) {
      select.where((t) => t.currentStatus.equalsValue(status));
    }
    if (from != null) {
      select.where((t) => t.createdAt.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      select.where((t) => t.createdAt.isSmallerOrEqualValue(to));
    }
    if (query != null && query.isNotEmpty) {
      select.where((t) => t.title.like('%$query%'));
    }
    final rows = await select.get();
    return rows.map(_taskToModel).toList();
  }

  /// Validates the transition against the task's derived state, appends
  /// the event, and rewrites the `tasks.currentStatus`/`updatedAt` cache
  /// from the fold -- all inside one transaction.
  Future<core.TaskEvent> appendTaskEvent(
    String taskId,
    core.CreateTaskEventRequest request,
  ) async {
    final taskRow = await (_db.select(
      _db.tasks,
    )..where((t) => t.id.equals(taskId))).getSingleOrNull();
    if (taskRow == null) throw TaskNotFound(taskId);

    final existingEvents = await listTaskEvents(taskId);
    final currentState = core.deriveTask(existingEvents);

    if (request.eventType == core.TaskEventType.statusChanged) {
      final to = core.TaskStatus.values.byName(request.payload['to'] as String);
      if (!core.canTransition(currentState, to)) {
        throw InvalidTaskTransition(
          currentState.status,
          to,
          core.allowedNextStatuses(currentState),
        );
      }
    } else if (request.eventType == core.TaskEventType.reopened) {
      if (currentState.status != core.TaskStatus.done) {
        throw InvalidTaskTransition(
          currentState.status,
          core.TaskStatus.specified,
          const {},
        );
      }
    }

    final now = DateTime.now().toUtc();
    late core.TaskEvent inserted;
    await _db.transaction(() async {
      inserted = await _insertEvent(
        taskId: taskId,
        ts: now,
        actor: request.actor,
        eventType: request.eventType,
        payload: request.payload,
      );
      final newState = core.deriveTask([...existingEvents, inserted]);
      await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
        TasksCompanion(
          currentStatus: Value(newState.status),
          updatedAt: Value(now),
        ),
      );
    });
    return inserted;
  }

  Future<List<core.TaskEvent>> listTaskEvents(String taskId) async {
    final rows =
        await (_db.select(_db.taskEvents)
              ..where((e) => e.taskId.equals(taskId))
              ..orderBy([(e) => OrderingTerm.asc(e.ts)]))
            .get();
    return rows.map(_eventToModel).toList();
  }

  Future<core.TaskEvent> _insertEvent({
    required String taskId,
    required DateTime ts,
    required core.Actor actor,
    required core.TaskEventType eventType,
    required Map<String, Object?> payload,
  }) async {
    final id = core.newId();
    await _db
        .into(_db.taskEvents)
        .insert(
          TaskEventsCompanion.insert(
            id: id,
            taskId: taskId,
            ts: ts,
            actor: actor.toStorageString(),
            eventType: eventType,
            payloadJson: jsonEncode(payload),
          ),
        );
    return core.TaskEvent(
      id: id,
      taskId: taskId,
      ts: ts,
      actor: actor,
      eventType: eventType,
      payload: payload,
    );
  }

  // ---- Artifacts (task-scoped) ----

  Future<core.Artifact> createArtifact(
    String taskId,
    core.CreateArtifactRequest request,
  ) async {
    if (await getTask(taskId) == null) throw TaskNotFound(taskId);

    final existingOfKind = (await listArtifacts(
      taskId,
    )).where((a) => a.kind == request.kind);
    final nextVersion =
        existingOfKind.fold<int>(
          0,
          (max, a) => a.version > max ? a.version : max,
        ) +
        1;

    final id = core.newId();
    final now = DateTime.now().toUtc();
    await _db
        .into(_db.artifacts)
        .insert(
          ArtifactsCompanion.insert(
            id: id,
            taskId: Value(taskId),
            kind: request.kind,
            uri: request.uri,
            version: nextVersion,
            createdAt: now,
          ),
        );
    return core.Artifact(
      id: id,
      taskId: taskId,
      kind: request.kind,
      uri: request.uri,
      version: nextVersion,
      createdAt: now,
    );
  }

  Future<List<core.Artifact>> listArtifacts(String taskId) async {
    final rows = await (_db.select(
      _db.artifacts,
    )..where((a) => a.taskId.equals(taskId))).get();
    return rows.map(_artifactToModel).toList();
  }

  // ---- Artifacts (project-scoped, e.g. Health Reports) ----

  Future<core.Artifact> createProjectArtifact(
    String projectId, {
    required core.ArtifactKind kind,
    required String uri,
    String? content,
  }) async {
    if (await getProject(projectId) == null) throw ProjectNotFound(projectId);

    final existingOfKind = (await listProjectArtifacts(projectId, kind: kind));
    final nextVersion =
        existingOfKind.fold<int>(
          0,
          (max, a) => a.version > max ? a.version : max,
        ) +
        1;

    final id = core.newId();
    final now = DateTime.now().toUtc();
    await _db
        .into(_db.artifacts)
        .insert(
          ArtifactsCompanion.insert(
            id: id,
            projectId: Value(projectId),
            kind: kind,
            uri: uri,
            content: Value(content),
            version: nextVersion,
            createdAt: now,
          ),
        );
    return core.Artifact(
      id: id,
      projectId: projectId,
      kind: kind,
      uri: uri,
      content: content,
      version: nextVersion,
      createdAt: now,
    );
  }

  Future<List<core.Artifact>> listProjectArtifacts(
    String projectId, {
    core.ArtifactKind? kind,
    int? limit,
  }) async {
    final select = _db.select(_db.artifacts)
      ..where((a) => a.projectId.equals(projectId))
      ..orderBy([(a) => OrderingTerm.desc(a.createdAt)]);
    if (kind != null) {
      select.where((a) => a.kind.equalsValue(kind));
    }
    if (limit != null) {
      select.limit(limit);
    }
    final rows = await select.get();
    return rows.map(_artifactToModel).toList();
  }

  // ---- Conversations ----

  /// Returns the one conversation for this (projectId, channel) scope,
  /// creating it if it doesn't exist yet. Channels are a fixed set the app
  /// knows about (General + one per agent role) rather than user-created
  /// entities, so callers never create a conversation explicitly -- they
  /// just ask for the one at a given scope.
  Future<core.Conversation> getOrCreateConversation({
    String? projectId,
    required core.ChatChannel channel,
  }) async {
    if (projectId != null && await getProject(projectId) == null) {
      throw ProjectNotFound(projectId);
    }

    final channelStr = channel.toStorageString();
    return _db.transaction(() async {
      final select = _db.select(_db.conversations)
        ..where((c) => c.channel.equals(channelStr))
        ..where(
          (c) => projectId == null
              ? c.projectId.isNull()
              : c.projectId.equals(projectId),
        );
      final existing = await select.getSingleOrNull();
      if (existing != null) return _conversationToModel(existing);

      final id = core.newId();
      final now = DateTime.now().toUtc();
      await _db
          .into(_db.conversations)
          .insert(
            ConversationsCompanion.insert(
              id: id,
              projectId: Value(projectId),
              channel: channelStr,
              createdAt: now,
            ),
          );
      return core.Conversation(
        id: id,
        projectId: projectId,
        channel: channel,
        createdAt: now,
      );
    });
  }

  Future<core.Conversation?> getConversation(String id) async {
    final row = await (_db.select(
      _db.conversations,
    )..where((c) => c.id.equals(id))).getSingleOrNull();
    return row == null ? null : _conversationToModel(row);
  }

  Future<core.ChatMessage> postChatMessage(
    String conversationId,
    core.CreateChatMessageRequest request,
  ) async {
    if (await getConversation(conversationId) == null) {
      throw ConversationNotFound(conversationId);
    }
    return _insertChatMessage(
      conversationId: conversationId,
      sender: const core.Actor.user(),
      content: request.content,
    );
  }

  /// Stores an agent's reply. Unlike [postChatMessage], this is never driven
  /// by an HTTP request body -- callers are the services that actually run
  /// an agent turn (e.g. [ClaudeConversationService]), not the chat UI.
  Future<core.ChatMessage> postAgentChatMessage(
    String conversationId, {
    required String role,
    required String content,
  }) {
    return _insertChatMessage(
      conversationId: conversationId,
      sender: core.Actor.agent(role),
      content: content,
    );
  }

  Future<core.ChatMessage> _insertChatMessage({
    required String conversationId,
    required core.Actor sender,
    required String content,
  }) async {
    final id = core.newId();
    final now = DateTime.now().toUtc();
    await _db
        .into(_db.chatMessages)
        .insert(
          ChatMessagesCompanion.insert(
            id: id,
            conversationId: conversationId,
            ts: now,
            sender: sender.toStorageString(),
            content: content,
          ),
        );
    return core.ChatMessage(
      id: id,
      conversationId: conversationId,
      ts: now,
      sender: sender,
      content: content,
    );
  }

  /// Records the Claude Code session id created by a conversation's first
  /// agent turn, so later turns can `--resume` it instead of starting over.
  Future<void> setConversationSessionId(
    String conversationId,
    String sessionId,
  ) async {
    await (_db.update(_db.conversations)
          ..where((c) => c.id.equals(conversationId)))
        .write(ConversationsCompanion(claudeSessionId: Value(sessionId)));
  }

  Future<List<core.ChatMessage>> listChatMessages(String conversationId) async {
    final rows =
        await (_db.select(_db.chatMessages)
              ..where((m) => m.conversationId.equals(conversationId))
              ..orderBy([(m) => OrderingTerm.asc(m.ts)]))
            .get();
    return rows.map(_chatMessageToModel).toList();
  }

  // ---- Sources ----

  Future<core.Source> createSource(core.CreateSourceRequest request) async {
    if (request.projectId != null &&
        await getProject(request.projectId!) == null) {
      throw ProjectNotFound(request.projectId!);
    }

    final id = core.newId();
    final now = DateTime.now().toUtc();
    await _db
        .into(_db.sources)
        .insert(
          SourcesCompanion.insert(
            id: id,
            kind: request.kind,
            configJson: jsonEncode(request.config),
            projectId: Value(request.projectId),
            createdAt: now,
          ),
        );
    return core.Source(
      id: id,
      kind: request.kind,
      config: request.config,
      projectId: request.projectId,
      createdAt: now,
    );
  }

  Future<core.Source?> getSource(String id) async {
    final row = await (_db.select(
      _db.sources,
    )..where((s) => s.id.equals(id))).getSingleOrNull();
    return row == null ? null : _sourceToModel(row);
  }

  Future<List<core.Source>> listSources({String? projectId}) async {
    final select = _db.select(_db.sources);
    if (projectId != null) {
      select.where((s) => s.projectId.equals(projectId));
    }
    final rows = await select.get();
    return rows.map(_sourceToModel).toList();
  }

  // ---- Messages ----

  /// Returns the existing message if (sourceId, externalId) was already
  /// imported -- idempotent across repeat scans of the same source (e.g. an
  /// ERF folder re-scan), so callers can always get-or-create without
  /// tracking what they've already seen themselves. Whether a message still
  /// needs processing is `message.processedAt == null`, not "was this call
  /// the one that created it" -- that way a scan also retries any message
  /// whose extraction failed on a previous run.
  Future<core.Message> getOrCreateMessage({
    required String sourceId,
    required String externalId,
    String? author,
    required DateTime sentAt,
    required String body,
    required Map<String, Object?> raw,
    String? routedProjectId,
    double? routingConfidence,
  }) async {
    if (await getSource(sourceId) == null) throw SourceNotFound(sourceId);

    return _db.transaction(() async {
      final existing =
          await (_db.select(_db.messages)..where(
                (m) =>
                    m.sourceId.equals(sourceId) &
                    m.externalId.equals(externalId),
              ))
              .getSingleOrNull();
      if (existing != null) return _messageToModel(existing);

      final id = core.newId();
      await _db
          .into(_db.messages)
          .insert(
            MessagesCompanion.insert(
              id: id,
              sourceId: sourceId,
              externalId: externalId,
              author: Value(author),
              sentAt: sentAt,
              body: body,
              rawJson: jsonEncode(raw),
              routedProjectId: Value(routedProjectId),
              routingConfidence: Value(routingConfidence),
            ),
          );
      return core.Message(
        id: id,
        sourceId: sourceId,
        externalId: externalId,
        author: author,
        sentAt: sentAt,
        body: body,
        raw: raw,
        routedProjectId: routedProjectId,
        routingConfidence: routingConfidence,
      );
    });
  }

  Future<void> markMessageProcessed(String messageId) async {
    await (_db.update(_db.messages)..where((m) => m.id.equals(messageId)))
        .write(MessagesCompanion(processedAt: Value(DateTime.now().toUtc())));
  }

  Future<List<core.Message>> listMessages({String? sourceId}) async {
    final select = _db.select(_db.messages)
      ..orderBy([(m) => OrderingTerm.asc(m.sentAt)]);
    if (sourceId != null) {
      select.where((m) => m.sourceId.equals(sourceId));
    }
    final rows = await select.get();
    return rows.map(_messageToModel).toList();
  }

  Future<core.Message?> getMessage(String id) async {
    final row = await (_db.select(
      _db.messages,
    )..where((m) => m.id.equals(id))).getSingleOrNull();
    return row == null ? null : _messageToModel(row);
  }

  /// Org-wide: a message is unrouted when it came from a source that still
  /// needs per-message routing and nothing (automatic or manual) has
  /// assigned it a project yet. A project-scoped source's messages are
  /// never unrouted -- their `routedProjectId` is set at creation time.
  Future<List<core.Message>> listUnroutedMessages() async {
    final rows =
        await (_db.select(_db.messages)
              ..where((m) => m.routedProjectId.isNull())
              ..orderBy([(m) => OrderingTerm.asc(m.sentAt)]))
            .get();
    return rows.map(_messageToModel).toList();
  }

  /// Manually assigns a project to a message the owner is routing by hand
  /// (one that came in below the auto-routing confidence threshold, or
  /// whose routing attempt failed outright). Just the assignment -- whether
  /// to then draft a Task Spec from it is the caller's decision, same
  /// "route orchestrates, repository does one thing" split used elsewhere.
  Future<core.Message> assignMessageProject(
    String messageId,
    String projectId,
  ) async {
    if (await getMessage(messageId) == null) {
      throw MessageNotFound(messageId);
    }
    if (await getProject(projectId) == null) {
      throw ProjectNotFound(projectId);
    }

    await (_db.update(_db.messages)..where((m) => m.id.equals(messageId)))
        .write(MessagesCompanion(routedProjectId: Value(projectId)));
    return (await getMessage(messageId))!;
  }

  // ---- row <-> core model mapping ----

  core.Project _projectToModel(ProjectRow row) => core.Project(
    id: row.id,
    name: row.name,
    slug: row.slug,
    repos: (jsonDecode(row.reposJson) as List)
        .map((e) => core.RepoConfig.fromJson(e as Map<String, Object?>))
        .toList(),
    status: row.status,
    createdAt: row.createdAt,
    flutterVersion: row.flutterVersion,
    designSystemRef: row.designSystemRef,
    archivedAt: row.archivedAt,
  );

  core.ProjectLink _linkToModel(ProjectLinkRow row) => core.ProjectLink(
    id: row.id,
    fromProjectId: row.fromProjectId,
    toProjectId: row.toProjectId,
    relation: row.relation,
  );

  core.Task _taskToModel(TaskRow row) => core.Task(
    id: row.id,
    projectId: row.projectId,
    title: row.title,
    currentStatus: row.currentStatus,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );

  core.TaskEvent _eventToModel(TaskEventRow row) => core.TaskEvent(
    id: row.id,
    taskId: row.taskId,
    ts: row.ts,
    actor: core.Actor.parse(row.actor),
    eventType: row.eventType,
    payload: jsonDecode(row.payloadJson) as Map<String, Object?>,
  );

  core.Artifact _artifactToModel(ArtifactRow row) => core.Artifact(
    id: row.id,
    taskId: row.taskId,
    projectId: row.projectId,
    kind: row.kind,
    uri: row.uri,
    content: row.content,
    version: row.version,
    createdAt: row.createdAt,
  );

  core.Conversation _conversationToModel(ConversationRow row) =>
      core.Conversation(
        id: row.id,
        projectId: row.projectId,
        channel: core.ChatChannel.parse(row.channel),
        claudeSessionId: row.claudeSessionId,
        createdAt: row.createdAt,
      );

  core.ChatMessage _chatMessageToModel(ChatMessageRow row) => core.ChatMessage(
    id: row.id,
    conversationId: row.conversationId,
    ts: row.ts,
    sender: core.Actor.parse(row.sender),
    content: row.content,
  );

  core.Source _sourceToModel(SourceRow row) => core.Source(
    id: row.id,
    kind: row.kind,
    config: jsonDecode(row.configJson) as Map<String, Object?>,
    projectId: row.projectId,
    createdAt: row.createdAt,
  );

  core.Message _messageToModel(MessageRow row) => core.Message(
    id: row.id,
    sourceId: row.sourceId,
    externalId: row.externalId,
    author: row.author,
    sentAt: row.sentAt,
    body: row.body,
    raw: jsonDecode(row.rawJson) as Map<String, Object?>,
    routedProjectId: row.routedProjectId,
    routingConfidence: row.routingConfidence,
    processedAt: row.processedAt,
  );
}
