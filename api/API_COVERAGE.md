# API Integration Coverage Report

I have reviewed the backend API documentation (`api/README.md`) and compared it against the current Android frontend codebase (specifically `ApiClient` and `SyncService`).

Here is the current status of API integration:

## ✅ Implemented
- `POST /auth/register`: Fully integrated.
- `POST /auth/login`: Fully integrated.
- `GET /stories`: Partially integrated (Basic pull in `SyncService`).
- `POST /stories`: Partially integrated (Basic push in `SyncService`).

## ❌ Missing / Not Yet Integrated

The vast majority of the backend API remains to be integrated into the app's synchronization logic.

### Authentication
- `GET /auth/me`: Get current user profile and preferences.
- `POST /auth/logout`: Backend invalidation of refresh tokens.

### Story Operations
- `GET /stories/:id`: Fetch deep story details.
- `PUT /stories/:id`: Update story metadata.
- `DELETE /stories/:id`: Delete a story.

### Core Entities (CRUD for all)
Currently, **none** of the child entities of a story are being synced with the backend. For each of the following, we need to implement GET (list), POST (create), PUT (update), and DELETE endpoints:
- **Characters** (`/characters`)
- **Locations** (`/locations`)
- **Plot Events** (`/events`)
- **Chapters & Drafting** (`/chapters`)
- **Notes / Scratchpad** (`/notes`)
- **Relationships / Node Graph** (`/relationships`)
- **Unresolved Questions** (`/questions`)

### AI Proxy Endpoints
The frontend is currently built to hit AI APIs directly (Gemini/OpenAI) using local keys. None of the backend AI proxy endpoints have been implemented yet:
- `/ai/generate-portrait`
- `/ai/analyze-tropes`
- `/ai/plot-hole-check`
- `/ai/expand-plot`
- `/ai/critique`
- `/ai/revise-draft`
- `/ai/show-dont-tell`
- `/ai/suggest-next`

## Recommendations
To reach full online parity where data is completely backed up:
1. **Sync Service Expansion:** The `SyncService` needs to be significantly expanded to handle bidirectional sync for *all* core entities (Characters, Locations, Notes, etc.).
2. **Conflict Resolution:** We need to implement robust delta syncing and conflict resolution (e.g., using `updatedAt` timestamps) so local edits aren't blindly overwritten by older remote data and vice-versa.
3. **AI Proxy Migration:** We should migrate the frontend's AI features (like the AI assistant and generators) to use the backend's `/ai/*` endpoints instead of requiring users to input their own API keys in the settings. This is much more secure.
