import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'repositories/org_store.dart';
import 'repositories/registry_store.dart';
import 'services/git_service.dart';
import 'services/onboarding_service.dart';

const jsonHeaders = {'content-type': 'application/json'};

Response jsonResponse(Object? body, {int status = 200}) =>
    Response(status, body: jsonEncode(body), headers: jsonHeaders);

Response notFoundResponse(String message) =>
    jsonResponse({'error': message}, status: 404);

Response badRequestResponse(String message) =>
    jsonResponse({'error': message}, status: 400);

Response conflictResponse(Map<String, Object?> body) =>
    jsonResponse(body, status: 409);

Response upstreamErrorResponse(String message) =>
    jsonResponse({'error': message}, status: 502);

Future<Map<String, Object?>> readJsonBody(Request request) async {
  final text = await request.readAsString();
  if (text.isEmpty) return const {};
  return jsonDecode(text) as Map<String, Object?>;
}

/// Wraps a route handler, translating repository exceptions into the HTTP
/// responses described in the Phase 0 spec: not-found ids (including ids
/// that belong to another org) become 404, slug conflicts and invalid task
/// transitions become 409 with the allowed transitions attached.
Future<Response> guarded(Future<Response> Function() action) async {
  try {
    return await action();
  } on OrganizationNotFound catch (e) {
    return notFoundResponse('Organization ${e.id} not found');
  } on ProjectNotFound catch (e) {
    return notFoundResponse('Project ${e.id} not found');
  } on TaskNotFound catch (e) {
    return notFoundResponse('Task ${e.id} not found');
  } on ConversationNotFound catch (e) {
    return notFoundResponse('Conversation ${e.id} not found');
  } on CrossOrgLinkRejected catch (e) {
    return notFoundResponse('Project ${e.toProjectId} not found');
  } on DuplicateOrgSlug catch (e) {
    return conflictResponse({'error': 'slug "${e.slug}" is already in use'});
  } on DuplicateProjectSlug catch (e) {
    return conflictResponse({'error': 'slug "${e.slug}" is already in use'});
  } on NoRepoConfigured catch (e) {
    return badRequestResponse(
      'Project ${e.projectId} has no repo configured to onboard',
    );
  } on GitOperationException catch (e) {
    return upstreamErrorResponse(e.message);
  } on InvalidTaskTransition catch (e) {
    return conflictResponse({
      'error': 'invalid transition',
      'from': e.from.name,
      'attempted': e.attempted.name,
      'allowed': e.allowed.map((s) => s.name).toList(),
    });
  } on FormatException catch (e) {
    return badRequestResponse(e.message);
  }
}
