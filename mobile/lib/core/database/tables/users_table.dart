import 'package:drift/drift.dart';

/// Local cache of authenticated user profile.
class LocalUsers extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get emailVerifiedAt => text().nullable()();
  IntColumn get currentHouseholdId => integer().nullable()();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
