# Android Phase 2: Data Layer

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Define all domain models (freezed), create the Drift SQLite schema, implement the repository pattern, and register everything with Riverpod providers.

**Architecture:** Freezed models in `domain/models/`, Drift tables in `data/local/tables/`, local repository implementations in `data/local/repositories/`, Riverpod providers wiring them together.

**Tech Stack:** Freezed, json_serializable, Drift, Riverpod

**Depends on:** Phase 1 complete (Flutter project initialized with all packages).
**Next phase:** `2026-02-21-android-phase-3-dashboard-codex.md`

**IMPORTANT:** Run `dart run build_runner build --delete-conflicting-outputs` after adding any new file that contains `part '*.g.dart'` or `part '*.freezed.dart'`.

---

## Task 1: Domain Models (freezed)

**Files:**
- Create: `android/lib/domain/models/story.dart`
- Create: `android/lib/domain/models/character.dart`
- Create: `android/lib/domain/models/location.dart`
- Create: `android/lib/domain/models/plot_event.dart`
- Create: `android/lib/domain/models/chapter.dart`
- Create: `android/lib/domain/models/note.dart`
- Create: `android/lib/domain/models/unresolved_question.dart`
- Create: `android/lib/domain/models/relationship.dart`

**Step 1: Story model**

`android/lib/domain/models/story.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.freezed.dart';
part 'story.g.dart';

@freezed
class Story with _$Story {
  const factory Story({
    required String id,
    required String title,
    @Default('') String summary,
    @Default('') String theme,
    @Default('') String coreQuestion,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
```

**Step 2: Character model**

`android/lib/domain/models/character.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';
part 'character.g.dart';

enum CharacterRole { protagonist, antagonist, supporting, other }

@freezed
class Character with _$Character {
  const factory Character({
    required String id,
    required String storyId,
    required String name,
    @Default(CharacterRole.supporting) CharacterRole role,
    @Default('') String description,
    @Default([]) List<String> traits,
    String? arcLie,
    String? arcTruth,
    String? arcGhost,
    String? avatarUrl,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
}
```

**Step 3: Location model**

`android/lib/domain/models/location.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
class Location with _$Location {
  const factory Location({
    required String id,
    required String storyId,
    required String name,
    @Default('') String description,
    String? sensorySight,
    String? sensorySound,
    String? sensorySmell,
    String? sensoryTouch,
    String? sensoryTaste,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
}
```

**Step 4: PlotEvent model**

`android/lib/domain/models/plot_event.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'plot_event.freezed.dart';
part 'plot_event.g.dart';

enum EventStatus { idea, drafted, finalEvent }

@freezed
class PlotEvent with _$PlotEvent {
  const factory PlotEvent({
    required String id,
    required String storyId,
    required String title,
    @Default('') String description,
    @Default(0) int order,
    String? chapterId,
    @Default([]) List<String> characterIds,
    String? locationId,
    @Default(EventStatus.idea) EventStatus status,
    @Default('Main Plot') String plotThread,
    @Default(0) int emotionalValue,
  }) = _PlotEvent;

  factory PlotEvent.fromJson(Map<String, dynamic> json) => _$PlotEventFromJson(json);
}
```

**Step 5: Chapter model**

`android/lib/domain/models/chapter.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter.freezed.dart';
part 'chapter.g.dart';

enum ChapterStatus { planned, drafting, completed }

@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required String id,
    required String storyId,
    required String title,
    @Default('') String content,
    @Default(0) int order,
    @Default(ChapterStatus.planned) ChapterStatus status,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);
}
```

**Step 6: Note, UnresolvedQuestion, Relationship models**

`android/lib/domain/models/note.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'note.freezed.dart';
part 'note.g.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    required String storyId,
    required String content,
    required DateTime createdAt,
  }) = _Note;
  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
```

