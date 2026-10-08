import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:http/http.dart' as http;
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ApiException implements Exception {
  ApiException(this.statusCode, this.body);

  final int statusCode;
  final Object? body;

  @override
  String toString() => 'ApiException($statusCode, $body)';
}

/// Thin HTTP client over the server's JSON API. Widgets never call HTTP
/// directly -- everything goes through this class and core's DTOs.
class ApiClient {
  ApiClient({required this.baseUrl, http.Client? httpClient})
    : _client = httpClient ?? http.Client();

  final Uri baseUrl;
  final http.Client _client;

  void close() => _client.close();

  Uri _uri(String path, [Map<String, String>? query]) {
    final combinedPath = '${baseUrl.path}$path'.replaceAll('//', '/');
    return baseUrl.replace(path: combinedPath, queryParameters: query);
  }

  Future<Object?> _send(
    String method,
    Uri uri, {
    Map<String, Object?>? json,
  }) async {
    final request = http.Request(method, uri);
    if (json != null) {
      request.headers['content-type'] = 'application/json';
      request.body = jsonEncode(json);
    }
    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);
    final text = response.body;
    final decoded = text.isEmpty ? null : jsonDecode(text);
    if (response.statusCode >= 400) {
      throw ApiException(response.statusCode, decoded);
    }
    return decoded;
  }

  // ---- Organizations ----

  Future<List<core.Organization>> listOrgs() async {
    final body = await _send('GET', _uri('/orgs')) as List;
    return body
        .map((e) => core.Organization.fromJson(e as Map<String, Object?>))
        .toList();
  }

  Future<core.Organization> createOrg(
    core.CreateOrganizationRequest request,
  ) async {
    final body = await _send('POST', _uri('/orgs'), json: request.toJson());
    return core.Organization.fromJson(body! as Map<String, Object?>);
  }

  Future<core.Organization> updateOrg(
    String orgId,
    core.UpdateOrganizationRequest request,
  ) async {
    final body = await _send(
      'PATCH',
      _uri('/orgs/$orgId'),
      json: request.toJson(),
    );
    return core.Organization.fromJson(body! as Map<String, Object?>);
  }

  // ---- Projects ----

  Future<List<core.Project>> listProjects(
    String orgId, {
    bool includeArchived = false,
  }) async {
    final body =
        await _send(
              'GET',
              _uri('/orgs/$orgId/projects', {
                'includeArchived': '$includeArchived',
              }),
            )
            as List;
    return body
        .map((e) => core.Project.fromJson(e as Map<String, Object?>))
        .toList();
  }

  Future<core.Project> createProject(
    String orgId,
    core.CreateProjectRequest request,
  ) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/projects'),
      json: request.toJson(),
    );
    return core.Project.fromJson(body! as Map<String, Object?>);
  }

  Future<core.Project> updateProject(
    String orgId,
    String projectId,
    core.UpdateProjectRequest request,
  ) async {
    final body = await _send(
      'PATCH',
      _uri('/orgs/$orgId/projects/$projectId'),
      json: request.toJson(),
    );
    return core.Project.fromJson(body! as Map<String, Object?>);
  }

  Future<core.Project> archiveProject(String orgId, String projectId) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/projects/$projectId/archive'),
      json: const {},
    );
    return core.Project.fromJson(body! as Map<String, Object?>);
  }

  /// Clones (or pulls) the project's configured repo and detects its
  /// Flutter version.
  Future<core.Project> onboardProject(String orgId, String projectId) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/projects/$projectId/onboard'),
      json: const {},
    );
    return core.Project.fromJson(body! as Map<String, Object?>);
  }

  // ---- Project links ----

  Future<List<core.ProjectLink>> listProjectLinks(
    String orgId,
    String projectId,
  ) async {
    final body =
        await _send('GET', _uri('/orgs/$orgId/projects/$projectId/links'))
            as List;
    return body
        .map((e) => core.ProjectLink.fromJson(e as Map<String, Object?>))
        .toList();
  }

  Future<core.ProjectLink> createProjectLink(
    String orgId,
    String projectId,
    core.CreateProjectLinkRequest request,
  ) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/projects/$projectId/links'),
      json: request.toJson(),
    );
    return core.ProjectLink.fromJson(body! as Map<String, Object?>);
  }

  Future<void> deleteProjectLink(
    String orgId,
    String projectId,
    String linkId,
  ) {
    return _send(
      'DELETE',
      _uri('/orgs/$orgId/projects/$projectId/links/$linkId'),
    );
  }

  // ---- Tasks ----

  Future<List<core.Task>> listTasks(
    String orgId,
    String projectId, {
    core.TaskStatus? status,
    DateTime? from,
    DateTime? to,
    String? query,
  }) async {
    final params = <String, String>{
      if (status != null) 'status': status.name,
      if (from != null) 'from': from.toIso8601String(),
      if (to != null) 'to': to.toIso8601String(),
      if (query != null && query.isNotEmpty) 'q': query,
    };
    final body =
        await _send(
              'GET',
              _uri('/orgs/$orgId/projects/$projectId/tasks', params),
            )
            as List;
    return body
        .map((e) => core.Task.fromJson(e as Map<String, Object?>))
        .toList();
  }

  Future<core.Task> createTask(
    String orgId,
    String projectId,
    core.CreateTaskRequest request,
  ) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/projects/$projectId/tasks'),
      json: request.toJson(),
    );
    return core.Task.fromJson(body! as Map<String, Object?>);
  }

  Future<core.Task> getTask(String orgId, String taskId, {DateTime? at}) async {
    final params = at == null ? null : {'at': at.toIso8601String()};
    final body = await _send('GET', _uri('/orgs/$orgId/tasks/$taskId', params));
    return core.Task.fromJson(body! as Map<String, Object?>);
  }

  Future<List<core.TaskEvent>> listTaskEvents(
    String orgId,
    String taskId,
  ) async {
    final body =
        await _send('GET', _uri('/orgs/$orgId/tasks/$taskId/events')) as List;
    return body
        .map((e) => core.TaskEvent.fromJson(e as Map<String, Object?>))
        .toList();
  }

  Future<core.TaskEvent> appendTaskEvent(
    String orgId,
    String taskId,
    core.CreateTaskEventRequest request,
  ) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/tasks/$taskId/events'),
      json: request.toJson(),
    );
    return core.TaskEvent.fromJson(body! as Map<String, Object?>);
  }

  // ---- Artifacts ----

  Future<List<core.Artifact>> listArtifacts(String orgId, String taskId) async {
    final body =
        await _send('GET', _uri('/orgs/$orgId/tasks/$taskId/artifacts'))
            as List;
    return body
        .map((e) => core.Artifact.fromJson(e as Map<String, Object?>))
        .toList();
  }

  Future<core.Artifact> createArtifact(
    String orgId,
    String taskId,
    core.CreateArtifactRequest request,
  ) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/tasks/$taskId/artifacts'),
      json: request.toJson(),
    );
    return core.Artifact.fromJson(body! as Map<String, Object?>);
  }

  // ---- Health checks ----

  /// Clones/pulls, runs the deterministic pipeline, and stores the result.
  /// Can take a while (a real `flutter build` run) -- no client timeout.
  Future<core.Artifact> runProjectHealthCheck(
    String orgId,
    String projectId,
  ) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/projects/$projectId/health-check'),
      json: const {},
    );
    return core.Artifact.fromJson(body! as Map<String, Object?>);
  }

  /// Checks every project in the org that has a repo configured.
  Future<List<core.Artifact>> runOrgHealthCheck(String orgId) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/health-check'),
      json: const {},
    );
    return (body! as List)
        .map((e) => core.Artifact.fromJson(e as Map<String, Object?>))
        .toList();
  }

  Future<List<core.Artifact>> listHealthReports(
    String orgId,
    String projectId, {
    int? limit,
  }) async {
    final query = limit == null ? null : {'limit': '$limit'};
    final body =
        await _send(
              'GET',
              _uri('/orgs/$orgId/projects/$projectId/health-reports', query),
            )
            as List;
    return body
        .map((e) => core.Artifact.fromJson(e as Map<String, Object?>))
        .toList();
  }

  /// Attempts to auto-fix the latest health report's failure, if it's
  /// judged trivial. Can take a while (a real pipeline re-run to verify);
  /// no client timeout. Never pushes or merges -- a `fixed` outcome just
  /// means a local branch now exists for review.
  Future<core.HealthFixResult> runProjectHealthFix(
    String orgId,
    String projectId,
  ) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/projects/$projectId/health-fix'),
      json: const {},
    );
    return core.HealthFixResult.fromJson(body! as Map<String, Object?>);
  }

  // ---- Conversations ----

  /// Fetches the one conversation for a (projectId, channel) scope,
  /// creating it server-side the first time it's opened. `channel` is
  /// `"general"` or `"agent:<role>"`; omit `projectId` for the org-level
  /// scope.
  Future<core.Conversation> getOrCreateConversation(
    String orgId, {
    String? projectId,
    required String channel,
  }) async {
    final body = await _send(
      'GET',
      _uri('/orgs/$orgId/conversations', {
        'channel': channel,
        'projectId': ?projectId,
      }),
    );
    return core.Conversation.fromJson(body! as Map<String, Object?>);
  }

  Future<List<core.ChatMessage>> listChatMessages(
    String orgId,
    String conversationId,
  ) async {
    final body =
        await _send(
              'GET',
              _uri('/orgs/$orgId/conversations/$conversationId/messages'),
            )
            as List;
    return body
        .map((e) => core.ChatMessage.fromJson(e as Map<String, Object?>))
        .toList();
  }

  Future<core.ChatMessage> postChatMessage(
    String orgId,
    String conversationId,
    core.CreateChatMessageRequest request,
  ) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/conversations/$conversationId/messages'),
      json: request.toJson(),
    );
    return core.ChatMessage.fromJson(body! as Map<String, Object?>);
  }

  /// Opens the live-streaming side channel for one conversation. A message
  /// is still sent via [postChatMessage]; this socket only receives
  /// `{"type":"delta","text":...}` / `{"type":"done","message":...}` events
  /// as an agent turn runs -- the full reply is always persisted
  /// server-side regardless of whether this socket is open.
  ///
  /// Typed as the generic [StreamChannel] rather than `WebSocketChannel`
  /// specifically (which satisfies this interface) so tests can override
  /// this with a purely in-memory channel instead of a real socket.
  StreamChannel<dynamic> connectConversationStream(
    String orgId,
    String conversationId,
  ) {
    final httpUri = _uri('/orgs/$orgId/conversations/$conversationId/stream');
    final wsUri = httpUri.replace(
      scheme: httpUri.scheme == 'https' ? 'wss' : 'ws',
    );
    return WebSocketChannel.connect(wsUri);
  }

  // ---- Sources, messages, Task Specs ----

  Future<core.Source> createSource(
    String orgId,
    core.CreateSourceRequest request,
  ) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/sources'),
      json: request.toJson(),
    );
    return core.Source.fromJson(body! as Map<String, Object?>);
  }

  Future<List<core.Source>> listSources(
    String orgId, {
    String? projectId,
  }) async {
    final body =
        await _send(
              'GET',
              _uri('/orgs/$orgId/sources', {'projectId': ?projectId}),
            )
            as List;
    return body
        .map((e) => core.Source.fromJson(e as Map<String, Object?>))
        .toList();
  }

  Future<Map<String, Object?>> scanErfSource(
    String orgId,
    String sourceId,
  ) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/sources/$sourceId/scan'),
      json: const {},
    );
    return body! as Map<String, Object?>;
  }

  Future<Map<String, Object?>> importWhatsApp(
    String orgId,
    String sourceId,
    String exportText,
  ) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/sources/$sourceId/import-whatsapp'),
      json: {'exportText': exportText},
    );
    return body! as Map<String, Object?>;
  }

  Future<List<core.Message>> listUnroutedMessages(String orgId) async {
    final body =
        await _send('GET', _uri('/orgs/$orgId/messages/unrouted')) as List;
    return body
        .map((e) => core.Message.fromJson(e as Map<String, Object?>))
        .toList();
  }

  Future<core.Message> assignMessageProject(
    String orgId,
    String messageId,
    String projectId,
  ) async {
    final body = await _send(
      'POST',
      _uri('/orgs/$orgId/messages/$messageId/assign'),
      json: {'projectId': projectId},
    );
    return core.Message.fromJson(body! as Map<String, Object?>);
  }

  Future<List<core.Artifact>> listTaskSpecs(
    String orgId,
    String projectId,
  ) async {
    final body =
        await _send('GET', _uri('/orgs/$orgId/projects/$projectId/task-specs'))
            as List;
    return body
        .map((e) => core.Artifact.fromJson(e as Map<String, Object?>))
        .toList();
  }

  // ---- Dashboard ----

  Future<core.DashboardSummary> dashboard() async {
    final body = await _send('GET', _uri('/dashboard'));
    return core.DashboardSummary.fromJson(body! as Map<String, Object?>);
  }
}
