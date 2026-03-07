# Storybook API Documentation

This folder (`api/`) contains the shared TypeScript types (`src/index.ts`) and the documentation for the Storybook backend API. 

This API is designed to be consumed by the Web UI, Android apps, and any other future clients.

## Base URLs
- **Production (Google Cloud Run):** `https://storybook-backend-66224741815.us-central1.run.app/api/v1`
- **Local Development:** `http://localhost:3000/api/v1`

## Standard Response Format
All successful API responses return a generic `ApiResponse<T>` wrapper:
```json
{
  "success": true,
  "data": { ... } // the actual entity payload
}
```

Errors return standard HTTP status codes (400, 401, 403, 404, 500) and a typical NestJS error payload:
```json
{
  "statusCode": 400,
  "message": ["Validation error"],
  "error": "Bad Request"
}
```

## Security & Authentication
- **JWT:** All requests (except login/register) REQUIRE a valid JWT in the `Authorization: Bearer <token>` header.
- **Tenant Isolation:** Every core entity is scoped to the authenticated `user.id`. You cannot fetch or mutate data belonging to another user.

---

## 1. Authentication
- `POST /auth/register` - Create an account. Payload: `{ email, password }`
- `POST /auth/login` - Authenticate. Payload: `{ email, password }`. Returns `{ success: true, data: { access_token: "..." } }`.
- `POST /auth/refresh` - Rotate the access token. (Currently not mocked/implemented robustly, use standard login)
- `POST /auth/logout` - Invalidate the refresh token.
- `GET /auth/me` - Get current user profile and preferences.

## 2. Projects / Stories
A "Story" is the root entity for all related relational data.

- `POST /stories` - Create a new story. Payload: `{ title: string, summary: string }`
- `GET /stories` - List all stories for the authenticated user.
- `GET /stories/:id` - Get full story details.
- `PUT /stories/:id` - Update story metadata (title, summary, theme, coreQuestion).
- `DELETE /stories/:id` - Delete a story strictly owned by the user.

## 3. Characters
- `GET /stories/:storyId/characters` - List all characters for a specific story.
- `POST /stories/:storyId/characters` - Create a character. Payload: `{ name, role, description, traits: [] }`.
- `GET /characters/:id` - Get single character details.
- `PUT /characters/:id` - Update character.
- `DELETE /characters/:id` - Delete a character.

## 4. Locations
- `GET /stories/:storyId/locations` - List all locations.
- `POST /stories/:storyId/locations` - Create a location. Payload: `{ name, description }`.
- `GET /locations/:id` - Get location details.
- `PUT /locations/:id` - Update location.
- `DELETE /locations/:id` - Delete a location.

## 5. Plot Events (Timeline)
- `GET /stories/:storyId/events` - List all events.
- `POST /stories/:storyId/events` - Create an event. Payload: `{ title, description, order }`.
- `GET /events/:id` - Get event details.
- `PUT /events/:id` - Update event.
- `DELETE /events/:id` - Delete an event.

## 6. Chapters & Drafting
- `GET /stories/:storyId/chapters` - List all chapters.
- `POST /stories/:storyId/chapters` - Create a chapter. Payload: `{ title, content, order, status }`.
- `GET /chapters/:id` - Get chapter details.
- `PUT /chapters/:id` - Update chapter text. Payload: `{ title, content, order, status }`.
- `DELETE /chapters/:id` - Delete a chapter.

## 7. Notes (Scratchpad)
- `GET /stories/:storyId/notes` - List all notes.
- `POST /stories/:storyId/notes` - Create a note. Payload: `{ content }`.
- `GET /notes/:id` - Get note details.
- `PUT /notes/:id` - Update note content.
- `DELETE /notes/:id` - Delete a note.

## 8. Relationships (Node Graph Data)
- `GET /stories/:storyId/relationships` - Get all relationship edges.
- `POST /stories/:storyId/relationships` - Create a new relationship. Payload: `{ sourceId, targetId, type, description }`.
- `GET /relationships/:id` - Get relationship.
- `PUT /relationships/:id` - Update relationship.
- `DELETE /relationships/:id` - Remove relationship edge.

## 9. Unresolved Questions
- `GET /stories/:storyId/questions` - List all questions and mysteries.
- `POST /stories/:storyId/questions` - Create a new question. Payload: `{ question, details }`.
- `GET /questions/:id` - Get question.
- `PUT /questions/:id` - Update question status. Payload: `{ isResolved, answer }`.
- `DELETE /questions/:id` - Delete question.

---

## 10. AI Proxy Endpoints
The Android client must not hold Gemini/OpenAI API keys directly. Use these backend endpoints to proxy AI requests.
All endpoints require `POST` with a JSON payload.

- `POST /ai/generate-portrait` - `{ characterDescription: string }`
- `POST /ai/analyze-tropes` - `{ storyContext: string }`
- `POST /ai/plot-hole-check` - `{ storyContext: string }`
- `POST /ai/expand-plot` - `{ currentPlot: string }`
- `POST /ai/critique` - `{ draft: string, context: string }`
- `POST /ai/revise-draft` - `{ draft: string, maxims: string[] }`
- `POST /ai/show-dont-tell` - `{ prose: string }`
- `POST /ai/suggest-next` - `{ priorText: string, plotContext: string }`

*For exact TypeScript payload and response shapes, please refer to the exported interfaces in `src/index.ts` within this `api` folder!*
