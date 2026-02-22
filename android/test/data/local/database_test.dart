import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_android/data/local/database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory(
    setup: (database) => database.execute('PRAGMA foreign_keys = ON'),
  )));
  tearDown(() async => await db.close());

  test('insert and retrieve story', () async {
    final now = DateTime.now();
    await db.into(db.storiesTable).insert(StoriesTableCompanion.insert(
      id: '1', title: 'Test Story', createdAt: now, updatedAt: now,
    ));
    final stories = await db.select(db.storiesTable).get();
    expect(stories.length, 1);
    expect(stories.first.title, 'Test Story');
  });

  test('cascade delete removes characters when story is deleted', () async {
    final now = DateTime.now();
    await db.into(db.storiesTable).insert(StoriesTableCompanion.insert(
      id: 's1', title: 'Story', createdAt: now, updatedAt: now,
    ));
    await db.into(db.charactersTable).insert(CharactersTableCompanion.insert(
      id: 'c1', storyId: 's1', name: 'Hero',
    ));
    await (db.delete(db.storiesTable)..where((t) => t.id.equals('s1'))).go();
    final chars = await db.select(db.charactersTable).get();
    expect(chars, isEmpty);
  });
}