`android/lib/domain/models/unresolved_question.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'unresolved_question.freezed.dart';
part 'unresolved_question.g.dart';

@freezed
class UnresolvedQuestion with _$UnresolvedQuestion {
  const factory UnresolvedQuestion({
    required String id,
    required String storyId,
    required String question,
    @Default('') String details,
    @Default(false) bool isResolved,
    String? answer,
    required DateTime createdAt,
  }) = _UnresolvedQuestion;
  factory UnresolvedQuestion.fromJson(Map<String, dynamic> json) =>
      _$UnresolvedQuestionFromJson(json);
}
```

`android/lib/domain/models/relationship.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'relationship.freezed.dart';
part 'relationship.g.dart';

@freezed
class Relationship with _$Relationship {
  const factory Relationship({
    required String id,
    required String storyId,
    required String sourceId,
    required String targetId,
    required String type,
    @Default('') String description,
  }) = _Relationship;
  factory Relationship.fromJson(Map<String, dynamic> json) =>
      _$RelationshipFromJson(json);
}
```

**Step 7: Run code generation**

```bash
cd android
dart run build_runner build --delete-conflicting-outputs
```

Expected: All `*.freezed.dart` and `*.g.dart` generated without errors.

**Step 8: Write tests**

`android/test/domain/models/story_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_android/domain/models/story.dart';

void main() {
  group('Story', () {
    test('copyWith updates only specified fields', () {
      final story = Story(
        id: '1', title: 'My Story',
        createdAt: DateTime(2025), updatedAt: DateTime(2025),
      );
      final updated = story.copyWith(title: 'New Title');
      expect(updated.title, 'New Title');
      expect(updated.id, '1');
    });

    test('serializes to/from JSON', () {
      final story = Story(
        id: '1', title: 'Test',
        createdAt: DateTime(2025, 1, 1), updatedAt: DateTime(2025, 1, 1),
      );
      final restored = Story.fromJson(story.toJson());
      expect(restored, story);
    });
  });
}
```

**Step 9: Run tests**

```bash
cd android
flutter test test/domain/models/story_test.dart
```

Expected: PASS.

**Step 10: Commit**

```bash
git add android/lib/domain/ android/test/domain/
git commit -m "feat(android): domain models with freezed serialization"
```

---

## Task 2: Drift Database Schema

**Files:**
- Create: `android/lib/data/local/tables/stories_table.dart`
- Create: `android/lib/data/local/tables/characters_table.dart`
- Create: `android/lib/data/local/tables/locations_table.dart`
- Create: `android/lib/data/local/tables/plot_events_table.dart`
- Create: `android/lib/data/local/tables/chapters_table.dart`
- Create: `android/lib/data/local/tables/notes_table.dart`
- Create: `android/lib/data/local/tables/questions_table.dart`
- Create: `android/lib/data/local/tables/relationships_table.dart`
- Create: `android/lib/data/local/database.dart`
- Create: `android/lib/core/providers/database_provider.dart`

**Step 1: Stories table**

`android/lib/data/local/tables/stories_table.dart`:

```dart
import 'package:drift/drift.dart';

class StoriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get summary => text().withDefault(const Constant(''))();
  TextColumn get theme => text().withDefault(const Constant(''))();
  TextColumn get coreQuestion => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Step 2: Characters table**

`android/lib/data/local/tables/characters_table.dart`:

```dart
import 'package:drift/drift.dart';
import 'stories_table.dart';

