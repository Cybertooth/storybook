import { useState, useEffect } from 'react';
import TextareaAutosize from 'react-textarea-autosize';
import { useStoryStore } from '@/store/useStoryStore';
import { aiService } from '@/lib/ai';
import { Wand2, Loader2, FileSearch, Sparkles, Check, X } from 'lucide-react';
import clsx from 'clsx';
import { useAnalysis } from '@/hooks/useAnalysis';
import { PlotExpander } from './PlotExpander';
import { useDebounce } from '@/hooks/useDebounce';

export const PlotGerminator = () => {
    const { currentStory, characters, events, locations, createStory, isLoading: isStoreLoading, error: storeError, isSaving } = useStoryStore();
    const [plotText, setPlotText] = useState('');
    const [themeText, setThemeText] = useState('');
    const [coreQuestionText, setCoreQuestionText] = useState('');
    const [isDirty, setIsDirty] = useState(false);
    const [isAiLoading, setIsAiLoading] = useState(false);
    const [aiError, setAiError] = useState<string | null>(null);
    const [critique, setCritique] = useState<string | null>(null);
    const [showExpander, setShowExpander] = useState(false);

    // Analysis Hook
    const { isAnalyzing, analysisResult, analyze, applyAnalysis, discardAnalysis } = useAnalysis();

    useEffect(() => {
        if (currentStory) {
            setPlotText(currentStory.summary || '');
            setThemeText(currentStory.theme || '');
            setCoreQuestionText(currentStory.coreQuestion || '');
            // Reset dirty state when loading a new story to prevent immediate auto-save
            setIsDirty(false);
        }
    }, [currentStory?.id]); // Only trigger on story ID change to avoid cursor jumps

    const debouncedPlot = useDebounce(plotText, 1500);
    const debouncedTheme = useDebounce(themeText, 1500);
    const debouncedCoreQuestion = useDebounce(coreQuestionText, 1500);

    useEffect(() => {
        if (!isDirty) return;

        const performSave = async () => {
            if (!currentStory) {
                await createStory("New Novel");
            }
            // The store might have been updated by createStory, so wait a tick
            setTimeout(async () => {
                await useStoryStore.getState().updatePlot(debouncedPlot, debouncedTheme, debouncedCoreQuestion);
                setIsDirty(false);
            }, 0);
        };

        performSave();
    }, [debouncedPlot, debouncedTheme, debouncedCoreQuestion]);

    const handleExpand = () => {
        if (!plotText.trim()) return;
        setShowExpander(true);
    };

    const handleCritique = async () => {
        if (!plotText.trim() && !currentStory) return;
        setIsAiLoading(true);
        setAiError(null);
        setCritique(null);

        try {
            // Build context
            const context = `
            PLOT SUMMARY:
            ${plotText}

            CHARACTERS:
            ${characters.map(c => `- ${c.name} (${c.role}): ${c.description}`).join('\n')}

            EVENTS:
            ${events.map(e => `- ${e.title} (${e.plotThread})`).join('\n')}

            LOCATIONS:
            ${locations.map(l => `- ${l.name}: ${l.description}`).join('\n')}
            `;

            const result = await aiService.critiqueStory(context);
            setCritique(result);
        } catch (err) {
            setAiError((err as Error).message);
        } finally {
            setIsAiLoading(false);
        }
    }

    const handleChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
        setPlotText(e.target.value);
        setIsDirty(true);
    };

    const handleDetailsChange = (setter: React.Dispatch<React.SetStateAction<string>>) => (e: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => {
        setter(e.target.value);
        setIsDirty(true);
    };

    const isLoading = isStoreLoading || isAiLoading || isAnalyzing;
    const error = storeError || aiError;

    return (
        <div className="max-w-4xl mx-auto space-y-8 pb-12 relative animate-in fade-in duration-500">
            {/* Header - Floating */}
            <div className="flex justify-between items-center sticky top-0 py-4 z-20 backdrop-blur-md bg-stone-50/80 -mx-4 px-4 rounded-b-xl transition-all">
                <div className="flex items-center gap-3">
                    <div className="p-2 bg-indigo-100/50 rounded-lg text-indigo-700">
                        <Sparkles className="w-5 h-5" />
                    </div>
                    <div>
                        <h2 className="text-2xl font-serif font-bold text-stone-800 tracking-tight">The Seed</h2>
                        <p className="text-stone-500 text-xs font-medium uppercase tracking-wide">Plant your story idea</p>
                    </div>
                </div>

                <div className="flex gap-2 p-1 bg-stone-200/50 rounded-lg backdrop-blur-sm">
                    <button
                        onClick={() => analyze(plotText)}
                        disabled={isLoading || !plotText.trim()}
                        className={clsx("glass-button flex items-center gap-2 px-3 py-1.5 text-xs font-bold text-indigo-700 rounded-md", isAnalyzing && "opacity-70")}
                        title="Extract entities from plot"
                    >
                        {isAnalyzing ? <Loader2 className="w-3 h-3 animate-spin" /> : <Sparkles className="w-3 h-3" />}
                        <span>Analyze</span>
                    </button>
                    <div className="w-px bg-stone-300 my-1"></div>
                    <button
                        onClick={handleCritique}
                        disabled={isLoading || !plotText.trim()}
                        className="glass-button flex items-center gap-2 px-3 py-1.5 text-xs font-medium text-stone-700 rounded-md hover:text-amber-700"
                        title="Get critical feedback"
                    >
                        {isAiLoading ? <Loader2 className="w-3 h-3 animate-spin" /> : <FileSearch className="w-3 h-3" />}
                        <span>Critique</span>
                    </button>
                    <button
                        onClick={handleExpand}
                        disabled={isLoading || !plotText.trim()}
                        className="glass-button flex items-center gap-2 px-3 py-1.5 text-xs font-medium text-stone-700 rounded-md"
                    >
                        <Wand2 className="w-3 h-3" />
                        <span>Expand</span>
                    </button>
                    {/* Manual Save button removed in favor of autosave, but we keep the visual indicator */}
                    <div
                        className={clsx(
                            "flex items-center gap-2 px-3 py-1.5 rounded-md transition-all font-medium text-xs",
                            isDirty || isSaving
                                ? "text-amber-600 bg-amber-50"
                                : "text-emerald-600 bg-emerald-50"
                        )}
                    >
                        {(isDirty || isSaving || isStoreLoading) ? <Loader2 className="w-3 h-3 animate-spin" /> : <Check className="w-3 h-3" />}
                        <span>{(isDirty || isSaving || isStoreLoading) ? 'Saving...' : 'Saved'}</span>
                    </div>
                </div>
            </div>

            {error && (
                <div className="p-4 bg-red-50/80 backdrop-blur-sm text-red-600 rounded-xl border border-red-100 text-sm shadow-sm animate-in slide-in-from-top-2">
                    {error}
                </div>
            )}

            {/* Analysis Result Modal/Panel */}
            {analysisResult && (
                <div className="glass-panel rounded-2xl p-6 space-y-6 relative overflow-hidden group">
                    <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500"></div>
                    <div className="flex justify-between items-start">
                        <h3 className="font-bold text-indigo-900 flex items-center gap-2 text-lg">
                            <Sparkles className="w-5 h-5 text-indigo-500" />
                            Analysis Results
                        </h3>
                        <div className="flex gap-2">
                            <button
                                onClick={discardAnalysis}
                                className="px-3 py-1.5 text-xs font-medium text-stone-500 hover:text-stone-800 hover:bg-stone-100 rounded-md transition-colors"
                            >
                                Discard
                            </button>
                            <button
                                onClick={applyAnalysis}
                                className="px-4 py-1.5 text-xs font-bold bg-indigo-600 text-white rounded-md hover:bg-indigo-700 flex items-center gap-2 shadow-lg shadow-indigo-500/20 hover:shadow-indigo-500/40 transition-all hover:-translate-y-0.5"
                            >
                                <Check className="w-3 h-3" />
                                Apply Changes
                            </button>
                        </div>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                        <div className="bg-white/50 dark:bg-stone-800/50 p-4 rounded-xl border border-indigo-100 dark:border-indigo-900/50 hover:border-indigo-200 dark:hover:border-indigo-500/50 transition-colors">
                            <h4 className="font-bold text-stone-700 mb-3 flex items-center gap-2">
                                <span className="w-2 h-2 rounded-full bg-indigo-400"></span>
                                Characters
                                <span className="ml-auto text-xs bg-indigo-100 text-indigo-700 px-2 py-0.5 rounded-full">{analysisResult.characters?.length || 0}</span>
                            </h4>
                            <ul className="space-y-2">
                                {analysisResult.characters?.map((c: any, i: number) => (
                                    <li key={i} className="flex flex-col text-stone-600">
                                        <span className="font-semibold text-stone-800">{c.Name || c.name}</span>
                                        <span className="text-xs text-stone-400">{c.Job || c.Role || c.role}</span>
                                    </li>
                                ))}
                            </ul>
                        </div>
                        <div className="bg-white/50 dark:bg-stone-800/50 p-4 rounded-xl border border-indigo-100 dark:border-indigo-900/50 hover:border-indigo-200 dark:hover:border-indigo-500/50 transition-colors">
                            <h4 className="font-bold text-stone-700 mb-3 flex items-center gap-2">
                                <span className="w-2 h-2 rounded-full bg-emerald-400"></span>
                                Locations
                                <span className="ml-auto text-xs bg-emerald-100 text-emerald-700 px-2 py-0.5 rounded-full">{analysisResult.locations?.length || 0}</span>
                            </h4>
                            <ul className="space-y-2">
                                {analysisResult.locations?.map((l: any, i: number) => (
                                    <li key={i} className="text-stone-600">{l.Name || l.name}</li>
                                ))}
                            </ul>
                        </div>
                        <div className="bg-white/50 dark:bg-stone-800/50 p-4 rounded-xl border border-indigo-100 dark:border-indigo-900/50 hover:border-indigo-200 dark:hover:border-indigo-500/50 transition-colors">
                            <h4 className="font-bold text-stone-700 mb-3 flex items-center gap-2">
                                <span className="w-2 h-2 rounded-full bg-amber-400"></span>
                                Events
                                <span className="ml-auto text-xs bg-amber-100 text-amber-700 px-2 py-0.5 rounded-full">{analysisResult.events?.length || 0}</span>
                            </h4>
                            <ul className="space-y-2">
                                {analysisResult.events?.map((e: any, i: number) => (
                                    <li key={i} className="text-stone-600">{e.Title || e.title}</li>
                                ))}
                            </ul>
                        </div>
                    </div>
                </div>
            )}

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
                <div className={clsx("glass-panel rounded-xl flex flex-col relative transition-all duration-500", critique ? "lg:col-span-2" : "lg:col-span-3")}>

                    {/* Thematic Elements Bar */}
                    <div className="flex flex-col sm:flex-row divide-y sm:divide-y-0 sm:divide-x divide-stone-200 dark:divide-stone-700/50 border-b border-stone-200 dark:border-stone-700/50">
                        <div className="flex-1 p-4 bg-white/50 dark:bg-stone-900/40 space-y-2">
                            <label className="text-xs font-bold text-indigo-700 dark:text-indigo-400 uppercase tracking-wider flex items-center gap-2">
                                Core Question
                                <span className="text-stone-400 font-normal lowercase" title="What is the story trying to answer? (e.g., Will the detective catch the killer?)">?</span>
                            </label>
                            <input
                                type="text"
                                value={coreQuestionText}
                                onChange={handleDetailsChange(setCoreQuestionText)}
                                placeholder="e.g., Will the protagonist find their way home?"
                                className="w-full bg-transparent border-none focus:ring-0 text-stone-800 placeholder:text-stone-300 font-medium p-0"
                            />
                        </div>
                        <div className="flex-1 p-4 bg-white/50 space-y-2">
                            <label className="text-xs font-bold text-emerald-700 uppercase tracking-wider flex items-center gap-2">
                                Theme
                                <span className="text-stone-400 font-normal lowercase" title="What is the underlying message? (e.g., Revenge costs everything)">?</span>
                            </label>
                            <input
                                type="text"
                                value={themeText}
                                onChange={handleDetailsChange(setThemeText)}
                                placeholder="e.g., The enduring power of friendship"
                                className="w-full bg-transparent border-none focus:ring-0 text-stone-800 placeholder:text-stone-300 font-medium p-0"
                            />
                        </div>
                    </div>

                    <div className="p-8 min-h-[500px]">
                        <TextareaAutosize
                            value={plotText}
                            onChange={handleChange}
                            placeholder="Once upon a time..."
                            className="w-full h-full resize-none border-none focus:ring-0 text-lg leading-relaxed font-serif text-stone-800 placeholder:text-stone-300 bg-transparent"
                            minRows={16}
                        />
                    </div>

                    <div className="absolute bottom-4 right-6 text-xs font-mono text-stone-400 pointer-events-none flex gap-3">
                        <span>{plotText.trim() ? plotText.trim().split(/\s+/).length : 0} words</span>
                        <span>{plotText.length} chars</span>
                    </div>
                </div>

                {critique && (
                    <div className="lg:col-span-1 glass-panel bg-amber-50/50 rounded-xl p-6 border-amber-100/50 overflow-y-auto max-h-[600px] shadow-lg animate-in slide-in-from-right-4 duration-500">
                        <div className="flex justify-between items-start mb-6 sticky top-0 bg-amber-50/90 backdrop-blur-sm -mx-6 -mt-6 p-6 border-b border-amber-100 z-10">
                            <h3 className="font-bold text-amber-900 flex items-center gap-2">
                                <FileSearch className="w-5 h-5" />
                                Critical Analysis
                            </h3>
                            <button onClick={() => setCritique(null)} className="text-amber-400 hover:text-amber-600 transition-colors p-1 hover:bg-amber-100 rounded-md">
                                <X className="w-4 h-4" />
                            </button>
                        </div>
                        <div className="prose prose-sm prose-amber whitespace-pre-wrap font-serif leading-relaxed">
                            {critique}
                        </div>
                    </div>
                )}
            </div>

            {/* Plot Expander Overlay */}
            {showExpander && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-8 bg-stone-900/40 backdrop-blur-sm animate-in fade-in duration-300">
                    <div className="w-full max-w-5xl h-full max-h-[800px] shadow-2xl">
                        <PlotExpander
                            currentPlot={plotText}
                            onApply={(newPlot) => {
                                setPlotText(newPlot);
                                setIsDirty(true);
                                setShowExpander(false);
                            }}
                            onCancel={() => setShowExpander(false)}
                        />
                    </div>
                </div>
            )}
        </div>
    );
};
