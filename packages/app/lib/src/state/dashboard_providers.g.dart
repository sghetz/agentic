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
