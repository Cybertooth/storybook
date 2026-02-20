import { useState, useEffect } from 'react';
import TextareaAutosize from 'react-textarea-autosize';
import { useStoryStore } from '@/store/useStoryStore';
import { aiService, PlotCritique } from '@/lib/ai';
import { Wand2, Loader2, FileSearch, Sparkles, Check, X, AlertTriangle, Lightbulb, Info } from 'lucide-react';
import clsx from 'clsx';
import { useAnalysis } from '@/hooks/useAnalysis';
import { PlotExpander } from './PlotExpander';
import { useDebounce } from '@/hooks/useDebounce';
import { DiffViewer } from '@/components/ui/DiffViewer';

export const PlotGerminator = () => {
    const { currentStory, characters, events, locations, createStory, isLoading: isStoreLoading, error: storeError, isSaving } = useStoryStore();
    const [plotText, setPlotText] = useState('');
    const [themeText, setThemeText] = useState('');
    const [coreQuestionText, setCoreQuestionText] = useState('');
    const [isDirty, setIsDirty] = useState(false);
    const [isAiLoading, setIsAiLoading] = useState(false);
    const [aiError, setAiError] = useState<string | null>(null);
    const [critiques, setCritiques] = useState<PlotCritique[] | null>(null);
    const [selectedCritiques, setSelectedCritiques] = useState<number[]>([]);
    const [revisionOptions, setRevisionOptions] = useState<string[] | null>(null);
    const [isGeneratingRevisions, setIsGeneratingRevisions] = useState(false);
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
        setCritiques(null);
        setSelectedCritiques([]);
        setRevisionOptions(null);

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

            const results = await aiService.generateCritiques(context);
            setCritiques(results);
        } catch (err) {
            setAiError((err as Error).message);
        } finally {
            setIsAiLoading(false);
        }
    }

    const toggleCritiqueSelection = (index: number) => {
        setSelectedCritiques(prev =>
            prev.includes(index) ? prev.filter(i => i !== index) : [...prev, index]
        );
    };

    const handleGenerateRevisions = async () => {
        if (!critiques || selectedCritiques.length === 0) return;
        setIsGeneratingRevisions(true);
        setAiError(null);

        try {
            const selected = selectedCritiques.map(i => critiques[i]);
            const options = await aiService.generateRevisionsFromCritiques(plotText, selected);
            setRevisionOptions(options);
        } catch (err) {
            setAiError((err as Error).message);
        } finally {
            setIsGeneratingRevisions(false);
        }
    };

    const handleApplyRevision = (revisionText: string) => {
        setPlotText(revisionText);
        setIsDirty(true);
        // Clear all panels
        setCritiques(null);
        setSelectedCritiques([]);
        setRevisionOptions(null);
    };

    const handleChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
        setPlotText(e.target.value);
        setIsDirty(true);
    };

    const handleDetailsChange = (setter: React.Dispatch<React.SetStateAction<string>>) => (e: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => {
        setter(e.target.value);
        setIsDirty(true);
    };

    const isLoading = isStoreLoading || isAiLoading || isAnalyzing || isGeneratingRevisions;
    const error = storeError || aiError;

    const getSeverityStyles = (severity: 'small' | 'medium' | 'major') => {
        switch (severity) {
            case 'major': return "bg-red-100 text-red-800 dark:bg-red-900/40 dark:text-red-300 border-red-200 dark:border-red-800/50";
            case 'medium': return "bg-amber-100 text-amber-800 dark:bg-amber-900/40 dark:text-amber-300 border-amber-200 dark:border-amber-800/50";
            case 'small': return "bg-blue-100 text-blue-800 dark:bg-blue-900/40 dark:text-blue-300 border-blue-200 dark:border-blue-800/50";
        }
    };

    const getSeverityIcon = (severity: 'small' | 'medium' | 'major') => {
        switch (severity) {
            case 'major': return <AlertTriangle className="w-3 h-3" />;
            case 'medium': return <Lightbulb className="w-3 h-3" />;
            case 'small': return <Info className="w-3 h-3" />;
        }
    };

    return (
        <div className="max-w-5xl mx-auto space-y-8 pb-12 relative animate-in fade-in duration-500">
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

            <div className="grid grid-cols-1 lg:grid-cols-5 gap-8 items-start">
                <div className={clsx("glass-panel rounded-xl flex flex-col relative transition-all duration-500", critiques ? "lg:col-span-3" : "lg:col-span-5")}>

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
                                className="w-full bg-transparent border-none focus:ring-0 text-stone-800 placeholder:text-stone-300 font-medium p-0 text-sm"
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
                                className="w-full bg-transparent border-none focus:ring-0 text-stone-800 placeholder:text-stone-300 font-medium p-0 text-sm"
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

                {/* Critique Selection Panel */}
                {critiques && (
                    <div className="lg:col-span-2 flex flex-col gap-6">
                        <div className="glass-panel rounded-xl flex flex-col shadow-lg animate-in slide-in-from-right-4 duration-500 max-h-[700px]">
                            <div className="flex justify-between items-start p-4 border-b border-stone-200/50 dark:border-stone-800/50 sticky top-0 bg-stone-50/90 dark:bg-stone-900/50 backdrop-blur-md z-10 rounded-t-xl">
                                <div>
                                    <h3 className="font-bold text-stone-800 dark:text-stone-200 flex items-center gap-2">
                                        <FileSearch className="w-4 h-4 text-amber-500" />
                                        Story Critiques
                                    </h3>
                                    <p className="text-xs text-stone-500 mt-1">Select the feedback you want to address.</p>
                                </div>
                                <button onClick={() => { setCritiques(null); setSelectedCritiques([]); setRevisionOptions(null); }} className="text-stone-400 hover:text-stone-600 transition-colors p-1 rounded-md">
                                    <X className="w-4 h-4" />
                                </button>
                            </div>

                            <div className="overflow-y-auto p-4 space-y-4">
                                {critiques.map((c, idx) => {
                                    const isSelected = selectedCritiques.includes(idx);
                                    const severityStyle = getSeverityStyles(c.severity);
                                    return (
                                        <div
                                            key={idx}
                                            onClick={() => toggleCritiqueSelection(idx)}
                                            className={clsx(
                                                "p-4 rounded-xl border-2 transition-all cursor-pointer",
                                                isSelected
                                                    ? "bg-white dark:bg-stone-800 border-indigo-400 shadow-md ring-2 ring-indigo-400/20"
                                                    : "bg-stone-50/50 dark:bg-stone-900/30 border-stone-200 dark:border-stone-800 hover:border-indigo-300 dark:hover:border-indigo-700 hover:bg-white"
                                            )}
                                        >
                                            <div className="flex gap-3">
                                                <div className="mt-1 flex-shrink-0">
                                                    <div className={clsx(
                                                        "w-5 h-5 rounded flex items-center justify-center border transition-colors",
                                                        isSelected ? "bg-indigo-500 border-indigo-500 text-white" : "border-stone-300 bg-white dark:bg-stone-800"
                                                    )}>
                                                        {isSelected && <Check className="w-3 h-3" />}
                                                    </div>
                                                </div>
                                                <div className="space-y-2">
                                                    <div className="flex items-start justify-between gap-2">
                                                        <h4 className="font-bold text-stone-800 dark:text-stone-200 text-sm leading-tight">{c.summary}</h4>
                                                        <span className={clsx("flex items-center gap-1 text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded border flex-shrink-0", severityStyle)}>
                                                            {getSeverityIcon(c.severity)}
                                                            {c.severity}
                                                        </span>
                                                    </div>
                                                    <p className="text-stone-600 dark:text-stone-400 text-xs leading-relaxed">{c.details}</p>
                                                </div>
                                            </div>
                                        </div>
                                    );
                                })}
                            </div>

                            <div className="p-4 border-t border-stone-200/50 dark:border-stone-800/50 bg-stone-50/90 dark:bg-stone-900/50 sticky bottom-0 rounded-b-xl z-10 backdrop-blur-md">
                                <button
                                    onClick={handleGenerateRevisions}
                                    disabled={selectedCritiques.length === 0 || isGeneratingRevisions}
                                    className="w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 disabled:bg-stone-300 disabled:text-stone-500 text-white text-xs font-bold rounded-lg transition-all flex items-center justify-center gap-2 shadow-lg shadow-indigo-500/20 disabled:shadow-none"
                                >
                                    {isGeneratingRevisions ? <Loader2 className="w-4 h-4 animate-spin" /> : <Wand2 className="w-4 h-4" />}
                                    Suggest Fixes ({selectedCritiques.length})
                                </button>
                            </div>
                        </div>

                    </div>
                )}
            </div>

            {/* Generated Revision Options Panel */}
            {revisionOptions && revisionOptions.length > 0 && (
                <div className="my-12 animate-in fade-in slide-in-from-bottom-8 duration-700 space-y-6">
                    <div className="flex items-center gap-3 px-2">
                        <div className="p-2 bg-indigo-100 rounded-lg text-indigo-600">
                            <Wand2 className="w-5 h-5" />
                        </div>
                        <div>
                            <h3 className="text-xl font-bold font-serif text-stone-800">Suggested Revisions</h3>
                            <p className="text-sm text-stone-500">Pick an option to apply the fixes to your plot.</p>
                        </div>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                        {revisionOptions.map((opt, idx) => (
                            <div key={idx} className="glass-panel flex flex-col rounded-xl overflow-hidden shadow-sm hover:shadow-lg transition-shadow border border-indigo-100 dark:border-indigo-900/50">
                                <div className="p-3 bg-indigo-50/50 dark:bg-indigo-900/20 border-b border-indigo-100 dark:border-indigo-900/50 flex justify-between items-center z-10 sticky top-0">
                                    <span className="font-bold text-indigo-900 dark:text-indigo-300 text-sm">Option {idx + 1}</span>
                                    <button
                                        onClick={() => handleApplyRevision(opt)}
                                        className="py-1 px-3 bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold rounded flex items-center gap-1 shadow-sm transition-colors"
                                    >
                                        <Check className="w-3 h-3" />
                                        Apply
                                    </button>
                                </div>
                                <div className="p-6 overflow-y-auto max-h-[600px] custom-scrollbar bg-white/40 dark:bg-stone-900/40">
                                    <DiffViewer oldText={plotText} newText={opt} />
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            )}


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
