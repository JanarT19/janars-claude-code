---
description: Generate Liquibase migration changelogs for FastAPI + PostgreSQL
model: claude-sonnet-4-5
---

Generate Liquibase migration changelogs in plain SQL format for FastAPI applications using PostgreSQL.

## Requirements

Migration Request: $ARGUMENTS

## Implementation Guidelines

### 1. **Check for Existing Pydantic Models**

-   **FIRST**: Search the codebase for existing Pydantic models/entities
-   If models exist, use their field definitions to generate changelogs
-   Extract field names, types, constraints, and relationships from Pydantic models
-   If no models exist, generate schema based on user instructions or previous context

### 2. **Changelog Format**

-   Use **plain SQL syntax** (NOT XML format)
-   Follow Liquibase SQL changelog conventions
-   File naming: `YYYYMMDD-HHMM-descriptive-name.sql`
-   Location: Place in project's resources or Liquibase migrations directory (typically `migrations/`, `db/changelog/`, or `liquibase/changelogs/`)

### 3. **Changelog Structure**

```sql
--liquibase formatted sql

--changeset author:unique-id-1
CREATE TABLE table_name (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- other columns
);

--changeset author:unique-id-2
CREATE INDEX idx_table_column ON table_name(column_name);
```

### 4. **Field Type Mapping (Pydantic → PostgreSQL)**

-   `str` → `TEXT`
-   `int` → `INTEGER` or `BIGINT`
-   `float` → `NUMERIC` or `DOUBLE PRECISION`
-   `bool` → `BOOLEAN`
-   `datetime` → `TIMESTAMP` or `TIMESTAMP WITH TIME ZONE`
-   `date` → `DATE`
-   `UUID` → `UUID`
-   `Optional[T]` → Nullable column
-   `list` / `List[T]` → `JSONB` or separate table
-   `dict` → `JSONB`
-   Foreign keys → Use appropriate type matching referenced column

### 5. **Best Practices**

**Schema Design:**

-   Always include `id`, `created_on`, `updated_on` columns
-   Use UUID for primary keys by default
-   Use `TIMESTAMP WITH TIME ZONE` for timezone-aware timestamps
-   Add NOT NULL constraints where appropriate
-   Define foreign key constraints explicitly

**Changesets:**

-   One logical change per changeset
-   Unique, incerementing changeset IDs
-   In case of complex cahnges, add optional comments explaining purpose
-   Consider idempotency (use IF NOT EXISTS where appropriate)

**Indexes:**

-   Create indexes for foreign keys
-   Add indexes for frequently queried columns
-   Use partial indexes for filtered queries
-   Consider composite indexes for multi-column queries

**Constraints:**

-   Define CHECK constraints for data validation
-   Add UNIQUE constraints where needed
-   Use FOREIGN KEY with appropriate ON DELETE/ON UPDATE actions

### 6. **Common Patterns**

**Creating a new table:**

```sql
--changeset janart:1-1
--comment: Create users table for authentication
CREATE TABLE IF NOT EXISTS users (
    id BIGINT NOT NULL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_on TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_on TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE SEQUENCE users_seq;

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
```

**Adding a column:**

```sql
--changeset janar:add-user-avatar
--comment: Add avatar URL column to users table
ALTER TABLE users ADD COLUMN avatar_url TEXT;
```

**Creating a relationship:**

```sql
--changeset janar:create-posts-table
--comment: Create posts table with user relationship
CREATE TABLE IF NOT EXISTS posts (
    id BIGINT NOT NULL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    published_on TIMESTAMP WITH TIME ZONE,
    created_on TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_on TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE posts_seq;

CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_published_at ON posts(published_on) WHERE published_on IS NOT NULL;
```

**Adding JSONB column:**

```sql
--changeset janar:add-user-metadata
--comment: Add metadata JSONB column for flexible user data
ALTER TABLE users ADD COLUMN metadata JSONB;
CREATE INDEX idx_users_metadata ON users USING GIN(metadata);
```

### 7. **Integration Notes**

-   Liquibase runs automatically when FastAPI app starts
-   Ensure changelog files are in the correct directory
-   Keep changelogs in version control
-   Never modify existing changelogs; create new ones for changes

### 8. **Validation Checklist**

-   [ ] Changelog uses plain SQL format with Liquibase headers
-   [ ] Unique changeset IDs (<author>:<file-nr>-<change-nr>)
-   [ ] Rollback statements provided for all changes
-   [ ] Appropriate column types and constraints
-   [ ] Indexes created for foreign keys and frequently queried columns
-   [ ] Timestamps use TIMESTAMP WITH TIME ZONE for timezone awareness
-   [ ] IF NOT EXISTS used where appropriate for idempotency
-   [ ] Optional comments explain the purpose of changes

## Output

Generate production-ready Liquibase SQL changelog files that:

1. Match existing Pydantic model definitions (if they exist)
2. Follow PostgreSQL best practices
3. Include proper indexes and constraints
4. Provide rollback statements
5. Are ready to run when the FastAPI application starts
