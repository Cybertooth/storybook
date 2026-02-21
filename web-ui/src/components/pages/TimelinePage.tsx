import { useState } from 'react';
import { EventBoard } from '../features/timeline/EventBoard';
import { TimelineGraph } from '../features/timeline/TimelineGraph';
import { PacingGraph } from '../features/timeline/PacingGraph';
import { LayoutTemplate, Network, Activity, Filter } from 'lucide-react';
import { useStoryStore } from '@/store/useStoryStore';
import clsx from 'clsx';

export const TimelinePage = () => {
    const [viewMode, setViewMode] = useState<'board' | 'graph' | 'pacing'>('board');
    const { characters } = useStoryStore();
    const [filterCharacterId, setFilterCharacterId] = useState<string | null>(null);

    const filterChar = characters.find(c => c.id === filterCharacterId);

    return (
        <div className="h-full flex flex-col p-8">
            <div className="flex justify-between items-center mb-6">
                <div>
                    <h2 className="text-3xl font-serif font-bold text-stone-900 dark:text-stone-100 flex items-center gap-3">
                        {viewMode === 'board' ? <LayoutTemplate className="w-8 h-8 text-indigo-600 dark:text-indigo-400" /> :
                            viewMode === 'graph' ? <Network className="w-8 h-8 text-indigo-600 dark:text-indigo-400" /> :
                                <Activity className="w-8 h-8 text-indigo-600 dark:text-indigo-400" />}
                        Timeline
                    </h2>
                    <p className="text-stone-500 dark:text-stone-400 mt-1">
                        {viewMode === 'pacing' ? 'Visualize your story\'s emotional arc.' : 'Plan your story sequence.'}
                    </p>
                </div>

                <div className="flex items-center gap-3">
                    {/* Character Filter */}
                    <div className="flex items-center gap-2 bg-white dark:bg-stone-800 border border-stone-200 dark:border-stone-700 rounded-lg px-3 py-1.5 shadow-sm">
                        <Filter className={clsx("w-3.5 h-3.5", filterCharacterId ? "text-indigo-500" : "text-stone-400")} />
                        <select
                            value={filterCharacterId || ''}
                            onChange={e => setFilterCharacterId(e.target.value || null)}
                            className="text-sm border-none bg-transparent focus:ring-0 py-0 pl-0 pr-6 text-stone-700 dark:text-stone-300 cursor-pointer"
                        >
                            <option value="">All Characters</option>
                            {characters.map(c => (
                                <option key={c.id} value={c.id}>{c.name} ({c.role})</option>
                            ))}
                        </select>
                    </div>

                    {filterCharacterId && (
                        <button
                            onClick={() => setFilterCharacterId(null)}
                            className="text-xs text-indigo-600 dark:text-indigo-400 hover:underline font-medium"
                        >
                            Clear
                        </button>
                    )}

                    {/* View Toggle */}
                    <div className="flex bg-stone-100 dark:bg-stone-800 p-1 rounded-lg">
                        <button
                            onClick={() => setViewMode('board')}
                            className={clsx(
                                "px-4 py-2 rounded-md text-sm font-medium transition-all flex items-center gap-2",
                                viewMode === 'board' ? "bg-white dark:bg-stone-700 text-stone-900 dark:text-stone-100 shadow-sm" : "text-stone-500 dark:text-stone-400 hover:text-stone-700 dark:hover:text-stone-200"
                            )}
                        >
                            <LayoutTemplate className="w-4 h-4" />
                            Board
                        </button>
                        <button
                            onClick={() => setViewMode('graph')}
                            className={clsx(
                                "px-4 py-2 rounded-md text-sm font-medium transition-all flex items-center gap-2",
                                viewMode === 'graph' ? "bg-white dark:bg-stone-700 text-stone-900 dark:text-stone-100 shadow-sm" : "text-stone-500 dark:text-stone-400 hover:text-stone-700 dark:hover:text-stone-200"
                            )}
                        >
                            <Network className="w-4 h-4" />
                            Graph
                        </button>
                        <button
                            onClick={() => setViewMode('pacing')}
                            className={clsx(
                                "px-4 py-2 rounded-md text-sm font-medium transition-all flex items-center gap-2",
                                viewMode === 'pacing' ? "bg-white dark:bg-stone-700 text-stone-900 dark:text-stone-100 shadow-sm" : "text-stone-500 dark:text-stone-400 hover:text-stone-700 dark:hover:text-stone-200"
                            )}
                        >
                            <Activity className="w-4 h-4" />
                            Pacing
                        </button>
                    </div>
                </div>
            </div>

            {/* Filter indicator */}
            {filterChar && (
                <div className="mb-4 flex items-center gap-2 text-sm bg-indigo-50 dark:bg-indigo-900/20 text-indigo-700 dark:text-indigo-300 px-4 py-2 rounded-lg border border-indigo-200 dark:border-indigo-800 animate-in fade-in duration-200">
                    <Filter className="w-3.5 h-3.5" />
                    Showing events involving <span className="font-bold">{filterChar.name}</span>
                    <button onClick={() => setFilterCharacterId(null)} className="ml-auto text-xs hover:underline">Clear filter</button>
                </div>
            )}

            <div className={clsx(
                "flex-1 overflow-hidden rounded-2xl border shadow-xl dark:shadow-black/30",
                viewMode === 'pacing'
                    ? "overflow-y-auto p-6 bg-white/50 dark:bg-stone-800/50 backdrop-blur-sm border-white/20 dark:border-stone-700/30"
                    : "bg-white/50 dark:bg-stone-800/50 backdrop-blur-sm border-white/20 dark:border-stone-700/30"
            )}>
                {viewMode === 'board' ? <EventBoard filterCharacterId={filterCharacterId} /> :
                    viewMode === 'graph' ? <TimelineGraph filterCharacterId={filterCharacterId} /> :
                        <PacingGraph filterCharacterId={filterCharacterId} />}
            </div>
        </div>
    );
};
