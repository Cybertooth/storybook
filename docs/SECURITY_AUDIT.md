# Security Audit — Storybook Backend API

**Date:** 2026-03-10
**Scope:** NestJS backend (`backend/`), shared API types (`api/`), Docker/deployment configuration
**Auditor:** Security review of changes made by automated security hardening agent

---

## Executive Summary

The security hardening pass introduced substantial improvements over the baseline skeleton:
Helmet headers, strict CORS whitelisting, global rate limiting, timing-safe authentication,
bcrypt password hashing with adequate cost factor, JWT-scoped multi-tenant isolation,
input validation on all endpoints, and sync-level ownership enforcement.

Several **medium and low severity gaps** remain and are documented below with recommended remediation.

---

## 1. What Was Hardened (Positive Findings)

### 1.1 HTTP Security Headers (Helmet)
- `helmet()` applied globally in `main.ts` with `referrerPolicy: 'no-referrer'`.
- `x-powered-by` header explicitly removed.
- Provides: `X-Frame-Options`, `X-Content-Type-Options`, `Strict-Transport-Security`, `Content-Security-Policy` defaults, and more.

**Status: Good.**

### 1.2 CORS Origin Whitelist
- Explicit allowlist via `CORS_ORIGINS` env var (comma-separated).
- Wildcard `*` is explicitly rejected even if provided in the env var.
- Production fails-fast if `CORS_ORIGINS` is not set.
- Dev defaults to `localhost:5173` only.

**Status: Good.** See §2.3 for the null-origin note.

### 1.3 JWT Authentication
- All non-auth endpoints protected by `JwtAuthGuard`.
- Token expiry: **15 minutes** — appropriate short window.
- `JWT_SECRET` validated at startup: required, ≥ 32 characters, fails-fast in production.
- Test environments use a clearly labelled fallback secret.

**Status: Good.** See §2.1 for refresh token gap.

### 1.4 Password Hashing
- `bcrypt` with **12 rounds** (OWASP recommends ≥ 10; 12 is a good default for 2026 hardware).
- Email normalized to lowercase before storage and lookup.

**Status: Good.**

### 1.5 Timing-Safe Login
- A `DUMMY_HASH` is always bcrypt-compared even when the user is not found.
- This prevents timing-based user enumeration on the login endpoint.

**Status: Good.**

### 1.6 Input Validation
- `ValidationPipe` with `whitelist: true`, `forbidNonWhitelisted: true`, `transform: true` applied globally.
- Auth DTOs enforce email format, length constraints (email ≤ 254, password 8–128 / 12–128).
- AI controller DTOs enforce `MaxLength` on all free-text inputs (4000–30000 chars) preventing prompt injection payload amplification.
- Sync controller validates `last_sync_timestamp` as ISO 8601.
- Array inputs (`maxims`) have `ArrayMaxSize(30)` and per-item `MaxLength(200)`.

**Status: Good.**

### 1.7 Rate Limiting
- Global `ThrottlerGuard` applied via `APP_GUARD`: 60 requests per 60 seconds per IP.
- Applied to all routes including auth endpoints.

**Status: Adequate (see §2.2 for improvement).**

### 1.8 Multi-Tenant Isolation
- All CRUD operations extract `userId` exclusively from the validated JWT payload — never from the request body.
- All database queries include `where: { userId }` predicates.
- Ownership checks use `findFirst({ where: { id, userId } })` rather than trusting the client-supplied userId.
- Sync service validates cross-entity ownership (`assertStoryOwnership`) for all child entity operations.
- `updateMany`/`deleteMany` with `{ id, userId }` prevents updating another user's record even with a known ID.

**Status: Good.**

### 1.9 Sync Data Sanitization
- `sanitizeData()` strips `_status`, `id`, `createdAt`, `updatedAt`, `userId` before writing to the database.
- This prevents clients from overwriting server-managed fields.

**Status: Good — see §2.5 for the residual concern.**

### 1.10 Tombstone User Scoping
- The `Tombstone` model was updated to include `userId` and a compound index on `(userId, deletedAt)`.
- Sync pull now correctly scopes tombstone lookups to the requesting user, preventing cross-user tombstone leakage.

**Status: Good.**

---

## 2. Issues Fixed in This Session

The following issues were identified and remediated as part of this audit:

| Fix | File | Change |
|---|---|---|
| Gemini API key moved from URL query param to `x-goog-api-key` header | `ai.service.ts` | Key no longer appears in proxy/access logs |
| Auth endpoints tightened to 10 req/60s | `auth.controller.ts` | `@Throttle` override on `AuthController` |
| Tombstone `@@unique([userId, entityId, entityType])` added | `schema.prisma` | Prevents duplicate tombstones on push retries |
| Sync `createTombstone()` changed to `upsert` | `sync.service.ts` | Idempotent with the unique constraint |
| `register()` hashes password before checking existence | `auth.service.ts` | Eliminates timing-based account enumeration |
| Sync push arrays bounded to 500 items per entity type | `sync.controller.ts` | `SyncChangesDto` with `@ArrayMaxSize(500)` prevents DoS |
| Health endpoint excluded from throttle quota | `app.controller.ts` | `@SkipThrottle()` on `GET /api/v1/health` |

