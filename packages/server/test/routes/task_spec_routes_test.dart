import 'dart:convert';

import 'package:server/src/app_context.dart';
import 'package:server/src/server.dart';
import 'package:server/src/services/analyst_extraction_service.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../test_support/http_test_support.dart';

const _structuredOutput = {
  'structured_output': {
    'goal': 'Let users reset their password via email',
    'requirementIds': ['RF-07'],
    'acceptanceCriteria': ['A reset link expires after 1 hour'],
    'affectedAreas': ['Auth'],
    'priority': 'high',
    'openQuestions': <String>[],
  },
};

void main() {
  late AppContext ctx;
  late Handler handler;
  late String orgId;
  late String projectId;

  setUp(() async {
    ctx = buildTestContext(
      analystExtractionService: AnalystExtractionService(
        invoker: (_) async => jsonEncode(_structuredOutput),
      ),
    );
    handler = buildHandler(ctx);
    orgId = await createOrg(handler);
    projectId = await createProject(handler, orgId);
  });

  test(
    'POST .../task-specs/extract stores a project-scoped Task Spec artifact',
    () async {
      final (status, body) = await send(
        handler,
        'POST',
        '/orgs/$orgId/projects/$projectId/task-specs/extract',
        json: {
          'rawText':
              'We need a way for users to reset their password via email '
              '(RF-07). A reset link should expire after 1 hour.',
        },
      );

      expect(status, 201);
      final map = body! as Map;
      expect(map['kind'], 'taskSpec');
      expect(map['projectId'], projectId);
      expect(map['taskId'], isNull);
      final content = jsonDecode(map['content'] as String) as Map;
      expect(content['goal'], 'Let users reset their password via email');
      expect(content['priority'], 'high');
    },
  );

  test('rawText is required', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/task-specs/extract',
      json: const {},
    );
    expect(status, 400);
  });

  test('extraction for an unknown project is a 404', () async {
    final (status, _) = await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/no-such-project/task-specs/extract',
      json: {'rawText': 'something'},
    );
    expect(status, 404);
  });

  test('extraction failure (no structured output) is a 502', () async {
    final failingCtx = buildTestContext(
      analystExtractionService: AnalystExtractionService(
        invoker: (_) async => jsonEncode({'result': 'no schema used'}),
      ),
    );
    final failingHandler = buildHandler(failingCtx);
    final org = await createOrg(failingHandler, slug: 'fail-org');
    final proj = await createProject(failingHandler, org);

    final (status, _) = await send(
      failingHandler,
      'POST',
      '/orgs/$org/projects/$proj/task-specs/extract',
      json: {'rawText': 'something'},
    );
    expect(status, 502);
  });

  test('GET .../task-specs lists extracted specs, newest first', () async {
    await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/task-specs/extract',
      json: {'rawText': 'first message'},
    );
    await send(
      handler,
      'POST',
      '/orgs/$orgId/projects/$projectId/task-specs/extract',
      json: {'rawText': 'second message'},
    );

    final (status, body) = await send(
      handler,
      'GET',
      '/orgs/$orgId/projects/$projectId/task-specs',
    );

    expect(status, 200);
    final specs = body! as List;
    expect(specs, hasLength(2));
    expect((specs[0] as Map)['version'], 2);
    expect((specs[1] as Map)['version'], 1);
  });

  test('task-specs for an unknown project is a 404', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/$orgId/projects/no-such-project/task-specs',
    );
    expect(status, 404);
  });
}
