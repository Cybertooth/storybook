import { Users } from 'lucide-react';
import { CharacterList } from '../features/characters/CharacterList';

export const CharactersPage = () => (
    <div className="max-w-6xl mx-auto space-y-8">
        <div className="flex items-center gap-3 mb-2">
            <div className="p-2 bg-amber-100/50 rounded-lg text-amber-700">
                <Users className="w-5 h-5" />
            </div>
            <div>
                <h2 className="text-2xl font-serif font-bold text-stone-900 tracking-tight">Characters</h2>
                <p className="text-stone-500 text-xs font-medium uppercase tracking-wide">Build your cast</p>
            </div>
        </div>
        <CharacterList />
    </div>
);
