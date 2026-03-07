# Offline-First Sync API Requirements [DONE]

To fully support the offline-first SQLite synchronization implemented in the Flutter application, we need the following endpoints implemented on the backend. 

Currently, our implementation has to fallback to primitive 1:1 entity syncing or rely heavily on the generic CRUD endpoints provided, which results in significant networking overhead and complex conflict resolution on the client side.

## 1. Batch Syncing Endpoints [DONE]
We need the ability to push/pull multiple entities in a single transaction. Since a single "Story" includes multiple Chapters, Events, Characters, and Notes, syncing them individually takes too long and fails offline guarantees.

### `POST /api/v1/sync/push` [DONE]
- **Purpose**: Accepts a generic payload containing multiple modified entities from the client (Stories, Characters, Locations, Notes, PlotEvents) and applies them atomically.
- **Payload Example**:
  ```json
  {
    "device_timestamp": "2024-03-07T12:00:00Z",
    "changes": {
      "stories": [{ "id": "...", "title": "...", "_status": "updated" }],
      "characters": [{ "id": "...", "name": "...", "_status": "created" }]
    }
  }
  ```

### `POST /api/v1/sync/pull` [DONE]
- **Purpose**: Fetch all changes that occurred on the server *after* a specific timestamp given by the client.
- **Payload Example**:
  ```json
  {
    "last_sync_timestamp": "2024-03-07T10:00:00Z"
  }
  ```
- **Response**: Same structure as the push payload, returning only the deltas (modified or deleted entity IDs).

## 2. Long-Form Draft Support [DONE]
The current `/api/v1/chapters` endpoint assumes a basic payload. For a writing app, chapter bodies ("Drafts") can become incredibly large. We need explicit support to decouple the Chapter Metadata from the Draft Body.

### `GET /api/v1/chapters/:id/draft` [DONE]
- **Purpose**: Fetch solely the heavy text-blob/JSON representation of the editor draft.

### `PUT /api/v1/chapters/:id/draft` [DONE]
- **Purpose**: Save the heavy text content separated from the chapter metadata updates.

## 3. Conflict Resolution Headers [DONE]
For basic CRUD endpoints like `PUT /api/v1/stories/:id`, the backend should enforce or respect ETags or a `updated_at` timestamp check to prevent the client from blindly overwriting a story that was edited on another device.
