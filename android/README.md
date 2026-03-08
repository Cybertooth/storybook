# Storybook Android

A Flutter-based writing assistant and story planner that combines local-first convenience with backend synchronization.

## 🚀 Key Features

- **Story Management**: Create and organize multiple writing projects.
- **Offline-First**: Uses a local Drift (SQLite) database, ensuring your work is always available.
- **Backend Sync**: Synchronize your stories across devices via a dedicated NestJS backend.
- **AI-Powered Assistance**: Integrated support for Gemini and OpenAI to help with plot development and drafting.
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
- **Automatic Sync**: Stories are pushed to and pulled from the backend for cloud backup.
- **Persistent Access**: Securely stores JWT tokens to keep you logged in.

## 🛠️ Current Development State

- **Authentication**: Registration and Login flows are fully implemented.
- **Syncing**: Bidirectional story-level syncing is active.
- **Next Steps**: Integration of child entities (Characters, Locations, Chapters, Plot Events) and migrating AI features to backend proxy endpoints. Refer to `api/API_COVERAGE.md` for more details.

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

### Feature Map
- `features/projects/`: Managing list of stories.
- `features/scratchpad/`: Quick notes and brainstorming.
- `features/draft/`: The primary writing interface.
- `features/story_engine/`: AI-powered brainstorming and analysis tools accessible via the "AI" tab.
- `features/codex/`: Centralized reference for Characters, Locations, and Relationships.
- `features/timeline/`: Story event management and ordering.

## 🔗 Routing Details
The app uses `GoRouter` (defined in `lib/core/router.dart`).
- **Redirects**: The router handles guards for both authentication and ensuring an `activeStory` is selected before entering the main workspace.
- **Paths**:
  - `/login`: Auth screen.
  - `/projects`: Story selection.
  - `/settings`: Configuration and account management.
  - `/scratchpad`, `/draft`, `/ai`, `/timeline`, `/codex`: Primary workspace features (ShellRoute).
