import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { AppSettings } from '@storybook/api';

interface SettingsState extends AppSettings {
    updateSettings: (settings: Partial<AppSettings>) => void;
}

export const useSettingsStore = create<SettingsState>()(
    persist(
        (set) => ({
            id: 'local-settings',
            userId: 'local-user',
            llmProvider: 'gemini',
            geminiKey: '',
            geminiModel: 'gemini-3-flash-preview',
            openaiKey: '',
            theme: 'system',
            updateSettings: (newSettings) => set((state) => ({ ...state, ...newSettings })),
        }),
        {
            name: 'storybook-settings',
        }
    )
);
