import 'package:drift/drift.dart';
import 'stories_table.dart';

class NotesTable extends Table {
  TextColumn get id => text()();
  TextColumn get storyId =>
      text().references(StoriesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  TextColumn get label => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
