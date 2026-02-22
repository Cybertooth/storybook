// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_story_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storyListHash() => r'7851d0797fdc9ba7407f06dfae36af8857c96956';

/// See also [StoryList].
@ProviderFor(StoryList)
final storyListProvider =
    AsyncNotifierProvider<StoryList, List<Story>>.internal(
  StoryList.new,
  name: r'storyListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$storyListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StoryList = AsyncNotifier<List<Story>>;
String _$activeStoryHash() => r'4f5543f5bc68ec875d64eb44e748d5277e9b9f73';

/// See also [ActiveStory].
@ProviderFor(ActiveStory)
final activeStoryProvider =
    NotifierProvider<ActiveStory, Story?>.internal(
  ActiveStory.new,
  name: r'activeStoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeStoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActiveStory = Notifier<Story?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
