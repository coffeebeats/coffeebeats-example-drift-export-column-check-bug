import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations.dart';

import 'migration.g.dart';

part 'tables.dart';
part 'database.g.dart';

/// This isn't a Flutter app, so we have to define the constant. In a real app,
/// just use the constant defined in the Flutter SDK.
const kDebugMode = true;

@DriftDatabase(tables: [Users])
class Database extends _$Database {
  Database(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // See https://drift.simonbinder.eu/api/drift/buildcolumn/references.
        await customStatement("PRAGMA foreign_keys = ON");

        if (kDebugMode) {
          await validateDatabaseSchema();
        }
      },
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Run migration steps without foreign keys and re-enable them later;
        // see https://drift.simonbinder.eu/docs/advanced-features/migrations/#tips.
        await customStatement("PRAGMA foreign_keys = OFF");

        await transaction(() async {
          await m.runMigrationSteps(
            from: from,
            to: to,
            steps: migrationSteps(
              from1To2: (m, schema) async {
                // This passes tests, but will fail on a real migration.
                // await m.addColumn(schema.users, schema.users.creationTime);

                // This fails tests, but will pass on a real migration.
                await m.addColumn(schema.users,
                    m.database.allTables.first.columnsByName["creation_time"]!);
              },
            ),
          );
        });

        // Verify that the migrated schema is valid.
        if (kDebugMode) {
          final wrongForeignKeys =
              await customSelect('PRAGMA foreign_key_check').get();
          assert(wrongForeignKeys.isEmpty,
              '${wrongForeignKeys.map((e) => e.data)}');
        }
      },
    );
  }
}
