import 'dart:convert';

import 'package:app/src/api/api_client.dart';
import 'package:app/src/api/api_client_provider.dart';
import 'package:app/src/state/org_providers.dart';
import 'package:app/src/state/project_providers.dart';
import 'package:app/src/ui/chat/chat_screen.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_channel/stream_channel.dart';

class _FakeApiClient extends ApiClient {
  _FakeApiClient() : super(baseUrl: Uri.parse('http://localhost'));

  final _conversations = <String, core.Conversation>{};
  final _messages = <String, List<core.ChatMessage>>{};
  final createdConversationScopes = <String>[];

  String _key(String? projectId, String channel) => '$projectId:$channel';

  @override
  Future<core.Conversation> getOrCreateConversation(
    String orgId, {
    String? projectId,
    required String channel,
  }) async {
    final key = _key(projectId, channel);
    return _conversations.putIfAbsent(key, () {
      createdConversationScopes.add(key);
      return core.Conversation(
        id: 'conv-$key',
        projectId: projectId,
        channel: core.ChatChannel.parse(channel),
        createdAt: DateTime.utc(2026, 1, 1),
      );
    });
  }

  @override
  Future<List<core.ChatMessage>> listChatMessages(
    String orgId,
    String conversationId,
  ) async => _messages[conversationId] ?? const [];

  @override
  Future<core.ChatMessage> postChatMessage(
    String orgId,
    String conversationId,
    core.CreateChatMessageRequest request,
  ) async {
    final message = core.ChatMessage(
      id: 'msg-${_messages[conversationId]?.length ?? 0}',
      conversationId: conversationId,
      ts: DateTime.utc(2026, 1, 1),
      sender: const core.Actor.user(),
      content: request.content,
    );
    _messages[conversationId] = [...(_messages[conversationId] ?? []), message];
    return message;
  }

  final _streamControllers = <String, StreamChannelController<Object?>>{};

  StreamChannelController<Object?> controllerFor(String conversationId) =>
      _streamControllers.putIfAbsent(
        conversationId,
        StreamChannelController<Object?>.new,
      );

  void addAgentMessage(String conversationId, core.ChatMessage message) {
    _messages[conversationId] = [...(_messages[conversationId] ?? []), message];
  }

  @override
  StreamChannel<dynamic> connectConversationStream(
    String orgId,
    String conversationId,
  ) => controllerFor(conversationId).local;
}

class _FixedOrgId extends SelectedOrgId {
  @override
  String? build() => 'org-1';
}

class _FixedProjectId extends SelectedProjectId {
  @override
  String? build() => 'proj-1';
}

Widget _buildApp(_FakeApiClient client, {bool withProject = true}) {
  return ProviderScope(
    overrides: [
      apiClientProvider.overrideWithValue(client),
      selectedOrgIdProvider.overrideWith(() => _FixedOrgId()),
      if (withProject)
        selectedProjectIdProvider.overrideWith(() => _FixedProjectId()),
    ],
    child: const MaterialApp(home: Scaffold(body: ChatScreen())),
  );
}

void main() {
  testWidgets('shows the org general channel plus per-project channels', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp(_FakeApiClient()));
    await tester.pumpAndSettle();

    expect(find.text('General (org)'), findsOneWidget);
    expect(find.text('General (project)'), findsOneWidget);
    expect(find.text('Health'), findsOneWidget);
    expect(find.text('Librarian'), findsOneWidget);
  });

  testWidgets('without a selected project, only the org channel is shown', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp(_FakeApiClient(), withProject: false));
    await tester.pumpAndSettle();

    expect(find.text('General (org)'), findsOneWidget);
    expect(find.text('Health'), findsNothing);
  });

  testWidgets('switching channels opens a distinct conversation', (
    tester,
  ) async {
    final client = _FakeApiClient();
    await tester.pumpWidget(_buildApp(client));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Health'));
    await tester.pumpAndSettle();

    expect(client.createdConversationScopes, contains('proj-1:agent:health'));
  });

  testWidgets('sending a message posts it and shows it in the thread', (
    tester,
  ) async {
    final client = _FakeApiClient();
    await tester.pumpWidget(_buildApp(client));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('chatInput')), 'hello there');
    await tester.tap(find.byKey(const Key('sendButton')));
    await tester.pumpAndSettle();

    expect(find.text('hello there'), findsOneWidget);
  });

  testWidgets(
    'streamed deltas appear live, then are replaced by the persisted message',
    (tester) async {
      final client = _FakeApiClient();
      await tester.pumpWidget(_buildApp(client));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Health'));
      await tester.pumpAndSettle();

      const conversationId = 'conv-proj-1:agent:health';
      final sink = client.controllerFor(conversationId).foreign.sink;

      sink.add(jsonEncode({'type': 'delta', 'text': 'Looks '}));
      await tester.pump();
      await tester.pump();
      expect(find.text('Looks '), findsOneWidget);

      sink.add(jsonEncode({'type': 'delta', 'text': 'healthy.'}));
      await tester.pump();
      await tester.pump();
      expect(find.text('Looks healthy.'), findsOneWidget);
      expect(find.byKey(const Key('streamingBubble')), findsOneWidget);

      client.addAgentMessage(
        conversationId,
        core.ChatMessage(
          id: 'msg-agent-1',
          conversationId: conversationId,
          ts: DateTime.utc(2026, 1, 1),
          sender: const core.Actor.agent('health'),
          content: 'Looks healthy.',
        ),
      );
      sink.add(jsonEncode({'type': 'done', 'message': null}));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('streamingBubble')), findsNothing);
      expect(find.text('Looks healthy.'), findsOneWidget);
    },
  );
}
