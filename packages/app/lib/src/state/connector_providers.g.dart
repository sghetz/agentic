// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(connectorDefinitions)
final connectorDefinitionsProvider = ConnectorDefinitionsProvider._();

final class ConnectorDefinitionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.ConnectorDefinition>>,
          List<core.ConnectorDefinition>,
          FutureOr<List<core.ConnectorDefinition>>
        >
    with
        $FutureModifier<List<core.ConnectorDefinition>>,
        $FutureProvider<List<core.ConnectorDefinition>> {
  ConnectorDefinitionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectorDefinitionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectorDefinitionsHash();

  @$internal
  @override
  $FutureProviderElement<List<core.ConnectorDefinition>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<core.ConnectorDefinition>> create(Ref ref) {
    return connectorDefinitions(ref);
  }
}

String _$connectorDefinitionsHash() =>
    r'c73bdf018b7a28177dca08620b59317cdc50db23';

@ProviderFor(connectorSources)
final connectorSourcesProvider = ConnectorSourcesFamily._();

final class ConnectorSourcesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.Source>>,
          List<core.Source>,
          FutureOr<List<core.Source>>
        >
    with
        $FutureModifier<List<core.Source>>,
        $FutureProvider<List<core.Source>> {
  ConnectorSourcesProvider._({
    required ConnectorSourcesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'connectorSourcesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$connectorSourcesHash();

  @override
  String toString() {
    return r'connectorSourcesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<core.Source>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<core.Source>> create(Ref ref) {
    final argument = this.argument as String;
    return connectorSources(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ConnectorSourcesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$connectorSourcesHash() => r'94c3178a6654975bc22b59599ea0209add264c11';

final class ConnectorSourcesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<core.Source>>, String> {
  ConnectorSourcesFamily._()
    : super(
        retry: null,
        name: r'connectorSourcesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ConnectorSourcesProvider call(String orgId) =>
      ConnectorSourcesProvider._(argument: orgId, from: this);

  @override
  String toString() => r'connectorSourcesProvider';
}
