import { Story, Character, PlotEvent, Location, Chapter, Note, UnresolvedQuestion, Relationship } from '@storybook/api';
import { apiClient } from './apiClient';
import { v4 as uuidv4 } from 'uuid';

export interface IStorageService {
    getStory(id: string): Promise<Story | null>;
    saveStory(story: Story): Promise<void>;
    getAllStories(): Promise<Story[]>;
    createStory(title: string): Promise<Story>;
    updateStory(id: string, updates: Partial<Story>): Promise<Story>;
    deleteStory(id: string): Promise<void>;

    getCharacters(storyId: string): Promise<Character[]>;
    saveCharacter(character: Character): Promise<void>;
    deleteCharacter(id: string): Promise<void>;

    getLocations(storyId: string): Promise<Location[]>;
    saveLocation(location: Location): Promise<void>;
    deleteLocation(id: string): Promise<void>;

    getEvents(storyId: string): Promise<PlotEvent[]>;
    saveEvent(event: PlotEvent): Promise<void>;
    deleteEvent(id: string): Promise<void>;

    getChapters(storyId: string): Promise<Chapter[]>;
    saveChapter(chapter: Chapter): Promise<void>;
    deleteChapter(id: string): Promise<void>;

    getNotes(storyId: string): Promise<Note[]>;
    saveNote(note: Note): Promise<void>;
    deleteNote(id: string): Promise<void>;

    getUnresolvedQuestions(storyId: string): Promise<UnresolvedQuestion[]>;
    saveUnresolvedQuestion(question: UnresolvedQuestion): Promise<void>;
    deleteUnresolvedQuestion(id: string): Promise<void>;

    getRelationships(storyId: string): Promise<Relationship[]>;
    saveRelationship(relationship: Relationship): Promise<void>;
    deleteRelationship(id: string): Promise<void>;
}

class StorageService implements IStorageService {
    async getStory(id: string): Promise<Story | null> {
        try {
            const res = await apiClient.get<{ success: boolean, data: Story }>(`/stories/${id}`);
            return res.data.data;
        } catch (e) {
            return null;
        }
    }

    async saveStory(story: Story): Promise<void> {
        await apiClient.put(`/stories/${story.id}`, story);
    }

    async getAllStories(): Promise<Story[]> {
        const res = await apiClient.get<{ success: boolean, data: Story[] }>(`/stories`);
        return res.data.data.sort((a: Story, b: Story) => b.updatedAt - a.updatedAt);
    }

    async createStory(title: string): Promise<Story> {
        const payload: Partial<Story> = {
            id: uuidv4(),
            title,
            summary: '',
            createdAt: Date.now(),
            updatedAt: Date.now(),
        };
        const res = await apiClient.post<{ success: boolean, data: Story }>(`/stories`, payload);
        return res.data.data;
    }

    async updateStory(id: string, updates: Partial<Story>): Promise<Story> {
        const res = await apiClient.put<{ success: boolean, data: Story }>(`/stories/${id}`, updates);
        return res.data.data;
    }

    async deleteStory(id: string): Promise<void> {
        await apiClient.delete(`/stories/${id}`);
    }

    // -- Characters --
    async getCharacters(storyId: string): Promise<Character[]> {
        const res = await apiClient.get<{ success: boolean, data: Character[] }>(`/stories/${storyId}/characters`);
        return res.data.data;
    }

    async saveCharacter(item: Character): Promise<void> {
        try {
            await apiClient.put(`/characters/${item.id}`, item);
        } catch (e: any) {
            if (e.response?.status === 404) {
                await apiClient.post(`/stories/${item.storyId}/characters`, item);
            }
            // else throw e;
        }
    }

    async deleteCharacter(id: string): Promise<void> {
        await apiClient.delete(`/characters/${id}`);
    }

    // -- Locations --
    async getLocations(storyId: string): Promise<Location[]> {
        const res = await apiClient.get<{ success: boolean, data: Location[] }>(`/stories/${storyId}/locations`);
        return res.data.data;
    }

    async saveLocation(item: Location): Promise<void> {
        try {
            await apiClient.put(`/locations/${item.id}`, item);
        } catch (e: any) {
            if (e.response?.status === 404) {
                await apiClient.post(`/stories/${item.storyId}/locations`, item);
            }
        }
    }

    async deleteLocation(id: string): Promise<void> {
        await apiClient.delete(`/locations/${id}`);
    }

