import 'dart:convert';

import 'package:server/src/app_context.dart';
import 'package:server/src/server.dart';
import 'package:server/src/services/analyst_extraction_service.dart';
import 'package:server/src/services/creative_extraction_service.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../test_support/http_test_support.dart';

const _taskSpecOutput = {
  'structured_output': {
    'goal': 'Let users reset their password via email',
    'requirementIds': ['RF-07'],
    'acceptanceCriteria': ['A reset link expires after 1 hour'],
    'affectedAreas': ['Auth'],
    'priority': 'high',
    'openQuestions': <String>[],
  },
};

const _designSpecOutput = {
  'structured_output': {
    'screens': [
      {
        'name': 'Login',
        'purpose': 'Let the user sign in',
        'states': ['loading', 'error'],
        'navigatesTo': ['ResetPassword'],
      },
      {
        'name': 'ResetPassword',
        'purpose': 'Request a password reset email',
        'states': ['empty', 'loading', 'error', 'success'],
        'navigatesTo': <String>[],
      },
    ],
    'mermaid': 'flowchart TD\n  Login -->|reset| ResetPassword',
  },
};

void main() {
  late AppContext ctx;
  late Handler handler;
  late String orgId;
  late String projectId;
  late String taskSpecArtifactId;

  setUp(() async {
    ctx = buildTestContext(
      analystExtractionService: AnalystExtractionService(
        invoker: (_) async => jsonEncode(_taskSpecOutput),
      ),
      creativeExtractionService: CreativeExtractionService(
        invoker: (_) async => jsonEncode(_designSpecOutput),
      ),
    );
    handler = buildHandler(ctx);
    orgId = await createOrg(handler);
    projectId = await createProject(handler, orgId);

    final (_, taskSpecBody) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/task-specs/extract',
      json: {'rawText': 'password reset via email, RF-07'},
    );
    taskSpecArtifactId = (taskSpecBody! as Map)['id'] as String;
  });

  test(
    'POST .../design-specs/generate stores a Design Spec and a diagram artifact',
    () async {
      final (status, body) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$projectId/design-specs/generate',
        json: {'taskSpecArtifactId': taskSpecArtifactId},
      );

      expect(status, 201);
      final map = body! as Map;

      final designSpecArtifact = map['designSpec'] as Map;
      expect(designSpecArtifact['kind'], 'designSpec');
      expect(designSpecArtifact['projectId'], projectId);
      final designSpecContent =
          jsonDecode(designSpecArtifact['content'] as String) as Map;
      expect(designSpecContent['screens'], hasLength(2));
      expect(designSpecContent['requirementIds'], ['RF-07']);
      expect(designSpecContent['sourceTaskSpecArtifactId'], taskSpecArtifactId);

      final diagramArtifact = map['diagram'] as Map;
      expect(diagramArtifact['kind'], 'diagram');
      expect(diagramArtifact['projectId'], projectId);
      expect(diagramArtifact['content'], contains('flowchart TD'));
    },
  );

  test('taskSpecArtifactId is required', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/design-specs/generate',
      json: const {},
    );
    expect(status, 400);
  });

  test('an unknown taskSpecArtifactId is a 404', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/design-specs/generate',
      json: {'taskSpecArtifactId': 'no-such-artifact'},
    );
    expect(status, 404);
  });

  test('generation for an unknown project is a 404', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/no-such-project/design-specs/generate',
      json: {'taskSpecArtifactId': taskSpecArtifactId},
    );
    expect(status, 404);
  });

  test('generation failure (no structured output) is a 502', () async {
    final failingCtx = buildTestContext(
      analystExtractionService: AnalystExtractionService(
        invoker: (_) async => jsonEncode(_taskSpecOutput),
      ),
      creativeExtractionService: CreativeExtractionService(
        invoker: (_) async => jsonEncode({'result': 'no schema used'}),
      ),
    );
    final failingHandler = buildHandler(failingCtx);
    final org = await createOrg(failingHandler, slug: 'fail-org');
    final proj = await createProject(failingHandler, org);
    final (_, taskSpecBody) = await send(
      failingHandler,
      'POST',
      '/orgs/$org/projects/$proj/task-specs/extract',
      json: {'rawText': 'something'},
    );
    final failingTaskSpecId = (taskSpecBody! as Map)['id'] as String;

    final (status, _) = await send(
      failingHandler,
      'POST',
      '/orgs/$org/projects/$proj/design-specs/generate',
      json: {'taskSpecArtifactId': failingTaskSpecId},
    );
    expect(status, 502);
  });

  test(
    'GET .../design-specs and .../diagrams list what was generated',
    () async {
      await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$projectId/design-specs/generate',
        json: {'taskSpecArtifactId': taskSpecArtifactId},
      );

      final (specsStatus, specsBody) = await send(
        handler,
        'GET',
        '/orgs/$orgId/projects/$projectId/design-specs',
      );
      expect(specsStatus, 200);
      expect((specsBody! as List), hasLength(1));

      final (diagramsStatus, diagramsBody) = await send(
        handler,
        'GET',
        '/orgs/$orgId/projects/$projectId/diagrams',
      );
      expect(diagramsStatus, 200);
      expect((diagramsBody! as List), hasLength(1));
    },
  );

  test('design-specs for an unknown project is a 404', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/$orgId/projects/no-such-project/design-specs',
    );
    expect(status, 404);
  });

  test('diagrams for an unknown project is a 404', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/$orgId/projects/no-such-project/diagrams',
    );
    expect(status, 404);
  });
}
