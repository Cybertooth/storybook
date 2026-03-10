-- Migration: Add userId to Tombstone table for multi-tenant isolation
-- Date: 2026-03-10
--
-- Context: The Tombstone model previously had no userId column, making it
-- impossible to scope tombstone lookups to a specific user during sync/pull.
-- This migration adds the column, drops orphaned rows (which lack a userId
-- and therefore cannot be attributed to any user), and creates the compound
-- index used by the sync pull query.
--
-- IMPORTANT: Existing tombstone rows have no userId and will be DELETED.
-- This is safe because:
--   1. The old tombstones are not associated with any user and are useless
--      for user-scoped sync operations.
--   2. The worst-case effect is that clients that had deletions synced via
--      the old tombstone mechanism may re-sync already-deleted records on
--      the next pull, but Prisma cascade deletes will keep data consistent.
-- --------------------------------------------------------------------------

-- Step 1: Remove orphaned tombstones that have no user association.
TRUNCATE TABLE "Tombstone";

-- Step 2: Add the userId column as NOT NULL (safe because the table is empty).
ALTER TABLE "Tombstone"
  ADD COLUMN "userId" TEXT NOT NULL;

-- Step 3: Create the compound index used by the sync pull query.
CREATE INDEX "Tombstone_userId_deletedAt_idx"
  ON "Tombstone" ("userId", "deletedAt");

-- Step 4: Add a unique constraint to prevent duplicate tombstones for the
-- same (user, entity) pair — idempotent push retries will upsert instead of insert.
ALTER TABLE "Tombstone"
  ADD CONSTRAINT "Tombstone_userId_entityId_entityType_key"
  UNIQUE ("userId", "entityId", "entityType");
