# example-drift-export-column-check-bug

A repository demonstrating an issue trying to export column `check` constraints.

## Issue description

Column `check` constraints are not exported as part of a table schema. This is demonstrated by a new migration to version `2` which adds the column `creationTime` to the `Users` table. This migration _should_ work, but it fails when calling `validateDatabaseSchema()` in `beforeOpen` with the error shown below (output from `dart test`):

```txt
Schema does not match
  users:
   columns:
    creation_time:
     Not equal: `NOT NULL DEFAULT 1704096000` (expected) and `NOT NULL DEFAULT 1704096000 CHECK(NOT 1 AND "creation_time" IS NULL OR 1 AND "creation_time" IS NOT NULL AND "creation_time" > 0)` (actual)
```

From above, we see that the schema does not result in the correct column constraint definition. However, the database's definition of the column _does_ include the expected constraint.

## Reproduction steps

> NOTE: `drift` and `drift_dev` have been pinned to the latest version available
> at this time. The issue does reproduce at these versions.

1. Clone this repository:

    ```sh
    git clone https://github.com/coffeebeats/example-drift-export-column-check-bug.git
    ```

2. Run the migration tests (installing packages as needed) and observe the error:

    ```sh
    dart test
    ```

3. Toggle the migration logic back to the passing code (which matches what should work/is documented):

    In [lib/database.dart](./lib/database.dart#L46):

    ```sh
    // This passes tests, but will fail on a real migration.
    await m.addColumn(schema.users, schema.users.creationTime);

    // This fails tests, but will pass on a real migration.
    // await m.addColumn(schema.users, m.database.allTables.first.columnsByName["creation_time"]!);
    ```

4. Re-run the migration tests and observe the failure:

    ```sh
    dart test
    ```

## Regenerating code

This isn't needed for reproducing the issue, but as a reference, run the following command to regenerate all migration/schema files:

```sh
\
    dart run build_runner build --delete-conflicting-outputs & \
    ( \
        dart run drift_dev schema dump lib/database.dart drift_schemas/ && \
        dart run drift_dev schema steps drift_schemas/ lib/migration.g.dart && \
        dart run drift_dev schema generate --data-classes --companions drift_schemas/ test/migrations && \
    ) & \
    wait
```
