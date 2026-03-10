# API Integration Coverage Report

This document reflects the current state of backend API integration in the Android Flutter app.

## ✅ Fully Implemented

### Authentication
- `POST /auth/login`: Fully integrated (login screen, token stored in secure storage).
- `POST /auth/register`: Fully integrated.
- `GET /auth/me`: Integrated via `ApiClient.getMe()`.
- `POST /auth/logout`: Integrated — called on logout from Settings screen.

### Stories
- `GET /stories`: Integrated — `SyncService.pullAllStories()` pulls on Projects screen load.
- `POST /stories`: Integrated — fired after local `createStory`.
- `PUT /stories/:id`: Integrated — fired after local `updateStory`.
- `DELETE /stories/:id`: Integrated — fired after local `deleteStory`.

### Characters
- `GET /stories/:id/characters`: Integrated — `SyncService.pullCharacters()` called on story open.
- `POST /stories/:id/characters`: Integrated — fired after local `createCharacter`.
- `PUT /characters/:id`: Integrated — fired after local `updateCharacter`.
- `DELETE /characters/:id`: Integrated — fired after local `deleteCharacter`.

### Locations
- `GET /stories/:id/locations`: Integrated — `SyncService.pullLocations()` called on story open.
- `POST /stories/:id/locations`: Integrated — fired after local `createLocation`.
- `PUT /locations/:id`: Integrated — fired after local `updateLocation`.
- `DELETE /locations/:id`: Integrated — fired after local `deleteLocation`.

### Plot Events (Timeline)
- `GET /stories/:id/events`: Integrated — `SyncService.pullEvents()` called on story open.
- `POST /stories/:id/events`: Integrated — fired after local `createEvent`.
- `PUT /events/:id`: Integrated — fired after local `updateEvent`.
- `DELETE /events/:id`: Integrated — fired after local `deleteEvent`.

### Chapters & Drafting
- `GET /stories/:id/chapters`: Integrated — `SyncService.pullChapters()` called on story open.
- `POST /stories/:id/chapters`: Integrated — fired after local `createChapter`.
- `PUT /chapters/:id`: Integrated — fired after local `updateChapter` (metadata).
- `GET /chapters/:id/draft`: Integrated — fetched as part of `pullChapters()`.
- `PUT /chapters/:id/draft`: Integrated — fired after local `saveContent`.
- `DELETE /chapters/:id`: Integrated — fired after local `deleteChapter`.

### Notes (Scratchpad)
- `GET /stories/:id/notes`: Integrated — `SyncService.pullNotes()` called on story open.
- `POST /stories/:id/notes`: Integrated — fired after local `add`.
- `PUT /notes/:id`: Integrated — fired after local `updateNote` and `reorderNotes`.
- `DELETE /notes/:id`: Integrated — fired after local `delete`.

### Relationships (Node Graph)
- `GET /stories/:id/relationships`: Integrated — `SyncService.pullRelationships()` called on story open.
- `POST /stories/:id/relationships`: Integrated — fired after local `createRelationship`.
- `DELETE /relationships/:id`: Integrated — fired after local `deleteRelationship`.

### Unresolved Questions
- `GET /stories/:id/questions`: Integrated — `SyncService.pullQuestions()` called on story open.
- `POST /stories/:id/questions`: Integrated — fired after local `add`.
- `PUT /questions/:id`: Integrated — fired after local `resolve`.
- `DELETE /questions/:id`: Integrated — fired after local `delete`.

### AI Proxy Endpoints
All AI proxy endpoints are integrated via `BackendProxyAiService`. The `aiServiceProvider`
automatically uses the backend proxy when the user is authenticated, falling back to direct
Gemini calls when offline with an API key configured.

- `POST /ai/generate-portrait`: ✅
- `POST /ai/analyze-tropes`: ✅
- `POST /ai/plot-hole-check`: ✅
- `POST /ai/expand-plot`: ✅ (mapped to `suggestContinuations`)
- `POST /ai/critique`: ✅
- `POST /ai/revise-draft`: ✅
- `POST /ai/show-dont-tell`: ✅
- `POST /ai/suggest-next`: ✅

## ⚠️ Known Limitations / Not Yet Integrated

### Conflict Resolution
- Story updates use `updatedAt` for server-side conflict detection (409 Conflict response).
  The app currently falls back to a re-try with PUT on conflict, but does not expose
  the conflict to the user. A proper 3-way merge or last-write-wins UI would be needed
  for multi-device usage.

### Delete Propagation (Pull direction)
- When pulling remote data, entities that were deleted on the server are NOT deleted locally.
  The pull is additive (upsert-only). To support this properly, a soft-delete / tombstone
  mechanism or delta-sync endpoint would be needed.

### Offline Queue
- Changes made while offline are NOT queued for later sync. They are stored locally and
  pushed only when the user triggers an action again while online. A persistent offline
  queue (e.g., using a local "pending_changes" table) would be needed for full offline-first
  guarantees.

### Relationship Update
- `PUT /relationships/:id` is implemented in `ApiClient` but not yet called from any
  provider (relationships have no update flow in the UI currently).
