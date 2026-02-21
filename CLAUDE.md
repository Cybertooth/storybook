# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Storybook v1 is an AI-assisted story writing and planning application. It is an **npm workspaces monorepo** in active migration from a client-only (LocalForage) architecture to a full-stack distributed system.

**Current Phase:** Phase 3 (backend implementation in progress — NestJS skeleton exists, frontend still uses LocalForage for persistence).

## Monorepo Structure

```
storybook_v1/
├── web-ui/       # React 19 + Vite frontend (@storybook/web-ui)
├── backend/      # NestJS + Prisma backend (@storybook/backend)
├── api/          # Shared TypeScript types & interfaces (@storybook/api)
├── API.md        # REST API design specification
├── UPGRADE.md    # Phase-by-phase migration plan (Phases 1–5)
└── TODO_PRIORITY.md  # Feature backlog ranked by phase
```

## Commands

### Root (runs frontend only)
```bash
npm run dev        # Start frontend dev server
npm run build      # Build frontend
```

### Frontend (web-ui/)
```bash
npm run dev        # Vite dev server
npm run build      # tsc + vite build
npm run lint       # ESLint
npm run preview    # Preview production build
```

### Backend (backend/)
```bash
npm run start:dev  # NestJS watch mode
npm run start      # Production
npm run build      # NestJS compile
npm run test       # Jest unit tests
npm run test:watch # Jest watch mode
npm run test:cov   # Coverage report
npm run test:e2e   # End-to-end tests (jest-e2e.json)
npm run lint       # ESLint with auto-fix
npm run format     # Prettier
```

### Shared Types (api/)
```bash
npm run build      # TypeScript compile
npm run dev        # tsc --watch
```

## Architecture

### Frontend (web-ui/src/)

**Stack:** React 19, Vite, Zustand (+ Zundo for undo/redo), React Router 7, Tailwind CSS, Vercel AI SDK, dnd-kit.

**State:** Three Zustand stores:
- `store/useStoryStore.ts` — central app state (story, characters, locations, events, chapters, notes, questions, relationships) with undo/redo via Zundo temporal plugin
- `store/useSettingsStore.ts` — LLM provider config (Gemini default, OpenAI), API keys, theme
- `store/useAiLogStore.ts` — AI interaction history

**Storage:** `lib/storage.ts` exposes an `IStorageService` interface backed by LocalForage (IndexedDB). This abstraction layer exists so it can be swapped for backend API calls in Phase 4.

**AI:** `lib/ai.ts` — Vercel AI SDK wrapper with prompt engineering. AI API keys are stored client-side in settings (to be moved server-side in Phase 5).

**Component layout:**
- `components/features/` — domain modules: `characters/`, `locations/`, `timeline/`, `draft/`, `story-engine/`
- `components/pages/` — route-level components
- `components/ui/` — generic reusables (AiConsole, DiffViewer, Toast)
- `components/layout/` — AppShell with sidebar nav

**Routes:**
- `/` → PlotGerminator (story seed expansion)
- `/characters`, `/locations`, `/timeline`, `/write`, `/scratchpad`, `/settings`, `/dashboard`

**Path aliases:** `@/*` → `./src/*`, `@storybook/api` → `../api/src/index.ts` (in both tsconfig and vite.config).

### Backend (backend/src/)

**Stack:** NestJS 10, Prisma 7 (PostgreSQL via Prisma Postgres), Jest.

**Module pattern:** each domain (Stories, Characters, Locations) has a `module.ts` / `controller.ts` / `service.ts` triad. `PrismaModule` provides a singleton `PrismaService`.

**Database:** `backend/prisma/schema.prisma` — 10 models: User, Story, Character, Location, PlotEvent, Chapter, Note, UnresolvedQuestion, Relationship, AppSettings. All entities include `userId` for multi-tenant isolation. Cascade deletes enforce referential integrity.

**Connection:** `backend/.env` contains `DATABASE_URL` for Prisma Postgres.

### Shared Types (api/src/index.ts)

Single source of truth for TypeScript interfaces: `Story`, `Character`, `Location`, `PlotEvent`, `Chapter`, `Note`, `UnresolvedQuestion`, `Relationship`, `ProjectBundle`, `ApiResponse<T>`, `PaginatedResponse<T>`.

## Migration Roadmap (UPGRADE.md)

- **Phase 1–2 ✅** Monorepo restructure, shared types, frontend feature-complete
- **Phase 3 🔄** Backend NestJS CRUD implementation, AI proxy endpoints
- **Phase 4** Frontend replaces LocalForage with backend HTTP calls
- **Phase 5** JWT authentication, server-side API key management, deployment (Docker/K8s)

When implementing backend endpoints, refer to `API.md` for the REST contract. When adding new shared data types, add them to `api/src/index.ts`.
