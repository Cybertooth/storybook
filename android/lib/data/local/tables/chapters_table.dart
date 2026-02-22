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
