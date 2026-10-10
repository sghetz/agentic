// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskStatusFilter)
final taskStatusFilterProvider = TaskStatusFilterProvider._();

final class TaskStatusFilterProvider
    extends $NotifierProvider<TaskStatusFilter, core.TaskStatus?> {
  TaskStatusFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskStatusFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskStatusFilterHash();

  @$internal
  @override
  TaskStatusFilter create() => TaskStatusFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(core.TaskStatus? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<core.TaskStatus?>(value),
    );
  }
}

String _$taskStatusFilterHash() => r'2a2b21a0670b6c94069deca9dddbd78199c3bad4';

abstract class _$TaskStatusFilter extends $Notifier<core.TaskStatus?> {
  core.TaskStatus? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<core.TaskStatus?, core.TaskStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<core.TaskStatus?, core.TaskStatus?>,
              core.TaskStatus?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(TaskSearchQuery)
final taskSearchQueryProvider = TaskSearchQueryProvider._();

final class TaskSearchQueryProvider
    extends $NotifierProvider<TaskSearchQuery, String> {
  TaskSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskSearchQueryHash();

  @$internal
  @override
  TaskSearchQuery create() => TaskSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$taskSearchQueryHash() => r'227b2330562c9c2cb2520552e2570e5ab5d1d706';

abstract class _$TaskSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(TaskDateRange)
final taskDateRangeProvider = TaskDateRangeProvider._();

final class TaskDateRangeProvider
    extends $NotifierProvider<TaskDateRange, (DateTime?, DateTime?)> {
  TaskDateRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskDateRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskDateRangeHash();

  @$internal
  @override
  TaskDateRange create() => TaskDateRange();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((DateTime?, DateTime?) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(DateTime?, DateTime?)>(value),
    );
  }
}

String _$taskDateRangeHash() => r'23b6bf3edbe07e6ed323f3d6a988eef2490c6822';

abstract class _$TaskDateRange extends $Notifier<(DateTime?, DateTime?)> {
  (DateTime?, DateTime?) build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<(DateTime?, DateTime?), (DateTime?, DateTime?)>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<(DateTime?, DateTime?), (DateTime?, DateTime?)>,
              (DateTime?, DateTime?),
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(taskList)
final taskListProvider = TaskListFamily._();

final class TaskListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.Task>>,
          List<core.Task>,
          FutureOr<List<core.Task>>
        >
    with $FutureModifier<List<core.Task>>, $FutureProvider<List<core.Task>> {
  TaskListProvider._({
    required TaskListFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'taskListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskListHash();

  @override
  String toString() {
    return r'taskListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<core.Task>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<core.Task>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return taskList(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskListHash() => r'0e443d7e06cc6128c6126933cce34b316cbb6a45';

final class TaskListFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<core.Task>>, (String, String)> {
  TaskListFamily._()
    : super(
        retry: null,
        name: r'taskListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TaskListProvider call(String orgId, String projectId) =>
      TaskListProvider._(argument: (orgId, projectId), from: this);

  @override
  String toString() => r'taskListProvider';
}

@ProviderFor(taskDetail)
final taskDetailProvider = TaskDetailFamily._();

final class TaskDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<core.Task>,
          core.Task,
          FutureOr<core.Task>
        >
    with $FutureModifier<core.Task>, $FutureProvider<core.Task> {
  TaskDetailProvider._({
    required TaskDetailFamily super.from,
    required (String, String, {DateTime? at}) super.argument,
  }) : super(
         retry: null,
         name: r'taskDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskDetailHash();

  @override
  String toString() {
    return r'taskDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<core.Task> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<core.Task> create(Ref ref) {
    final argument = this.argument as (String, String, {DateTime? at});
    return taskDetail(ref, argument.$1, argument.$2, at: argument.at);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskDetailHash() => r'8251cf67ab0f976a0d75effe2644442f6704942b';

final class TaskDetailFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<core.Task>,
          (String, String, {DateTime? at})
        > {
  TaskDetailFamily._()
    : super(
        retry: null,
        name: r'taskDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TaskDetailProvider call(String orgId, String taskId, {DateTime? at}) =>
      TaskDetailProvider._(argument: (orgId, taskId, at: at), from: this);

  @override
  String toString() => r'taskDetailProvider';
}

@ProviderFor(taskEvents)
final taskEventsProvider = TaskEventsFamily._();

final class TaskEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.TaskEvent>>,
          List<core.TaskEvent>,
          FutureOr<List<core.TaskEvent>>
        >
    with
        $FutureModifier<List<core.TaskEvent>>,
        $FutureProvider<List<core.TaskEvent>> {
  TaskEventsProvider._({
    required TaskEventsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'taskEventsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskEventsHash();

  @override
  String toString() {
    return r'taskEventsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<core.TaskEvent>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<core.TaskEvent>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return taskEvents(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskEventsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskEventsHash() => r'bb5370d17c8e3eec5cada1328d6313cdec243bc8';

final class TaskEventsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<core.TaskEvent>>,
          (String, String)
        > {
  TaskEventsFamily._()
    : super(
        retry: null,
        name: r'taskEventsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TaskEventsProvider call(String orgId, String taskId) =>
      TaskEventsProvider._(argument: (orgId, taskId), from: this);

  @override
  String toString() => r'taskEventsProvider';
}

@ProviderFor(taskArtifacts)
final taskArtifactsProvider = TaskArtifactsFamily._();

final class TaskArtifactsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.Artifact>>,
          List<core.Artifact>,
          FutureOr<List<core.Artifact>>
        >
    with
        $FutureModifier<List<core.Artifact>>,
        $FutureProvider<List<core.Artifact>> {
  TaskArtifactsProvider._({
    required TaskArtifactsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'taskArtifactsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskArtifactsHash();

  @override
  String toString() {
    return r'taskArtifactsProvider'
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
    return taskArtifacts(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskArtifactsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskArtifactsHash() => r'8b4037f938c8b9aebaebedbb515861be3dbde6cd';

final class TaskArtifactsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<core.Artifact>>,
          (String, String)
        > {
  TaskArtifactsFamily._()
    : super(
        retry: null,
        name: r'taskArtifactsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TaskArtifactsProvider call(String orgId, String taskId) =>
      TaskArtifactsProvider._(argument: (orgId, taskId), from: this);

  @override
  String toString() => r'taskArtifactsProvider';
}

/// The task's current PR's live external check status. Only call this once
/// a PR artifact actually exists -- the server 400s otherwise.

@ProviderFor(prChecks)
final prChecksProvider = PrChecksFamily._();

/// The task's current PR's live external check status. Only call this once
/// a PR artifact actually exists -- the server 400s otherwise.

final class PrChecksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.PullRequestCheck>>,
          List<core.PullRequestCheck>,
          FutureOr<List<core.PullRequestCheck>>
        >
    with
        $FutureModifier<List<core.PullRequestCheck>>,
        $FutureProvider<List<core.PullRequestCheck>> {
  /// The task's current PR's live external check status. Only call this once
  /// a PR artifact actually exists -- the server 400s otherwise.
  PrChecksProvider._({
    required PrChecksFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'prChecksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$prChecksHash();

  @override
  String toString() {
    return r'prChecksProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<core.PullRequestCheck>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<core.PullRequestCheck>> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return prChecks(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is PrChecksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$prChecksHash() => r'fcbf202bfc13a47939f28911f21569045f3b1f43';

/// The task's current PR's live external check status. Only call this once
/// a PR artifact actually exists -- the server 400s otherwise.

final class PrChecksFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<core.PullRequestCheck>>,
          (String, String, String)
        > {
  PrChecksFamily._()
    : super(
        retry: null,
        name: r'prChecksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The task's current PR's live external check status. Only call this once
  /// a PR artifact actually exists -- the server 400s otherwise.

  PrChecksProvider call(String orgId, String projectId, String taskId) =>
      PrChecksProvider._(argument: (orgId, projectId, taskId), from: this);

  @override
  String toString() => r'prChecksProvider';
}
