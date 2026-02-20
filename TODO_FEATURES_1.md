# Storybook — Feature Roadmap for Budding Authors

> Features organized by priority within each section.  
> 🔥 = High impact for first-time authors | 🤖 = AI-powered | 🎬 = Screenplay-specific

---

## App-Wide / Cross-Cutting

### Project Management
- [ ] 🔥 **Multi-story support** — Currently the app appears to handle a single story. Add a project picker / dashboard so authors can work on multiple novels or screenplays
- [ ] 🔥 **Story dashboard** — Landing page showing progress overview: word count, chapter completion %, character count, timeline coverage, last edited timestamp
- [ ] **Project templates** — "Start from Hero's Journey", "Three-Act Structure", "Save the Cat Beat Sheet", "Screenplay (Fountain)"
- [ ] **Genre selector** — Choosing a genre (Fantasy, Thriller, Romance, Sci-Fi, Screenplay) influences AI tone and suggestions throughout the app

### Writing Experience
- [ ] 🔥 **Auto-save with debounce** — Replace manual save buttons with automatic saves (300ms debounce). Keep the save indicator but remove the friction
- [ ] 🔥 **Undo/Redo** — Global undo stack for all entity operations (create, edit, delete)
- [ ] 🔥 **Dark mode** — The `AppSettings.theme` type already supports `'light' | 'dark' | 'system'` but it's not implemented. Essential for late-night writing sessions
- [ ] **Keyboard shortcuts** — `Ctrl+S` to save, `Ctrl+Z/Y` for undo/redo, `Ctrl+K` for quick search, `Escape` to close modals
- [ ] **Global search** — Search across all characters, locations, events, and chapter content via a spotlight/command palette (`Ctrl+K`)
- [ ] **Notification center** — Upgrade the toast system into a persistent notification area for AI completions, save confirmations, and error recovery

### Data & Export
- [ ] 🔥 **Export to PDF/DOCX** — One-click export of the full manuscript with proper formatting (chapter breaks, title page, headers)
- [ ] 🎬 **Export to Fountain** — For screenwriters, export in Fountain format (.fountain) which is the industry standard plain-text screenplay format
- [ ] **Story bible export** — Generate a single PDF/document compiling all characters, locations, timeline, and plot summary as a reference bible
- [ ] **Version snapshots** — "Save checkpoint" feature that creates a named snapshot of the entire project at a moment in time, with ability to restore

### Mobile & Accessibility
- [ ] **Responsive layout** — Collapsible sidebar for tablet/mobile, touch-friendly interactions
- [ ] **Offline mode** — The app uses localForage which already works offline, but add a clear offline indicator and sync status

---

## Story Engine (Home Page)

### Plot Development
- [ ] 🔥 **Plot structure templates** — Provide selectable frameworks overlaid on the writing area:
  - Three-Act Structure (Setup → Confrontation → Resolution)
  - Hero's Journey (12 stages)
  - Save the Cat (15 beats)
  - Dan Harmon's Story Circle (8 steps)
  - Kishotenketsu (4-act for non-Western narratives)
- [ ] 🔥🤖 **"What If" generator** — AI generates 5 "what if" premise variations from a basic idea, helping overcome the blank page
- [ ] 🤖 **Theme extractor** — AI identifies the underlying themes in the plot and suggests how to strengthen them
- [ ] 🤖 **Logline generator** — From the plot summary, generate a one-sentence logline (critical for both novels and screenplays)
- [ ] **Tone/mood selector** — Set the story's tone (Dark, Whimsical, Gritty, Romantic) which influences all subsequent AI interactions
- [ ] **Premise vs. Synopsis vs. Treatment** — Structured sections for the three levels of story summary (1 sentence → 1 paragraph → 2 pages)

### Writing Prompts & Inspiration
- [ ] 🔥 **Daily writing prompt** — Show a random creative writing prompt on the home page to combat writer's block
- [ ] 🤖 **"Unstick me"** — When stuck, describe the problem ("my protagonist has no clear motivation") and get targeted AI suggestions

---

## Characters Page

### Character Development
- [ ] 🔥 **Character profile template** — Structured fields beyond name/role/description:
  - **Motivation** — What do they want?
  - **Flaw** — What holds them back?
  - **Ghost/Wound** — Backstory trauma that drives behavior
  - **Arc direction** — How they change (positive/negative/flat)
  - **Voice notes** — How this character speaks (formal? slang? catchphrases?)
  - **Age, appearance, mannerisms**
