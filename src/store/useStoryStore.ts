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

    // Story Actions
    loadStory: (id: string) => Promise<void>;
    createStory: (title: string) => Promise<void>;
    updatePlot: (summary: string) => Promise<void>;

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

    updatePlot: async (summary: string) => {
        const { currentStory } = get();
        if (!currentStory) return;

        const updatedStory = { ...currentStory, summary, updatedAt: Date.now() };
        set({ currentStory: updatedStory, isSaving: true });

        try {
            await storage.updateStory(currentStory.id, { summary });
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
    }
}));
