import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/location.dart';

part 'location_providers.g.dart';

@riverpod
class LocationList extends _$LocationList {
  @override
  Future<List<Location>> build() async {
    final story = ref.watch(activeStoryProvider);
    if (story == null) return [];
    return ref.watch(locationRepositoryProvider).getAllForStory(story.id);
  }

  Future<void> createLocation(String name) async {
    final story = ref.read(activeStoryProvider);
    if (story == null) return;
    final location = Location(id: const Uuid().v4(), storyId: story.id, name: name);
    await ref.read(locationRepositoryProvider).create(location);
    ref.invalidateSelf();
  }

  Future<void> updateLocation(Location location) async {
    await ref.read(locationRepositoryProvider).update(location);
    ref.invalidateSelf();
  }

  Future<void> deleteLocation(String id) async {
    await ref.read(locationRepositoryProvider).delete(id);
    ref.invalidateSelf();
  }
}
