import { useState } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { aiService } from '@/lib/ai';
import { Search, Loader2, AlertTriangle, GitBranch, Clock, Link2 } from 'lucide-react';
import clsx from 'clsx';

interface ConsistencyIssue {
    issue: string;
    details: string;
    type: 'plot_hole' | 'continuity' | 'abandoned_thread' | 'timeline';
}

const TYPE_CONFIG = {
    plot_hole: { label: 'Plot Hole', icon: AlertTriangle, color: 'text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-900/20 border-red-200 dark:border-red-800' },
    continuity: { label: 'Continuity', icon: Link2, color: 'text-amber-600 dark:text-amber-400 bg-amber-50 dark:bg-amber-900/20 border-amber-200 dark:border-amber-800' },
    abandoned_thread: { label: 'Abandoned Thread', icon: GitBranch, color: 'text-purple-600 dark:text-purple-400 bg-purple-50 dark:bg-purple-900/20 border-purple-200 dark:border-purple-800' },
    timeline: { label: 'Timeline Issue', icon: Clock, color: 'text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-900/20 border-blue-200 dark:border-blue-800' },
};

export const PlotHoleChecker = () => {
    const { currentStory, characters, events, locations } = useStoryStore();
    const [issues, setIssues] = useState<ConsistencyIssue[] | null>(null);
    const [isChecking, setIsChecking] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const handleCheck = async () => {
        if (!currentStory) return;
        setIsChecking(true);
        setError(null);
        setIssues(null);

        const context = `
STORY: ${currentStory.title}
PLOT SUMMARY: ${currentStory.summary}
THEME: ${currentStory.theme || 'Not set'}
CORE QUESTION: ${currentStory.coreQuestion || 'Not set'}

CHARACTERS:
${characters.map(c => `- ${c.name} (${c.role}): ${c.description}${c.arcLie ? ` | Lie: ${c.arcLie}` : ''}${c.arcTruth ? ` | Truth: ${c.arcTruth}` : ''}${c.arcGhost ? ` | Ghost: ${c.arcGhost}` : ''}`).join('\n')}

EVENTS (in order):
${events.sort((a, b) => a.order - b.order).map(e => `- [${e.order}] ${e.title} (Thread: ${e.plotThread || 'Main'})${e.characters.length > 0 ? ` Characters: ${e.characters.map(c => c.name).join(', ')}` : ''}: ${e.description}`).join('\n')}

LOCATIONS:
${locations.map(l => `- ${l.name}: ${l.description}`).join('\n')}`;

        try {
            const results = await aiService.checkConsistency(context);
            setIssues(results);
        } catch (err) {
            setError((err as Error).message);
        } finally {
            setIsChecking(false);
        }
    };

    return (
        <div className="glass-panel rounded-xl overflow-hidden">
            <div className="flex items-center justify-between p-4 border-b border-stone-200/50 dark:border-stone-700/50">
                <div className="flex items-center gap-3">
                    <div className="p-1.5 bg-red-100/50 dark:bg-red-900/30 rounded-lg text-red-600 dark:text-red-400">
                        <Search className="w-4 h-4" />
                    </div>
                    <div>
                        <h3 className="text-sm font-bold text-stone-700 dark:text-stone-300">Plot Hole & Consistency Checker</h3>
                        <p className="text-xs text-stone-400 dark:text-stone-500">AI-powered analysis for continuity errors</p>
                    </div>
                </div>
                <button
                    onClick={handleCheck}
                    disabled={isChecking || !currentStory}
                    className="flex items-center gap-2 px-4 py-2 bg-red-600 text-white text-xs font-bold rounded-lg hover:bg-red-700 disabled:opacity-40 transition-colors shadow-sm"
                >
                    {isChecking ? <Loader2 className="w-3 h-3 animate-spin" /> : <Search className="w-3 h-3" />}
                    {isChecking ? 'Analyzing...' : 'Run Check'}
                </button>
            </div>

            {error && (
                <div className="p-4 bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">{error}</div>
            )}

            {issues && (
                <div className="p-4 space-y-3">
                    {issues.length === 0 ? (
                        <div className="text-center py-8 text-emerald-600 dark:text-emerald-400">
                            <p className="font-bold text-lg">✨ All Clear!</p>
                            <p className="text-sm mt-1 text-stone-500 dark:text-stone-400">No major consistency issues detected.</p>
                        </div>
                    ) : (
                        <>
                            <p className="text-xs text-stone-400 dark:text-stone-500 font-medium">{issues.length} issue{issues.length !== 1 ? 's' : ''} found</p>
                            {issues.map((issue, i) => {
                                const config = TYPE_CONFIG[issue.type] || TYPE_CONFIG.plot_hole;
                                const Icon = config.icon;
                                return (
                                    <div key={i} className={clsx("p-4 rounded-xl border", config.color)}>
                                        <div className="flex items-start gap-3">
                                            <Icon className="w-4 h-4 mt-0.5 shrink-0" />
                                            <div className="space-y-1">
                                                <div className="flex items-center gap-2">
                                                    <h4 className="font-bold text-sm">{issue.issue}</h4>
                                                    <span className={clsx("text-[9px] font-bold uppercase tracking-wider px-1.5 py-0.5 rounded border", config.color)}>
                                                        {config.label}
                                                    </span>
                                                </div>
                                                <p className="text-xs opacity-80 leading-relaxed">{issue.details}</p>
                                            </div>
                                        </div>
                                    </div>
                                );
                            })}
                        </>
                    )}
                </div>
            )}
        </div>
    );
};
