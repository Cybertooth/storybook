import { create } from 'zustand';
import { v4 as uuidv4 } from 'uuid';

export interface AiLog {
    id: string;
    timestamp: number;
    type: 'request' | 'response' | 'error';
    provider: 'gemini' | 'openai';
    model: string;
    content: string; // The prompt or response text
    metadata?: Record<string, any>; // e.g., latency, tokens
}

interface AiLogState {
    logs: AiLog[];
    isOpen: boolean;
    toggleOpen: () => void;
    addLog: (log: Omit<AiLog, 'id' | 'timestamp'>) => void;
    clearLogs: () => void;
}

export const useAiLogStore = create<AiLogState>((set) => ({
    logs: [],
    isOpen: false, // Default closed

    toggleOpen: () => set((state) => ({ isOpen: !state.isOpen })),

    addLog: (log) => set((state) => ({
        logs: [{
            id: uuidv4(),
            timestamp: Date.now(),
            ...log
        }, ...state.logs]
    })),

    clearLogs: () => set({ logs: [] })
}));
