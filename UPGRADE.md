# Upgrade Plan: Full-Stack Monorepo Migration

We are transitioning the application from a purely local, browser-based React app (using LocalForage) into a deployed, full-stack application with a proper backend to allow for secure data hosting, user authentication, and multi-device access (e.g., allowing for a mobile app later).

## Target Architecture (Monorepo)

The repository will be restructured into three distinct top-level directories:

1. `/web-ui` - The frontend React/Vite application (current codebase moved here).
2. `/backend` - The Node.js application (Express/NestJS or similar) serving the API and connecting to the database.
3. `/api` - Shared types, interfaces, schema definitions, and API client utilities used by both `web-ui` and `backend`.

---

## Task Breakdown for Sub-Agents

The work to complete this migration should be picked up by multiple sub-agents. Here is the sequential and parallel task list:

### Phase 1: Repository Restructuring (Coordinator / Agent 1)
- [x] Create the `/web-ui`, `/backend`, and `/api` directories.
- [x] Move the existing frontend code (everything currently in `./src`, `package.json`, `vite.config.ts`, etc.) into `/web-ui`.
- [x] Update build scripts, paths, and `.gitignore` at the root level to support the monorepo workspaces (e.g., using npm workspaces, pnpm, or TurboRepo).
- [x] Ensure the `/web-ui` app still starts up and runs locally using the existing LocalForage implementation in its new location.

### Phase 2: Shared API & Types Layer (Agent 2)
- [ ] Initialize `/api` folder as a workspace package (`package.json`, TypeScript config).
- [ ] Migrate the types from `/web-ui/src/types/index.ts` to the `/api` package so both backend and frontend can import them.
- [ ] Define standardized REST payload and response types corresponding to `API.md`.
- [ ] Define API client interfaces (e.g., Axios wrappers or tRPC routers) to ensure type safety across the network boundary.

### Phase 3: Backend Implementation (Agent 3)
- [ ] Initialize `/backend` folder (`package.json`, `tsconfig.json`, basic server setup using Express or Fastify).
- [ ] Setup a database connection (e.g., PostgreSQL with Prisma/Drizzle ORM or MongoDB with Mongoose).
- [ ] Implement robust schema models mirroring the Shared API types.
- [ ] Implement CRUD route handlers for Stories, Characters, Locations, Events, Chapters, Notes, Unresolved Questions, and Relationships, strictly adhering to `API.md`.
- [ ] Implement the AI Proxy Routes (protecting API keys server-side). Migrate the LLM calling logic from `src/lib/ai.ts` into the backend services.

### Phase 4: Frontend API Integration & Data Layer Swap (Agent 4)
- [ ] In `/web-ui`, install the shared `/api` package.
- [ ] Replace `src/lib/storage.ts` (LocalForage) with HTTP calls to the new `/backend` using Axios/Fetch.
- [ ] Update the global state stores (`useStoryStore`, `useSettingsStore`) to dispatch actions to the backend to persist data, rather than saving to local DB.
- [ ] Migrate `src/lib/ai.ts` in the frontend to simply call the backend proxy endpoints instead of hitting Gemini/OpenAI directly from the browser.
- [ ] Handle asynchronous loading states, errors, and optimistic UI updates seamlessly.

### Phase 5: Authentication & Deployment Prep (Agent 1 & 2)
- [ ] Implement a basic authentication layer (JWT) on the backend.
- [ ] Add Login / Registration screens to the `/web-ui`.
- [ ] Ensure API routes authenticate requests and isolate data by `userId`.
- [ ] Configure environment variables (`.env`) for both apps.
- [ ] Write a `docker-compose.yml` or deployment scripts for hosting on platforms like Vercel (Web UI) and Render/Heroku (Backend/DB).

## Guidelines for Sub-Agents
- Read `API.md` and `WEB_UI_FEATURES.md` completely before assuming how a feature works.
- Maintain the current visual identity and Tailwind aesthetics; only the data layer should change.
- Work iteratively: Ensure the app builds after each major refactor phase.
