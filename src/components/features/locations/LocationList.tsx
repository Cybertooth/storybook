import { useState } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { LocationCard } from './LocationCard';
import { Plus } from 'lucide-react';

export const LocationList = () => {
    const { locations, createLocation, updateLocation, deleteLocation } = useStoryStore();
    const [isCreating, setIsCreating] = useState(false);
    const [newName, setNewName] = useState('');

    const handleCreate = async (e: React.FormEvent) => {
        e.preventDefault();
        if (newName.trim()) {
            await createLocation(newName);
            setNewName('');
            setIsCreating(false);
        }
    };

    return (
        <div className="space-y-8">
            <div className="flex justify-between items-center">
                <h2 className="text-2xl font-serif font-bold text-stone-800">World & Locations</h2>
                <button
                    onClick={() => setIsCreating(true)}
                    className="flex items-center gap-2 px-3 py-1.5 bg-stone-900 text-white rounded-md hover:bg-stone-700 transition-colors text-sm"
                >
                    <Plus className="w-4 h-4" />
                    Add Location
                </button>
            </div>

            {isCreating && (
                <form onSubmit={handleCreate} className="bg-stone-50 p-4 rounded-lg border border-stone-200 flex gap-2">
                    <input
                        autoFocus
                        type="text"
                        value={newName}
                        onChange={(e) => setNewName(e.target.value)}
                        placeholder="Location Name..."
                        className="flex-1 px-3 py-2 border border-stone-300 rounded-md"
                    />
                    <button type="submit" className="px-4 py-2 bg-stone-800 text-white rounded-md">Add</button>
                    <button type="button" onClick={() => setIsCreating(false)} className="px-4 py-2 text-stone-500">Cancel</button>
                </form>
            )}

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {locations.map(loc => (
                    <LocationCard
                        key={loc.id}
                        location={loc}
                        onUpdate={updateLocation}
                        onDelete={deleteLocation}
                    />
                ))}
            </div>

            {locations.length === 0 && !isCreating && (
                <div className="text-center py-16 text-stone-400 bg-stone-50/50 rounded-xl border-2 border-dashed border-stone-200">
                    <div className="w-12 h-12 bg-emerald-50 rounded-full flex items-center justify-center mx-auto mb-4">
                        <Plus className="w-6 h-6 text-emerald-300" />
                    </div>
                    <p className="font-medium text-stone-500">No locations mapped yet</p>
                    <p className="text-sm mt-1">Build out your story's world — taverns, castles, galaxies and beyond.</p>
                </div>
            )}
        </div>
    );
};
