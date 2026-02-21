import { useState } from 'react';
import { aiService } from '@/lib/ai';
import { Eye, Loader2, ArrowRight, Check } from 'lucide-react';
import clsx from 'clsx';

interface ShowDontTellResult {
    original: string;
    suggestion: string;
    explanation: string;
}

interface ShowDontTellProps {
    draftText: string;
    onApplySuggestion: (original: string, replacement: string) => void;
}

export const ShowDontTell = ({ draftText, onApplySuggestion }: ShowDontTellProps) => {
    const [results, setResults] = useState<ShowDontTellResult[] | null>(null);
    const [isAnalyzing, setIsAnalyzing] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const [appliedIndices, setAppliedIndices] = useState<Set<number>>(new Set());

    const handleAnalyze = async () => {
        if (!draftText.trim()) return;
        setIsAnalyzing(true);
        setError(null);
        setResults(null);
        setAppliedIndices(new Set());

        try {
            const items = await aiService.highlightShowDontTell(draftText);
            setResults(items);
        } catch (err) {
            setError((err as Error).message);
        } finally {
            setIsAnalyzing(false);
        }
    };

    const handleApply = (result: ShowDontTellResult, index: number) => {
        onApplySuggestion(result.original, result.suggestion);
        setAppliedIndices(prev => new Set(prev).add(index));
    };

    return (
        <div className="glass-panel rounded-xl overflow-hidden">
            <div className="flex items-center justify-between p-4 border-b border-stone-200/50 dark:border-stone-700/50">
                <div className="flex items-center gap-3">
                    <div className="p-1.5 bg-violet-100/50 dark:bg-violet-900/30 rounded-lg text-violet-600 dark:text-violet-400">
                        <Eye className="w-4 h-4" />
                    </div>
                    <div>
                        <h3 className="text-sm font-bold text-stone-700 dark:text-stone-300">"Show, Don't Tell" Highlighter</h3>
                        <p className="text-xs text-stone-400 dark:text-stone-500">AI-powered prose improvement suggestions</p>
                    </div>
                </div>
                <button
                    onClick={handleAnalyze}
                    disabled={isAnalyzing || !draftText.trim()}
                    className="flex items-center gap-2 px-4 py-2 bg-violet-600 text-white text-xs font-bold rounded-lg hover:bg-violet-700 disabled:opacity-40 transition-colors shadow-sm"
                >
                    {isAnalyzing ? <Loader2 className="w-3 h-3 animate-spin" /> : <Eye className="w-3 h-3" />}
                    {isAnalyzing ? 'Analyzing...' : 'Analyze Prose'}
                </button>
            </div>

            {error && (
                <div className="p-4 bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">{error}</div>
            )}

            {results && (
                <div className="p-4 space-y-4">
                    {results.length === 0 ? (
                        <div className="text-center py-8 text-emerald-600 dark:text-emerald-400">
                            <p className="font-bold text-lg">✨ Excellent Prose!</p>
                            <p className="text-sm mt-1 text-stone-500 dark:text-stone-400">No significant "telling" detected. Your writing is strong.</p>
                        </div>
                    ) : (
                        results.map((result, i) => {
                            const isApplied = appliedIndices.has(i);
                            return (
                                <div key={i} className={clsx(
                                    "rounded-xl border transition-all",
                                    isApplied
                                        ? "bg-emerald-50/50 dark:bg-emerald-900/10 border-emerald-200 dark:border-emerald-800 opacity-60"
                                        : "bg-white dark:bg-stone-800 border-stone-200 dark:border-stone-700"
                                )}>
                                    <div className="p-4 space-y-3">
                                        {/* Original */}
                                        <div>
                                            <span className="text-[10px] font-bold text-red-400 dark:text-red-500 uppercase tracking-wider">Telling</span>
                                            <p className="text-sm text-stone-700 dark:text-stone-300 mt-1 italic bg-red-50/50 dark:bg-red-900/10 px-3 py-2 rounded-lg border border-red-100 dark:border-red-900/30 line-through decoration-red-300 dark:decoration-red-700">
                                                "{result.original}"
                                            </p>
                                        </div>

                                        <div className="flex justify-center">
                                            <ArrowRight className="w-4 h-4 text-stone-300 dark:text-stone-600" />
                                        </div>

                                        {/* Suggestion */}
                                        <div>
                                            <span className="text-[10px] font-bold text-emerald-500 dark:text-emerald-400 uppercase tracking-wider">Showing</span>
                                            <p className="text-sm text-stone-700 dark:text-stone-300 mt-1 bg-emerald-50/50 dark:bg-emerald-900/10 px-3 py-2 rounded-lg border border-emerald-100 dark:border-emerald-900/30 font-medium">
                                                "{result.suggestion}"
                                            </p>
                                        </div>

                                        {/* Explanation */}
                                        <p className="text-xs text-stone-500 dark:text-stone-400 italic">{result.explanation}</p>

                                        {/* Apply button */}
                                        {!isApplied ? (
                                            <button
                                                onClick={() => handleApply(result, i)}
                                                className="flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium bg-indigo-50 dark:bg-indigo-900/30 text-indigo-600 dark:text-indigo-400 rounded-lg hover:bg-indigo-100 dark:hover:bg-indigo-900/50 transition-colors"
                                            >
                                                <Check className="w-3 h-3" />
                                                Apply this fix
                                            </button>
                                        ) : (
                                            <span className="flex items-center gap-1.5 text-xs font-medium text-emerald-500 dark:text-emerald-400">
                                                <Check className="w-3 h-3" />
                                                Applied
                                            </span>
                                        )}
                                    </div>
                                </div>
                            );
                        })
                    )}
                </div>
            )}
        </div>
    );
};
