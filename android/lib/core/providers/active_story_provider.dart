import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/story.dart';
import 'repository_providers.dart';

part 'active_story_provider.g.dart';

@Riverpod(keepAlive: true)
class StoryList extends _$StoryList {
  @override
  Future<List<Story>> build() async {
    return ref.watch(storyRepositoryProvider).getAll();
  }

  Future<void> createStory(String title) async {
    await ref.read(storyRepositoryProvider).create(title);
    ref.invalidateSelf();
  }

  Future<void> deleteStory(String id) async {
    await ref.read(storyRepositoryProvider).delete(id);
    ref.invalidateSelf();
    if (ref.read(activeStoryProvider)?.id == id) {
      ref.read(activeStoryProvider.notifier).clear();
    }
  }
}

@Riverpod(keepAlive: true)
class ActiveStory extends _$ActiveStory {
  @override
  Story? build() => null;

  void set(Story story) => state = story;
  void clear() => state = null;
}
