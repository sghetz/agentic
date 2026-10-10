import 'package:core/core.dart' as core;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../app_context.dart';
import '../http_utils.dart';

void registerConnectorRoutes(Router router, AppContext ctx) {
  router.get('/connectors', (Request request) {
    return guarded(() async {
      return jsonResponse(
        ctx.connectorRegistry.definitions.map((d) => d.toJson()).toList(),
      );
    });
  });

  router.post('/orgs/<orgId>/connectors/<connectorId>/connect', (
    Request request,
    String orgId,
    String connectorId,
  ) {
    return guarded(() async {
      final org = await ctx.registryStore.get(orgId);
      if (org == null) {
        return notFoundResponse('Organization $orgId not found');
      }
      if (ctx.connectorRegistry.definitionFor(connectorId) == null) {
        return notFoundResponse('Connector $connectorId not found');
      }

      final body = await readJsonBody(request);
      final clientId = body['clientId'] as String?;
      final clientSecret = body['clientSecret'] as String?;
      if (clientId == null || clientSecret == null) {
        return badRequestResponse('clientId and clientSecret are required');
      }

      final authorizeUrl = await ctx.connectorOAuthService.beginConnect(
        orgId: orgId,
        connectorId: connectorId,
        clientId: clientId,
        clientSecret: clientSecret,
      );
      return jsonResponse({'authorizeUrl': authorizeUrl});
    });
  });

  // Not org-scoped in the path: the redirect_uri registered with every
  // OAuth provider must be fixed, so (org, connector) travels in `state`
  // instead -- see ConnectorOAuthService.
  router.get('/connectors/callback', (Request request) {
    return guarded(() async {
      final code = request.url.queryParameters['code'];
      final state = request.url.queryParameters['state'];
      if (code == null || state == null) {
        return badRequestResponse('Missing code or state');
      }

      final completed = await ctx.connectorOAuthService.completeConnect(
        code: code,
        state: state,
      );
      final store = await ctx.orgStore(completed.orgId);
      if (store == null) {
        return notFoundResponse('Organization ${completed.orgId} not found');
      }

      await store.createSource(
        core.CreateSourceRequest(
          kind: core.SourceKind.oauthConnector,
          config: {'connectorId': completed.connectorId},
        ),
      );

      return Response.ok(
        '<html><body><h3>Connected.</h3>'
        '<p>You can close this window and return to Agentic.</p>'
        '</body></html>',
        headers: {'content-type': 'text/html'},
      );
    });
  });
}
