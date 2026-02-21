import { useState } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { aiService } from '@/lib/ai';
import { Loader2, AlertTriangle, Lightbulb, Shield, ShieldAlert, ShieldCheck } from 'lucide-react';
import clsx from 'clsx';

interface TropeResult {
    trope: string;
    usage: string;
    risk: 'low' | 'medium' | 'high';
    suggestion: string;
}

export const TropesAnalyzer = () => {
    const { currentStory, characters, events, locations } = useStoryStore();
    const [isAnalyzing, setIsAnalyzing] = useState(false);
    const [results, setResults] = useState<TropeResult[] | null>(null);
    const [error, setError] = useState<string | null>(null);

    const handleAnalyze = async () => {
        if (!currentStory) return;
        setIsAnalyzing(true);
        setError(null);

        const context = `
STORY TITLE: ${currentStory.title}

PLOT SUMMARY:
${currentStory.summary}
${currentStory.theme ? `\nTHEME: ${currentStory.theme}` : ''}
${currentStory.coreQuestion ? `\nCORE QUESTION: ${currentStory.coreQuestion}` : ''}

CHARACTERS:
${characters.map(c => `- ${c.name} (${c.role}): ${c.description}${c.arcLie ? ` | Lie: ${c.arcLie}` : ''}${c.arcTruth ? ` | Truth: ${c.arcTruth}` : ''}${c.arcGhost ? ` | Ghost: ${c.arcGhost}` : ''}`).join('\n')}

TIMELINE/EVENTS:
${events.sort((a, b) => a.order - b.order).map(e => `- ${e.title}: ${e.description} [Thread: ${e.plotThread || 'Main'}]`).join('\n')}

LOCATIONS:
${locations.map(l => `- ${l.name}: ${l.description}`).join('\n')}
`;

        try {
            const tropes = await aiService.analyzeTropes(context);
            setResults(tropes);
        } catch (err) {
            setError((err as Error).message);
        } finally {
            setIsAnalyzing(false);
        }
    };

    const riskConfig = {
        low: { icon: ShieldCheck, color: 'text-emerald-600 dark:text-emerald-400', bg: 'bg-emerald-50 dark:bg-emerald-900/20', border: 'border-emerald-200 dark:border-emerald-800', label: 'Low Risk' },
        medium: { icon: Shield, color: 'text-amber-600 dark:text-amber-400', bg: 'bg-amber-50 dark:bg-amber-900/20', border: 'border-amber-200 dark:border-amber-800', label: 'Medium Risk' },
        high: { icon: ShieldAlert, color: 'text-red-600 dark:text-red-400', bg: 'bg-red-50 dark:bg-red-900/20', border: 'border-red-200 dark:border-red-800', label: 'High Risk' },
    };

    return (
        <div className="space-y-4">
            <div className="flex items-center justify-between">
                <p className="text-sm text-stone-500 dark:text-stone-400">
                    Identify narrative tropes and clichés in your story.
                </p>
                <button
                    onClick={handleAnalyze}
                    disabled={isAnalyzing || !currentStory?.summary}
                    className="flex items-center gap-2 px-4 py-2 bg-violet-600 text-white text-sm font-bold rounded-lg hover:bg-violet-700 disabled:opacity-50 transition-colors shadow-sm"
                >
                    {isAnalyzing ? (
                        <>
                            <Loader2 className="w-4 h-4 animate-spin" />
                            Analyzing...
                        </>
                    ) : (
                        <>
                            <AlertTriangle className="w-4 h-4" />
                            Scan for Tropes
                        </>
                    )}
                </button>
            </div>

            {error && (
                <div className="p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg text-sm text-red-700 dark:text-red-300">
                    {error}
                </div>
            )}

            {results && results.length === 0 && (
                <div className="text-center py-6 text-stone-400 dark:text-stone-500">
                    <ShieldCheck className="w-8 h-8 mx-auto mb-2" />
                    <p className="text-sm">No obvious tropes or clichés detected. Your story feels original!</p>
                </div>
            )}

            {results && results.length > 0 && (
                <div className="space-y-3 animate-in fade-in slide-in-from-bottom-2 duration-300">
                    {results.map((trope, i) => {
                        const config = riskConfig[trope.risk];
                        const RiskIcon = config.icon;
                        return (
                            <div key={i} className={clsx("p-4 rounded-xl border", config.bg, config.border)}>
                                <div className="flex items-start gap-3">
                                    <RiskIcon className={clsx("w-5 h-5 shrink-0 mt-0.5", config.color)} />
                                    <div className="flex-1 min-w-0 space-y-2">
                                        <div className="flex items-center gap-2 flex-wrap">
                                            <h4 className="font-bold text-stone-800 dark:text-stone-200 text-sm">{trope.trope}</h4>
                                            <span className={clsx("text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full", config.color, config.bg, "border", config.border)}>
                                                {config.label}
                                            </span>
                                        </div>
                                        <p className="text-xs text-stone-600 dark:text-stone-400 leading-relaxed">{trope.usage}</p>
                                        <div className="flex items-start gap-2 pt-2 border-t border-stone-200/50 dark:border-stone-700/50">
                                            <Lightbulb className="w-3.5 h-3.5 shrink-0 mt-0.5 text-indigo-500 dark:text-indigo-400" />
                                            <p className="text-xs text-indigo-800 dark:text-indigo-300 font-medium leading-relaxed">{trope.suggestion}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        );
                    })}
                </div>
            )}
        </div>
    );
};
