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
