// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocationList)
final locationListProvider = LocationListProvider._();

final class LocationListProvider
    extends $AsyncNotifierProvider<LocationList, List<Location>> {
  LocationListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'locationListProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$locationListHash();

  @$internal
  @override
  LocationList create() => LocationList();
}

String _$locationListHash() => r'ef06dd8b6a54e27c9985d842ae545b49fa35da4a';

abstract class _$LocationList extends $AsyncNotifier<List<Location>> {
  FutureOr<List<Location>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Location>>, List<Location>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Location>>, List<Location>>,
        AsyncValue<List<Location>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
