# Storybook Android

A Flutter-based writing assistant and story planner that combines local-first convenience with backend synchronization.

## 🚀 Key Features

- **Story Management**: Create and organize multiple writing projects.
- **Offline-First**: Uses a local Drift (SQLite) database, ensuring your work is always available.
- **Backend Sync**: Synchronize your stories across devices via a dedicated NestJS backend.
- **AI-Powered Assistance**: Integrated support for Gemini and OpenAI to help with plot development and drafting. When online, AI requests are automatically proxied through the backend — no API key required on the device.
- **Customizable Appearance**: Dynamic theming with user-selectable seed colors.

## 📡 Offline vs. Online Mode

The app supports two primary modes of operation:

### 1. Offline Mode (Local Only)
- **Bypass Login**: Accessible directly from the login screen via "Continue Offline".
- **Local Storage**: All data is stored purely in the local Drift database.
- **Privacy**: No data is sent to the backend API.
- **Transition to Online**: Users can log in later via the "Account" section in Settings to enable synchronization.

### 2. Online Mode
- **Secure Authentication**: Requires login or registration via the backend API.
- **Automatic Sync**: All data (stories, characters, locations, plot events, chapters, notes, relationships, and questions) is pushed to and pulled from the backend for cloud backup.
- **Pull on Open**: When a story is opened, all its child entities are pulled from the server and merged into the local database (server wins, additive upsert).
- **Push on Mutation**: Every local create/update/delete fires a fire-and-forget background push to the backend, so the server stays in sync without blocking the UI.
- **Backend AI Proxy**: AI features (plot analysis, critique, show-don't-tell, etc.) are routed through the backend — no Gemini or OpenAI key needs to be stored on the device.
- **Persistent Access**: Securely stores JWT tokens to keep you logged in.

## 🛠️ Current Development State

- **Authentication**: Registration and Login flows are fully implemented. ✅
- **Syncing**: Full bidirectional sync is active for all entities — Stories, Characters, Locations, Plot Events, Chapters (including draft content), Notes, Relationships, and Unresolved Questions. ✅
- **AI Proxy**: All AI features route through the backend when authenticated (`BackendProxyAiService`). Gemini direct-call is retained as an offline fallback when a key is configured. ✅
- **~~Next Steps~~** ✅ **Done**: Integration of child entities (Characters, Locations, Chapters, Plot Events) and migrating AI features to backend proxy endpoints — both completed. Refer to `api/API_COVERAGE.md` for the full integration status and known limitations.

## 💻 Technical Stack & Libraries

- **UI & SDK**: Flutter
- **State Management**: [Riverpod](https://riverpod.dev/) (`flutter_riverpod`, `riverpod_annotation`)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Local Database**: [Drift](https://drift.simonbinder.eu/) (SQLite)
- **Networking**: [Dio](https://pub.dev/packages/dio)
- **Data Models**: [Freezed](https://pub.dev/packages/freezed) & JSON Serializable

## ⌨️ Common Build Commands

### Code Generation
Since the architecture relies on code generation, run the build runner after modifying models, providers, or database schemas:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Build & Run
```bash
# Get dependencies
flutter pub get

# Static Analysis
flutter analyze

# Build for Windows
flutter build windows

# Build for Android (APK)
flutter build apk --split-per-abi
```

### Development
```bash
# Run in debug mode
flutter run
```

---

## 📂 Directory Structure
- `lib/core/`: Utilities, themes, and global providers (e.g., `router.dart`, `auth_provider.dart`).
- `lib/data/`: Drift database, local and remote data source implementations.
- `lib/domain/`: Abstract repository definitions and business logic.
- `lib/features/`: UI screens and feature-specific providers.
- `lib/shared/`: Reusable widgets and common UI components (`app_scaffold.dart`).

## 🗺️ Navigation & Architecture

For developers and agents to quickly navigate the interface:

### Navigation Flow
1. **Entry**: Start at `/login`. Choose **Online** (sign in/register) or **Offline** (Continue Local).
2. **Dashboard**: Navigate to `/projects`. This is the **Story Selection** screen.
3. **Workspace**: Once a story is selected, the app redirects to `/scratchpad`.
4. **Main Shell**: Most features (`/scratchpad`, `/draft`, `/ai`, `/timeline`, `/codex`) are wrapped in a `ShellRoute` (`AppScaffold`), providing a persistent bottom navigation bar.

### Core State Management
- **`authProvider`**: Manages the logged-in user state and offline mode status. Located in `lib/core/providers/auth_provider.dart`.
- **`activeStoryProvider`**: **Critical.** This holds the currently selected story. Most features (Characters, Notes, Chapters) watch this provider to filter data. If `activeStory` is null, the router will force a redirect back to `/projects`. Located in `lib/core/providers/active_story_provider.dart`.
- **`settingsProvider`**: Manages API keys (Gemini/OpenAI), backend URLs, and theme preferences.
- **`syncServiceProvider`**: Central sync coordinator. Handles all pull (remote→local) and push (local→remote) operations. Located in `lib/data/sync/sync_service.dart`.
- **`aiServiceProvider`**: Returns `BackendProxyAiService` when authenticated, `GeminiAiService` when offline with a key, or `null` (banner shown). Located in `lib/core/providers/ai_provider.dart`.

### Feature Map
- `features/projects/`: Managing list of stories.
- `features/scratchpad/`: Quick notes and brainstorming.
- `features/draft/`: The primary writing interface.
- `features/story_engine/`: AI-powered brainstorming and analysis tools accessible via the "AI" tab.
- `features/codex/`: Centralized reference for Characters, Locations, and Relationships.
- `features/timeline/`: Story event management and ordering.

## 🔄 Sync Architecture

The app uses a **local-first, write-through** sync model. The local Drift database is always the source of truth for the UI.

### Pull (Remote → Local)
Triggered automatically when the user opens the app (stories list) or selects a story (child entities). Uses Drift's `insertOnConflictUpdate` so the server always wins for existing records without deleting locally-created data.

| Trigger | What is pulled |
|---|---|
| Projects screen loads | All stories |
| Story tapped / opened | Characters, Locations, Plot Events, Notes, Relationships, Questions, Chapters + draft content |
| Manual sync button (Projects screen) | All stories |

### Push (Local → Remote)
Every mutation in a feature provider fires a **fire-and-forget** background push after writing to the local DB. The UI never waits for the network.

- **Create**: `POST /stories/:id/<entity>` — falls back to `PUT` if the entity already exists on the server.
- **Update**: `PUT /<entity>/:id`
- **Delete**: `DELETE /<entity>/:id`
- **Chapter draft**: `PUT /chapters/:id/draft` — fired separately from metadata updates.

If the device is offline, all push operations silently no-op and the data remains safely in the local DB.

### Known Limitations
- **No offline queue**: Changes made offline are not queued for later upload; they will sync naturally the next time the user performs an action while online.
- **No delete propagation on pull**: Server-side deletes are not mirrored locally on pull (additive upsert only).
- **Conflict resolution**: Story updates check `updatedAt` server-side (409 response); the app falls back to a PUT retry. No user-facing conflict UI yet.

## 🔗 Routing Details
The app uses `GoRouter` (defined in `lib/core/router.dart`).
- **Redirects**: The router handles guards for both authentication and ensuring an `activeStory` is selected before entering the main workspace.
- **Paths**:
  - `/login`: Auth screen.
  - `/projects`: Story selection.
  - `/settings`: Configuration and account management.
  - `/scratchpad`, `/draft`, `/ai`, `/timeline`, `/codex`: Primary workspace features (ShellRoute).
