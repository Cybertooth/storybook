import { useState } from 'react';
import { Character } from '@/types';
import { User, Edit2, Trash2, Check, X } from 'lucide-react';
import clsx from 'clsx';
import TextareaAutosize from 'react-textarea-autosize';

interface CharacterCardProps {
    character: Character;
    onUpdate: (id: string, updates: Partial<Character>) => void;
    onDelete: (id: string) => void;
}

export const CharacterCard = ({ character, onUpdate, onDelete }: CharacterCardProps) => {
    const [isEditing, setIsEditing] = useState(false);
    const [name, setName] = useState(character.name);
    const [role, setRole] = useState(character.role);
    const [description, setDescription] = useState(character.description);

    const handleSave = () => {
        onUpdate(character.id, { name, role, description });
        setIsEditing(false);
    };

    const handleCancel = () => {
        setName(character.name);
        setRole(character.role);
        setDescription(character.description);
        setIsEditing(false);
    };

    if (isEditing) {
        return (
            <div className="bg-white p-4 rounded-lg border border-stone-200 shadow-sm space-y-3">
                <div className="flex gap-3">
                    <div className="w-12 h-12 bg-stone-100 rounded-full flex items-center justify-center shrink-0">
                        <User className="w-6 h-6 text-stone-400" />
                    </div>
                    <div className="flex-1 space-y-2">
                        <input
                            type="text"
                            value={name}
                            onChange={(e) => setName(e.target.value)}
                            className="w-full px-2 py-1 border border-stone-300 rounded font-medium"
                            placeholder="Character Name"
                        />
                        <select
                            value={role}
                            onChange={(e) => setRole(e.target.value as any)}
                            className="w-full px-2 py-1 border border-stone-300 rounded text-sm text-stone-600"
                        >
                            <option value="protagonist">Protagonist</option>
                            <option value="antagonist">Antagonist</option>
                            <option value="supporting">Supporting</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                </div>

                <TextareaAutosize
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    placeholder="Brief description..."
                    className="w-full px-2 py-1 border border-stone-300 rounded text-sm min-h-[60px]"
                />

                <div className="flex justify-end gap-2 pt-2">
                    <button onClick={handleCancel} className="p-1 hover:bg-stone-100 rounded">
                        <X className="w-4 h-4 text-stone-500" />
                    </button>
                    <button onClick={handleSave} className="p-1 hover:bg-stone-100 rounded text-green-600">
                        <Check className="w-4 h-4" />
                    </button>
                    <button onClick={() => { if (window.confirm(`Delete "${character.name}"? This cannot be undone.`)) onDelete(character.id); }} className="p-1 hover:bg-red-50 rounded text-red-500 ml-auto">
                        <Trash2 className="w-4 h-4" />
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div className="glass-panel p-4 rounded-xl hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group relative overflow-hidden">
            <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-stone-200 to-stone-100 opacity-50"></div>
            <div className="flex gap-4">
                <div className={clsx(
                    "w-12 h-12 rounded-full flex items-center justify-center shrink-0",
                    character.role === 'protagonist' ? "bg-amber-100 text-amber-600" :
                        character.role === 'antagonist' ? "bg-red-100 text-red-600" :
                            "bg-stone-100 text-stone-400"
                )}>
                    <User className="w-6 h-6" />
                </div>
                <div className="flex-1 min-w-0">
                    <div className="flex justify-between items-start">
                        <h3 className="font-bold text-stone-900 truncate">{character.name}</h3>
                        <button
                            onClick={() => setIsEditing(true)}
                            className="opacity-0 group-hover:opacity-100 p-1 hover:bg-stone-100 rounded text-stone-400 transition-opacity"
                        >
                            <Edit2 className="w-3 h-3" />
                        </button>
                    </div>
                    <span className="inline-block px-2 py-0.5 rounded-full bg-stone-100 text-stone-500 text-xs font-medium capitalize mb-2">
                        {character.role}
                    </span>
                    <p className="text-sm text-stone-600 line-clamp-3">
                        {character.description || "No description yet."}
                    </p>
                </div>
            </div>
        </div>
    );
};
