import { useState } from 'react';
import { Character } from '@/types';
import { User, Edit2, Trash2, Check, X, Camera, Loader2, RefreshCw } from 'lucide-react';
import clsx from 'clsx';
import TextareaAutosize from 'react-textarea-autosize';
import { aiService } from '@/lib/ai';

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
    const [arcLie, setArcLie] = useState(character.arcLie || '');
    const [arcTruth, setArcTruth] = useState(character.arcTruth || '');
    const [arcGhost, setArcGhost] = useState(character.arcGhost || '');

    // Portrait generation state
    const [isGenerating, setIsGenerating] = useState(false);
    const [previewUrl, setPreviewUrl] = useState<string | null>(null);
    const [portraitError, setPortraitError] = useState<string | null>(null);

    const handleSave = () => {
        onUpdate(character.id, { name, role, description, arcLie, arcTruth, arcGhost });
        setIsEditing(false);
    };

    const handleCancel = () => {
        setName(character.name);
        setRole(character.role);
        setDescription(character.description);
        setArcLie(character.arcLie || '');
        setArcTruth(character.arcTruth || '');
        setArcGhost(character.arcGhost || '');
        setIsEditing(false);
    };

    const handleGeneratePortrait = async () => {
        setIsGenerating(true);
        setPortraitError(null);
        try {
            const desc = `Name: ${character.name}\nRole: ${character.role}\nDescription: ${character.description}${character.arcGhost ? `\nBackstory: ${character.arcGhost}` : ''}${character.traits.length > 0 ? `\nTraits: ${character.traits.join(', ')}` : ''}`;
            const url = await aiService.generateCharacterPortrait(desc);
            setPreviewUrl(url);
        } catch (err) {
            setPortraitError((err as Error).message);
        } finally {
            setIsGenerating(false);
        }
    };

    const handleUsePortrait = () => {
        if (previewUrl) {
            onUpdate(character.id, { avatarUrl: previewUrl });
            setPreviewUrl(null);
        }
    };

    const handleRemovePortrait = () => {
        onUpdate(character.id, { avatarUrl: undefined });
    };

    // Avatar component
    const Avatar = ({ size = 'md' }: { size?: 'sm' | 'md' }) => {
        const sizeClass = size === 'md' ? 'w-12 h-12' : 'w-10 h-10';
        const iconSize = size === 'md' ? 'w-6 h-6' : 'w-5 h-5';

        if (character.avatarUrl) {
            return (
                <img
                    src={character.avatarUrl}
                    alt={character.name}
                    className={clsx(sizeClass, "rounded-full object-cover shrink-0 ring-2 ring-white dark:ring-stone-700 shadow-md")}
                />
            );
        }

        return (
            <div className={clsx(
                sizeClass, "rounded-full flex items-center justify-center shrink-0",
                character.role === 'protagonist' ? "bg-amber-100 dark:bg-amber-900/40 text-amber-600 dark:text-amber-400" :
                    character.role === 'antagonist' ? "bg-red-100 dark:bg-red-900/40 text-red-600 dark:text-red-400" :
                        "bg-stone-100 dark:bg-stone-700 text-stone-400 dark:text-stone-500"
            )}>
                <User className={iconSize} />
            </div>
        );
    };

    if (isEditing) {
        return (
            <div className="bg-white dark:bg-stone-800 p-4 rounded-lg border border-stone-200 dark:border-stone-700 shadow-sm space-y-3">
                <div className="flex gap-3">
                    <div className="w-12 h-12 bg-stone-100 dark:bg-stone-700 rounded-full flex items-center justify-center shrink-0">
                        <User className="w-6 h-6 text-stone-400 dark:text-stone-500" />
                    </div>
                    <div className="flex-1 space-y-2">
                        <input
                            type="text"
                            value={name}
                            onChange={(e) => setName(e.target.value)}
                            className="w-full px-2 py-1 border border-stone-300 dark:border-stone-600 dark:bg-stone-900 dark:text-stone-100 rounded font-medium"
                            placeholder="Character Name"
                        />
                        <select
                            value={role}
                            onChange={(e) => setRole(e.target.value as any)}
                            className="w-full px-2 py-1 border border-stone-300 dark:border-stone-600 dark:bg-stone-900 rounded text-sm text-stone-600 dark:text-stone-300"
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
                    className="w-full px-2 py-1 border border-stone-300 dark:border-stone-600 dark:bg-stone-900 dark:text-stone-100 rounded text-sm min-h-[60px]"
                />

                <div className="space-y-2 pt-2 border-t border-stone-100 dark:border-stone-700">
                    <p className="text-xs font-bold text-stone-400 dark:text-stone-500 uppercase tracking-wider">Internal Arc</p>
                    <div className="grid grid-cols-1 gap-2">
                        <input
                            type="text"
                            value={arcLie}
                            onChange={(e) => setArcLie(e.target.value)}
                            placeholder="The Lie they believe..."
                            className="w-full px-2 py-1 border border-stone-200 dark:border-stone-600 rounded text-xs text-stone-700 dark:text-stone-300 bg-red-50/30 dark:bg-red-900/20 focus:bg-white dark:focus:bg-stone-800 focus:border-red-300 dark:focus:border-red-700"
                        />
                        <input
                            type="text"
                            value={arcTruth}
                            onChange={(e) => setArcTruth(e.target.value)}
                            placeholder="The Truth they discover..."
                            className="w-full px-2 py-1 border border-stone-200 dark:border-stone-600 rounded text-xs text-stone-700 dark:text-stone-300 bg-emerald-50/30 dark:bg-emerald-900/20 focus:bg-white dark:focus:bg-stone-800 focus:border-emerald-300 dark:focus:border-emerald-700"
                        />
                        <input
                            type="text"
                            value={arcGhost}
                            onChange={(e) => setArcGhost(e.target.value)}
                            placeholder="The Ghost (Backstory wound)..."
                            className="w-full px-2 py-1 border border-stone-200 dark:border-stone-600 rounded text-xs text-stone-700 dark:text-stone-300 bg-stone-50 dark:bg-stone-900/50 focus:bg-white dark:focus:bg-stone-800 focus:border-stone-300 dark:focus:border-stone-500"
                        />
                    </div>
                </div>

                <div className="flex justify-end gap-2 pt-2">
                    <button onClick={handleCancel} className="p-1 hover:bg-stone-100 dark:hover:bg-stone-700 rounded">
                        <X className="w-4 h-4 text-stone-500" />
                    </button>
                    <button onClick={handleSave} className="p-1 hover:bg-stone-100 dark:hover:bg-stone-700 rounded text-green-600 dark:text-green-400">
                        <Check className="w-4 h-4" />
                    </button>
                    <button onClick={() => { if (window.confirm(`Delete "${character.name}"? This cannot be undone.`)) onDelete(character.id); }} className="p-1 hover:bg-red-50 dark:hover:bg-red-900/30 rounded text-red-500 ml-auto">
                        <Trash2 className="w-4 h-4" />
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div className="glass-panel p-4 rounded-xl hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group relative overflow-hidden">
            <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-stone-200 dark:from-stone-700 to-stone-100 dark:to-stone-800 opacity-50"></div>
            <div className="flex gap-4">
                <div className="relative">
                    <Avatar size="md" />
                    <button
                        onClick={handleGeneratePortrait}
                        disabled={isGenerating}
                        className={clsx(
                            "absolute -bottom-1 -right-1 p-1 rounded-full shadow-md transition-all",
                            isGenerating
                                ? "bg-indigo-500 text-white cursor-wait"
                                : "bg-white dark:bg-stone-700 text-stone-500 dark:text-stone-400 hover:text-indigo-600 dark:hover:text-indigo-400 hover:bg-indigo-50 dark:hover:bg-indigo-900/30 opacity-0 group-hover:opacity-100 border border-stone-200 dark:border-stone-600"
                        )}
                        title="Generate AI Portrait"
                    >
                        {isGenerating ? <Loader2 className="w-3 h-3 animate-spin" /> : <Camera className="w-3 h-3" />}
                    </button>
                </div>
                <div className="flex-1 min-w-0">
                    <div className="flex justify-between items-start">
                        <h3 className="font-bold text-stone-900 dark:text-stone-100 truncate">{character.name}</h3>
                        <div className="flex items-center gap-1">
                            {character.avatarUrl && (
                                <button
                                    onClick={handleRemovePortrait}
                                    className="opacity-0 group-hover:opacity-100 p-1 hover:bg-red-50 dark:hover:bg-red-900/30 rounded text-stone-400 hover:text-red-500 transition-opacity"
                                    title="Remove portrait"
                                >
                                    <X className="w-3 h-3" />
                                </button>
                            )}
                            <button
                                onClick={() => setIsEditing(true)}
                                className="opacity-0 group-hover:opacity-100 p-1 hover:bg-stone-100 dark:hover:bg-stone-700 rounded text-stone-400 transition-opacity"
                            >
                                <Edit2 className="w-3 h-3" />
                            </button>
                        </div>
                    </div>
                    <span className="inline-block px-2 py-0.5 rounded-full bg-stone-100 dark:bg-stone-700 text-stone-500 dark:text-stone-400 text-xs font-medium capitalize mb-2">
                        {character.role}
                    </span>
                    <p className="text-sm text-stone-600 dark:text-stone-400 line-clamp-3">
                        {character.description || "No description yet."}
                    </p>

                    {(character.arcLie || character.arcTruth || character.arcGhost) && (
                        <div className="mt-3 pt-3 border-t border-white/30 dark:border-stone-700/50 space-y-1.5">
                            {character.arcLie && (
                                <p className="text-xs flex gap-2">
                                    <span className="font-medium text-red-700/80 dark:text-red-400/80 min-w-10">Lie:</span>
                                    <span className="text-stone-600 dark:text-stone-400 line-clamp-1">{character.arcLie}</span>
                                </p>
                            )}
                            {character.arcTruth && (
                                <p className="text-xs flex gap-2">
                                    <span className="font-medium text-emerald-700/80 dark:text-emerald-400/80 min-w-10">Truth:</span>
                                    <span className="text-stone-600 dark:text-stone-400 line-clamp-1">{character.arcTruth}</span>
                                </p>
                            )}
                            {character.arcGhost && (
                                <p className="text-xs flex gap-2">
                                    <span className="font-medium text-stone-500 dark:text-stone-400 min-w-10">Ghost:</span>
                                    <span className="text-stone-600 dark:text-stone-400 line-clamp-1">{character.arcGhost}</span>
                                </p>
                            )}
                        </div>
                    )}
                </div>
            </div>

            {/* Portrait Error */}
            {portraitError && (
                <div className="mt-3 p-2 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg text-xs text-red-700 dark:text-red-300 flex justify-between items-start">
                    <span>{portraitError}</span>
                    <button onClick={() => setPortraitError(null)} className="ml-2 shrink-0"><X className="w-3 h-3" /></button>
                </div>
            )}

            {/* Portrait Preview Modal (Inline) */}
            {previewUrl && (
                <div className="mt-3 p-3 bg-stone-50 dark:bg-stone-900 border border-stone-200 dark:border-stone-700 rounded-xl animate-in fade-in slide-in-from-bottom-2 duration-300">
                    <img
                        src={previewUrl}
                        alt={`Portrait of ${character.name}`}
                        className="w-full rounded-lg shadow-lg mb-3 max-h-64 object-cover"
                    />
                    <p className="text-[10px] text-stone-400 dark:text-stone-500 text-center mb-3">
                        Not what you imagined? Try adding more physical details to the description.
                    </p>
                    <div className="flex gap-2">
                        <button
                            onClick={handleUsePortrait}
                            className="flex-1 py-2 px-3 bg-indigo-600 text-white text-xs font-bold rounded-lg hover:bg-indigo-700 transition-colors flex items-center justify-center gap-1.5"
                        >
                            <Check className="w-3.5 h-3.5" />
                            Use This
                        </button>
                        <button
                            onClick={handleGeneratePortrait}
                            disabled={isGenerating}
                            className="flex-1 py-2 px-3 bg-white dark:bg-stone-800 text-stone-700 dark:text-stone-300 text-xs font-bold rounded-lg hover:bg-stone-100 dark:hover:bg-stone-700 border border-stone-200 dark:border-stone-600 transition-colors flex items-center justify-center gap-1.5 disabled:opacity-50"
                        >
                            {isGenerating ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <RefreshCw className="w-3.5 h-3.5" />}
                            Try Again
                        </button>
                        <button
                            onClick={() => setPreviewUrl(null)}
                            className="py-2 px-3 text-stone-400 hover:text-stone-600 dark:hover:text-stone-300 text-xs rounded-lg hover:bg-stone-100 dark:hover:bg-stone-800 transition-colors"
                        >
                            <X className="w-3.5 h-3.5" />
                        </button>
                    </div>
                </div>
            )}
        </div>
    );
};