class CharactersTable extends Table {
  TextColumn get id => text()();
  TextColumn get storyId => text().references(StoriesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get role => text().withDefault(const Constant('supporting'))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get traitsJson => text().withDefault(const Constant('[]'))();
  TextColumn get arcLie => text().nullable()();
  TextColumn get arcTruth => text().nullable()();
  TextColumn get arcGhost => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Step 3: Locations table**

`android/lib/data/local/tables/locations_table.dart`:

```dart
import 'package:drift/drift.dart';
import 'stories_table.dart';

class LocationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get storyId => text().references(StoriesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get sensorySight => text().nullable()();
  TextColumn get sensorySound => text().nullable()();
  TextColumn get sensorySmell => text().nullable()();
  TextColumn get sensoryTouch => text().nullable()();
  TextColumn get sensoryTaste => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Step 4: Remaining tables**

`android/lib/data/local/tables/plot_events_table.dart`:

```dart
import 'package:drift/drift.dart';
import 'stories_table.dart';

class PlotEventsTable extends Table {
  TextColumn get id => text()();
  TextColumn get storyId => text().references(StoriesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get order => integer().withDefault(const Constant(0))();
  TextColumn get chapterId => text().nullable()();
  TextColumn get characterIdsJson => text().withDefault(const Constant('[]'))();
  TextColumn get locationId => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('idea'))();
  TextColumn get plotThread => text().withDefault(const Constant('Main Plot'))();
  IntColumn get emotionalValue => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
```

`android/lib/data/local/tables/chapters_table.dart`:

```dart
import 'package:drift/drift.dart';
import 'stories_table.dart';

class ChaptersTable extends Table {
  TextColumn get id => text()();
  TextColumn get storyId => text().references(StoriesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get content => text().withDefault(const Constant(''))();
  IntColumn get order => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('planned'))();

  @override
  Set<Column> get primaryKey => {id};
}
```

`android/lib/data/local/tables/notes_table.dart`:

```dart
import 'package:drift/drift.dart';
import 'stories_table.dart';

class NotesTable extends Table {
  TextColumn get id => text()();
  TextColumn get storyId => text().references(StoriesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

`android/lib/data/local/tables/questions_table.dart`:

```dart
import 'package:drift/drift.dart';
import 'stories_table.dart';

class QuestionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get storyId => text().references(StoriesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get question => text()();
  TextColumn get details => text().withDefault(const Constant(''))();
  BoolColumn get isResolved => boolean().withDefault(const Constant(false))();
  TextColumn get answer => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

`android/lib/data/local/tables/relationships_table.dart`:

```dart
import 'package:drift/drift.dart';
import 'stories_table.dart';

class RelationshipsTable extends Table {
  TextColumn get id => text()();
  TextColumn get storyId => text().references(StoriesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get sourceId => text()();
  TextColumn get targetId => text()();
  TextColumn get type => text()();
  TextColumn get description => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Step 5: Main database class**

`android/lib/data/local/database.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/stories_table.dart';
import 'tables/characters_table.dart';
import 'tables/locations_table.dart';
import 'tables/plot_events_table.dart';
import 'tables/chapters_table.dart';
import 'tables/notes_table.dart';
import 'tables/questions_table.dart';
import 'tables/relationships_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  StoriesTable, CharactersTable, LocationsTable, PlotEventsTable,
  ChaptersTable, NotesTable, QuestionsTable, RelationshipsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() => driftDatabase(name: 'storybook_db');
}
```

**Step 6: Database provider**

`android/lib/core/providers/database_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
```

**Step 7: Run code generation**

```bash
cd android
dart run build_runner build --delete-conflicting-outputs
```

Expected: `database.g.dart` generated with table companions and typed row classes.

**Step 8: Write database test**

`android/test/data/local/database_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_android/data/local/database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
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
```

**Step 9: Run tests**

```bash
cd android
flutter test test/data/local/database_test.dart
```

Expected: PASS.

**Step 10: Commit**

```bash
git add android/lib/data/local/ android/lib/core/providers/database_provider.dart android/test/data/
git commit -m "feat(android): Drift SQLite schema with all 8 entity tables"
```

---

## Task 3: Repository Interfaces + Local Implementations

**Files (per entity — repeat this pattern for all 8 entities):**
- Create: `android/lib/domain/repositories/<entity>_repository.dart`
- Create: `android/lib/data/local/repositories/local_<entity>_repository.dart`
- Create: `android/lib/core/providers/repository_providers.dart`

**Step 1: Story repository interface**

`android/lib/domain/repositories/story_repository.dart`:

```dart
import '../models/story.dart';

abstract class StoryRepository {
  Future<List<Story>> getAll();
  Future<Story?> getById(String id);
  Future<Story> create(String title);
  Future<Story> update(Story story);
  Future<void> delete(String id);
}
```

**Step 2: Character repository interface**

`android/lib/domain/repositories/character_repository.dart`:

```dart
import '../models/character.dart';

abstract class CharacterRepository {
  Future<List<Character>> getAllForStory(String storyId);
  Future<Character?> getById(String id);
  Future<Character> create(Character character);
  Future<Character> update(Character character);
  Future<void> delete(String id);
}
```

**Step 3: Create interfaces for the remaining 6 entities**

Repeat the same pattern (with `getAllForStory` + `create` + `update` + `delete`) for:
- `location_repository.dart` (Location)
- `plot_event_repository.dart` (PlotEvent)
- `chapter_repository.dart` (Chapter)
- `note_repository.dart` (Note)
- `question_repository.dart` (UnresolvedQuestion)
- `relationship_repository.dart` (Relationship)

**Step 4: Local story repository**

`android/lib/data/local/repositories/local_story_repository.dart`:

```dart
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/story.dart';
import '../../../domain/repositories/story_repository.dart';
import '../database.dart';

class LocalStoryRepository implements StoryRepository {
  final AppDatabase _db;
  const LocalStoryRepository(this._db);

  Story _fromRow(StoriesTableData row) => Story(
        id: row.id, title: row.title, summary: row.summary,
        theme: row.theme, coreQuestion: row.coreQuestion,
        createdAt: row.createdAt, updatedAt: row.updatedAt,
      );

  @override
  Future<List<Story>> getAll() async =>
      (await _db.select(_db.storiesTable).get()).map(_fromRow).toList();

  @override
  Future<Story?> getById(String id) async {
    final row = await (_db.select(_db.storiesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<Story> create(String title) async {
    final now = DateTime.now();
    final id = const Uuid().v4();
    await _db.into(_db.storiesTable).insert(StoriesTableCompanion.insert(
      id: id, title: title, createdAt: now, updatedAt: now,
    ));
    return (await getById(id))!;
  }

  @override
  Future<Story> update(Story story) async {
    final updated = story.copyWith(updatedAt: DateTime.now());
    await (_db.update(_db.storiesTable)..where((t) => t.id.equals(story.id)))
        .write(StoriesTableCompanion(
      title: Value(updated.title), summary: Value(updated.summary),
      theme: Value(updated.theme), coreQuestion: Value(updated.coreQuestion),
      updatedAt: Value(updated.updatedAt),
    ));
    return updated;
  }

  @override
  Future<void> delete(String id) async =>
      (_db.delete(_db.storiesTable)..where((t) => t.id.equals(id))).go();
}
```

**Step 5: Local character repository**

`android/lib/data/local/repositories/local_character_repository.dart`:

```dart
import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../domain/models/character.dart';
import '../../../domain/repositories/character_repository.dart';
import '../database.dart';

class LocalCharacterRepository implements CharacterRepository {
  final AppDatabase _db;
  const LocalCharacterRepository(this._db);

  Character _fromRow(CharactersTableData row) => Character(
        id: row.id, storyId: row.storyId, name: row.name,
        role: CharacterRole.values.firstWhere(
          (r) => r.name == row.role,
          orElse: () => CharacterRole.supporting,
        ),
        description: row.description,
        traits: List<String>.from(jsonDecode(row.traitsJson)),
        arcLie: row.arcLie, arcTruth: row.arcTruth, arcGhost: row.arcGhost,
        avatarUrl: row.avatarUrl,
      );

  @override
  Future<List<Character>> getAllForStory(String storyId) async =>
      (await (_db.select(_db.charactersTable)..where((t) => t.storyId.equals(storyId))).get())
          .map(_fromRow).toList();

  @override
  Future<Character?> getById(String id) async {
    final row = await (_db.select(_db.charactersTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<Character> create(Character character) async {
    await _db.into(_db.charactersTable).insert(CharactersTableCompanion.insert(
      id: character.id, storyId: character.storyId, name: character.name,
      role: Value(character.role.name),
      description: Value(character.description),
      traitsJson: Value(jsonEncode(character.traits)),
      arcLie: Value(character.arcLie), arcTruth: Value(character.arcTruth),
      arcGhost: Value(character.arcGhost), avatarUrl: Value(character.avatarUrl),
    ));
    return (await getById(character.id))!;
  }

  @override
  Future<Character> update(Character character) async {
    await (_db.update(_db.charactersTable)..where((t) => t.id.equals(character.id)))
        .write(CharactersTableCompanion(
      name: Value(character.name), role: Value(character.role.name),
      description: Value(character.description),
      traitsJson: Value(jsonEncode(character.traits)),
      arcLie: Value(character.arcLie), arcTruth: Value(character.arcTruth),
      arcGhost: Value(character.arcGhost), avatarUrl: Value(character.avatarUrl),
    ));
    return character;
  }

  @override
  Future<void> delete(String id) async =>
      (_db.delete(_db.charactersTable)..where((t) => t.id.equals(id))).go();
}
```

**Step 6: Implement remaining 6 local repositories**

Repeat the same `_fromRow` + CRUD pattern for:
- `local_location_repository.dart`
- `local_plot_event_repository.dart` (note: `characterIdsJson` needs `jsonDecode/jsonEncode`)
- `local_chapter_repository.dart`
- `local_note_repository.dart`
- `local_question_repository.dart`
- `local_relationship_repository.dart`

**Step 7: Repository providers**

`android/lib/core/providers/repository_providers.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/repositories/local_story_repository.dart';
import '../../data/local/repositories/local_character_repository.dart';
import '../../data/local/repositories/local_location_repository.dart';
import '../../data/local/repositories/local_plot_event_repository.dart';
import '../../data/local/repositories/local_chapter_repository.dart';
import '../../data/local/repositories/local_note_repository.dart';
import '../../data/local/repositories/local_question_repository.dart';
import '../../data/local/repositories/local_relationship_repository.dart';
import '../../domain/repositories/story_repository.dart';
import '../../domain/repositories/character_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/plot_event_repository.dart';
import '../../domain/repositories/chapter_repository.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/question_repository.dart';
import '../../domain/repositories/relationship_repository.dart';
import 'database_provider.dart';

final storyRepositoryProvider = Provider<StoryRepository>(
  (ref) => LocalStoryRepository(ref.watch(databaseProvider)));
final characterRepositoryProvider = Provider<CharacterRepository>(
  (ref) => LocalCharacterRepository(ref.watch(databaseProvider)));
final locationRepositoryProvider = Provider<LocationRepository>(
  (ref) => LocalLocationRepository(ref.watch(databaseProvider)));
final plotEventRepositoryProvider = Provider<PlotEventRepository>(
  (ref) => LocalPlotEventRepository(ref.watch(databaseProvider)));
final chapterRepositoryProvider = Provider<ChapterRepository>(
  (ref) => LocalChapterRepository(ref.watch(databaseProvider)));
final noteRepositoryProvider = Provider<NoteRepository>(
  (ref) => LocalNoteRepository(ref.watch(databaseProvider)));
final questionRepositoryProvider = Provider<QuestionRepository>(
  (ref) => LocalQuestionRepository(ref.watch(databaseProvider)));
final relationshipRepositoryProvider = Provider<RelationshipRepository>(
  (ref) => LocalRelationshipRepository(ref.watch(databaseProvider)));
```

**Step 8: Write repository tests**

`android/test/data/local/repositories/local_story_repository_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_android/data/local/database.dart';
import 'package:storybook_android/data/local/repositories/local_story_repository.dart';

void main() {
  late AppDatabase db;
  late LocalStoryRepository repo;

  setUp(() { db = AppDatabase.forTesting(NativeDatabase.memory()); repo = LocalStoryRepository(db); });
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
```

**Step 9: Run tests**

```bash
cd android
flutter test test/data/local/repositories/
```

Expected: PASS.

**Step 10: Commit**

```bash
git add android/lib/domain/repositories/ android/lib/data/local/repositories/ android/lib/core/providers/repository_providers.dart android/test/data/local/repositories/
git commit -m "feat(android): repository interfaces and local Drift implementations for all entities"
```
