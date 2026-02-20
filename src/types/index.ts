export type EntityId = string;

export interface Story {
    id: EntityId;
    title: string;
    summary: string; // The "Seed"
    theme?: string;
    coreQuestion?: string;
    createdAt: number;
    updatedAt: number;
    // potentially more metadata
}

export interface Character {
    id: EntityId;
    name: string;
    role: 'protagonist' | 'antagonist' | 'supporting' | 'other';
    description: string;
    traits: string[]; // Quirks
    arcLie?: string;
    arcTruth?: string;
    arcGhost?: string;
    avatarUrl?: string;
    storyId: EntityId;
}

export interface Relationship {
    id: EntityId;
    sourceId: EntityId;
    targetId: EntityId;
    type: string; // "Sibling", "Enemy", "Lover"
    description: string;
    storyId: EntityId;
}

export interface Location {
    id: EntityId;
    name: string;
    description: string;
    sensorySight?: string;
    sensorySound?: string;
    sensorySmell?: string;
    sensoryTouch?: string;
    sensoryTaste?: string;
    storyId: EntityId;
}

export interface PlotEvent {
    id: EntityId;
    title: string;
    description: string;
    order: number;
    chapterId?: EntityId;
    characterIds: EntityId[];
    locationId?: EntityId;
    storyId: EntityId;
    // For Kanban/Timeline
    status?: 'idea' | 'drafted' | 'final';
    plotThread?: string; // e.g. "Main Plot", "Subplot A"
}

export interface Chapter {
    id: EntityId;
    title: string;
    content: string; // Markdown content
    order: number;
    storyId: EntityId;
    status: 'planned' | 'drafting' | 'completed';
}

export interface AppSettings {
    llmProvider: 'gemini' | 'openai';
    geminiKey?: string;
    geminiModel?: string;
    openaiKey?: string;
    theme: 'light' | 'dark' | 'system';
}

export interface ProjectBundle {
    version: number;
    appName: 'storybook';
    savedAt: number;
    story: Story;
    characters: Character[];
    locations: Location[];
    events: PlotEvent[];
    chapters: Chapter[];
}
