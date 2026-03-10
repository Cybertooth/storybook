// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_story_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StoryList)
final storyListProvider = StoryListProvider._();

final class StoryListProvider
    extends $AsyncNotifierProvider<StoryList, List<Story>> {
  StoryListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'storyListProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$storyListHash();

  @$internal
  @override
  StoryList create() => StoryList();
}

String _$storyListHash() => r'558835b2d8f4720e3246b636101242f631270dd7';

abstract class _$StoryList extends $AsyncNotifier<List<Story>> {
  FutureOr<List<Story>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Story>>, List<Story>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Story>>, List<Story>>,
        AsyncValue<List<Story>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ActiveStory)
final activeStoryProvider = ActiveStoryProvider._();

final class ActiveStoryProvider extends $NotifierProvider<ActiveStory, Story?> {
  ActiveStoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'activeStoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activeStoryHash();

  @$internal
  @override
  ActiveStory create() => ActiveStory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Story? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Story?>(value),
    );
  }
}

String _$activeStoryHash() => r'2bdafd4d6ad0f9537a5411464127f188096448bc';

abstract class _$ActiveStory extends $Notifier<Story?> {
  Story? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Story?, Story?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Story?, Story?>, Story?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