    // -- Events --
    async getEvents(storyId: string): Promise<PlotEvent[]> {
        const res = await apiClient.get<{ success: boolean, data: PlotEvent[] }>(`/stories/${storyId}/events`);
        return res.data.data.sort((a: PlotEvent, b: PlotEvent) => a.order - b.order);
    }

    async saveEvent(item: PlotEvent): Promise<void> {
        try {
            await apiClient.put(`/events/${item.id}`, item);
        } catch (e: any) {
            if (e.response?.status === 404) {
                await apiClient.post(`/stories/${item.storyId}/events`, item);
            }
        }
    }

    async deleteEvent(id: string): Promise<void> {
        await apiClient.delete(`/events/${id}`);
    }

    // -- Chapters --
    async getChapters(storyId: string): Promise<Chapter[]> {
        const res = await apiClient.get<{ success: boolean, data: Chapter[] }>(`/stories/${storyId}/chapters`);
        return res.data.data.sort((a: Chapter, b: Chapter) => a.order - b.order);
    }

    async saveChapter(item: Chapter): Promise<void> {
        try {
            await apiClient.put(`/chapters/${item.id}`, item);
        } catch (e: any) {
            if (e.response?.status === 404) {
                await apiClient.post(`/stories/${item.storyId}/chapters`, item);
            }
        }
    }

    async deleteChapter(id: string): Promise<void> {
        await apiClient.delete(`/chapters/${id}`);
    }

    // -- Notes --
    async getNotes(storyId: string): Promise<Note[]> {
        const res = await apiClient.get<{ success: boolean, data: Note[] }>(`/stories/${storyId}/notes`);
        return res.data.data.sort((a: Note, b: Note) => b.createdAt - a.createdAt);
    }

    async saveNote(item: Note): Promise<void> {
        try {
            await apiClient.put(`/notes/${item.id}`, item);
        } catch (e: any) {
            if (e.response?.status === 404) {
                await apiClient.post(`/stories/${item.storyId}/notes`, item);
            }
        }
    }

    async deleteNote(id: string): Promise<void> {
        await apiClient.delete(`/notes/${id}`);
    }

    // -- Unresolved Questions --
    async getUnresolvedQuestions(storyId: string): Promise<UnresolvedQuestion[]> {
        const res = await apiClient.get<{ success: boolean, data: UnresolvedQuestion[] }>(`/stories/${storyId}/questions`);
        return res.data.data.sort((a: UnresolvedQuestion, b: UnresolvedQuestion) => a.createdAt - b.createdAt);
    }

    async saveUnresolvedQuestion(item: UnresolvedQuestion): Promise<void> {
        try {
            await apiClient.put(`/questions/${item.id}`, item);
        } catch (e: any) {
            if (e.response?.status === 404) {
                await apiClient.post(`/stories/${item.storyId}/questions`, item);
            }
        }
    }

    async deleteUnresolvedQuestion(id: string): Promise<void> {
        await apiClient.delete(`/questions/${id}`);
    }

    // -- Relationships --
    async getRelationships(storyId: string): Promise<Relationship[]> {
        const res = await apiClient.get<{ success: boolean, data: Relationship[] }>(`/stories/${storyId}/relationships`);
        return res.data.data;
    }

    async saveRelationship(item: Relationship): Promise<void> {
        try {
            await apiClient.put(`/relationships/${item.id}`, item);
        } catch (e: any) {
            if (e.response?.status === 404) {
                await apiClient.post(`/stories/${item.storyId}/relationships`, item);
            }
        }
    }

    async deleteRelationship(id: string): Promise<void> {
        await apiClient.delete(`/relationships/${id}`);
    }

    // --- Backup & Restore (Optional fallback, could fetch bundle API) ---
    async exportDatabase(): Promise<string> {
        throw new Error("Export is handled server-side now.");
    }

    async importDatabase(_jsonString: string): Promise<void> {
        throw new Error("Import is handled server-side now.");
    }

    async exportProjectForStory(storyId: string): Promise<string> {
        // Can be mocked, but for real we should implement a bundle API on backend.
        return JSON.stringify({ version: 2, appName: 'storybook', storyId });
    }

    async importProject(_jsonString: string): Promise<string> {
        throw new Error("Import from file disabled pending backend upload logic");
    }
}

export const storage = new StorageService();
