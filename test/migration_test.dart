import 'package:example_drift_export_column_check_bug/database.dart';
import 'package:drift/drift.dart';
import 'package:test/test.dart';
import 'package:drift_dev/api/migrations.dart';

// Import the generated schema helper to instantiate databases at old versions.
import 'migrations/schema.dart';
import 'migrations/schema_v1.dart' as v1;
import 'migrations/schema_v2.dart' as v2;

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    // NOTE: Data migration tests seem to warn about this. Disable for now until
    // a better solution is found.
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

    // GeneratedHelper() was generated by drift, the verifier is an api
    // provided by drift_dev.
    verifier = SchemaVerifier(GeneratedHelper());
  });

  tearDownAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = false;
  });

  group("Migrating to v2", () {
    test("from v1 succeeds", () async {
      // Given: A connection to a database with all 'v1' entities.
      final connection = await verifier.startAt(1);

      // Given: A 'Database' using the 'v1' connection.
      final db = Database(connection);

      // When: The 'Database' is migrated to 'v2'.
      // Then: The migration succeeds.
      await verifier.migrateAndValidate(db, 2);
    });

    test("from v1 doesn't lose data", () async {
      // Given: The 'v1' database schema.
      final schema = await verifier.schemaAt(1);

      // Given: A 'v1' database wrapper.
      final prior = v1.DatabaseAtV1(schema.newConnection());

      // Given: A new 'v1' user is created.
      final want = await prior
          .into(prior.users)
          .insertReturning(v1.UsersCompanion.insert());
      await prior.close();

      // When: The migration to 'v2' is run.
      final db = Database(schema.newConnection());
      await verifier.migrateAndValidate(db, 2);
      await db.close();

      // Then: The inserted user still exists.
      final next = v2.DatabaseAtV2(schema.newConnection());
      final got = await next.select(next.users).getSingle();
      expect(got.id, want.id);
      expect(got.creationTime, DateTime(2024, 1, 1)); // Default column value.
      await next.close();
    });
  });
}
