import 'package:drift/drift.dart';

class LocalCategories extends Table {
  IntColumn get id => integer()();
  IntColumn get householdId => integer()();
  IntColumn get parentId => integer().nullable()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // income | expense
  TextColumn get icon => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
