import localforage from 'localforage';
import { Story, Character, PlotEvent, Location, Chapter, ProjectBundle, Note } from '@/types';
import { v4 as uuidv4 } from 'uuid';

// Default initial data for a new story
const createNewStory = (title: string): Story => ({
    id: uuidv4(),
    title,
    summary: '',
    createdAt: Date.now(),
    updatedAt: Date.now(),
});

// Configure localforage instances
const storyStore = localforage.createInstance({ name: 'storybook', storeName: 'stories' });
const characterStore = localforage.createInstance({ name: 'storybook', storeName: 'characters' });
const locationStore = localforage.createInstance({ name: 'storybook', storeName: 'locations' });
const eventStore = localforage.createInstance({ name: 'storybook', storeName: 'events' });
const chapterStore = localforage.createInstance({ name: 'storybook', storeName: 'chapters' });
const noteStore = localforage.createInstance({ name: 'storybook', storeName: 'notes' });

export interface IStorageService {
    // Stories
    getStory(id: string): Promise<Story | null>;
    saveStory(story: Story): Promise<void>;
    getAllStories(): Promise<Story[]>;
    createStory(title: string): Promise<Story>;
    updateStory(id: string, updates: Partial<Story>): Promise<Story>;
    deleteStory(id: string): Promise<void>;

    // Characters
    getCharacters(storyId: string): Promise<Character[]>;
    saveCharacter(character: Character): Promise<void>;
    deleteCharacter(id: string): Promise<void>;

    // Locations
    getLocations(storyId: string): Promise<Location[]>;
    saveLocation(location: Location): Promise<void>;
    deleteLocation(id: string): Promise<void>;

    // Events
    getEvents(storyId: string): Promise<PlotEvent[]>;
    saveEvent(event: PlotEvent): Promise<void>;
    deleteEvent(id: string): Promise<void>;

    // Chapters
    getChapters(storyId: string): Promise<Chapter[]>;
    saveChapter(chapter: Chapter): Promise<void>;
    deleteChapter(id: string): Promise<void>;

    // Notes
    getNotes(storyId: string): Promise<Note[]>;
    saveNote(note: Note): Promise<void>;
    deleteNote(id: string): Promise<void>;
}

class StorageService implements IStorageService {
    // --- Stories ---
    async getStory(id: string): Promise<Story | null> {
        return await storyStore.getItem<Story>(id);
    }

    async saveStory(story: Story): Promise<void> {
        await storyStore.setItem(story.id, { ...story, updatedAt: Date.now() });
    }

    async getAllStories(): Promise<Story[]> {
        const stories: Story[] = [];
        await storyStore.iterate<Story, void>((value) => stories.push(value));
        return stories.sort((a, b) => b.updatedAt - a.updatedAt);
    }

    async createStory(title: string): Promise<Story> {
        const newStory = createNewStory(title);
        await this.saveStory(newStory);
        return newStory;
    }

    async updateStory(id: string, updates: Partial<Story>): Promise<Story> {
        const story = await this.getStory(id);
        if (!story) throw new Error(`Story with id ${id} not found`);
        const updatedStory = { ...story, ...updates, updatedAt: Date.now() };
        await this.saveStory(updatedStory);
        return updatedStory;
    }

    async deleteStory(id: string): Promise<void> {
        await storyStore.removeItem(id);
    }

    // --- Characters ---
    async getCharacters(storyId: string): Promise<Character[]> {
        const items: Character[] = [];
        await characterStore.iterate<Character, void>((item) => {
            if (item.storyId === storyId) items.push(item);
        });
        return items;
    }

    async saveCharacter(item: Character): Promise<void> {
        await characterStore.setItem(item.id, item);
    }

    async deleteCharacter(id: string): Promise<void> {
        await characterStore.removeItem(id);
    }

    // --- Locations ---
    async getLocations(storyId: string): Promise<Location[]> {
        const items: Location[] = [];
        await locationStore.iterate<Location, void>((item) => {
            if (item.storyId === storyId) items.push(item);
        });
        return items;
    }

    async saveLocation(item: Location): Promise<void> {
        await locationStore.setItem(item.id, item);
    }

    async deleteLocation(id: string): Promise<void> {
        await locationStore.removeItem(id);
    }

    // --- Events ---
    async getEvents(storyId: string): Promise<PlotEvent[]> {
        const items: PlotEvent[] = [];
        await eventStore.iterate<PlotEvent, void>((item) => {
            if (item.storyId === storyId) items.push(item);
        });
        return items.sort((a, b) => a.order - b.order);
    }

    async saveEvent(item: PlotEvent): Promise<void> {
        await eventStore.setItem(item.id, item);
    }

