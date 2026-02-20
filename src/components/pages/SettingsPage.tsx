import { useSettingsStore } from '@/store/useSettingsStore';
import { Save, Key, Database, Download, Upload, Settings } from 'lucide-react';
import { storage } from '@/lib/storage';
import { useToastStore } from '@/hooks/useToast';

import { useState, useEffect } from 'react';

export const SettingsPage = () => {
    const settings = useSettingsStore();
    const toast = useToastStore(s => s.toast);
    // Local state to avoid zustand persistence lag/jitter during typing
    const [localGeminiKey, setLocalGeminiKey] = useState(settings.geminiKey || '');
    const [localOpenAIKey, setLocalOpenAIKey] = useState(settings.openaiKey || '');

    useEffect(() => {
        setLocalGeminiKey(settings.geminiKey || '');
        setLocalOpenAIKey(settings.openaiKey || '');
    }, [settings.geminiKey, settings.openaiKey]);

    const handleSave = (e?: React.FormEvent) => {
        if (e) e.preventDefault();
        settings.updateSettings({
            geminiKey: localGeminiKey,
            openaiKey: localOpenAIKey
        });
        toast('Settings saved successfully!', 'success');
    };

    return (
        <form onSubmit={handleSave} className="max-w-2xl mx-auto space-y-8">
            <div className="border-b border-stone-200/50 pb-4">
                <div className="flex items-center gap-3">
                    <div className="p-2 bg-stone-100/50 rounded-lg text-stone-700">
                        <Settings className="w-5 h-5" />
                    </div>
                    <div>
                        <h2 className="text-2xl font-serif font-bold text-stone-900">Settings</h2>
                        <p className="text-stone-500 text-sm">Configure your writing assistant.</p>
                    </div>
                </div>
            </div>

            <div className="space-y-6">
                <div>
                    <h3 className="text-lg font-medium mb-3 flex items-center gap-2">
                        <Key className="w-5 h-5 text-indigo-600" />
                        LLM Provider
                    </h3>

                    <div className="glass-panel p-6 rounded-xl space-y-4">
                        <div className="space-y-2">
                            <label className="flex items-center gap-3 cursor-pointer">
                                <input
                                    type="radio"
                                    name="provider"
                                    value="gemini"
                                    checked={settings.llmProvider === 'gemini'}
                                    onChange={() => settings.updateSettings({ llmProvider: 'gemini' })}
                                    className="text-indigo-600 focus:ring-indigo-500"
                                />
                                <span className="font-medium text-stone-800">Google Gemini</span>
                            </label>
                            <div className="ml-7">
                                <input
                                    type="password"
                                    placeholder="Enter Gemini API Key"
                                    value={localGeminiKey}
                                    onChange={(e) => setLocalGeminiKey(e.target.value)}
                                    className="w-full p-2.5 glass-input rounded-lg text-sm mb-3"
                                />
                                <div className="space-y-1.5">
                                    <label className="text-xs font-semibold text-stone-500 uppercase tracking-wider">Model</label>
                                    <select
                                        value={settings.geminiModel || 'gemini-3-flash-preview'}
                                        onChange={(e) => settings.updateSettings({ geminiModel: e.target.value })}
                                        className="w-full p-2 glass-input rounded-lg text-sm text-stone-700 font-medium"
                                    >
                                        <option value="gemini-3-flash-preview">Gemini 3 Flash Preview (Fast/Default)</option>
                                        <option value="gemini-3-pro-preview">Gemini 3 Pro (High Quality)</option>
                                        <option value="gemini-3.1-pro-preview">Gemini 3.1 Pro (Latest)</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div className="border-t border-white/20 my-4"></div>

                        <div className="space-y-2">
                            <label className="flex items-center gap-3 cursor-pointer">
                                <input
                                    type="radio"
                                    name="provider"
                                    value="openai"
                                    checked={settings.llmProvider === 'openai'}
                                    onChange={() => settings.updateSettings({ llmProvider: 'openai' })}
                                    className="text-indigo-600 focus:ring-indigo-500"
                                />
                                <span className="font-medium text-stone-800">OpenAI</span>
                            </label>
                            <div className="ml-7">
                                <input
                                    type="password"
                                    placeholder="Enter OpenAI API Key"
                                    value={localOpenAIKey}
                                    onChange={(e) => setLocalOpenAIKey(e.target.value)}
                                    className="w-full p-2.5 glass-input rounded-lg text-sm"
                                />
                            </div>
                        </div>
                    </div>
                </div>

                <div className="border-t border-stone-200/50 pt-6">
                    <h3 className="text-lg font-medium mb-3 flex items-center gap-2">
                        <Database className="w-5 h-5 text-emerald-600" />
                        Data Management
                    </h3>
                    <div className="glass-panel p-6 rounded-xl space-y-4">
                        <p className="text-sm text-stone-600">
                            Download a backup of your entire story bible or restore from a previous file.
                        </p>
                        <div className="flex gap-3">
                            <button
                                onClick={async () => {
                                    const json = await storage.exportDatabase();
                                    const blob = new Blob([json], { type: 'application/json' });
                                    const url = URL.createObjectURL(blob);
                                    const a = document.createElement('a');
                                    a.href = url;
                                    a.download = `storybook-backup-${new Date().toISOString().slice(0, 10)}.json`;
                                    a.click();
                                    toast('Backup exported successfully!', 'success');
                                }}
                                className="flex items-center gap-2 px-4 py-2.5 bg-indigo-50/80 text-indigo-700 rounded-lg hover:bg-indigo-100 border border-indigo-200/50 transition-all hover:-translate-y-0.5 text-sm font-medium shadow-sm"
                            >
                                <Download className="w-4 h-4" />
                                Export Backup
                            </button>
                            <label className="flex items-center gap-2 px-4 py-2.5 bg-stone-50/80 text-stone-700 rounded-lg hover:bg-stone-100 border border-stone-200/50 transition-all hover:-translate-y-0.5 text-sm font-medium cursor-pointer shadow-sm">
                                <Upload className="w-4 h-4" />
                                Restore Backup
                                <input
                                    type="file"
                                    accept=".json"
                                    className="hidden"
                                    onChange={async (e) => {
                                        const file = e.target.files?.[0];
                                        if (!file) return;
                                        if (confirm("WARNING: This will overwrite ALL current data with the backup. Are you sure?")) {
                                            const text = await file.text();
                                            await storage.importDatabase(text);
                                            toast('Backup restored! Reloading...', 'info');
                                            setTimeout(() => window.location.reload(), 1000);
                                        }
                                    }}
                                />
                            </label>
                        </div>
                    </div>
                </div>

                <div className="flex justify-end pt-4">
                    <button
                        type="submit"
                        className="flex items-center gap-2 px-6 py-2.5 bg-stone-900 text-white rounded-lg hover:bg-stone-800 transition-all shadow-lg shadow-stone-900/20 hover:-translate-y-0.5 hover:shadow-xl"
                    >
                        <Save className="w-4 h-4" />
                        Save Settings
                    </button>
                </div>
            </div>
        </form>
    );
};
