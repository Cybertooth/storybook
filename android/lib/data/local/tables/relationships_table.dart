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
