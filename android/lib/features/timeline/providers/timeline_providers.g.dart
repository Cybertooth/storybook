// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EventList)
final eventListProvider = EventListProvider._();

final class EventListProvider
    extends $AsyncNotifierProvider<EventList, List<PlotEvent>> {
  EventListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'eventListProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$eventListHash();

  @$internal
  @override
  EventList create() => EventList();
}

String _$eventListHash() => r'19af4aef6983a378e6212dcfb81295eb0ee40986';

abstract class _$EventList extends $AsyncNotifier<List<PlotEvent>> {
  FutureOr<List<PlotEvent>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<PlotEvent>>, List<PlotEvent>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<PlotEvent>>, List<PlotEvent>>,
        AsyncValue<List<PlotEvent>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(plotThreads)
final plotThreadsProvider = PlotThreadsProvider._();

final class PlotThreadsProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  PlotThreadsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'plotThreadsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$plotThreadsHash();

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    return plotThreads(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$plotThreadsHash() => r'03aa361d8e3b9411243dd8356e765cf11364116a';
