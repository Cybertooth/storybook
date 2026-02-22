import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_android/data/local/database.dart';
import 'package:storybook_android/data/local/repositories/local_story_repository.dart';

void main() {
  late AppDatabase db;
  late LocalStoryRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory(
      setup: (database) => database.execute('PRAGMA foreign_keys = ON'),
    ));
    repo = LocalStoryRepository(db);
  });
  tearDown(() async => await db.close());

  test('create returns story with generated id', () async {
    final story = await repo.create('My Novel');
    expect(story.title, 'My Novel');
    expect(story.id, isNotEmpty);
  });

  test('getAll returns all stories', () async {
    await repo.create('A');
    await repo.create('B');
    expect((await repo.getAll()).length, 2);
  });

  test('update persists title change', () async {
    final story = await repo.create('Original');
    await repo.update(story.copyWith(title: 'Updated'));
    expect((await repo.getById(story.id))?.title, 'Updated');
  });

  test('delete removes story', () async {
    final story = await repo.create('ToDelete');
    await repo.delete(story.id);
    expect(await repo.getAll(), isEmpty);
  });
}
