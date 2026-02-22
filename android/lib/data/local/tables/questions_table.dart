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
