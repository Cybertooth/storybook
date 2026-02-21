import { useState } from 'react';
import { Users, GitGraph } from 'lucide-react';
import { CharacterList } from '../features/characters/CharacterList';
import { RelationshipGraph } from '../features/characters/RelationshipGraph';
import clsx from 'clsx';

export const CharactersPage = () => {
    const [viewMode, setViewMode] = useState<'cards' | 'relationships'>('cards');

    return (
        <div className="max-w-6xl mx-auto space-y-8">
            <div className="flex items-center justify-between mb-2">
                <div className="flex items-center gap-3">
                    <div className="p-2 bg-amber-100/50 dark:bg-amber-900/30 rounded-lg text-amber-700 dark:text-amber-400">
                        <Users className="w-5 h-5" />
                    </div>
                    <div>
                        <h2 className="text-2xl font-serif font-bold text-stone-900 dark:text-stone-100 tracking-tight">Characters</h2>
                        <p className="text-stone-500 dark:text-stone-400 text-xs font-medium uppercase tracking-wide">Build your cast</p>
                    </div>
                </div>

                <div className="flex bg-stone-100 dark:bg-stone-800 p-1 rounded-lg">
                    <button
                        onClick={() => setViewMode('cards')}
                        className={clsx(
                            "px-4 py-2 rounded-md text-sm font-medium transition-all flex items-center gap-2",
                            viewMode === 'cards' ? "bg-white dark:bg-stone-700 text-stone-900 dark:text-stone-100 shadow-sm" : "text-stone-500 dark:text-stone-400 hover:text-stone-700 dark:hover:text-stone-200"
                        )}
                    >
                        <Users className="w-4 h-4" />
                        Cards
                    </button>
                    <button
                        onClick={() => setViewMode('relationships')}
                        className={clsx(
                            "px-4 py-2 rounded-md text-sm font-medium transition-all flex items-center gap-2",
                            viewMode === 'relationships' ? "bg-white dark:bg-stone-700 text-stone-900 dark:text-stone-100 shadow-sm" : "text-stone-500 dark:text-stone-400 hover:text-stone-700 dark:hover:text-stone-200"
                        )}
                    >
                        <GitGraph className="w-4 h-4" />
                        Relationships
                    </button>
                </div>
            </div>

            {viewMode === 'cards' ? <CharacterList /> : <RelationshipGraph />}
        </div>
    );
};
