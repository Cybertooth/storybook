export type EntityId = string;

export interface Story {
    id: EntityId;
    title: string;
    summary: string; // The "Seed"
    theme?: string;
    coreQuestion?: string;
    createdAt: string; // ISO 8601 timestamp
    updatedAt: string; // ISO 8601 timestamp
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
    characters: Character[];
    locationId?: EntityId;
    storyId: EntityId;
    // For Kanban/Timeline
    status?: 'idea' | 'drafted' | 'final';
    plotThread?: string; // e.g. "Main Plot", "Subplot A"
    emotionalValue?: number; // -5 (lowest) to +5 (highest) for pacing graph
}

export interface Chapter {
    id: EntityId;
    title: string;
    content?: string; // Only present when fetched via GET /chapters/:id/draft
    order: number;
    storyId: EntityId;
    status: 'planned' | 'drafting' | 'completed';
}

export interface AppSettings {
    id: string;
    userId: string;
    llmProvider: 'gemini' | 'openai';
    geminiKey?: string;
    geminiModel?: string;
    openaiKey?: string;
    theme: 'light' | 'dark' | 'system';
}

export interface Note {
    id: EntityId;
    content: string;
    createdAt: string; // ISO 8601 timestamp
    storyId: EntityId;
}

export interface UnresolvedQuestion {
    id: EntityId;
    question: string;
    details: string;
    isResolved: boolean;
    answer?: string;
    storyId: EntityId;
    createdAt: string; // ISO 8601 timestamp
}

export interface ProjectBundle {
    version: number;
    appName: 'storybook';
    savedAt: string; // ISO 8601 timestamp
    story: Story;
    characters: Character[];
    locations: Location[];
    events: PlotEvent[];
    chapters: Chapter[];
    notes?: Note[]; // Optional for backwards compatibility
    unresolvedQuestions?: UnresolvedQuestion[]; // Optional for backwards compatibility
    relationships?: Relationship[]; // Optional for backwards compatibility
}
