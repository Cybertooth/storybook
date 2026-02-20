import { useState } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { CharacterCard } from './CharacterCard';
import { Plus } from 'lucide-react';

export const CharacterList = () => {
    const { characters, createCharacter, updateCharacter, deleteCharacter } = useStoryStore();
    const [isCreating, setIsCreating] = useState(false);
    const [newName, setNewName] = useState('');

    const handleCreate = async (e: React.FormEvent) => {
        e.preventDefault();
        if (newName.trim()) {
            await createCharacter(newName, 'supporting');
            setNewName('');
            setIsCreating(false);
        }
    };



    return (
        <div className="space-y-8">
            <div className="flex justify-between items-center">
                <h2 className="text-2xl font-serif font-bold text-stone-800">Cast of Characters</h2>
                <button
                    onClick={() => setIsCreating(true)}
                    className="flex items-center gap-2 px-3 py-1.5 bg-stone-900 text-white rounded-md hover:bg-stone-700 transition-colors text-sm"
                >
                    <Plus className="w-4 h-4" />
                    Add Character
                </button>
            </div>

            {isCreating && (
                <form onSubmit={handleCreate} className="bg-stone-50 p-4 rounded-lg border border-stone-200 flex gap-2">
                    <input
                        autoFocus
                        type="text"
                        value={newName}
                        onChange={(e) => setNewName(e.target.value)}
                        placeholder="Character Name..."
                        className="flex-1 px-3 py-2 border border-stone-300 rounded-md"
                    />
                    <button type="submit" className="px-4 py-2 bg-stone-800 text-white rounded-md">Add</button>
                    <button type="button" onClick={() => setIsCreating(false)} className="px-4 py-2 text-stone-500">Cancel</button>
                </form>
            )}

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {/* We could render by groups, but for now just flat list if asked, or groups if better. 
                    Let's render flat list sorted by role priority? 
                    Actually, let's just dump them all for now to keep it simple as grid. 
                */}
                {characters.map(char => (
                    <CharacterCard
                        key={char.id}
                        character={char}
                        onUpdate={updateCharacter}
                        onDelete={deleteCharacter}
                    />
                ))}
            </div>

            {characters.length === 0 && !isCreating && (
                <div className="text-center py-16 text-stone-400 bg-stone-50/50 rounded-xl border-2 border-dashed border-stone-200">
                    <div className="w-12 h-12 bg-stone-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <Plus className="w-6 h-6 text-stone-300" />
                    </div>
                    <p className="font-medium text-stone-500">No characters yet</p>
                    <p className="text-sm mt-1">Every great story needs a great cast. Add your first character above.</p>
                </div>
            )}
        </div>
    );
};
