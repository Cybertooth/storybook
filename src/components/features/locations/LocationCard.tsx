import { useState } from 'react';
import { Location } from '@/types';
import { MapPin, Edit2, Trash2, Check, X } from 'lucide-react';
import TextareaAutosize from 'react-textarea-autosize';

interface LocationCardProps {
    location: Location;
    onUpdate: (id: string, updates: Partial<Location>) => void;
    onDelete: (id: string) => void;
}

export const LocationCard = ({ location, onUpdate, onDelete }: LocationCardProps) => {
    const [isEditing, setIsEditing] = useState(false);
    const [name, setName] = useState(location.name);
    const [description, setDescription] = useState(location.description);
    const [sensory, setSensory] = useState(location.sensoryDetails || '');

    const handleSave = () => {
        onUpdate(location.id, { name, description, sensoryDetails: sensory });
        setIsEditing(false);
    };

    const handleDelete = () => {
        if (window.confirm(`Delete "${location.name}"? This cannot be undone.`)) {
            onDelete(location.id);
        }
    };

    if (isEditing) {
        return (
            <div className="bg-white p-4 rounded-xl border border-stone-200 shadow-sm space-y-3">
                <div className="flex gap-3 items-center">
                    <div className="w-10 h-10 bg-emerald-100 rounded-full flex items-center justify-center shrink-0">
                        <MapPin className="w-5 h-5 text-emerald-600" />
                    </div>
                    <input
                        type="text"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        className="flex-1 px-2 py-1 border border-stone-300 rounded-lg font-medium"
                        placeholder="Location Name"
                    />
                </div>

                <TextareaAutosize
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    placeholder="Description..."
                    className="w-full px-2 py-1 border border-stone-300 rounded-lg text-sm min-h-[60px]"
                />
                <TextareaAutosize
                    value={sensory}
                    onChange={(e) => setSensory(e.target.value)}
                    placeholder="Sensory details (smells, sounds)..."
                    className="w-full px-2 py-1 border border-stone-300 rounded-lg text-sm min-h-[40px] italic"
                />

                <div className="flex justify-end gap-2 pt-2">
                    <button onClick={() => setIsEditing(false)} className="p-1.5 hover:bg-stone-100 rounded-lg transition-colors">
                        <X className="w-4 h-4 text-stone-500" />
                    </button>
                    <button onClick={handleSave} className="p-1.5 hover:bg-emerald-50 rounded-lg text-emerald-600 transition-colors">
                        <Check className="w-4 h-4" />
                    </button>
                    <button onClick={handleDelete} className="p-1.5 hover:bg-red-50 rounded-lg text-red-500 ml-auto transition-colors">
                        <Trash2 className="w-4 h-4" />
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div className="glass-panel p-4 rounded-xl hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group relative overflow-hidden">
            <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-emerald-200 to-teal-100 opacity-50"></div>
            <div className="flex gap-4">
                <div className="w-10 h-10 bg-emerald-100 rounded-full flex items-center justify-center shrink-0 text-emerald-600">
                    <MapPin className="w-5 h-5" />
                </div>
                <div className="flex-1 min-w-0">
                    <div className="flex justify-between items-start">
                        <h3 className="font-bold text-stone-900 truncate">{location.name}</h3>
                        <button
                            onClick={() => setIsEditing(true)}
                            className="opacity-0 group-hover:opacity-100 p-1 hover:bg-stone-100 rounded text-stone-400 transition-opacity"
                        >
                            <Edit2 className="w-3 h-3" />
                        </button>
                    </div>
                    <p className="text-sm text-stone-600 line-clamp-2 mt-1">
                        {location.description || "No description yet."}
                    </p>
                    {location.sensoryDetails && (
                        <p className="text-xs text-stone-500 italic mt-2 line-clamp-1 border-t border-white/20 pt-2">
                            "{location.sensoryDetails}"
                        </p>
                    )}
                </div>
            </div>
        </div>
    );
};
