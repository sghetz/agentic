// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'org_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(orgList)
final orgListProvider = OrgListProvider._();

final class OrgListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<core.Organization>>,
          List<core.Organization>,
          FutureOr<List<core.Organization>>
        >
    with
        $FutureModifier<List<core.Organization>>,
        $FutureProvider<List<core.Organization>> {
  OrgListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orgListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orgListHash();

  @$internal
  @override
  $FutureProviderElement<List<core.Organization>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<core.Organization>> create(Ref ref) {
    return orgList(ref);
  }
}

String _$orgListHash() => r'4075345176a4c0f36c0ca692e716df8c8e35733b';

@ProviderFor(SelectedOrgId)
final selectedOrgIdProvider = SelectedOrgIdProvider._();

final class SelectedOrgIdProvider
    extends $NotifierProvider<SelectedOrgId, String?> {
  SelectedOrgIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedOrgIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedOrgIdHash();

  @$internal
  @override
  SelectedOrgId create() => SelectedOrgId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedOrgIdHash() => r'221115438177c51cbf7587bed41e4423c7d8bbed';

abstract class _$SelectedOrgId extends $Notifier<String?> {
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
