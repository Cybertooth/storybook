// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$plotThreadsHash() => r'f77e681336ed2a5764c162b9e58f7e630e76889f';

/// See also [plotThreads].
@ProviderFor(plotThreads)
final plotThreadsProvider = AutoDisposeProvider<List<String>>.internal(
  plotThreads,
  name: r'plotThreadsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$plotThreadsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlotThreadsRef = AutoDisposeProviderRef<List<String>>;
String _$eventListHash() => r'433f621492b6d8ad991121fa61091717239cfbbe';

/// See also [EventList].
@ProviderFor(EventList)
final eventListProvider =
    AsyncNotifierProvider<EventList, List<PlotEvent>>.internal(
  EventList.new,
  name: r'eventListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventList = AsyncNotifier<List<PlotEvent>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
