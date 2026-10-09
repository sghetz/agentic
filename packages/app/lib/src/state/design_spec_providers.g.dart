// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_spec_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(designSpecs)
final designSpecsProvider = DesignSpecsFamily._();

final class DesignSpecsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.Artifact>>,
          List<core.Artifact>,
          FutureOr<List<core.Artifact>>
        >
    with
        $FutureModifier<List<core.Artifact>>,
        $FutureProvider<List<core.Artifact>> {
  DesignSpecsProvider._({
    required DesignSpecsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'designSpecsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$designSpecsHash();

  @override
  String toString() {
    return r'designSpecsProvider'
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
    return designSpecs(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is DesignSpecsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$designSpecsHash() => r'2d316f1800956799ec5560559519ddf9cf0c07f2';

final class DesignSpecsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<core.Artifact>>,
          (String, String)
        > {
  DesignSpecsFamily._()
    : super(
        retry: null,
        name: r'designSpecsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DesignSpecsProvider call(String orgId, String projectId) =>
      DesignSpecsProvider._(argument: (orgId, projectId), from: this);

  @override
  String toString() => r'designSpecsProvider';
}

@ProviderFor(diagrams)
final diagramsProvider = DiagramsFamily._();

final class DiagramsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.Artifact>>,
          List<core.Artifact>,
          FutureOr<List<core.Artifact>>
        >
    with
        $FutureModifier<List<core.Artifact>>,
        $FutureProvider<List<core.Artifact>> {
  DiagramsProvider._({
    required DiagramsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'diagramsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diagramsHash();

  @override
  String toString() {
    return r'diagramsProvider'
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
    return diagrams(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is DiagramsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diagramsHash() => r'b7969f5b74f1f389e5112967cd3e223e21e3d50c';

final class DiagramsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<core.Artifact>>,
          (String, String)
        > {
  DiagramsFamily._()
    : super(
        retry: null,
        name: r'diagramsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DiagramsProvider call(String orgId, String projectId) =>
      DiagramsProvider._(argument: (orgId, projectId), from: this);

  @override
  String toString() => r'diagramsProvider';
}
