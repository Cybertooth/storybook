import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/story.dart';
import 'repository_providers.dart';
import '../../data/sync/sync_service.dart';

part 'active_story_provider.g.dart';

@Riverpod(keepAlive: true)
class StoryList extends _$StoryList {
  @override
  Future<List<Story>> build() async {
    return ref.watch(storyRepositoryProvider).getAll();
  }

  Future<void> createStory(String title) async {
    final story = await ref.read(storyRepositoryProvider).create(title);
    ref.invalidateSelf();
    // Background sync: fire-and-forget; offline mode silently skips.
    ref.read(syncServiceProvider).pushStoryCreate(story).ignore();
  }

  Future<void> updateStory(Story story) async {
    final updated = await ref.read(storyRepositoryProvider).update(story);
    ref.invalidateSelf();
    ref.read(syncServiceProvider).pushStoryUpdate(updated).ignore();
  }

  Future<void> deleteStory(String id) async {
    await ref.read(storyRepositoryProvider).delete(id);
    ref.invalidateSelf();
    if (ref.read(activeStoryProvider)?.id == id) {
      ref.read(activeStoryProvider.notifier).clear();
    }
    ref.read(syncServiceProvider).pushStoryDelete(id).ignore();
  }
}

@Riverpod(keepAlive: true)
class ActiveStory extends _$ActiveStory {
  @override
  Story? build() => null;

  void set(Story story) => state = story;
  void clear() => state = null;
}
