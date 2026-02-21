export type EntityId = string;

// Standard API Response Models
export interface ApiResponse<T> {
    success: boolean;
    data?: T;
    error?: string;
    message?: string;
}

export interface PaginatedResponse<T> {
    success: boolean;
    data: T[];
    total: number;
    page: number;
    limit: number;
}

// Data Models

export interface Story {
    id: EntityId;
    userId: string; // Tenant isolation
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
    userId: string; // Tenant isolation
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
    userId: string; // Tenant isolation
    sourceId: EntityId;
    targetId: EntityId;
    type: string; // "Sibling", "Enemy", "Lover"
    description: string;
    storyId: EntityId;
}

export interface Location {
    id: EntityId;
    userId: string; // Tenant isolation
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
    userId: string; // Tenant isolation
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
    emotionalValue?: number; // -5 (lowest) to +5 (highest) for pacing graph
}

export interface Chapter {
    id: EntityId;
    userId: string; // Tenant isolation
    title: string;
    content: string; // Markdown content
    order: number;
    storyId: EntityId;
    status: 'planned' | 'drafting' | 'completed';
}

export interface AppSettings {
    userId: string; // Tenant isolation
    llmProvider: 'gemini' | 'openai';
    geminiKey?: string;
    geminiModel?: string;
    openaiKey?: string;
    theme: 'light' | 'dark' | 'system';
}

export interface Note {
    id: EntityId;
    userId: string; // Tenant isolation
    content: string;
    createdAt: number;
    storyId: EntityId;
}

export interface UnresolvedQuestion {
    id: EntityId;
    userId: string; // Tenant isolation
    question: string;
    details: string;
    isResolved: boolean;
    answer?: string;
    storyId: EntityId;
    createdAt: number;
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
    notes?: Note[]; // Optional for backwards compatibility
    unresolvedQuestions?: UnresolvedQuestion[]; // Optional for backwards compatibility
    relationships?: Relationship[]; // Optional for backwards compatibility
}
