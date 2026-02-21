# Web UI Features List (Storybook v1)

This document outlines the extensive list of features currently available in the Storybook web application. This will serve as a reference for maintaining feature parity when developing the mobile application and refactoring the backend.

## 1. Global & Core Features
- **App Shell & Navigation:** Responsive sidebar/navigation for accessing different modules (Dashboard, Codex, Timeline, Draft, Scratchpad, Settings).
- **Dark Mode:** System-aware or manual toggle for dark/light themes.
- **State Management & Persistence:** Local storage (LocalForage) persistence for all story elements.
- **Time-Travel (Undo/Redo):** Global undo/redo functionality for accidental deletions or edits across the app.
- **Data Management:** Export full project backups (JSON) and restore projects from files.
- **Multi-Story Support:** Create, switch between, and manage multiple stories/projects independently.

## 2. Story Dashboard
- **Project Overview:** High-level details of the current active project.
- **Statistics & Metrics:** Word count tracking, entity counts (characters, locations, events), and writing streaks.

## 3. The "Codex" (World-building & Entities)
### Characters
- **Character Profiles:** Name, Role (Protagonist, Antagonist, Supporting, Other), Description, and Traits.
- **Internal Arc Tracking:** Fields for tracking the character's Lie, Truth, and Ghost (Backstory wound).
- **AI Portrait Generation (Nano-Banana):** Generate character portraits using AI, with inline preview, regeneration, and saving image data URLs.
- **Character Relationship Visualizer:** A node-graph visualization showing connections, tensions, and relationships between characters.

### Locations
- **Location Profiles:** Name and general description.
- **Sensory Details:** Dedicated fields for Sight, Sound, Smell, Touch, and Taste to encourage vivid scene descriptions.

## 4. Timeline & Plotting
- **True 2D Timeline (Event Board):** Drag-and-drop Kanban-style board.
  - **Y-Axis:** Plot Threads (e.g., Main Plot, Subplot A).
  - **X-Axis:** Chronological Beats/Chapters.
- **Story / Pacing Graph:** Interactive visualization of events overlaying scene intensity and emotional value to diagnose pacing (sagging middles).
- **Character-Specific Filters:** Filter the timeline to highlight events involving a specific character to ensure continuity.

## 5. Story Engine (Plot Germinator & AI Editing Tools)
- **The Seed Expander:** Input a raw story seed/idea and generate 3 AI-suggested continuations. Options can be broken down sentence-by-sentence to cherry-pick ideas.
- **AI Critique Workflow:**
  - Submit drafts/plots for critical analysis.
  - Results classified by severity (Small, Medium, Major).
  - Multiselect filtering to choose which critiques to act on.
  - Generates diff-based revisions (red for removals, green for additions) using DiffViewer to preview changes before applying.
- **Plot Hole & Consistency Checker:** AI analysis that scans the full story bible for continuity errors, abandoned threads, and timeline glitches.
- **Beat Sheets / Plot Structure Templates:** "Save the Cat" or Hero's Journey templates overlaid on the timeline to guide plot structure.
- **Tropes & Clichés Analyzer:** Scans the story for common narrative tropes, classifies their risk level (Low/Medium/High), and suggests how to subvert or lean into them intentionally.

## 6. The Draft (Writing Editor)
- **Markdown Editor:** Distraction-free (Focus Mode) writing interface.
- **Split-Pane Reference Sidebar:** View world-building elements (Characters, Locations, Events) side-by-side with the draft.
  - **Pinning:** Pin specific reference cards to keep them always visible while switching tabs.
- **AI Brainstorming Partner:** "Suggest Next" button (Wand icon) feeds recent prose to the AI to generate 3 distinct short continuations.
- **"Show, Don't Tell" Highlighter:** Inline prose improvement tool that highlights tell-heavy sentences and suggests evocative rewrites.

## 7. Scratchpad
- **Masonry Layout:** Fluid, Pinterest-style grid for unformed notes, snippets, and dialogue.
- **Quick-add Bar:** Frictionless input for dumping thoughts quickly.

## 8. Unresolved Questions (Floating Global UI)
- **Global Panel:** Floating '?' button accessible from any screen in the app.
- **Tracker:** Log mysteries, plot holes, and required payoffs.
- **Resolution:** Mark questions as resolved and store them in an "Answered" archive.

## 9. Settings
- **LLM Configuration:** Input API keys and select models (e.g., Gemini vs. OpenAI).
- **Theme Selection.**
- **Project Export/Import (Backup).**
