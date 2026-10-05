// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Server address. Fixed for Phase 0 -- the backend only binds to
/// 127.0.0.1, per the non-negotiable local-only design.

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

/// Server address. Fixed for Phase 0 -- the backend only binds to
/// 127.0.0.1, per the non-negotiable local-only design.

final class ApiClientProvider
    extends $FunctionalProvider<ApiClient, ApiClient, ApiClient>
    with $Provider<ApiClient> {
  /// Server address. Fixed for Phase 0 -- the backend only binds to
  /// 127.0.0.1, per the non-negotiable local-only design.
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClient create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClient>(value),
    );
  }
}

String _$apiClientHash() => r'09cdcb3ce4cd9e443ed81b7fbf0a9932ea6610b3';
