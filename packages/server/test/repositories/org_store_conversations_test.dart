import 'package:core/core.dart' as core;
import 'package:server/src/repositories/org_store.dart';
import 'package:server/src/storage/org_database.dart';
import 'package:test/test.dart';

void main() {
  late OrgDatabase db;
  late OrgStore store;

  setUp(() {
    db = OrgDatabase.memory();
    store = OrgStore('org-1', db);
  });

  tearDown(() => db.close());

  group('getOrCreateConversation', () {
    test('creates an org-scoped conversation when none exists', () async {
      final conversation = await store.getOrCreateConversation(
        channel: const core.ChatChannel.general(),
      );

      expect(conversation.projectId, isNull);
      expect(conversation.channel, const core.ChatChannel.general());
      expect(conversation.claudeSessionId, isNull);
    });

    test('returns the same row on a second call (no duplicate)', () async {
      final first = await store.getOrCreateConversation(
        channel: const core.ChatChannel.agent('health'),
      );
      final second = await store.getOrCreateConversation(
        channel: const core.ChatChannel.agent('health'),
      );

      expect(second.id, first.id);
    });

    test(
      'org-scoped and project-scoped "general" are distinct conversations',
      () async {
        final project = await store.createProject(
          const core.CreateProjectRequest(name: 'P', slug: 'p'),
        );

        final orgGeneral = await store.getOrCreateConversation(
          channel: const core.ChatChannel.general(),
        );
        final projectGeneral = await store.getOrCreateConversation(
          projectId: project.id,
          channel: const core.ChatChannel.general(),
        );

        expect(orgGeneral.id, isNot(projectGeneral.id));
        expect(projectGeneral.projectId, project.id);
      },
    );

    test('different roles get different conversations', () async {
      final health = await store.getOrCreateConversation(
        channel: const core.ChatChannel.agent('health'),
      );
      final analyst = await store.getOrCreateConversation(
        channel: const core.ChatChannel.agent('analyst'),
      );

      expect(health.id, isNot(analyst.id));
    });

    test('rejects an unknown projectId', () async {
      expect(
        () => store.getOrCreateConversation(
          projectId: 'no-such-project',
          channel: const core.ChatChannel.general(),
        ),
        throwsA(isA<ProjectNotFound>()),
      );
    });
  });

  group('chat messages', () {
    test(
      'postChatMessage then listChatMessages round trips in order',
      () async {
        final conversation = await store.getOrCreateConversation(
          channel: const core.ChatChannel.general(),
        );

        final first = await store.postChatMessage(
          conversation.id,
          const core.CreateChatMessageRequest(content: 'first'),
        );
        final second = await store.postChatMessage(
          conversation.id,
          const core.CreateChatMessageRequest(content: 'second'),
        );

        expect(first.sender, const core.Actor.user());

        final messages = await store.listChatMessages(conversation.id);
        expect(messages.map((m) => m.content).toList(), ['first', 'second']);
        expect(messages.map((m) => m.id).toList(), [first.id, second.id]);
      },
    );

    test('posting to an unknown conversation throws', () async {
      expect(
        () => store.postChatMessage(
          'no-such-conversation',
          const core.CreateChatMessageRequest(content: 'hi'),
        ),
        throwsA(isA<ConversationNotFound>()),
      );
    });
  });
}
