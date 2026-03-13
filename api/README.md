# Storybook API Documentation

This folder (`api/`) contains the shared TypeScript types (`src/index.ts`) and the documentation for the Storybook backend REST API.

The API is consumed by:
- **Web UI** (React/Vite — `web-ui/`)
- **Android app** (Flutter)
- **Windows desktop app** (Flutter)

TypeScript consumers should import types from `@storybook/api` (see `src/index.ts`). Flutter/Dart consumers should implement equivalent data classes that match the JSON shapes described below.

---

## Base URLs
| Environment | URL |
|---|---|
| Production (Google Cloud Run) | `https://storybook-backend-66224741815.us-central1.run.app/api/v1` |
| Local Development | `http://localhost:3000/api/v1` |

---

## Standard Response Envelopes

**Success:**
```json
{ "success": true, "data": { ... } }
```

**Error:**
```json
{ "statusCode": 400, "message": ["Validation error detail"], "error": "Bad Request" }
```

Common HTTP status codes:
- `400 Bad Request` — validation failure or malformed payload
- `401 Unauthorized` — missing or invalid/expired JWT
- `403 Forbidden` — authenticated but not owner of the resource
- `404 Not Found` — entity does not exist (or does not belong to you)
- `409 Conflict` — optimistic concurrency conflict (see Stories `PUT`)
- `429 Too Many Requests` — rate limit exceeded (60 req / 60 s global)

---

## Security & Authentication

- **All endpoints except `/auth/login` and `/auth/register` require a JWT.**
- Send the token in every request: `Authorization: Bearer <token>`
- Tokens expire in **15 minutes**. Re-authenticate when a `401` is received.
- Every entity is strictly scoped to the authenticated user's `userId`. Cross-user access returns `403` or `404`.

---

## 1. Authentication — `/auth`

### POST `/auth/register`
Create a new account.

**Request:**
```json
{ "email": "user@example.com", "password": "strongPassword123!" }
```
*Constraints: email ≤ 254 chars; password 12–128 chars.*

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "token": "<jwt>",
    "user": { "id": "uuid", "email": "user@example.com" }
  }
}
```

---

### POST `/auth/login`
Authenticate an existing account.

**Request:**
```json
{ "email": "user@example.com", "password": "yourPassword" }
```
*Constraints: email ≤ 254 chars; password 8–128 chars.*

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "token": "<jwt>",
    "user": { "id": "uuid", "email": "user@example.com" }
  }
}
```

> **Note for mobile clients:** Store the JWT securely (Android Keystore / Windows DPAPI). Tokens expire in 15 minutes. When a `401` is returned, prompt the user to log in again or implement silent re-authentication if credentials are securely cached.

---

## 2. Stories — `/stories`

A **Story** is the root entity for all related data.

### POST `/stories`
```json
{ "title": "My Novel", "summary": "A story about..." }
```
Response `201`: `{ "success": true, "data": <Story> }`

---

### GET `/stories`
List all stories for the authenticated user.

Response `200`: `{ "success": true, "data": [<Story>] }`

---

### GET `/stories/:id`
Response `200`: `{ "success": true, "data": <Story> }`

---

### PUT `/stories/:id`
Update story metadata. Supports **optimistic concurrency control**.

**Request:**
```json
{
  "title": "Updated Title",
  "summary": "...",
  "theme": "...",
  "coreQuestion": "...",
  "updatedAt": "2026-03-10T12:00:00.000Z"
}
```

If `updatedAt` is provided and the server's record has been modified _after_ that timestamp, the server returns **`409 Conflict`**. Fetch the latest version and re-apply changes before retrying.

---

### DELETE `/stories/:id`
Response `200`: `{ "success": true }`

---

## 3. Characters — `/stories/:storyId/characters` & `/characters`

### GET `/stories/:storyId/characters`
### POST `/stories/:storyId/characters`
```json
{ "name": "Alice", "role": "protagonist", "description": "...", "traits": ["brave"] }
```

### GET `/characters/:id`
### PUT `/characters/:id`
### DELETE `/characters/:id`

**Character fields:** `id`, `userId`, `storyId`, `name`, `role`, `description`, `traits[]`, `arcLie?`, `arcTruth?`, `arcGhost?`, `avatarUrl?`

---

## 4. Locations — `/stories/:storyId/locations` & `/locations`

### GET `/stories/:storyId/locations`
### POST `/stories/:storyId/locations`
```json
{ "name": "The Forest", "description": "A dark wood..." }
```

### GET `/locations/:id`
### PUT `/locations/:id`
### DELETE `/locations/:id`

**Location fields:** `id`, `userId`, `storyId`, `name`, `description`, `sensorySight?`, `sensorySound?`, `sensorySmell?`, `sensoryTouch?`, `sensoryTaste?`

---

## 5. Plot Events (Timeline) — `/stories/:storyId/events` & `/events`

### GET `/stories/:storyId/events`
### POST `/stories/:storyId/events`
```json
{ "title": "Opening scene", "description": "...", "order": 1 }
```

### GET `/events/:id`
### PUT `/events/:id`
### DELETE `/events/:id`

**PlotEvent fields:** `id`, `userId`, `storyId`, `title`, `description`, `order`, `chapterId?`, `locationId?`, `status?`, `plotThread?`, `emotionalValue?`

---

## 6. Chapters — `/stories/:storyId/chapters` & `/chapters`

Chapter **metadata** (title, order, status) and chapter **content** (full markdown draft) are handled separately for performance.

### GET `/stories/:storyId/chapters`
Returns metadata only — `content` field is excluded.

### POST `/stories/:storyId/chapters`
```json
{ "title": "Chapter 1", "content": "Once upon a time...", "order": 1, "status": "drafting" }
```

