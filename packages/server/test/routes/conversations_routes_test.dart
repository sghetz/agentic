import 'dart:convert';

import 'package:server/src/app_context.dart';
import 'package:server/src/server.dart';
import 'package:server/src/services/claude_conversation_service.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../test_support/http_test_support.dart';

void main() {
  late AppContext ctx;
  late Handler handler;
  late String orgId;
  late String projectId;

  setUp(() async {
    ctx = buildTestContext();
    handler = buildHandler(ctx);
    orgId = await createOrg(handler);
    projectId = await createProject(handler, orgId);
  });

  test(
    'GET conversations creates the org-level general channel once',
    () async {
      final (status1, body1) = await send(
        handler,
        'GET',
        '/orgs/$orgId/conversations?channel=general',
      );
      expect(status1, 200);
      final id1 = (body1! as Map)['id'];

      final (status2, body2) = await send(
        handler,
        'GET',
        '/orgs/$orgId/conversations?channel=general',
      );
      expect(status2, 200);
      expect((body2! as Map)['id'], id1);
    },
  );

  test('a project-scoped channel is distinct from the org-level one', () async {
    final (_, orgBody) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations?channel=general',
    );
    final (_, projectBody) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations?channel=general&projectId=$projectId',
    );

    final projectMap = projectBody! as Map;
    expect((orgBody! as Map)['id'], isNot(projectMap['id']));
    expect(projectMap['projectId'], projectId);
  });

  test('missing channel query parameter is a 400', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations',
    );
    expect(status, 400);
  });

  test('an unknown projectId is a 404', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations?channel=general&projectId=no-such-project',
    );
    expect(status, 404);
  });

  test('posting then listing messages round trips', () async {
    final (_, convBody) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations?channel=agent:health',
    );
    final conversationId = (convBody! as Map)['id'] as String;

    final (postStatus, postBody) = await send(
      handler,
      'POST',
      '/orgs/$orgId/conversations/$conversationId/messages',
      json: {'content': 'is this project healthy?'},
    );
    expect(postStatus, 201);
    expect((postBody! as Map)['sender'], 'user');

    final (listStatus, listBody) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations/$conversationId/messages',
    );
    expect(listStatus, 200);
    expect((listBody! as List), hasLength(1));
  });

  test('messages for an unknown conversation return 404', () async {
    final (status, _) = await send(
      handler,
      'GET',
      '/orgs/$orgId/conversations/no-such-conversation/messages',
    );
    expect(status, 404);
  });

  group('Health agent reply wiring', () {
    Future<(AppContext, Handler, String, String)> setUpWith(
      ClaudeConversationService conversationService,
    ) async {
      final context = buildTestContext(
        conversationService: conversationService,
      );
      final h = buildHandler(context);
      final org = await createOrg(h, slug: 'health-wiring-org');
      final proj = await createProject(h, org, slug: 'health-wiring-proj');
      return (context, h, org, proj);
    }

    test(
      'a message to the Health project channel gets an agent reply and persists the session id',
      () async {
        final calls = <List<String>>[];
        final (_, h, org, proj) = await setUpWith(
          ClaudeConversationService(
            invoker: (args, {required workingDirectory}) {
              calls.add(args);
              return Stream.fromIterable([
                jsonEncode({
                  'type': 'result',
                  'result': 'Looks healthy to me.',
                }),
              ]);
            },
          ),
        );

        final (_, convBody) = await send(
          h,
          'GET',
          '/orgs/$org/conversations?channel=agent:health&projectId=$proj',
        );
        final conversationId = (convBody! as Map)['id'] as String;

        await send(
          h,
          'POST',
          '/orgs/$org/conversations/$conversationId/messages',
          json: {'content': 'is this project healthy?'},
        );

        final (_, listBody) = await send(
          h,
          'GET',
          '/orgs/$org/conversations/$conversationId/messages',
        );
        final messages = listBody! as List;
        expect(messages, hasLength(2));
        expect((messages[0] as Map)['sender'], 'user');
        expect((messages[1] as Map)['sender'], 'agent:health');
        expect((messages[1] as Map)['content'], 'Looks healthy to me.');

        expect(calls, hasLength(1));
        expect(calls.single, contains('--session-id'));

        // The session id should now be persisted on the conversation.
        final (_, refetched) = await send(
          h,
          'GET',
          '/orgs/$org/conversations?channel=agent:health&projectId=$proj',
        );
        expect((refetched! as Map)['claudeSessionId'], isNotNull);
      },
    );

    test('a second turn resumes the session id from the first', () async {
      final calls = <List<String>>[];
      final (_, h, org, proj) = await setUpWith(
        ClaudeConversationService(
          invoker: (args, {required workingDirectory}) {
            calls.add(args);
            return Stream.fromIterable([
              jsonEncode({'type': 'result', 'result': 'ok ${calls.length}'}),
            ]);
          },
        ),
      );

      final (_, convBody) = await send(
        h,
        'GET',
        '/orgs/$org/conversations?channel=agent:health&projectId=$proj',
      );
      final conversationId = (convBody! as Map)['id'] as String;

      await send(
        h,
        'POST',
        '/orgs/$org/conversations/$conversationId/messages',
        json: {'content': 'first'},
      );
      await send(
        h,
        'POST',
        '/orgs/$org/conversations/$conversationId/messages',
        json: {'content': 'second'},
      );

      expect(calls, hasLength(2));
      final firstSessionId = calls[0][calls[0].indexOf('--session-id') + 1];
      expect(calls[1], containsAllInOrder(['--resume', firstSessionId]));
    });

    test(
      'an unrecognized agent role does not trigger a reply (not wired)',
      () async {
        var invoked = false;
        final (_, h, org, _) = await setUpWith(
          ClaudeConversationService(
            invoker: (args, {required workingDirectory}) {
              invoked = true;
              return Stream.fromIterable([
                jsonEncode({'type': 'result', 'result': 'should not happen'}),
              ]);
            },
          ),
        );

        final (_, convBody) = await send(
          h,
          'GET',
          '/orgs/$org/conversations?channel=agent:some-future-role',
        );
        final conversationId = (convBody! as Map)['id'] as String;

        await send(
          h,
          'POST',
          '/orgs/$org/conversations/$conversationId/messages',
          json: {'content': 'hello'},
        );

        expect(invoked, isFalse);
        final (_, listBody) = await send(
          h,
          'GET',
          '/orgs/$org/conversations/$conversationId/messages',
        );
        expect((listBody! as List), hasLength(1));
      },
    );

    test('the other agent roles (Analyst, Creative, Developer, Reviewer, '
        'Librarian) are wired to a real turn too', () async {
      for (final role in [
        'analyst',
        'creative',
        'developer',
        'reviewer',
        'librarian',
      ]) {
        final (_, h, org, proj) = await setUpWith(
          ClaudeConversationService(
            invoker: (args, {required workingDirectory}) =>
                Stream.fromIterable([
                  jsonEncode({'type': 'result', 'result': 'ack from $role'}),
                ]),
          ),
        );

        final (_, convBody) = await send(
          h,
          'GET',
          '/orgs/$org/conversations?channel=agent:$role&projectId=$proj',
        );
        final conversationId = (convBody! as Map)['id'] as String;

        await send(
          h,
          'POST',
          '/orgs/$org/conversations/$conversationId/messages',
          json: {'content': 'hello'},
        );

        final (_, listBody) = await send(
          h,
          'GET',
          '/orgs/$org/conversations/$conversationId/messages',
        );
        final messages = listBody! as List;
        expect(messages, hasLength(2), reason: 'role: $role');
        expect(
          (messages[1] as Map)['sender'],
          'agent:$role',
          reason: 'role: $role',
        );
        expect(
          (messages[1] as Map)['content'],
          'ack from $role',
          reason: 'role: $role',
        );
      }
    });
  });

  group('Orchestrator agent reply wiring', () {
    Future<(Handler, String, String)> setUpWith(
      ClaudeConversationService conversationService,
    ) async {
      final context = buildTestContext(
        conversationService: conversationService,
      );
      final h = buildHandler(context);
      final org = await createOrg(h, slug: 'orchestrator-wiring-org');
      final proj = await createProject(
        h,
        org,
        slug: 'orchestrator-wiring-proj',
      );
      return (h, org, proj);
    }

    test(
      'a message to the org-level general channel gets an Orchestrator reply',
      () async {
        final calls = <List<String>>[];
        final (h, org, proj) = await setUpWith(
          ClaudeConversationService(
            invoker: (args, {required workingDirectory}) {
              calls.add(args);
              return Stream.fromIterable([
                jsonEncode({'type': 'result', 'result': "I've got it."}),
              ]);
            },
          ),
        );

        final (_, convBody) = await send(
          h,
          'GET',
          '/orgs/$org/conversations?channel=general',
        );
        final conversationId = (convBody! as Map)['id'] as String;

        await send(
          h,
          'POST',
          '/orgs/$org/conversations/$conversationId/messages',
          json: {'content': 'add a task to fix the login bug'},
        );

        final (_, listBody) = await send(
          h,
          'GET',
          '/orgs/$org/conversations/$conversationId/messages',
        );
        final messages = listBody! as List;
        expect(messages, hasLength(2));
        expect((messages[1] as Map)['sender'], 'agent:orchestrator');
        expect((messages[1] as Map)['content'], "I've got it.");

        expect(calls, hasLength(1));
        final args = calls.single;
        expect(args, contains('--mcp-config'));
        expect(args, contains('--strict-mcp-config'));
        final systemPromptIndex = args.indexOf('--append-system-prompt');
        expect(args[systemPromptIndex + 1], contains(proj));
      },
    );

    test("a project-scoped General channel's MCP config is still org-wide, "
        'not limited to that project', () async {
      final (h, org, proj) = await setUpWith(
        ClaudeConversationService(
          invoker: (args, {required workingDirectory}) => Stream.fromIterable([
            jsonEncode({'type': 'result', 'result': 'ok'}),
          ]),
        ),
      );

      final (_, convBody) = await send(
        h,
        'GET',
        '/orgs/$org/conversations?channel=general&projectId=$proj',
      );
      final conversationId = (convBody! as Map)['id'] as String;

      final (status, _) = await send(
        h,
        'POST',
        '/orgs/$org/conversations/$conversationId/messages',
        json: {'content': 'what is this project called?'},
      );

      expect(status, 201);
      final (_, listBody) = await send(
        h,
        'GET',
        '/orgs/$org/conversations/$conversationId/messages',
      );
      expect((listBody! as List), hasLength(2));
    });
  });
}
