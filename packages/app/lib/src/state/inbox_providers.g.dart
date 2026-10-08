// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(unroutedMessages)
final unroutedMessagesProvider = UnroutedMessagesFamily._();

final class UnroutedMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.Message>>,
          List<core.Message>,
          FutureOr<List<core.Message>>
        >
    with
        $FutureModifier<List<core.Message>>,
        $FutureProvider<List<core.Message>> {
  UnroutedMessagesProvider._({
    required UnroutedMessagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unroutedMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unroutedMessagesHash();

  @override
  String toString() {
    return r'unroutedMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<core.Message>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<core.Message>> create(Ref ref) {
    final argument = this.argument as String;
    return unroutedMessages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UnroutedMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unroutedMessagesHash() => r'edc4a615d1b80ce1e563e73d115f678de9854c77';

final class UnroutedMessagesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<core.Message>>, String> {
  UnroutedMessagesFamily._()
    : super(
        retry: null,
        name: r'unroutedMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UnroutedMessagesProvider call(String orgId) =>
      UnroutedMessagesProvider._(argument: orgId, from: this);

  @override
  String toString() => r'unroutedMessagesProvider';
}

@ProviderFor(taskSpecs)
final taskSpecsProvider = TaskSpecsFamily._();

final class TaskSpecsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.Artifact>>,
          List<core.Artifact>,
          FutureOr<List<core.Artifact>>
        >
    with
        $FutureModifier<List<core.Artifact>>,
        $FutureProvider<List<core.Artifact>> {
  TaskSpecsProvider._({
    required TaskSpecsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'taskSpecsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskSpecsHash();

  @override
  String toString() {
    return r'taskSpecsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<core.Artifact>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<core.Artifact>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return taskSpecs(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskSpecsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskSpecsHash() => r'77c6aac333699744539d0b33a004646480234cae';

final class TaskSpecsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<core.Artifact>>,
          (String, String)
        > {
  TaskSpecsFamily._()
    : super(
        retry: null,
        name: r'taskSpecsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TaskSpecsProvider call(String orgId, String projectId) =>
      TaskSpecsProvider._(argument: (orgId, projectId), from: this);

  @override
  String toString() => r'taskSpecsProvider';
}