    async deleteEvent(id: string): Promise<void> {
        await eventStore.removeItem(id);
    }

    // --- Chapters ---
    async getChapters(storyId: string): Promise<Chapter[]> {
        const items: Chapter[] = [];
        await chapterStore.iterate<Chapter, void>((item) => {
            if (item.storyId === storyId) items.push(item);
        });
        return items.sort((a, b) => a.order - b.order);
    }

    async saveChapter(item: Chapter): Promise<void> {
        await chapterStore.setItem(item.id, item);
    }

    async deleteChapter(id: string): Promise<void> {
        await chapterStore.removeItem(id);
    }

    // --- Notes ---
    async getNotes(storyId: string): Promise<Note[]> {
        const items: Note[] = [];
        await noteStore.iterate<Note, void>((item) => {
            if (item.storyId === storyId) items.push(item);
        });
        return items.sort((a, b) => b.createdAt - a.createdAt);
    }

    async saveNote(item: Note): Promise<void> {
        await noteStore.setItem(item.id, item);
    }

    async deleteNote(id: string): Promise<void> {
        await noteStore.removeItem(id);
    }

    // --- Backup & Restore ---
    async exportDatabase(): Promise<string> {
        const backup = {
            version: 1,
            timestamp: Date.now(),
            stories: [] as Story[],
            characters: [] as Character[],
            locations: [] as Location[],
            events: [] as PlotEvent[],
            chapters: [] as Chapter[],
            notes: [] as Note[]
        };

        await storyStore.iterate<Story, void>((value) => backup.stories.push(value));
        await characterStore.iterate<Character, void>((value) => backup.characters.push(value));
        await locationStore.iterate<Location, void>((value) => backup.locations.push(value));
        await eventStore.iterate<PlotEvent, void>((value) => backup.events.push(value));
        await chapterStore.iterate<Chapter, void>((value) => backup.chapters.push(value));
        await noteStore.iterate<Note, void>((value) => backup.notes.push(value));

        return JSON.stringify(backup, null, 2);
    }

    async importDatabase(jsonString: string): Promise<void> {
        try {
            const data = JSON.parse(jsonString);

            // Basic validation
            if (!data.stories || !Array.isArray(data.stories)) throw new Error("Invalid backup format");

            // Clear current data
            await storyStore.clear();
            await characterStore.clear();
            await locationStore.clear();
            await eventStore.clear();
            await chapterStore.clear();
            await noteStore.clear();

            // Import new data
            for (const item of data.stories) await storyStore.setItem(item.id, item);
            for (const item of data.characters) await characterStore.setItem(item.id, item);
            for (const item of data.locations) await locationStore.setItem(item.id, item);
            for (const item of data.events) await eventStore.setItem(item.id, item);
            for (const item of data.chapters) await chapterStore.setItem(item.id, item);
            if (data.notes) for (const item of data.notes) await noteStore.setItem(item.id, item);

        } catch (error) {
            console.error("Import failed:", error);
            throw new Error(`Import failed: ${(error as Error).message}`);
        }
    }

    // --- Project File Save/Load ---
    async exportProjectForStory(storyId: string): Promise<string> {
        const story = await this.getStory(storyId);
        if (!story) throw new Error('No story found to export');

        const bundle: ProjectBundle = {
            version: 1,
            appName: 'storybook',
            savedAt: Date.now(),
            story,
            characters: await this.getCharacters(storyId),
            locations: await this.getLocations(storyId),
            events: await this.getEvents(storyId),
            chapters: await this.getChapters(storyId),
            notes: await this.getNotes(storyId),
        };

        return JSON.stringify(bundle, null, 2);
    }

    async importProject(jsonString: string): Promise<string> {
        try {
            const data = JSON.parse(jsonString) as ProjectBundle;

            // Validate format
            if (data.appName !== 'storybook' || !data.story) {
                throw new Error('Invalid .storybook file format');
            }

            // Clear current data
            await storyStore.clear();
            await characterStore.clear();
            await locationStore.clear();
            await eventStore.clear();
            await chapterStore.clear();
            await noteStore.clear();

            // Import project data
            await storyStore.setItem(data.story.id, data.story);
            for (const item of data.characters) await characterStore.setItem(item.id, item);
            for (const item of data.locations) await locationStore.setItem(item.id, item);
            for (const item of data.events) await eventStore.setItem(item.id, item);
            for (const item of data.chapters) await chapterStore.setItem(item.id, item);
            if (data.notes) for (const item of data.notes) await noteStore.setItem(item.id, item);

            return data.story.id;
        } catch (error) {
            console.error("Project import failed:", error);
            throw new Error(`Project import failed: ${(error as Error).message}`);
        }
    }
}

export const storage = new StorageService();
