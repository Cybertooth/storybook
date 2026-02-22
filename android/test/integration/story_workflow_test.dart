/// Integration tests for the core story-writing workflow.
///
/// These tests exercise the data layer end-to-end using an in-memory
/// SQLite database (no network, no Flutter UI required) and verify:
///   1. Story CRUD lifecycle
///   2. Character CRUD + cascade delete
///   3. Chapter create/update flow (no force-unwrap crash, CRIT-1)
///   4. Note/Question UUID uniqueness (IMP-9)
///   5. Cascade delete: deleting a story removes all children
///   6. Undo stack swallows errors from disposed refs (IMP-8)
///   7. Full workflow integration: create story → add characters → write chapters
library;

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_android/core/providers/undo_provider.dart';
import 'package:storybook_android/data/local/database.dart';
import 'package:storybook_android/data/local/repositories/local_character_repository.dart';
import 'package:storybook_android/data/local/repositories/local_chapter_repository.dart';
import 'package:storybook_android/data/local/repositories/local_note_repository.dart';
import 'package:storybook_android/data/local/repositories/local_question_repository.dart';
import 'package:storybook_android/data/local/repositories/local_story_repository.dart';
import 'package:storybook_android/domain/models/chapter.dart';
import 'package:storybook_android/domain/models/character.dart';
import 'package:storybook_android/domain/models/note.dart';
import 'package:storybook_android/domain/models/unresolved_question.dart';
import 'package:uuid/uuid.dart';

AppDatabase _makeDb() => AppDatabase.forTesting(NativeDatabase.memory(
      setup: (db) => db.execute('PRAGMA foreign_keys = ON'),
    ));

Chapter _makeChapter({
  required String storyId,
  required String title,
  int order = 0,
}) =>
    Chapter(
      id: const Uuid().v4(),
      storyId: storyId,
      title: title,
      order: order,
    );

