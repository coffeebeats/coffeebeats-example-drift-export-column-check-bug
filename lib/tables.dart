part of 'database.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  // NOTE: This column is added to show how column 'check' constraints are not
  // exported as part of the table's schema. For demonstration purposes, a
  // similar column to the example from [ColumnBuilder.check] is used.

  // Column added in version 11
  // Column that can only be set to times after 1950.
  DateTimeColumn get creationTime => dateTime()
      .check(creationTime.isBiggerThan(Constant(DateTime(2020))))
      .withDefault(Constant(DateTime(2024, 1, 1)))();
}
