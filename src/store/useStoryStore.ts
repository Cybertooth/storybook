import { create } from 'zustand';
import { Story, Character, PlotEvent, Location, Chapter } from '@/types';
import { storage } from '@/lib/storage';
import { v4 as uuidv4 } from 'uuid';

interface StoryState {
    currentStory: Story | null;
    characters: Character[];
    locations: Location[];
    events: PlotEvent[];
    chapters: Chapter[];
    isLoading: boolean;
    isSaving: boolean;
    error: string | null;
    projectFileHandle: FileSystemFileHandle | null;
    projectFileName: string | null;

    // Story Actions
    loadStory: (id: string) => Promise<void>;
    createStory: (title: string) => Promise<void>;
    updatePlot: (summary: string, theme?: string, coreQuestion?: string) => Promise<void>;

    // Character Actions
    createCharacter: (name: string, role: Character['role']) => Promise<void>;
    updateCharacter: (id: string, updates: Partial<Character>) => Promise<void>;
    deleteCharacter: (id: string) => Promise<void>;

    // Location Actions
    createLocation: (name: string) => Promise<void>;
    updateLocation: (id: string, updates: Partial<Location>) => Promise<void>;
    deleteLocation: (id: string) => Promise<void>;

    // Event Actions
    createEvent: (title: string, plotThread?: string) => Promise<void>;
    updateEvent: (id: string, updates: Partial<PlotEvent>) => Promise<void>;
    deleteEvent: (id: string) => Promise<void>;
    reorderEvents: (reorderedEvents: PlotEvent[]) => Promise<void>;

    // Chapter Actions
    createChapter: (title: string) => Promise<void>;
    updateChapter: (id: string, updates: Partial<Chapter>) => Promise<void>;
    deleteChapter: (id: string) => Promise<void>;

    saveProjectToFile: () => Promise<void>;
    loadProjectFromFile: () => Promise<void>;
    newProject: () => Promise<void>;
    init: () => Promise<void>;
}

