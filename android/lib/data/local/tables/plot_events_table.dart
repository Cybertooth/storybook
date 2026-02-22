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