---

## 3. Remaining Issues

### 3.1 No Token Refresh Mechanism (Medium)

**Issue:** JWTs expire in 15 minutes. There is no `/auth/refresh` endpoint. Mobile apps that are kept open or background-synced will receive `401` errors every 15 minutes, forcing full re-login.

**Impact:** Poor UX for Android/Windows clients; potential for users to use very long expiry workarounds elsewhere.

**Recommendation:**
- Implement a refresh token flow:
  - `POST /auth/refresh` accepts a long-lived, opaque refresh token (stored httpOnly cookie or secure device storage).
  - Returns a new 15-minute access token.
  - Refresh tokens should be rotated on use and invalidated on logout.
  - Store refresh token hashes in the database (new `RefreshToken` table) to allow server-side revocation.

---

### 3.2 CORS Null-Origin Passthrough — By Design (Informational)

**Issue:** `main.ts` allows requests with no `Origin` header (`!origin → callback(null, true)`). This is by design for server-to-server calls and mobile/desktop apps, but also allows:
- `curl` requests from any server
- Requests from non-browser clients without CORS enforcement

**Impact:** CORS is a browser-only enforcement mechanism. Non-browser clients (including Flutter apps) don't send an `Origin` header. Allowing null origin is therefore correct and necessary for mobile/desktop. The concern is that server-to-server abuse is not rate-limited beyond the global throttle.

**Recommendation:**
- Current behavior is acceptable for the intended multi-client architecture.
- Document that CORS is a browser control layer; mobile client security depends on JWT + HTTPS, not CORS.
- Consider an API key or client identifier header for server-to-server calls in the future if needed.

---

### 3.4 API Keys Stored in Plaintext (Medium)

**Issue:** `AppSettings.geminiKey` and `AppSettings.openaiKey` are stored as plaintext strings in the database.

**Impact:** A database compromise exposes all user API keys. These are third-party provider keys, so a user whose key is leaked could incur unexpected charges or have their AI quota abused.

**Recommendation:**
- Encrypt API keys at rest using AES-256-GCM before storing, using a server-side `ENCRYPTION_KEY` env var.
- Alternatively, if the backend holds a single server-side Gemini key (as `GEMINI_API_KEY` in the AI service), remove the per-user key storage entirely — it may be a vestige of the client-only architecture.
- The AI service currently uses `process.env.GEMINI_API_KEY` (server key), so user-stored keys are not used by the current AI proxy. Audit whether `AppSettings` key fields are actually needed and remove them if not.

---

### 3.5 Sync Push — Unvalidated Field Spread (Low-Medium)

**Issue:** In `sync.service.ts`, after `sanitizeData()` strips internal fields, the remaining `data` object is spread directly into `tx.entity.update/create()` as `any`. Prisma will ignore unknown columns but accepted fields could still be set to unexpected values (e.g., a client-crafted `traits` value of `[<xss>]` or extreme string lengths for unvalidated text fields).

**Impact:** No Prisma-level field validation means malicious clients can attempt to write very large text values to fields that have no `MaxLength` constraint enforced server-side (only DB-level `@db.Text` applies).

**Recommendation:**
- Replace the `any` spread with explicit field mapping per entity type (similar to how `StoriesService.toCreateData()` and `CharactersService.toData()` work).
- The sync service should use the same allow-list pattern: only map known, valid fields for each entity type.

---

### 3.6 Sync Pull — Child Entity Delta Filter Uses Story Timestamp (Low)

**Issue:** In `sync.service.ts` the pull query for characters, locations, events, chapters, and relationships filters by `story: { updatedAt: { gt: since } }` rather than by the child entity's own `updatedAt`. This means:
- If only a character is updated (not the parent story), it will **not** be returned in the next pull.
- If the story was recently created, **all** its children are returned regardless of whether they changed.

**Impact:** Sync reliability bug — client data may be stale after offline edits to child entities.

**Recommendation:**
- Add `updatedAt` fields to all child entity models that lack them (`Character`, `Location`, `PlotEvent`, `Relationship`).
- Filter pulls by each entity's own `updatedAt: { gt: since }` for correctness.

---

### 3.7 No `GET /auth/me` or `POST /auth/logout` Endpoint (Low)

**Issue:** The API documentation references `/auth/me` (get current user) and `/auth/logout` but neither is implemented.

**Impact:**
- Clients cannot verify their session state without making another authenticated API call.
- Logout is purely client-side (discard JWT) — there is no server-side token invalidation.

