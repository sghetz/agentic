// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(healthReports)
final healthReportsProvider = HealthReportsFamily._();

final class HealthReportsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.Artifact>>,
          List<core.Artifact>,
          FutureOr<List<core.Artifact>>
        >
    with
        $FutureModifier<List<core.Artifact>>,
        $FutureProvider<List<core.Artifact>> {
  HealthReportsProvider._({
    required HealthReportsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'healthReportsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$healthReportsHash();

  @override
  String toString() {
    return r'healthReportsProvider'
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
    return healthReports(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is HealthReportsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$healthReportsHash() => r'a2c9273559e4038b4d3d26ef9d43b5f162d58bef';

final class HealthReportsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<core.Artifact>>,
          (String, String)
        > {
  HealthReportsFamily._()
    : super(
        retry: null,
        name: r'healthReportsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HealthReportsProvider call(String orgId, String projectId) =>
      HealthReportsProvider._(argument: (orgId, projectId), from: this);

  @override
  String toString() => r'healthReportsProvider';
}

@ProviderFor(latestHealthReport)
final latestHealthReportProvider = LatestHealthReportFamily._();

final class LatestHealthReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<core.Artifact?>,
          core.Artifact?,
          FutureOr<core.Artifact?>
        >
    with $FutureModifier<core.Artifact?>, $FutureProvider<core.Artifact?> {
  LatestHealthReportProvider._({
    required LatestHealthReportFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'latestHealthReportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$latestHealthReportHash();

  @override
  String toString() {
    return r'latestHealthReportProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<core.Artifact?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<core.Artifact?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return latestHealthReport(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is LatestHealthReportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$latestHealthReportHash() =>
    r'a6310f81985acdaeebe03b015f020fa926151f07';

final class LatestHealthReportFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<core.Artifact?>, (String, String)> {
  LatestHealthReportFamily._()
    : super(
        retry: null,
        name: r'latestHealthReportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LatestHealthReportProvider call(String orgId, String projectId) =>
      LatestHealthReportProvider._(argument: (orgId, projectId), from: this);

  @override
  String toString() => r'latestHealthReportProvider';
}
