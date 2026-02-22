import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/chapter.dart';

part 'draft_providers.g.dart';

@Riverpod(keepAlive: true)
class ChapterList extends _$ChapterList {
  @override
  Future<List<Chapter>> build() async {
    final story = ref.watch(activeStoryProvider);
    if (story == null) return [];
    final chapters = await ref.watch(chapterRepositoryProvider).getAllForStory(story.id);
    chapters.sort((a, b) => a.order.compareTo(b.order));
    return chapters;
  }

  Future<Chapter> createChapter(String title) async {
    final story = ref.read(activeStoryProvider);
    if (story == null) throw StateError('No active story selected');
    final existing = await ref.read(chapterRepositoryProvider).getAllForStory(story.id);
    final chapter = Chapter(
      id: const Uuid().v4(),
      storyId: story.id,
      title: title,
      order: existing.length,
    );
    final created = await ref.read(chapterRepositoryProvider).create(chapter);
    ref.invalidateSelf();
    return created;
  }

  Future<void> saveContent(Chapter chapter, String content) async {
    await ref.read(chapterRepositoryProvider).update(chapter.copyWith(content: content));
    // Don't invalidateSelf here — it would cause re-render while typing.
    // The active chapter state is the source of truth during editing.
  }

  Future<void> deleteChapter(String id) async {
    await ref.read(chapterRepositoryProvider).delete(id);
    ref.invalidateSelf();
  }
}

@Riverpod(keepAlive: true)
class ActiveChapter extends _$ActiveChapter {
  @override
  Chapter? build() => null;

  void set(Chapter c) => state = c;
  void clear() => state = null;
}