**Recommendation:**
- Implement `GET /auth/me` to return the current user's profile (useful for session validation on app resume).
- Server-side logout becomes meaningful only when refresh tokens are implemented (§2.1) — at that point, `POST /auth/logout` should invalidate the refresh token.

---

### 3.9 `prisma db push --accept-data-loss` in Production Dockerfile (Medium)

**Issue:** The production `CMD` in `backend/Dockerfile` runs:
```
npx prisma db push --accept-data-loss && node dist/src/main
```
`prisma db push` is a development tool that applies schema diffs destructively (it can **drop columns and tables**). The `--accept-data-loss` flag suppresses all safety warnings.

**Impact:** Any schema change deployed to production will silently drop data. This is extremely dangerous for a production database.

**Recommendation:**
- Use `prisma migrate deploy` instead, which applies versioned, reviewed migrations safely.
- Create a Prisma migration for each schema change (the migration SQL in this repo is a start).
- The `pretest:e2e` script correctly uses `db push --accept-data-loss` for ephemeral test DBs — that usage is fine.

---

---

## 4. Security Posture Summary (Post-Audit)

| Category | Status | Notes |
|---|---|---|
| HTTP Security Headers | ✅ Good | Helmet with referrer policy |
| CORS | ✅ Good | Strict allowlist, wildcard rejected; null-origin intentional for mobile |
| Authentication | ✅ Good | JWT, 15m expiry, fails-fast secret validation, timing-safe register+login |
| Password Security | ✅ Good | bcrypt 12 rounds, normalized email |
| Input Validation | ✅ Good | Global ValidationPipe + per-DTO constraints |
| Rate Limiting | ✅ Good | Global 60/min + auth routes 10/min |
| Multi-Tenant Isolation | ✅ Good | JWT-scoped, all queries include userId |
| Sync Payload Limits | ✅ Good | 500 records max per entity type per push |
| Tombstone Integrity | ✅ Good | Unique constraint + upsert |
| AI Key in HTTP Header | ✅ Good | `x-goog-api-key` header, not URL |
| Health Endpoint | ✅ Good | @SkipThrottle — won't consume IP quota |
| Data Sanitization (Sync) | ⚠️ Partial | Internals stripped; no per-field allow-list yet |
| API Key Storage | ⚠️ Risk | User API keys stored plaintext in DB |
| Token Refresh | ❌ Missing | 15m JWT with no refresh — breaks mobile UX |
| Server-Side Logout | ❌ Missing | No token invalidation mechanism |
| Sync Delta Correctness | ❌ Bug | Child entity pull uses parent story timestamp |
| Production DB Migration | ❌ Risk | Dockerfile still uses `db push --accept-data-loss` |
| `GET /auth/me` | ❌ Missing | Not implemented |
| HTTPS Enforcement | ✅ Delegated | Enforced at Cloud Run / reverse proxy layer |

---

## 5. Recommended Priority Order (Remaining Work)

1. **P1 — Fix production Dockerfile** — replace `prisma db push --accept-data-loss` with `prisma migrate deploy` to prevent accidental column/table drops on schema changes.
2. **P1 — Implement refresh tokens** — add `POST /auth/refresh` with a `RefreshToken` DB table; required for Android/Windows clients to function without constant re-login.
3. **P2 — Fix sync pull delta filter** — add `updatedAt` to `Character`, `Location`, `PlotEvent`, `Relationship` models and filter by each entity's own `updatedAt`.
4. **P2 — Add field allow-list to sync push** — replace `...(data as any)` with explicit per-entity field mapping in `sync.service.ts`.
5. **P3 — Encrypt or remove API keys** from `AppSettings` — the AI service uses a server-side env key, so per-user key storage may be removable entirely.
6. **P3 — Implement `GET /auth/me`** — needed for client session rehydration on app resume.

---

## 6. Compliance Notes

- **OWASP API Security Top 10 (2023):**
  - API1 (Broken Object Level Authorization): ✅ Addressed — userId scoping on all queries
  - API2 (Broken Authentication): ⚠️ Partially addressed — no refresh token / revocation
  - API3 (Broken Object Property Level Authorization): ⚠️ Sync push still uses field spread
  - API4 (Unrestricted Resource Consumption): ✅ Addressed — sync bounded, auth throttled
  - API5 (Broken Function Level Authorization): ✅ All routes require JWT except auth
  - API8 (Security Misconfiguration): ⚠️ Dockerfile CMD is a misconfiguration risk
  - API10 (Unsafe Consumption of APIs): ✅ Gemini key now in header; 15s fetch timeout in place

- **GDPR / Data Minimization:** User email and hashed password are the only PII stored at the auth layer. No analytics or tracking data is collected.

---

*This document should be reviewed and updated whenever significant backend changes are deployed.*