void main() {
  // -------------------------------------------------------------------------
  // 1. Story CRUD
  // -------------------------------------------------------------------------
  group('StoryRepository', () {
    late AppDatabase db;
    late LocalStoryRepository repo;

    setUp(() {
      db = _makeDb();
      repo = LocalStoryRepository(db);
    });
    tearDown(() async => db.close());

    test('create returns a valid Story without crashing (CRIT-1)', () async {
      final story = await repo.create('The Dark Tower');
      expect(story.id, isNotEmpty);
      expect(story.title, 'The Dark Tower');
      expect(story.createdAt, isNotNull);
    });

    test('getById returns created story', () async {
      final story = await repo.create('Dune');
      final fetched = await repo.getById(story.id);
      expect(fetched?.title, 'Dune');
    });

    test('getAll returns all created stories', () async {
      await repo.create('A');
      await repo.create('B');
      await repo.create('C');
      expect((await repo.getAll()).length, 3);
    });

    test('update persists title and summary changes', () async {
      final story = await repo.create('Original');
      await repo.update(story.copyWith(title: 'Revised', summary: 'A great story'));
      final fetched = await repo.getById(story.id);
      expect(fetched?.title, 'Revised');
      expect(fetched?.summary, 'A great story');
    });

    test('delete removes the story', () async {
      final story = await repo.create('Ephemeral');
      await repo.delete(story.id);
      expect(await repo.getAll(), isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // 2. Character CRUD (CRIT-1: no force-unwrap after insert)
  // -------------------------------------------------------------------------
  group('CharacterRepository', () {
    late AppDatabase db;
    late LocalStoryRepository storyRepo;
    late LocalCharacterRepository charRepo;

    setUp(() {
      db = _makeDb();
      storyRepo = LocalStoryRepository(db);
      charRepo = LocalCharacterRepository(db);
    });
    tearDown(() async => db.close());

    test('create returns character without force-unwrap crash (CRIT-1)', () async {
      final story = await storyRepo.create('Test Story');
      final char = Character(
        id: const Uuid().v4(),
        storyId: story.id,
        name: 'Roland',
        role: CharacterRole.protagonist,
      );
      final created = await charRepo.create(char);
      expect(created.id, char.id);
      expect(created.name, 'Roland');
      expect(created.role, CharacterRole.protagonist);
    });

    test('getAllForStory returns only characters for that story', () async {
      final s1 = await storyRepo.create('S1');
      final s2 = await storyRepo.create('S2');
      await charRepo.create(Character(id: const Uuid().v4(), storyId: s1.id, name: 'Alice'));
      await charRepo.create(Character(id: const Uuid().v4(), storyId: s1.id, name: 'Bob'));
      await charRepo.create(Character(id: const Uuid().v4(), storyId: s2.id, name: 'Carol'));

      final s1Chars = await charRepo.getAllForStory(s1.id);
      expect(s1Chars.map((c) => c.name), containsAll(['Alice', 'Bob']));
      expect(s1Chars.length, 2);
    });

    test('update persists name and description changes', () async {
      final story = await storyRepo.create('Test');
      final char = await charRepo.create(
          Character(id: const Uuid().v4(), storyId: story.id, name: 'Draft Name'));
      await charRepo.update(char.copyWith(name: 'Final Name', description: 'Hero'));
      final fetched = await charRepo.getById(char.id);
      expect(fetched?.name, 'Final Name');
      expect(fetched?.description, 'Hero');
    });

    test('delete removes character', () async {
      final story = await storyRepo.create('Test');
      final char = await charRepo.create(
          Character(id: const Uuid().v4(), storyId: story.id, name: 'Temp'));
      await charRepo.delete(char.id);
      expect(await charRepo.getAllForStory(story.id), isEmpty);
    });

    test('cascade delete: deleting story removes all characters', () async {
      final story = await storyRepo.create('ToDelete');
      await charRepo.create(
          Character(id: const Uuid().v4(), storyId: story.id, name: 'Child'));
      await storyRepo.delete(story.id);
      expect(await charRepo.getAllForStory(story.id), isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // 3. Chapter CRUD (CRIT-1: no force-unwrap after insert)
  // -------------------------------------------------------------------------
  group('ChapterRepository', () {
    late AppDatabase db;
    late LocalStoryRepository storyRepo;
    late LocalChapterRepository chapterRepo;

    setUp(() {
      db = _makeDb();
      storyRepo = LocalStoryRepository(db);
      chapterRepo = LocalChapterRepository(db);
    });
    tearDown(() async => db.close());

    test('create returns chapter without force-unwrap crash (CRIT-1)', () async {
      final story = await storyRepo.create('Novel');
      final chapter =
          await chapterRepo.create(_makeChapter(storyId: story.id, title: 'Chapter 1'));
      expect(chapter.title, 'Chapter 1');
      expect(chapter.id, isNotEmpty);
    });

    test('saveContent: update persists prose content', () async {
      final story = await storyRepo.create('Novel');
      final chapter =
          await chapterRepo.create(_makeChapter(storyId: story.id, title: 'Prologue'));
      await chapterRepo.update(chapter.copyWith(content: 'It was a dark and stormy night.'));
      final fetched = await chapterRepo.getById(chapter.id);
      expect(fetched?.content, 'It was a dark and stormy night.');
    });

    test('multiple chapters created rapidly have unique IDs', () async {
      final story = await storyRepo.create('Novel');
      final ids = <String>{};
      for (int i = 0; i < 10; i++) {
        final c = await chapterRepo.create(_makeChapter(storyId: story.id, title: 'Ch $i', order: i));
        ids.add(c.id);
      }
      expect(ids.length, 10);
      expect((await chapterRepo.getAllForStory(story.id)).length, 10);
    });
  });

  // -------------------------------------------------------------------------
  // 4. Note UUID uniqueness (IMP-9: fixed from millisecond timestamp)
  // -------------------------------------------------------------------------
  group('Note UUID uniqueness', () {
    late AppDatabase db;
    late LocalStoryRepository storyRepo;
    late LocalNoteRepository noteRepo;

    setUp(() {
      db = _makeDb();
      storyRepo = LocalStoryRepository(db);
      noteRepo = LocalNoteRepository(db);
    });
    tearDown(() async => db.close());

    test('20 notes created in parallel all have unique IDs (IMP-9)', () async {
      final story = await storyRepo.create('Scratchpad Test');
      final notes = await Future.wait(List.generate(20, (i) async {
        return noteRepo.create(Note(
          id: const Uuid().v4(),
          storyId: story.id,
          content: 'Note $i',
          createdAt: DateTime.now(),
        ));
      }));
      final ids = notes.map((n) => n.id).toSet();
      expect(ids.length, 20);
      expect((await noteRepo.getAllForStory(story.id)).length, 20);
    });
  });

  // -------------------------------------------------------------------------
  // 5. Question UUID uniqueness (IMP-9)
  // -------------------------------------------------------------------------
  group('Question UUID uniqueness', () {
    late AppDatabase db;
    late LocalStoryRepository storyRepo;
    late LocalQuestionRepository questionRepo;

    setUp(() {
      db = _makeDb();
      storyRepo = LocalStoryRepository(db);
      questionRepo = LocalQuestionRepository(db);
    });
    tearDown(() async => db.close());

    test('20 questions created in parallel all have unique IDs (IMP-9)', () async {
      final story = await storyRepo.create('Question Test');
      final questions = await Future.wait(List.generate(20, (i) async {
        return questionRepo.create(UnresolvedQuestion(
          id: const Uuid().v4(),
          storyId: story.id,
          question: 'Why? $i',
          isResolved: false,
          createdAt: DateTime.now(),
        ));
      }));
      final ids = questions.map((q) => q.id).toSet();
      expect(ids.length, 20);
    });
  });

  // -------------------------------------------------------------------------
  // 6. Undo stack (IMP-8: silently swallows StateError from disposed ref)
  // -------------------------------------------------------------------------
  group('UndoStack', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });
    tearDown(() => container.dispose());

    test('undo with empty stack is a no-op', () async {
      final stack = container.read(undoStackProvider.notifier);
      await expectLater(stack.undo(), completes);
      expect(container.read(undoStackProvider), isEmpty);
    });

    test('undo executes the most recent command first (LIFO)', () async {
      final stack = container.read(undoStackProvider.notifier);
      final log = <int>[];
      stack.push(() async => log.add(1));
      stack.push(() async => log.add(2));
      stack.push(() async => log.add(3));
      await stack.undo();
      expect(log, [3]);
      await stack.undo();
      expect(log, [3, 2]);
    });

    test('undo does not crash when command throws StateError (IMP-8)', () async {
      final stack = container.read(undoStackProvider.notifier);
      stack.push(() async => throw StateError('Ref is no longer valid'));
      // Must complete without propagating the error.
      await expectLater(stack.undo(), completes);
      expect(container.read(undoStackProvider), isEmpty);
    });

    test('canUndo returns false when stack is empty', () {
      final stack = container.read(undoStackProvider.notifier);
      expect(stack.canUndo, isFalse);
      stack.push(() async {});
      expect(stack.canUndo, isTrue);
    });

    test('undo stack caps at 50 commands', () {
      final stack = container.read(undoStackProvider.notifier);
      for (int i = 0; i < 60; i++) {
        stack.push(() async {});
      }
      expect(container.read(undoStackProvider).length, 50);
    });
  });

  // -------------------------------------------------------------------------
  // 7. Full workflow: story → characters → chapters → cascade delete
  // -------------------------------------------------------------------------
  group('Full story workflow', () {
    late AppDatabase db;
    late LocalStoryRepository storyRepo;
    late LocalCharacterRepository charRepo;
    late LocalChapterRepository chapterRepo;

    setUp(() {
      db = _makeDb();
      storyRepo = LocalStoryRepository(db);
      charRepo = LocalCharacterRepository(db);
      chapterRepo = LocalChapterRepository(db);
    });
    tearDown(() async => db.close());

    test('create story, populate, query all data correctly', () async {
      // Create story
      final story = await storyRepo.create('Epic Fantasy');
      expect(story.id, isNotEmpty);

      // Add protagonist and antagonist
      await charRepo.create(Character(
        id: const Uuid().v4(),
        storyId: story.id,
        name: 'Aragorn',
        role: CharacterRole.protagonist,
        description: 'Ranger of the North',
      ));
      await charRepo.create(Character(
        id: const Uuid().v4(),
        storyId: story.id,
        name: 'Sauron',
        role: CharacterRole.antagonist,
      ));

      // Create and write to chapters
      final ch1 = await chapterRepo.create(
          _makeChapter(storyId: story.id, title: 'The Shire', order: 0));
      await chapterRepo.create(
          _makeChapter(storyId: story.id, title: 'Rivendell', order: 1));
      await chapterRepo.update(
          ch1.copyWith(content: 'In a hole in the ground there lived a hobbit.'));

      // Verify characters
      final chars = await charRepo.getAllForStory(story.id);
      expect(chars.length, 2);
      expect(chars.map((c) => c.name), containsAll(['Aragorn', 'Sauron']));

      // Verify chapters and content
      final chapters = await chapterRepo.getAllForStory(story.id);
      expect(chapters.length, 2);
      final savedCh1 = chapters.firstWhere((c) => c.title == 'The Shire');
      expect(savedCh1.content, 'In a hole in the ground there lived a hobbit.');
    });

    test('cascade delete removes story and all children', () async {
      final story = await storyRepo.create('Temporary');
      await charRepo.create(Character(
          id: const Uuid().v4(), storyId: story.id, name: 'X'));
      await chapterRepo.create(
          _makeChapter(storyId: story.id, title: 'Y'));

      await storyRepo.delete(story.id);

      expect(await storyRepo.getAll(), isEmpty);
      expect(await charRepo.getAllForStory(story.id), isEmpty);
      expect(await chapterRepo.getAllForStory(story.id), isEmpty);
    });

    test('two independent stories do not share data', () async {
      final s1 = await storyRepo.create('Story 1');
      final s2 = await storyRepo.create('Story 2');
      await charRepo.create(
          Character(id: const Uuid().v4(), storyId: s1.id, name: 'Alice'));
      await charRepo.create(
          Character(id: const Uuid().v4(), storyId: s2.id, name: 'Bob'));

      expect((await charRepo.getAllForStory(s1.id)).map((c) => c.name), ['Alice']);
      expect((await charRepo.getAllForStory(s2.id)).map((c) => c.name), ['Bob']);
    });
  });
}