- [ ] 🔥 **Character relationship web** — Visual graph showing relationships between characters (ally, rival, mentor, lover, sibling). Clickable nodes linking to character cards
- [ ] 🔥🤖 **Character interview** — AI role-plays as the character in a chat interface. The author asks questions and the AI responds in-character based on the profile, helping authors discover their character's voice
- [ ] 🤖 **Character arc suggestions** — Given a character's starting state and story events, AI suggests meaningful arc progression
- [ ] 🤖 **Avatar generation** — Use image generation to create character portraits from description
- [ ] **Character comparison view** — Side-by-side view of 2-3 characters to ensure they're distinct (different motivations, different speech patterns, different flaws)
- [ ] **Character grouping** — Group by faction, family, team, or custom tag. Filter the grid view by group
- [ ] 🎬 **Character dialogue log** — For screenplay writers, a filterable log of all dialogue written for a character across all chapters, to check voice consistency

### Conflict Matrix
- [ ] 🔥 **Relationship tension tracker** — For each character pair, track what creates conflict between them. Essential for dramatic tension

---

## World & Locations Page

### Worldbuilding
- [ ] 🔥 **Location hierarchy** — Nested locations: Continent → Country → City → Building → Room. Tree view in sidebar, cards in main area
- [ ] 🔥 **Sensory palette** — Structured fields for each location: Sight, Sound, Smell, Touch, Taste. Helps authors write immersive descriptions
- [ ] 🤖 **Location atmosphere generator** — Given a location name and basic description, AI generates rich sensory details, time-of-day variations, and mood descriptions
- [ ] **Visual mood board** — Attach reference images to locations (upload or generate with AI)
- [ ] **Map view** — Simple drag-and-drop canvas where authors can position locations spatially relative to each other (doesn't need to be a real map, just conceptual positioning)
- [ ] **Time-of-day variants** — Each location can have different descriptions for day/night/dawn/dusk
- [ ] 🎬 **Scene location tracker** — Show which events/chapters take place at this location, with quick navigation

### World Rules
- [ ] **Rules & Systems** — For fantasy/sci-fi: document magic systems, technology, social structures, religions. Structured sections that the AI can reference when giving suggestions
- [ ] **Cultural notes** — Language, customs, social hierarchy per location or faction
- [ ] **Timeline of world history** — Separate from the plot timeline — background lore events that happened before the story

---

## Timeline Page

### Structure & Pacing
- [ ] 🔥 **Drag-and-drop reordering** — The dnd-kit dependency is already installed but drag-and-drop isn't implemented on the board view. Enable reordering events within and across plot threads
- [ ] 🔥 **Act structure overlay** — Toggle a visual overlay showing act boundaries on the timeline graph (Act 1 / Act 2A / Act 2B / Act 3). Configurable for 3-act, 5-act, or custom
- [ ] 🔥 **Tension/pacing curve** — Visual graph showing tension level per event (author rates each event 1-5 for intensity). Highlights pacing problems like "saggy middle"
- [ ] 🤖 **Pacing analysis** — AI analyzes the sequence of events and warns about pacing issues: too many high-tension events in a row, missing breather scenes, unresolved subplots
- [ ] **Chapter-to-event mapping** — Link events to chapters. Show which chapter covers which events, revealing gaps or overstuffed chapters
- [ ] **Subplot dependency arrows** — Draw connections between subplots showing cause-and-effect relationships

### Event Enrichment
- [ ] 🔥 **Event detail expansion** — When clicking an event node, open a detail panel showing:
  - Characters involved (selectable from existing characters)
  - Location (selectable from existing locations)
  - Emotional beat (setup, tension, climax, resolution, twist)
  - Status (idea → outlined → drafted → final)
- [ ] **Scene type tags** — Tag events as: Action, Dialogue, Exposition, Montage, Flashback. Visual color coding on the timeline
- [ ] 🎬 **Beat sheet mode** — For screenwriters, overlay the Save the Cat / Blake Snyder beat sheet with target page numbers

### Filtering & Views
- [ ] **Filter by character** — Show only events involving a specific character to trace their journey
- [ ] **Filter by location** — Show only events at a specific location
- [ ] **Filter by subplot** — Isolate a single plot thread to check its coherence independently

---

## Draft Page (Writing)

### Editor Improvements
- [ ] 🔥 **Markdown preview** — Split pane or toggle: write in Markdown on the left, see formatted preview on the right
- [ ] 🔥 **Distraction-free / Focus mode** — Hide sidebar, timeline, and all UI chrome. Just the text, a subtle background, and a word count. Toggle with `F11` or a zen mode button
- [ ] 🔥 **Writing goals / targets** — Set daily word count goals (e.g., 1,000 words/day). Show progress bar, streak counter, and motivational messages
- [ ] **Format toolbar** — Bold, italic, heading, blockquote, list buttons above the editor for users unfamiliar with Markdown
- [ ] **Find and replace** — `Ctrl+F` to search within the current chapter, `Ctrl+Shift+F` across all chapters
- [ ] **Reading time estimate** — Display estimated reading time based on word count (avg 250 wpm)
- [ ] **Chapter word count** — Per-chapter word count shown in the chapter list sidebar
- [ ] **Chapter status badges** — Visual status tags on each chapter in the list: Planned → Drafting → Completed (already in the type but not shown in UI)

### AI Writing Assistance
- [ ] 🔥🤖 **Inline AI suggestions** — Highlight a paragraph and ask AI to: rewrite, expand, compress, change tone, add sensory detail, or continue
- [ ] 🤖 **Dialogue helper** — Select a dialogue exchange and ask AI to make it sharper, more natural, or adjust for a character's voice (using their profile)
- [ ] 🤖 **Show don't tell detector** — AI scans a chapter and highlights passages that "tell" instead of "show", with suggestions for improvement
- [ ] 🤖 **Readability analysis** — Grade level, sentence complexity, passive voice %, and suggestions for clarification
- [ ] 🤖 **Continuity checker** — Cross-reference chapter content against characters, locations, and timeline to flag inconsistencies (e.g., character in wrong location, wrong eye color mentioned)
- [ ] 🎬 **Screenplay formatting mode** — Toggle that formats the editor for screenplay conventions: scene headings (INT/EXT), character names in caps, parentheticals, transitions

### Chapter Management
- [ ] 🔥 **Drag-and-drop chapter reorder** — Rearrange chapters in the sidebar by dragging
- [ ] **Chapter notes/outline** — Per-chapter notes panel (separate from content) for planning what happens before writing it
- [ ] **Split/merge chapters** — Split a long chapter at cursor position, or merge two adjacent chapters
- [ ] **Chapter version history** — Save named snapshots of individual chapters ("before major rewrite") with diff view

---

## Settings Page

### Customization
- [ ] 🔥 **Dark mode toggle** — Wire up the existing `theme` setting to actually switch between light/dark/system themes
- [ ] **Font selection** — Choose between serif and sans-serif fonts for the writing area. Adjustable font size
- [ ] **AI model selection** — Choose between different model tiers (fast/cheap vs. high-quality) for different operations
- [ ] **Writing statistics dashboard** — Total words written, writing time tracked, words per session history chart

### Collaboration (Future)
- [ ] **Share project** — Generate a read-only link to share your story bible with beta readers or writing partners
- [ ] **Comments/feedback** — Allow shared viewers to leave inline comments on chapters

---

## New Pages / Features to Consider

### 📊 Dashboard Page (New)
- [ ] 🔥 **Project overview** — At-a-glance stats: total word count, character count, location count, events, chapters
- [ ] **Progress tracker** — Visual completion percentage per section (characters fleshed out, chapters written, events planned)
- [ ] **Recent activity feed** — What changed recently across the project
- [ ] **Writing streak tracker** — Daily/weekly writing habits with gamification (streaks, milestones)

### 🔗 Connections Page (New)
- [ ] **Cross-reference view** — See all connections between entities: which characters appear in which events, which locations are used in which chapters
- [ ] **Orphan detector** — Find characters who aren't in any events, locations never used, events not linked to chapters

### 📋 Research / Notes Page (New)
- [ ] 🔥 **Research board** — Free-form notes area for storing research, reference links, inspiration, worldbuilding details that don't fit elsewhere
- [ ] **Tagging system** — Tag notes and link them to characters, locations, or chapters
- [ ] **Web clipper** — Paste a URL and extract key content for reference

### 🎬 Screenplay-Specific Page (New)
- [ ] **Scene breakdown** — List all scenes with: INT/EXT, location, time of day, characters, page estimate
- [ ] **Character page count** — How many pages each character appears in
- [ ] **Act timing** — Target page counts per act (e.g., Act 1 = pp. 1-25 for a 110-page screenplay)

---

## Priority Recommendation for v2

If picking just **10 features** to build next that would have the most impact for a first-time author:

| # | Feature | Why |
|---|---------|-----|
| 1 | Dark mode | Already typed, low effort, huge perceived value |
| 2 | Auto-save | Remove friction, prevent data loss anxiety |
| 3 | Character profile template | Structured character development is the #1 need for new authors |
| 4 | Character relationship web | Visual thinking about character dynamics |
| 5 | Drag-and-drop on timeline | The dependency is already installed, just needs wiring |
| 6 | Markdown preview in editor | Authors need to see formatted output |
| 7 | Writing goals/daily targets | Motivation and habit building |
| 8 | Plot structure templates | Give beginners a framework to start with |
| 9 | Inline AI writing suggestions | The killer AI feature for drafting |
| 10 | Export to PDF/DOCX | Authors need to share and submit their work |
