# API Design (Storybook v1 Full-Stack)

This document outlines the RESTful API design for the upcoming full-stack architecture. The robust backend will manage data persistence (in a real database like PostgreSQL/MongoDB) and proxy API calls to LLM providers to securely manage API keys.

## Base URL
`/api/v1`

## Security & Multi-Tenancy Architecture

The core of this upgrade is moving from a single-user local app to a multi-tenant cloud application. This requires strict security boundaries.

### 1. Authentication (JWT)
All requests (except login/register) REQUIRE a valid JWT in the `Authorization: Bearer <token>` header.
- `POST /auth/register` - Create an account. Password must be hashed (e.g., bcrypt).
- `POST /auth/login` - Authenticate and receive a short-lived Access Token (JWT) and a HttpOnly Refresh Token.
- `POST /auth/refresh` - Rotate the access token.
- `POST /auth/logout` - Invalidate the refresh token.
- `GET /auth/me` - Get current user profile and preferences.

### 2. Multi-Tenant Data Isolation
Every core entity in the database (Stories, Characters, Locations, etc.) MUST have an associated `userId` or `ownerId`.
When querying or mutating data, the backend logic MUST implicitly scope the query to the authenticated `user.id` derived from the JWT.
- **Example:** `GET /stories` translates to `SELECT * FROM stories WHERE userId = ?`.
- **Authorization Checks:** For `GET /stories/:id`, the route must verify that `story.userId === jwt.userId`. If not, return `403 Forbidden` (or `404 Not Found` to obscure existence).

### 3. Rate Limiting & Abuse Prevention
Especially for the AI endpoints (which cost real money via Gemini/OpenAI API keys), strict rate limiting middleware must be applied per `userId` and/or IP address to prevent abuse.

## 1. Projects / Stories
A "Story" is the root entity for all related data.

- `GET /stories` - List all stories for the authenticated user.
- `POST /stories` - Create a new story.
- `GET /stories/:id` - Get full story details.
- `PUT /stories/:id` - Update story metadata (title, summary, theme, coreQuestion).
- `DELETE /stories/:id` - Delete a story and all its cascading entities.

## 2. Characters
- `GET /stories/:storyId/characters` - List all characters for a story.
- `POST /stories/:storyId/characters` - Create a new character.
- `GET /characters/:id` - Get character details.
- `PUT /characters/:id` - Update character (name, role, description, traits, arcs, avatarUrl).
- `DELETE /characters/:id` - Delete a character.

## 3. Locations
- `GET /stories/:storyId/locations` - List all locations.
- `POST /stories/:storyId/locations` - Create a new location.
- `PUT /locations/:id` - Update location (name, description, sensory details).
- `DELETE /locations/:id` - Delete a location.

## 4. Plot Events (Timeline)
- `GET /stories/:storyId/events` - List all events.
- `POST /stories/:storyId/events` - Create a new event.
- `PUT /events/:id` - Update event (title, description, order, plotThread, emotionalValue, attached characters/locations).
- `DELETE /events/:id` - Delete an event.

## 5. Chapters & Drafting
- `GET /stories/:storyId/chapters` - List all chapters.
- `POST /stories/:storyId/chapters` - Create a new chapter.
- `PUT /chapters/:id` - Update chapter (title, markdown content, order, status).
- `DELETE /chapters/:id` - Delete a chapter.

## 6. Relationships (Node Graph Data)
- `GET /stories/:storyId/relationships` - Get all relationship edges.
- `POST /stories/:storyId/relationships` - Create a new relationship (sourceId, targetId, type, description).
- `PUT /relationships/:id` - Update relationship.
- `DELETE /relationships/:id` - Remove a relationship edge.

## 7. Notes (Scratchpad)
- `GET /stories/:storyId/notes` - List all notes.
- `POST /stories/:storyId/notes` - Create a note.
- `PUT /notes/:id` - Update a note.
- `DELETE /notes/:id` - Delete a note.

## 8. Unresolved Questions
- `GET /stories/:storyId/questions` - List all questions and mysteries.
- `POST /stories/:storyId/questions` - Create a new question.
- `PUT /questions/:id` - Update question status (isResolved, answer).
- `DELETE /questions/:id` - Delete question.

---

## 9. AI Proxy Endpoints
To protect API keys and centralize LLM logic, the frontend will no longer call Gemini/OpenAI directly. Instead, it will call backend endpoints. The backend maintains the user's API keys (or the platform's global key) securely.

All endpoints require `POST` with specific JSON payloads containing the required context.

- `POST /ai/generate-portrait`
  - Payload: `{ characterDescription: string }`
  - Response: `{ imageUrl: string }`

- `POST /ai/analyze-tropes`
  - Payload: `{ storyContext: string }`
  - Response: Array of trope objects.

- `POST /ai/plot-hole-check`
  - Payload: `{ storyContext: string }`
  - Response: Array of consistency issues.

- `POST /ai/expand-plot`
  - Payload: `{ currentPlot: string }`
  - Response: `{ expansion: string }`

- `POST /ai/critique`
  - Payload: `{ draft: string, context: string }`
  - Response: Array of critique objects.

- `POST /ai/revise-draft`
  - Payload: `{ draft: string, maxims: string[] }`
  - Response: `{ revisions: string[] }`

- `POST /ai/show-dont-tell`
  - Payload: `{ prose: string }`
  - Response: Array of improvement suggestions.

- `POST /ai/suggest-next`
  - Payload: `{ priorText: string, plotContext: string }`
  - Response: `{ suggestions: string[] }`

## Future Considerations
- **WebSockets:** For collaborative editing or real-time AI generation streaming in the future.
- **Pagination:** Essential for large stories (e.g., inside the chapters or notes list).