export const useStoryStore = create<StoryState>((set, get) => ({
    currentStory: null,
    characters: [],
    locations: [],
    events: [],
    chapters: [],
    isLoading: false,
    isSaving: false,
    error: null,
    projectFileHandle: null,
    projectFileName: null,

    loadStory: async (id: string) => {
        set({ isLoading: true, error: null });
        try {
            const story = await storage.getStory(id);
            const characters = await storage.getCharacters(id);
            const locations = await storage.getLocations(id);
            const events = await storage.getEvents(id);
            const chapters = await storage.getChapters(id);
            set({ currentStory: story, characters, locations, events, chapters, isLoading: false });
        } catch (err) {
            set({ error: (err as Error).message, isLoading: false });
        }
    },

    createStory: async (title: string) => {
        set({ isLoading: true, error: null });
        try {
            const story = await storage.createStory(title);
            set({ currentStory: story, characters: [], locations: [], events: [], chapters: [], isLoading: false });
        } catch (err) {
            set({ error: (err as Error).message, isLoading: false });
        }
    },

    init: async () => {
        set({ isLoading: true, error: null });
        try {
            const allStories = await storage.getAllStories();
            if (allStories.length > 0) {
                await get().loadStory(allStories[0].id);
            } else {
                await get().newProject();
            }
        } catch (err) {
            set({ error: (err as Error).message, isLoading: false });
        }
    },

    updatePlot: async (summary: string, theme?: string, coreQuestion?: string) => {
        const { currentStory } = get();
        if (!currentStory) return;

        const updatedStory = { ...currentStory, summary, theme, coreQuestion, updatedAt: Date.now() };
        set({ currentStory: updatedStory, isSaving: true });

        try {
            await storage.updateStory(currentStory.id, { summary, theme, coreQuestion });
            set({ isSaving: false });
        } catch (err) {
            set({ currentStory, error: (err as Error).message, isSaving: false });
        }
    },

    // --- Characters ---
    createCharacter: async (name: string, role: Character['role']) => {
        const { currentStory, characters } = get();
        if (!currentStory) return;

        const newChar: Character = {
            id: uuidv4(),
            name,
            role,
            description: '',
            traits: [],
            storyId: currentStory.id
        };

        set({ characters: [...characters, newChar], isSaving: true });

        try {
            await storage.saveCharacter(newChar);
            set({ isSaving: false });
        } catch (err) {
            set({ characters, error: (err as Error).message, isSaving: false });
        }
    },

    updateCharacter: async (id: string, updates: Partial<Character>) => {
        const { characters } = get();
        const target = characters.find(c => c.id === id);
        if (!target) return;

        const updatedChar = { ...target, ...updates };
        set({ characters: characters.map(c => c.id === id ? updatedChar : c), isSaving: true });

        try {
            await storage.saveCharacter(updatedChar);
            set({ isSaving: false });
        } catch (err) {
            set({ characters, error: (err as Error).message, isSaving: false });
        }
    },

    deleteCharacter: async (id: string) => {
        const { characters } = get();
        set({ characters: characters.filter(c => c.id !== id), isSaving: true });
        try {
            await storage.deleteCharacter(id);
            set({ isSaving: false });
        } catch (err) {
            set({ characters, error: (err as Error).message, isSaving: false });
        }
    },

    // --- Locations ---
    createLocation: async (name: string) => {
        const { currentStory, locations } = get();
        if (!currentStory) return;

        const newLoc: Location = {
            id: uuidv4(),
            name,
            description: '',
            storyId: currentStory.id
        };

        set({ locations: [...locations, newLoc], isSaving: true });
        try {
            await storage.saveLocation(newLoc);
            set({ isSaving: false });
        } catch (err) {
            set({ locations, error: (err as Error).message, isSaving: false });
        }
    },

    updateLocation: async (id: string, updates: Partial<Location>) => {
        const { locations } = get();
        const target = locations.find(l => l.id === id);
        if (!target) return;

        const updatedLoc = { ...target, ...updates };
        set({ locations: locations.map(l => l.id === id ? updatedLoc : l), isSaving: true });

        try {
            await storage.saveLocation(updatedLoc);
            set({ isSaving: false });
        } catch (err) {
            set({ locations, error: (err as Error).message, isSaving: false });
        }
    },

    deleteLocation: async (id: string) => {
        const { locations } = get();
        set({ locations: locations.filter(l => l.id !== id), isSaving: true });
        try {
            await storage.deleteLocation(id);
            set({ isSaving: false });
        } catch (err) {
            set({ locations, error: (err as Error).message, isSaving: false });
        }
    },

    // --- Events ---
    createEvent: async (title: string, plotThread = 'Main') => {
        const { currentStory, events } = get();
        if (!currentStory) return;

        const maxOrder = events.length > 0 ? Math.max(...events.map(e => e.order)) : 0;

        const newEvent: PlotEvent = {
            id: uuidv4(),
            title,
            description: '',
            order: maxOrder + 1,
            characterIds: [],
            storyId: currentStory.id,
            plotThread
        };

        set({ events: [...events, newEvent], isSaving: true });
        try {
            await storage.saveEvent(newEvent);
            set({ isSaving: false });
        } catch (err) {
            set({ events, error: (err as Error).message, isSaving: false });
        }
    },

    updateEvent: async (id: string, updates: Partial<PlotEvent>) => {
        const { events } = get();
        const target = events.find(e => e.id === id);
        if (!target) return;

        const updatedEvent = { ...target, ...updates };
        set({ events: events.map(e => e.id === id ? updatedEvent : e), isSaving: true });

        try {
            await storage.saveEvent(updatedEvent);
            set({ isSaving: false });
        } catch (err) {
            set({ events, error: (err as Error).message, isSaving: false });
        }
    },

    deleteEvent: async (id: string) => {
        const { events } = get();
        set({ events: events.filter(e => e.id !== id), isSaving: true });
        try {
            await storage.deleteEvent(id);
            set({ isSaving: false });
        } catch (err) {
            set({ events, error: (err as Error).message, isSaving: false });
        }
    },

    reorderEvents: async (reorderedEvents: PlotEvent[]) => {
        const { events } = get();
        set({ events: reorderedEvents });

        try {
            const updates = reorderedEvents.map(async (event, index) => {
                if (event.order !== index) {
                    const updated = { ...event, order: index };
                    await storage.saveEvent(updated);
                }
            });
            await Promise.all(updates);
        } catch (err) {
            set({ events, error: (err as Error).message });
        }
    },

    // --- Chapters ---
    createChapter: async (title: string) => {
        const { currentStory, chapters } = get();
        if (!currentStory) return;

        const maxOrder = chapters.length > 0 ? Math.max(...chapters.map(c => c.order)) : 0;

        const newChapter: Chapter = {
            id: uuidv4(),
            title,
            content: '',
            order: maxOrder + 1,
            storyId: currentStory.id,
            status: 'planned'
        };

        set({ chapters: [...chapters, newChapter], isSaving: true });
        try {
            await storage.saveChapter(newChapter);
            set({ isSaving: false });
        } catch (err) {
            set({ chapters, error: (err as Error).message, isSaving: false });
        }
    },

    updateChapter: async (id: string, updates: Partial<Chapter>) => {
        const { chapters } = get();
        const target = chapters.find(c => c.id === id);
        if (!target) return;

        const updatedChapter = { ...target, ...updates };
        set({ chapters: chapters.map(c => c.id === id ? updatedChapter : c), isSaving: true });

        try {
            await storage.saveChapter(updatedChapter);
            set({ isSaving: false });
        } catch (err) {
            set({ chapters, error: (err as Error).message, isSaving: false });
        }
    },

    deleteChapter: async (id: string) => {
        const { chapters } = get();
        set({ chapters: chapters.filter(c => c.id !== id), isSaving: true });
        try {
            await storage.deleteChapter(id);
            set({ isSaving: false });
        } catch (err) {
            set({ chapters, error: (err as Error).message, isSaving: false });
        }
    },

    // --- Project File Management ---
    saveProjectToFile: async () => {
        const { currentStory } = get();
        if (!currentStory) return;

        try {
            set({ isSaving: true });
            const json = await storage.exportProjectForStory(currentStory.id);
            const blob = new Blob([json], { type: 'application/json' });

            // Try File System Access API first (Chrome, Edge, Brave)
            if ('showSaveFilePicker' in window) {
                try {
                    let handle = get().projectFileHandle;
                    if (!handle) {
                        handle = await (window as any).showSaveFilePicker({
                            suggestedName: `${currentStory.title.replace(/[^a-zA-Z0-9 ]/g, '')}.storybook`,
                            types: [{
                                description: 'Storybook Project',
                                accept: { 'application/json': ['.storybook'] },
                            }],
                        });
                    }
                    if (handle) {
                        const writable = await handle.createWritable();
                        await writable.write(blob);
                        await writable.close();
                        set({ projectFileHandle: handle, projectFileName: handle.name, isSaving: false });
                        return;
                    }
                } catch (err: any) {
                    // User cancelled the picker — that's fine
                    if (err?.name === 'AbortError') {
                        set({ isSaving: false });
                        return;
                    }
                    // API not supported or other error, fall through
                }
            }

            // Fallback: download          
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `${currentStory.title.replace(/[^a-zA-Z0-9 ]/g, '')}.storybook`;
            a.click();
            URL.revokeObjectURL(url);
            set({ projectFileName: a.download, isSaving: false });
        } catch (err) {
            set({ error: (err as Error).message, isSaving: false });
        }
    },

    loadProjectFromFile: async () => {
        try {
            let text: string;
            let fileName: string;
            let handle: FileSystemFileHandle | null = null;

            // Try File System Access API first
            if ('showOpenFilePicker' in window) {
                try {
                    const [fileHandle] = await (window as any).showOpenFilePicker({
                        types: [{
                            description: 'Storybook Project',
                            accept: { 'application/json': ['.storybook'] },
                        }],
                        multiple: false,
                    });
                    handle = fileHandle;
                    const file = await fileHandle.getFile();
                    text = await file.text();
                    fileName = file.name;
                } catch (err: any) {
                    if (err?.name === 'AbortError') return; // User cancelled
                    throw err;
                }
            } else {
                // Fallback: file input
                const result = await new Promise<{ text: string; name: string } | null>((resolve) => {
                    const input = document.createElement('input');
                    input.type = 'file';
                    input.accept = '.storybook,.json';
                    input.onchange = async () => {
                        const file = input.files?.[0];
                        if (!file) { resolve(null); return; }
                        resolve({ text: await file.text(), name: file.name });
                    };
                    input.click();
                });
                if (!result) return;
                text = result.text;
                fileName = result.name;
            }

            set({ isLoading: true, error: null });
            const storyId = await storage.importProject(text!);
            const story = await storage.getStory(storyId);
            const characters = await storage.getCharacters(storyId);
            const locations = await storage.getLocations(storyId);
            const events = await storage.getEvents(storyId);
            const chapters = await storage.getChapters(storyId);
            set({
                currentStory: story,
                characters,
                locations,
                events,
                chapters,
                isLoading: false,
                projectFileHandle: handle,
                projectFileName: fileName!,
            });
        } catch (err) {
            set({ error: (err as Error).message, isLoading: false });
        }
    },

    newProject: async () => {
        set({ isLoading: true, error: null });
        try {
            const story = await storage.createStory('Untitled Project');
            set({
                currentStory: story,
                characters: [],
                locations: [],
                events: [],
                chapters: [],
                isLoading: false,
                projectFileHandle: null,
                projectFileName: null,
            });
        } catch (err) {
            set({ error: (err as Error).message, isLoading: false });
        }
    },
}));
