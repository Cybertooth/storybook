# Android App Design — Storybook v1

**Date:** 2026-02-21
**Status:** Approved
**Scope:** Full feature parity with WEB_UI_FEATURES.md

---

## Decisions

| Concern | Decision |
|---------|----------|
| Framework | Flutter 3.x (Dart) |
| State management | Riverpod 2.x + `riverpod_annotation` code gen |
| Local storage | Drift (type-safe SQLite) |
| Data strategy | Local-first; add backend sync in a later phase |
| AI access | Direct Gemini/OpenAI calls now; abstracted to swap to NestJS `/ai/*` proxy later |
| HTTP client | `dio` |
| Secure key storage | `flutter_secure_storage` |
| Navigation | `go_router` (declarative) |

---

## Architecture

### Folder Layout

```
android/
  lib/
    core/              # AppTheme, constants, Riverpod ProviderScope setup
    data/
      local/           # Drift database definition, DAOs per entity
      remote/          # Dio API client, BackendProxyService, GeminiDirectService
    domain/            # Pure Dart entity classes, repository interfaces
    features/
      dashboard/       # Story switcher, stats, writing streaks
      characters/      # List, detail/edit, relationship graph
      locations/       # List, detail/edit
      timeline/        # Kanban board, pacing graph
      story_engine/    # Seed expander, critique, plot hole checker, beat sheets, tropes
      draft/           # Chapter list, markdown editor, reference drawer
      scratchpad/      # Masonry notes grid
      questions/       # Unresolved questions panel (FAB-accessible globally)
      settings/        # API keys, theme, export/import
    shared/            # Reusable widgets, extensions, hooks
  pubspec.yaml
  test/
```

### Layering

```
UI (Flutter Widgets)
  ↕ Riverpod providers
Domain (repository interfaces + entity models)
  ↕
Data (Drift DAOs | Remote API client)
```

Each feature folder follows: `screens/`, `widgets/`, `providers/` (Riverpod), `models/` if needed.

---

## Screens & Navigation

**Navigation structure:** Bottom navigation bar with 5 tabs + global FAB for Unresolved Questions.

### Bottom Tabs

1. **Dashboard** — active story overview, entity counts, word count, writing streak; story switcher drawer
2. **Codex** — tabbed: Characters | Locations
   - Characters: list → detail/edit sheet → relationships graph screen
   - Locations: list → detail/edit sheet (with sensory fields)
3. **Timeline** — tabbed: Event Board | Pacing Graph
   - Event Board: 2D Kanban (X = chapters/beats, Y = plot threads), tap event → detail sheet; long-press drag to reorder
   - Pacing Graph: scrollable chart of emotional value per event
4. **Draft** — chapter list side drawer + markdown editor + reference slide-in drawer (characters/locations/events; pin-to-keep)
5. **More** — routes to: Scratchpad, Story Engine, Settings

