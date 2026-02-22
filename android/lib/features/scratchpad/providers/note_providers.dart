import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/providers/undo_provider.dart';
import '../../../domain/models/note.dart';

part 'note_providers.g.dart';

@Riverpod(keepAlive: true)
class NoteList extends _$NoteList {
  @override
  Future<List<Note>> build() async {
    final storyId = ref.watch(activeStoryProvider)?.id;
    if (storyId == null) return [];
    final repo = ref.read(noteRepositoryProvider);
    return repo.getAllForStory(storyId);
  }

  Future<void> add(String storyId, String content) async {
    final repo = ref.read(noteRepositoryProvider);
    await repo.create(Note(
      id: const Uuid().v4(),
      storyId: storyId,
      content: content,
      createdAt: DateTime.now(),
    ));
    ref.invalidateSelf();
  }

  Future<void> updateNote(Note note) async {
    final repo = ref.read(noteRepositoryProvider);
    await repo.update(note);
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    final repo = ref.read(noteRepositoryProvider);
    final backup = await repo.getById(id);
    await repo.delete(id);
    ref.invalidateSelf();
    if (backup != null) {
      ref.read(undoStackProvider.notifier).push(() async {
        await ref.read(noteRepositoryProvider).create(backup);
        ref.invalidateSelf();
      });
    }
  }
}
