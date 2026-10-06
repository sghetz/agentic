// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(conversation)
final conversationProvider = ConversationFamily._();

final class ConversationProvider
    extends
        $FunctionalProvider<
          AsyncValue<core.Conversation>,
          core.Conversation,
          FutureOr<core.Conversation>
        >
    with
        $FutureModifier<core.Conversation>,
        $FutureProvider<core.Conversation> {
  ConversationProvider._({
    required ConversationFamily super.from,
    required (String, {String? projectId, String channel}) super.argument,
  }) : super(
         retry: null,
         name: r'conversationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$conversationHash();

  @override
  String toString() {
    return r'conversationProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<core.Conversation> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<core.Conversation> create(Ref ref) {
    final argument =
        this.argument as (String, {String? projectId, String channel});
    return conversation(
      ref,
      argument.$1,
      projectId: argument.projectId,
      channel: argument.channel,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conversationHash() => r'6051162aec55823ca0db3a379ac8645ef0a0e8ba';

final class ConversationFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<core.Conversation>,
          (String, {String? projectId, String channel})
        > {
  ConversationFamily._()
    : super(
        retry: null,
        name: r'conversationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ConversationProvider call(
    String orgId, {
    String? projectId,
    required String channel,
  }) => ConversationProvider._(
    argument: (orgId, projectId: projectId, channel: channel),
    from: this,
  );

  @override
  String toString() => r'conversationProvider';
}

@ProviderFor(chatMessages)
final chatMessagesProvider = ChatMessagesFamily._();

final class ChatMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.ChatMessage>>,
          List<core.ChatMessage>,
          FutureOr<List<core.ChatMessage>>
        >
    with
        $FutureModifier<List<core.ChatMessage>>,
        $FutureProvider<List<core.ChatMessage>> {
  ChatMessagesProvider._({
    required ChatMessagesFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'chatMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatMessagesHash();

  @override
  String toString() {
    return r'chatMessagesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<core.ChatMessage>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<core.ChatMessage>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return chatMessages(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatMessagesHash() => r'35635f7ff6162393f951532316d401cab8d00f66';

final class ChatMessagesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<core.ChatMessage>>,
          (String, String)
        > {
  ChatMessagesFamily._()
    : super(
        retry: null,
        name: r'chatMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatMessagesProvider call(String orgId, String conversationId) =>
      ChatMessagesProvider._(argument: (orgId, conversationId), from: this);

  @override
  String toString() => r'chatMessagesProvider';
}
