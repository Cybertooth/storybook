import { useState } from 'react';
import { EventBoard } from '../features/timeline/EventBoard';
import { TimelineGraph } from '../features/timeline/TimelineGraph';
import { LayoutTemplate, Network } from 'lucide-react';
import clsx from 'clsx';

export const TimelinePage = () => {
    const [viewMode, setViewMode] = useState<'board' | 'graph'>('board');

    return (
        <div className="h-full flex flex-col p-8">
            <div className="flex justify-between items-center mb-6">
                <div>
                    <h2 className="text-3xl font-serif font-bold text-stone-900 flex items-center gap-3">
                        {viewMode === 'board' ? <LayoutTemplate className="w-8 h-8 text-indigo-600" /> : <Network className="w-8 h-8 text-indigo-600" />}
                        Timeline
                    </h2>
                    <p className="text-stone-500 mt-1">Plan your story sequence.</p>
                </div>

                <div className="flex bg-stone-100 p-1 rounded-lg">
                    <button
                        onClick={() => setViewMode('board')}
                        className={clsx(
                            "px-4 py-2 rounded-md text-sm font-medium transition-all flex items-center gap-2",
                            viewMode === 'board' ? "bg-white text-stone-900 shadow-sm" : "text-stone-500 hover:text-stone-700"
                        )}
                    >
                        <LayoutTemplate className="w-4 h-4" />
                        Board
                    </button>
                    <button
                        onClick={() => setViewMode('graph')}
                        className={clsx(
                            "px-4 py-2 rounded-md text-sm font-medium transition-all flex items-center gap-2",
                            viewMode === 'graph' ? "bg-white text-stone-900 shadow-sm" : "text-stone-500 hover:text-stone-700"
                        )}
                    >
                        <Network className="w-4 h-4" />
                        Graph
                    </button>
                </div>
            </div>

            <div className="flex-1 overflow-hidden bg-white/50 backdrop-blur-sm rounded-2xl border border-white/20 shadow-xl">
                {viewMode === 'board' ? <EventBoard /> : <TimelineGraph />}
            </div>
        </div>
    );
};
