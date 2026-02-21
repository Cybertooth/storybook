# Storybook — Unified Features Roadmap

This document contains a consolidated list of features lacking in the current version of the app, synthesized from earlier roadmaps and competitive analysis. It focuses on features that bridge the gap between AI generation and manual plotting, tailoring the app for budding authors and screenwriters.

---

## 🏗️ App Infrastructure & UI/UX
*   **Multi-story / Project Management:** Dashboard to manage multiple novels or screenplays.
*   **Story Dashboard:** Overview of word count, progress, recent activity, and writing streaks.
*   **Auto-save & Version Control:** Debounced auto-save, global undo/redo, and "Snapshots" (version history/time machine) for fearless editing.
*   **Dark Mode:** A polished UI theme for late-night writing.
*   **Keyboard Shortcuts & Global Search:** Command palette (`Ctrl+K`) for quick navigation and shortcuts for common tasks.
*   **Goal Tracking & Gamification:** Daily word count widgets (rings) and milestone badges.

## 🌱 Core Story Engine & Ideation
*   **Brainstorming Scratchpad / Random Notes:** A free-form space to collect independent thoughts, research links, and random ideas over days/weeks before committing them to a formal seed prompt or story element.
*   **The "Seed Expander" (Iterative Ideation):** A dedicated workspace to input a basic premise and use an AI "Expand" button to suggest subplots, conflicts, or lore.
*   **"What If" Generator:** Output 5 premise variations from a single idea to combat the blank page.
*   **Structure Templates (Beat Sheets):** Overlays for "Save the Cat" (15 beats), Hero's Journey, or 3-Act structures.
*   **Core Question & Theme Tracker:** Sticky fields tracking the central dramatic question and theme.
*   **Tropes & Clichés Analyzer:** Run story seeds through AI to identify and subvert common tropes.

## 📖 The "Codex" (Characters & Locations)
*   **Deep Character Profiles:** Track internal arcs ("The Lie", "The Truth", "The Ghost/Wound"), motivations, and flaws.
*   **Character Relationship Visualizer:** Node-based matrix/mind-map showing relationships and conflict sources between characters.
*   **Sensory Palette for Locations:** Mandatory or suggested fields for Sight, Sound, Smell, Touch, and Taste when creating locations.
*   **Interactive Pinned Maps:** A flexible canvas to arrange spatial relationship pins between locations.
*   **AI Character Interactivity:** AI role-playing for "character interviews" to nail down their voice.
*   **Voice Distinctiveness Check:** AI warning when two characters' dialogue styles are too similar.
*   **Visual Generation:** API links to generate avatar portraits and concept art.

## ⏱️ Timeline & Outlining
*   **Kanban Timeline & Chapter Outliner:** Visual board with drag-and-drop representing chapters/time periods (X-axis) and plotlines/characters (Y-axis).
*   **Character-Specific Timelines:** Filter the Kanban board to trace a single character's geographic and temporal journey.
*   **Emotional Value / Pacing Graph:** Rate events (-5 to +5) to generate a line graph that visualizes narrative tension and flags "saggy middles."
*   **"Why" vs "And Then" Checker:** Force dependencies between scenes to ensure cause-and-effect narrative flow.

## ✍️ Writing & Editing Experience (Draft Page)
*   **Split-Pane Reference Sidebar [High Priority]:** Pin a Character Card, Location, or Timeline Event to the side while writing the prose.
*   **Distraction-Free / Typewriter Mode:** Dimmed interface and vertical-locked cursor for focused sprints.
*   **Rich Text Chapter Drafting:** Better formatting features and Markdown previews.
*   **Screenplay Typing Mode:** Native auto-formatting for scene headings, characters, and dialogue (`INT.`, `EXT.`).

## 🤖 AI Assistants & Critical Review
*   **Manual Control / Override Architecture:** All AI generations explicitly presented as suggestions, side-by-side or diff views. The user must approve or type over them.
*   **AI Brainstorming Partner ("What happens next?"):** Contextual suggestions based on current timeline events (e.g., Plot twist, new character).
*   **AI "Plot Hole & Consistency Checker":** Full manuscript analysis flagging inconsistencies (e.g., wrong eye color, impossible travel times, forgotten plot threads).
*   **"Show, Don't Tell" Highlighter:** In-line AI evaluation that flags prose that "tells" and suggests action-oriented variants.
*   **Actionable Feedback & Tone Analysis:** Post-draft review for pacing and emotional resonance.

## 📤 Export & Sharing
*   **Comprehensive Export Options:** Export to PDF/DOCX, standard industry formats like EPUB, and Fountain format (.fountain) for screenwriters.
*   **Scrivener Export:** Ability to export the timeline/outline directly to Scrivener.
*   **Story Bible Export:** compile characters, timeline, and lore into a single reference document.
