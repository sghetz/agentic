// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShowArchivedProjects)
final showArchivedProjectsProvider = ShowArchivedProjectsProvider._();

final class ShowArchivedProjectsProvider
    extends $NotifierProvider<ShowArchivedProjects, bool> {
  ShowArchivedProjectsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showArchivedProjectsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showArchivedProjectsHash();

  @$internal
  @override
  ShowArchivedProjects create() => ShowArchivedProjects();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showArchivedProjectsHash() =>
    r'c644fb7df75c4524b49311855365a81eb99afadb';

abstract class _$ShowArchivedProjects extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(projectList)
final projectListProvider = ProjectListFamily._();

final class ProjectListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.Project>>,
          List<core.Project>,
          FutureOr<List<core.Project>>
        >
    with
        $FutureModifier<List<core.Project>>,
        $FutureProvider<List<core.Project>> {
  ProjectListProvider._({
    required ProjectListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'projectListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectListHash();

  @override
  String toString() {
    return r'projectListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<core.Project>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<core.Project>> create(Ref ref) {
    final argument = this.argument as String;
    return projectList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectListHash() => r'9c94e206343d73a2a39047a0a684541538d0ce30';

final class ProjectListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<core.Project>>, String> {
  ProjectListFamily._()
    : super(
        retry: null,
        name: r'projectListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProjectListProvider call(String orgId) =>
      ProjectListProvider._(argument: orgId, from: this);

  @override
  String toString() => r'projectListProvider';
}

@ProviderFor(SelectedProjectId)
final selectedProjectIdProvider = SelectedProjectIdProvider._();

final class SelectedProjectIdProvider
    extends $NotifierProvider<SelectedProjectId, String?> {
  SelectedProjectIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedProjectIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedProjectIdHash();

  @$internal
  @override
  SelectedProjectId create() => SelectedProjectId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedProjectIdHash() => r'f55cc720f007f7469ffc3c0e0446bd0b83c777dc';

abstract class _$SelectedProjectId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
