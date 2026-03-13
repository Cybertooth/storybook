export type EntityId = string;

// ---------------------------------------------------------------------------
// Standard API Response Models
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Authentication
// ---------------------------------------------------------------------------

/** POST /auth/register */
export interface RegisterRequest {
    /** Valid email address, max 254 characters */
    email: string;
    /** Minimum 12 characters, maximum 128 characters */
    password: string;
}

/** POST /auth/login */
export interface LoginRequest {
    /** Valid email address, max 254 characters */
    email: string;
    /** Minimum 8 characters, maximum 128 characters */
    password: string;
}

/** Returned by both /auth/login and /auth/register */
export interface AuthResponse {
    token: string;
    user: {
        id: string;
        email: string;
    };
}

// ---------------------------------------------------------------------------
// Core Data Models
// ---------------------------------------------------------------------------

export interface Story {
    id: EntityId;
    userId: string;
    title: string;
    summary: string;
    theme?: string;
    coreQuestion?: string;
    createdAt: string; // ISO 8601 timestamp
    updatedAt: string; // ISO 8601 timestamp — pass back in PUT for conflict detection
}

export interface Character {
    id: EntityId;
    userId: string;
    storyId: EntityId;
    name: string;
    role: string;
    description: string;
    traits: string[];
    arcLie?: string;
    arcTruth?: string;
    arcGhost?: string;
    avatarUrl?: string;
}

export interface Relationship {
    id: EntityId;
    userId: string;
    storyId: EntityId;
    sourceId: EntityId;
    targetId: EntityId;
    type: string;
    description: string;
}

export interface Location {
    id: EntityId;
    userId: string;
    storyId: EntityId;
    name: string;
    description: string;
    sensorySight?: string;
    sensorySound?: string;
    sensorySmell?: string;
    sensoryTouch?: string;
    sensoryTaste?: string;
}

export interface PlotEvent {
    id: EntityId;
    userId: string;
    storyId: EntityId;
    title: string;
    description: string;
    order: number;
    chapterId?: EntityId;
    locationId?: EntityId;
    status?: string;
    plotThread?: string;
    emotionalValue?: number;
    characters: Character[];
}

/**
 * Chapter metadata. The `content` field is NOT returned by GET /stories/:id/chapters
 * or GET /chapters/:id — it must be fetched separately via GET /chapters/:id/draft.
 * When creating a chapter (POST), content is accepted and stored.
 * When syncing, content should be included in the payload.
 */
export interface Chapter {
    id: EntityId;
    userId: string;
    storyId: EntityId;
    title: string;
    order: number;
    status: string;
    content?: string; // Present only when fetched via GET /chapters/:id/draft or during sync/create
}

export interface Note {
    id: EntityId;
    userId: string;
    storyId: EntityId;
    content: string;
    createdAt: string; // ISO 8601
}

export interface UnresolvedQuestion {
    id: EntityId;
    userId: string;
    storyId: EntityId;
    question: string;
    details: string;
    isResolved: boolean;
    answer?: string;
    createdAt: string; // ISO 8601
}

export interface AppSettings {
    id: string;
    userId: string;
    llmProvider: string;
    geminiKey?: string;
    geminiModel?: string;
    openaiKey?: string;
    theme: string;
}

// ---------------------------------------------------------------------------
// Sync (Offline-First)
// ---------------------------------------------------------------------------

/**
 * A tombstone records that an entity was deleted on a device so that other
 * devices can delete their local copy on the next pull.
 */
export interface TombstoneRecord {
    id: string;
    userId: string;
    entityId: EntityId;
    entityType: string; // 'story' | 'character' | 'location' | 'event' | 'note' | 'chapter' | 'relationship' | 'unresolvedQuestion'
    deletedAt: string; // ISO 8601
}

/**
 * Each record in a push payload MUST include a `_status` field.
 * The `id` field MUST be a client-generated UUID that is stable across syncs.
 */
export type SyncEntityStatus = 'created' | 'updated' | 'deleted';