### Story Engine Sub-screens
- Seed Expander (PlotGerminator)
- AI Critique (submit draft → severity-classified results → diff preview → apply)
- Plot Hole & Consistency Checker
- Beat Sheets (Save the Cat / Hero's Journey overlays)
- Tropes & Clichés Analyzer

### Global FAB
Floating "?" button on every screen opens the Unresolved Questions panel (bottom sheet) — log/resolve mysteries and plot holes.

---

## Data Layer

### Drift Schema
Tables match the Prisma schema (without `userId` until backend sync):

- `stories` — id, title, summary, theme, coreQuestion, createdAt, updatedAt
- `characters` — id, storyId, name, role, description, traits (JSON list), arcLie, arcTruth, arcGhost, avatarUrl
- `locations` — id, storyId, name, description, sensory* (5 fields)
- `plot_events` — id, storyId, title, description, order, chapterId, characterIds (JSON), locationId, status, plotThread, emotionalValue
- `chapters` — id, storyId, title, content, order, status
- `notes` — id, storyId, content, createdAt
- `unresolved_questions` — id, storyId, question, details, isResolved, answer, createdAt
- `relationships` — id, storyId, sourceId, targetId, type, description

### Repository Pattern

```dart
abstract class CharacterRepository {
  Future<List<Character>> getAll(String storyId);
  Future<Character> create(CreateCharacterDto dto);
  Future<Character> update(String id, UpdateCharacterDto dto);
  Future<void> delete(String id);
}

class LocalCharacterRepository implements CharacterRepository { /* Drift */ }
class RemoteCharacterRepository implements CharacterRepository { /* Dio + API */ }
```

Riverpod provider holds the active implementation. Swap local → remote when backend is ready.

### Undo/Redo
Command stack in a Riverpod `StateNotifier` (in-memory). Push mutation commands, pop on undo.

### Export/Import
Serialize all Drift tables to a `ProjectBundle` JSON structure matching the web app format exactly — files portable between web and mobile.

---

## AI Layer

```
abstract class AiService {
  Future<String> generatePortrait(String characterDescription);
  Future<List<TropeResult>> analyzeTropes(String storyContext);
  Future<List<ConsistencyIssue>> plotHoleCheck(String storyContext);
  Future<String> expandPlot(String currentPlot);
  Future<List<CritiqueResult>> critique(String draft, String context);
  Future<List<String>> reviseDraft(String draft, List<String> maxims);
  Future<List<ShowDontTellSuggestion>> showDontTell(String prose);
  Future<List<String>> suggestNext(String priorText, String plotContext);
}
```

**Implementations:**
- `GeminiDirectService` — calls `generativelanguage.googleapis.com` directly; API key from `flutter_secure_storage`. Active now.
- `BackendProxyService` — calls NestJS `/api/v1/ai/*`; uses JWT from auth session. Swapped in when backend Phase 4-5 complete.

Provider selects implementation based on a config flag (local setting).

---

## Key Flutter Packages

| Purpose | Package |
|---------|---------|
| State management | `riverpod`, `flutter_riverpod`, `riverpod_annotation` |
| SQLite ORM | `drift`, `drift_flutter` |
| HTTP | `dio` |
| Secure storage | `flutter_secure_storage` |
| Navigation | `go_router` |
| Markdown editor | `flutter_markdown`, `markdown_editable_textinput` |
| Relationship graph | `graphview` |
| Charts (pacing) | `fl_chart` |
| Drag & drop (timeline) | `flutter_reorderable_grid` or custom `LongPressDraggable` |
| Code generation | `build_runner`, `riverpod_generator`, `drift_dev` |
| UUID | `uuid` |
| JSON serialization | `json_serializable`, `freezed` |

---

## Feature Parity Checklist (from WEB_UI_FEATURES.md)

- [ ] App shell + bottom navigation
- [ ] Dark/light mode toggle
- [ ] Local persistence (Drift SQLite)
- [ ] Undo/redo (command stack)
- [ ] JSON export/import (ProjectBundle)
- [ ] Multi-story support
- [ ] Story dashboard + stats
- [ ] Character profiles + arc tracking
- [ ] AI portrait generation
- [ ] Character relationship graph
- [ ] Location profiles + sensory fields
- [ ] 2D Kanban timeline (drag-and-drop)
- [ ] Pacing graph (emotional value chart)
- [ ] Character-specific timeline filters
- [ ] Seed expander (AI, 3 continuations)
- [ ] AI critique workflow (severity + diff preview)
- [ ] Plot hole & consistency checker
- [ ] Beat sheets / plot structure templates
- [ ] Tropes & clichés analyzer
- [ ] Markdown draft editor (focus mode)
- [ ] Reference sidebar with pinning
- [ ] AI "suggest next" in editor
- [ ] Show don't tell highlighter
- [ ] Scratchpad (masonry notes)
- [ ] Unresolved questions panel (global FAB)
- [ ] Settings: API keys, theme, export/import
