import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/providers/undo_provider.dart';
import '../../../data/sync/sync_service.dart';
import '../../../domain/models/location.dart';

part 'location_providers.g.dart';

@Riverpod(keepAlive: true)
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
    final location =
        Location(id: const Uuid().v4(), storyId: story.id, name: name);
    await ref.read(locationRepositoryProvider).create(location);
    ref.invalidateSelf();
    ref.read(syncServiceProvider).pushLocationCreate(location).ignore();
  }

  Future<void> updateLocation(Location location) async {
    await ref.read(locationRepositoryProvider).update(location);
    ref.invalidateSelf();
    ref.read(syncServiceProvider).pushLocationUpdate(location).ignore();
  }

  Future<void> deleteLocation(String id) async {
    final backup = await ref.read(locationRepositoryProvider).getById(id);
    await ref.read(locationRepositoryProvider).delete(id);
    ref.invalidateSelf();
    ref.read(syncServiceProvider).pushLocationDelete(id).ignore();
    if (backup != null) {
      ref.read(undoStackProvider.notifier).push(() async {
        await ref.read(locationRepositoryProvider).create(backup);
        ref.invalidateSelf();
        ref.read(syncServiceProvider).pushLocationCreate(backup).ignore();
      });
    }
  }
}
