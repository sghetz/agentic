// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboard)
final dashboardProvider = DashboardProvider._();

final class DashboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<core.DashboardSummary>,
          core.DashboardSummary,
          FutureOr<core.DashboardSummary>
        >
    with
        $FutureModifier<core.DashboardSummary>,
        $FutureProvider<core.DashboardSummary> {
  DashboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardHash();

  @$internal
  @override
  $FutureProviderElement<core.DashboardSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<core.DashboardSummary> create(Ref ref) {
    return dashboard(ref);
  }
}

String _$dashboardHash() => r'6f8b04113f801e37c72662a8fa7a1dc3f115059c';

@ProviderFor(systemCheck)
final systemCheckProvider = SystemCheckProvider._();

final class SystemCheckProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.DependencyCheck>>,
          List<core.DependencyCheck>,
          FutureOr<List<core.DependencyCheck>>
        >
    with
        $FutureModifier<List<core.DependencyCheck>>,
        $FutureProvider<List<core.DependencyCheck>> {
  SystemCheckProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemCheckProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemCheckHash();

  @$internal
  @override
  $FutureProviderElement<List<core.DependencyCheck>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<core.DependencyCheck>> create(Ref ref) {
    return systemCheck(ref);
  }
}

String _$systemCheckHash() => r'e69a708f6e0f15da56ab0b93cbad4964ecacf518';
