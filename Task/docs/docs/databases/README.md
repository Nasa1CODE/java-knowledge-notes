# Database SQL Folder

This folder stores SQL files for BillCloud database objects.

## Naming convention

Use one SQL file per database table:

- Tenant database tables: `databasetenant.<table_name>.sql`
- Host database tables: `databasehost.<table_name>.sql`

Examples:

```text
databasetenant.vs_hoadon.sql
databasetenant.vs_bangke.sql
databasehost.abptenants.sql
databasehost.abpusers.sql
```

## Rules

- Keep SQL files as plain `.sql` scripts.
- Do not commit connection strings, passwords, tokens, or production-only secrets.
- Prefer lowercase file names for consistency.
- If a table exists in both host and tenant databases, create two separate files using the correct prefix.
- **New column nullability:** when adding a new column, default it to `NULL` unless it is an index column (primary key, unique key, or foreign key). Index columns must be `NOT NULL`.