### GET `/chapters/:id`
Returns metadata only — `content` field excluded.

### PUT `/chapters/:id`
Update metadata: `{ "title": "...", "order": 2, "status": "completed" }`

### DELETE `/chapters/:id`

### GET `/chapters/:id/draft`
Fetch the full `content` text of a chapter.

Response `200`: `{ "content": "..." }`

### PUT `/chapters/:id/draft`
Update only the content of a chapter.

**Request:** `{ "content": "Updated markdown text..." }`

---

## 7. Notes (Scratchpad) — `/stories/:storyId/notes` & `/notes`

### GET `/stories/:storyId/notes`
### POST `/stories/:storyId/notes`
```json
{ "content": "Note text..." }
```
### GET `/notes/:id`
### PUT `/notes/:id`
### DELETE `/notes/:id`

---

## 8. Relationships (Node Graph) — `/stories/:storyId/relationships` & `/relationships`

### GET `/stories/:storyId/relationships`
### POST `/stories/:storyId/relationships`
```json
{ "sourceId": "char-uuid", "targetId": "char-uuid", "type": "Enemy", "description": "..." }
```
### GET `/relationships/:id`
### PUT `/relationships/:id`
### DELETE `/relationships/:id`

---

## 9. Unresolved Questions — `/stories/:storyId/questions` & `/questions`

### GET `/stories/:storyId/questions`
### POST `/stories/:storyId/questions`
```json
{ "question": "Why did X happen?", "details": "Context..." }
```
### GET `/questions/:id`
### PUT `/questions/:id`
```json
{ "isResolved": true, "answer": "Because..." }
```
### DELETE `/questions/:id`

---

## 10. Sync (Offline-First) — `/sync`

The sync API enables offline-first operation across devices. Use **push** to upload local changes and **pull** to download server-side changes since a given timestamp.

### POST `/sync/push`
Upload local changes atomically. All changes are applied in a single database transaction. If any change fails (e.g. wrong owner), the **entire push is rolled back**.

**Request:**
```json
{
  "changes": {
    "stories": [
      { "_status": "created", "id": "client-uuid", "title": "New Story", "summary": "..." },
      { "_status": "updated", "id": "existing-uuid", "title": "Renamed" },
      { "_status": "deleted", "id": "old-uuid" }
    ],
    "characters": [ ... ],
    "locations": [ ... ],
    "events": [ ... ],
    "notes": [ ... ],
    "chapters": [ ... ],
    "relationships": [ ... ],
    "unresolvedQuestions": [ ... ]
  }
}
```

**Rules:**
- `id` is required for every record and must be a stable client-generated UUID.
- `_status` must be `"created"`, `"updated"`, or `"deleted"`.
- For `created` records that don't yet exist on the server, the server creates them with the provided `id`. If the `id` already exists and belongs to another user, the push fails with `403`.
- The `userId`, `createdAt`, and `updatedAt` fields are managed by the server and will be ignored / stripped from the payload even if provided.
- For entities that belong to a story (`characters`, `locations`, etc.), `storyId` must be provided for new records.

**Response `200`:** `{ "success": true }`

---

### POST `/sync/pull`
Fetch all records modified since a given timestamp.

**Request:**
```json
{ "last_sync_timestamp": "2026-03-01T00:00:00.000Z" }
```
Pass `last_sync_timestamp` as an ISO 8601 string. Omit the field (or pass `"1970-01-01T00:00:00.000Z"`) to fetch everything.

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "changes": {
      "stories": [ <Story> ],
      "characters": [ <Character> ],
      "locations": [ <Location> ],
      "events": [ <PlotEvent> ],
      "notes": [ <Note> ],
      "chapters": [ <Chapter> ],
      "relationships": [ <Relationship> ],
      "unresolvedQuestions": [ <UnresolvedQuestion> ],
      "tombstones": [
        { "id": "...", "userId": "...", "entityId": "deleted-uuid", "entityType": "character", "deletedAt": "2026-03-10T..." }
      ]
    }
  }
}
```

**Tombstone handling:** For each tombstone, delete the local record with `entityId` of the given `entityType` from the local store. This ensures deletions propagate to all devices.

---

## 11. AI Proxy Endpoints — `/ai`

All endpoints require a valid JWT. The server holds the Gemini API key; clients do **not** need their own keys for server-routed AI calls.

All endpoints are `POST` with `Content-Type: application/json`.

| Endpoint | Request Fields | Response Shape |
|---|---|---|
| `POST /ai/generate-portrait` | `characterDescription` (max 4000) | `{ imageUrl: string }` |
| `POST /ai/analyze-tropes` | `storyContext` (max 20000) | `[{ name, description }]` |
| `POST /ai/plot-hole-check` | `storyContext` (max 20000) | `[{ issue, suggestion }]` |
| `POST /ai/expand-plot` | `currentPlot` (max 20000) | `{ expansion: string }` |
| `POST /ai/critique` | `draft` (max 30000), `context` (max 20000) | `[{ point, detail }]` |
| `POST /ai/revise-draft` | `draft` (max 30000), `maxims: string[]` (max 30 items × 200 chars) | `{ revisions: string[] }` |
| `POST /ai/show-dont-tell` | `prose` (max 30000) | `[{ original, suggestion }]` |
| `POST /ai/suggest-next` | `priorText` (max 30000), `plotContext` (max 20000) | `{ suggestions: string[] }` |
| `POST /ai/generic` | `prompt` (max 30000), `context?` (max 20000) | `{ text: string }` |

---

*For TypeScript type definitions of all request and response payloads, see `src/index.ts` in this folder.*
