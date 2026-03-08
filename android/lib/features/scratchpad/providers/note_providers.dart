import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/providers/undo_provider.dart';
import '../../../data/sync/sync_service.dart';
import '../../../domain/models/note.dart';

part 'note_providers.g.dart';

@riverpod
class NoteFilter extends _$NoteFilter {
  @override
  String? build() => null;

  void setFilter(String? label) {
    state = label;
  }
}

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
    final notes = state.value ?? [];
    final targetOrder = notes.isEmpty ? 0 : notes.last.orderIndex + 1;

    final note = Note(
      id: const Uuid().v4(),
      storyId: storyId,
      content: content,
      createdAt: DateTime.now(),
      orderIndex: targetOrder,
    );
    final repo = ref.read(noteRepositoryProvider);
    await repo.create(note);
    ref.invalidateSelf();
    ref.read(syncServiceProvider).pushNoteCreate(note).ignore();
  }

  Future<void> updateNote(Note note) async {
    final repo = ref.read(noteRepositoryProvider);
    await repo.update(note);
    ref.invalidateSelf();
    ref.read(syncServiceProvider).pushNoteUpdate(note).ignore();
  }

  Future<void> reorderNotes(int oldIndex, int newIndex) async {
    final notes = state.value?.toList();
    if (notes == null) return;

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final note = notes.removeAt(oldIndex);
    notes.insert(newIndex, note);

    final repo = ref.read(noteRepositoryProvider);
    final sync = ref.read(syncServiceProvider);
    for (int i = 0; i < notes.length; i++) {
      if (notes[i].orderIndex != i) {
        final updated = notes[i].copyWith(orderIndex: i);
        notes[i] = updated;
        await repo.update(updated);
        sync.pushNoteUpdate(updated).ignore();
      }
    }
    state = AsyncData(notes);
  }

  Future<void> delete(String id) async {
    final repo = ref.read(noteRepositoryProvider);
    final backup = await repo.getById(id);
    await repo.delete(id);
    ref.invalidateSelf();
    ref.read(syncServiceProvider).pushNoteDelete(id).ignore();
    if (backup != null) {
      ref.read(undoStackProvider.notifier).push(() async {
        await ref.read(noteRepositoryProvider).create(backup);
        ref.invalidateSelf();
        ref.read(syncServiceProvider).pushNoteCreate(backup).ignore();
      });
    }
  }
}
