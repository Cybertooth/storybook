# Storybook — Feature Roadmap 2 (Focus: Budding Authors & Screenwriters)

Building upon the initial feature set, this document focuses specifically on the needs of **first-time novelists and screenwriters**, bridging the gap between having an idea and executing a structured, compelling draft. 

These features prioritize guiding the author, preventing common beginner mistakes (like sagging middles or telling-not-showing), and keeping motivation high.

---

## 🏗️ App-Wide & Project Level

### 1. Goal Tracking & Gamification
- **Daily Word Count Widget:** A visual ring (like Apple Watch rings) that tracks daily writing against a chosen goal (e.g., 1,667 words for NaNoWriMo).
- **Writing Streaks & Milestones:** Badges for "7-day streak," "First 10k words," or "All scenes mapped." First-time authors need continuous positive reinforcement.

### 2. Snapshots & "Fearless Editing"
- **Version Control (Time Machine):** Beginners are often terrified of deleting text. Offer a one-click "Snapshot" button that saves the entire state of the project (drafts, characters, timeline). If a rewrite fails, they can revert easily.

### 3. Screenplay Export & Parsing (Fountain)
- **Fountain Translator:** Native import/export of `.fountain` files. Allows screenwriters to use the app to plot and then export into an industry-standard format ready for Final Draft or Highland.

---

## 🌱 Story Engine (Home Page)

### 1. Structure Templates (Beat Sheets)
- **"Save the Cat" Overlay:** Instead of a generic plot box, offer structured text areas for the 15 beats: *Opening Image, Theme Stated, Setup, Catalyst, Debate, Break into Two, etc.*
- **Tropes & Clichés Analyzer:** Run the story seed through the AI to identify overly common tropes and suggest ways to "subvert" or twist them to make the premise fresher.

### 2. Core Question & Theme Tracker
- A dedicated sticky field for the **"Story Question"** (e.g., *Will the detective find the killer before it's too late?*) and the **"Theme"** (e.g., *Revenge always costs more than you expect*). This stays pinned to keep the author focused on what the story is *actually* about.

---

## 🎭 Characters Page

### 1. Character Arcs & "The Lie"
- **Internal Journey Tracker:** Add fields specifically for the character's internal arc:
  - **The Lie they believe** at the start.
  - **The Truth they discover** by the end.
  - **The Ghost/Wound** (the backstory event that caused The Lie).
- **Voice distinctiveness check:** An AI tool that analyzes dialogue snippets for a character and warns if two characters "sound too similar."

### 2. Relationship Web (Matrix)
- Instead of just isolated cards, a grid or web showing what Character A thinks of Character B, and vice versa. Highlights areas where conflict can be deepened.

---

## 🗺️ World & Locations Page

### 1. "Senses" Checklist for Descriptions
- When creating a location, provide five text inputs: **Sight, Sound, Smell, Touch, Taste**. Beginners often rely only on sight. This forces immersive worldbuilding.

### 2. Interactive Pinned Maps
- A simple drag-and-drop canvas where authors can place "pins" representing their Location cards relative to one another (e.g., "The tavern is North of the castle"). Distance and travel time notes.

---

## ⏱️ Timeline Page

### 1. Scene Emotional Value (Pacing Curve)
- Allow writers to rate every scene on an emotional scale (-5 for crushing defeat, +5 for triumphant victory).
- **Pacing Graph:** Automatically plot these on a line graph above the timeline. If the graph forms a flat line for 10 scenes, the app warns the user of a "sagging middle."

### 2. "Why" vs "And Then" Dependency Checker
- A feature inspired by Trey Parker and Matt Stone: Ensure events are connected by *"Therefore"* or *"But"*, rather than *"And then..."*. A toggle to explicitly link scenes as cause-and-effect.

---

## ✍️ Draft Page (The Editor)

### 1. Split-Pane Reference Sidebar 🌟 *(Highest Priority)*
- Add a collapsible right sidebar where the author can "pin" a Character Card, Location Card, or Timeline Event while writing.
- **Why it matters:** Eliminates the mental tax of context-switching or opening new tabs just to remember an eye color or what's supposed to happen in the scene.

### 2. AI "Show, Don't Tell" Highlighter
- A specialized AI button that highlights sentences in the draft that are "telling" (e.g., *John was very angry*) and suggests 3 options for "showing" (e.g., *John's knuckles turned white as he gripped the steering wheel*).

### 3. Typewriter / Focus Mode
- A toggle that dims everything except the current paragraph and locks the cursor to the vertical center of the screen, keeping the writer in a state of flow without looking up and down the monitor.
- **Sprint Mode:** A built-in Pomodoro timer (e.g., 20 mins) that blocks the author from switching to other pages until the sprint is complete or aborted.

### 4. Screenplay Typing Mode
- Auto-formatting shortcuts: Typing `INT.` or `EXT.` auto-capitalizes and centers the next line as a Scene Heading. Hitting tab jumps to Character Name, hitting enter jumps to Dialogue.
