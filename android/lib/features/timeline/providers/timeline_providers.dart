import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/providers/undo_provider.dart';
import '../../../domain/models/plot_event.dart';

part 'timeline_providers.g.dart';

@riverpod
class EventList extends _$EventList {
  @override
  Future<List<PlotEvent>> build() async {
    final story = ref.watch(activeStoryProvider);
    if (story == null) return [];
    final events = await ref.watch(plotEventRepositoryProvider).getAllForStory(story.id);
    events.sort((a, b) => a.order.compareTo(b.order));
    return events;
  }

  Future<void> createEvent({required String title, required String plotThread}) async {
    final story = ref.read(activeStoryProvider);
    if (story == null) return;
    final all = await ref.read(plotEventRepositoryProvider).getAllForStory(story.id);
    final event = PlotEvent(
      id: const Uuid().v4(),
      storyId: story.id,
      title: title,
      plotThread: plotThread,
      order: all.length,
    );
    await ref.read(plotEventRepositoryProvider).create(event);
    ref.invalidateSelf();
  }

  Future<void> updateEvent(PlotEvent event) async {
    await ref.read(plotEventRepositoryProvider).update(event);
    ref.invalidateSelf();
  }

  Future<void> deleteEvent(String id) async {
    final backup = await ref.read(plotEventRepositoryProvider).getById(id);
    await ref.read(plotEventRepositoryProvider).delete(id);
    ref.invalidateSelf();
    if (backup != null) {
      ref.read(undoStackProvider.notifier).push(() async {
        await ref.read(plotEventRepositoryProvider).create(backup);
        ref.invalidateSelf();
      });
    }
  }
}

@riverpod
List<String> plotThreads(Ref ref) {
  final events = ref.watch(eventListProvider).valueOrNull ?? [];
  final threads = events.map((e) => e.plotThread).toSet().toList();
  if (!threads.contains('Main Plot')) threads.insert(0, 'Main Plot');
  return threads;
}