export interface SyncChanges {
    stories?: Array<Partial<Story> & { _status: SyncEntityStatus; id: EntityId }>;
    characters?: Array<Partial<Character> & { _status: SyncEntityStatus; id: EntityId }>;
    locations?: Array<Partial<Location> & { _status: SyncEntityStatus; id: EntityId }>;
    events?: Array<Partial<PlotEvent> & { _status: SyncEntityStatus; id: EntityId }>;
    notes?: Array<Partial<Note> & { _status: SyncEntityStatus; id: EntityId }>;
    chapters?: Array<Partial<Chapter> & { _status: SyncEntityStatus; id: EntityId }>;
    relationships?: Array<Partial<Relationship> & { _status: SyncEntityStatus; id: EntityId }>;
    unresolvedQuestions?: Array<Partial<UnresolvedQuestion> & { _status: SyncEntityStatus; id: EntityId }>;
}

/** POST /sync/push */
export interface SyncPushRequest {
    changes: SyncChanges;
}

/** POST /sync/pull */
export interface SyncPullRequest {
    /** ISO 8601 timestamp. Pass '1970-01-01T00:00:00.000Z' to fetch everything. */
    last_sync_timestamp?: string;
}

/** Response body for POST /sync/pull */
export interface SyncPullResponse {
    changes: {
        stories: Story[];
        characters: Character[];
        locations: Location[];
        events: PlotEvent[];
        notes: Note[];
        chapters: Chapter[];
        relationships: Relationship[];
        unresolvedQuestions: UnresolvedQuestion[];
        tombstones: TombstoneRecord[];
    };
}

// ---------------------------------------------------------------------------
// AI Proxy Endpoints
// All require POST with JWT. Payload and response types are listed below.
// ---------------------------------------------------------------------------

/** POST /ai/generate-portrait */
export interface GeneratePortraitRequest {
    /** Max 4000 characters */
    characterDescription: string;
}
export interface GeneratePortraitResponse {
    imageUrl: string;
}

/** POST /ai/analyze-tropes */
export interface AnalyzeTropesRequest {
    /** Max 20000 characters */
    storyContext: string;
}
export type AnalyzeTropesResponse = Array<{ name: string; description: string }>;

/** POST /ai/plot-hole-check */
export interface PlotHoleCheckRequest {
    /** Max 20000 characters */
    storyContext: string;
}
export type PlotHoleCheckResponse = Array<{ issue: string; suggestion: string }>;

/** POST /ai/expand-plot */
export interface ExpandPlotRequest {
    /** Max 20000 characters */
    currentPlot: string;
}
export interface ExpandPlotResponse {
    expansion: string;
}

/** POST /ai/critique */
export interface CritiqueRequest {
    /** Max 30000 characters */
    draft: string;
    /** Max 20000 characters */
    context: string;
}
export type CritiqueResponse = Array<{ point: string; detail: string }>;

/** POST /ai/revise-draft */
export interface ReviseDraftRequest {
    /** Max 30000 characters */
    draft: string;
    /** Max 30 items, each max 200 characters */
    maxims: string[];
}
export interface ReviseDraftResponse {
    revisions: string[];
}

/** POST /ai/show-dont-tell */
export interface ShowDontTellRequest {
    /** Max 30000 characters */
    prose: string;
}
export type ShowDontTellResponse = Array<{ original: string; suggestion: string }>;

/** POST /ai/suggest-next */
export interface SuggestNextRequest {
    /** Max 30000 characters */
    priorText: string;
    /** Max 20000 characters */
    plotContext: string;
}
export interface SuggestNextResponse {
    suggestions: string[];
}

/** POST /ai/generic */
export interface GenericPromptRequest {
    /** Max 30000 characters */
    prompt: string;
    /** Max 20000 characters */
    context?: string;
}
export interface GenericPromptResponse {
    text: string;
}

// ---------------------------------------------------------------------------
// Project Bundle (local export/import)
// ---------------------------------------------------------------------------

export interface ProjectBundle {
    version: number;
    appName: 'storybook';
    savedAt: string; // ISO 8601
    story: Story;
    characters: Character[];
    locations: Location[];
    events: PlotEvent[];
    chapters: Chapter[];
    notes?: Note[];
    unresolvedQuestions?: UnresolvedQuestion[];
    relationships?: Relationship[];
}
