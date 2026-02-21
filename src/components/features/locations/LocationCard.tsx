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

    // Senses
    const [sensorySight, setSensorySight] = useState(location.sensorySight || '');
    const [sensorySound, setSensorySound] = useState(location.sensorySound || '');
    const [sensorySmell, setSensorySmell] = useState(location.sensorySmell || '');
    const [sensoryTouch, setSensoryTouch] = useState(location.sensoryTouch || '');
    const [sensoryTaste, setSensoryTaste] = useState(location.sensoryTaste || '');

    const handleSave = () => {
        onUpdate(location.id, {
            name, description,
            sensorySight, sensorySound, sensorySmell, sensoryTouch, sensoryTaste
        });
        setIsEditing(false);
    };

    const handleDelete = () => {
        if (window.confirm(`Delete "${location.name}"? This cannot be undone.`)) {
            onDelete(location.id);
        }
    };

    if (isEditing) {
        return (
            <div className="bg-white dark:bg-stone-800 p-4 rounded-xl border border-stone-200 dark:border-stone-700 shadow-sm space-y-3">
                <div className="flex gap-3 items-center">
                    <div className="w-10 h-10 bg-emerald-100 dark:bg-emerald-900/30 rounded-full flex items-center justify-center shrink-0">
                        <MapPin className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />
                    </div>
                    <input
                        type="text"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        className="flex-1 px-2 py-1 border border-stone-300 dark:border-stone-600 dark:bg-stone-900 dark:text-stone-100 rounded-lg font-medium"
                        placeholder="Location Name"
                    />
                </div>

                <TextareaAutosize
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    placeholder="Description..."
                    className="w-full px-2 py-1 border border-stone-300 dark:border-stone-600 dark:bg-stone-900 dark:text-stone-100 rounded-lg text-sm min-h-[60px]"
                />

                <div className="space-y-2 pt-2 border-t border-stone-100 dark:border-stone-700">
                    <p className="text-xs font-bold text-stone-400 dark:text-stone-500 uppercase tracking-wider">Sensory Details</p>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                        <input
                            type="text"
                            value={sensorySight}
                            onChange={(e) => setSensorySight(e.target.value)}
                            placeholder="Sight (colors, lighting)..."
                            className="w-full px-2 py-1 border border-stone-200 dark:border-stone-600 rounded text-xs text-stone-700 dark:text-stone-300 bg-stone-50 dark:bg-stone-900/50"
                        />
                        <input
                            type="text"
                            value={sensorySound}
                            onChange={(e) => setSensorySound(e.target.value)}
                            placeholder="Sound (echoes, bustling)..."
                            className="w-full px-2 py-1 border border-stone-200 dark:border-stone-600 rounded text-xs text-stone-700 dark:text-stone-300 bg-stone-50 dark:bg-stone-900/50"
                        />
                        <input
                            type="text"
                            value={sensorySmell}
                            onChange={(e) => setSensorySmell(e.target.value)}
                            placeholder="Smell (damp earth, spices)..."
                            className="w-full px-2 py-1 border border-stone-200 dark:border-stone-600 rounded text-xs text-stone-700 dark:text-stone-300 bg-stone-50 dark:bg-stone-900/50"
                        />
                        <input
                            type="text"
                            value={sensoryTouch}
                            onChange={(e) => setSensoryTouch(e.target.value)}
                            placeholder="Touch (cold stone, humid)..."
                            className="w-full px-2 py-1 border border-stone-200 dark:border-stone-600 rounded text-xs text-stone-700 dark:text-stone-300 bg-stone-50 dark:bg-stone-900/50"
                        />
                        <input
                            type="text"
                            value={sensoryTaste}
                            onChange={(e) => setSensoryTaste(e.target.value)}
                            placeholder="Taste (metallic air, salt)..."
                            className="w-full px-2 py-1 border border-stone-200 dark:border-stone-600 rounded text-xs text-stone-700 dark:text-stone-300 bg-stone-50 dark:bg-stone-900/50 sm:col-span-2"
                        />
                    </div>
                </div>

                <div className="flex justify-end gap-2 pt-2">
                    <button onClick={() => setIsEditing(false)} className="p-1.5 hover:bg-stone-100 dark:hover:bg-stone-700 rounded-lg transition-colors">
                        <X className="w-4 h-4 text-stone-500" />
                    </button>
                    <button onClick={handleSave} className="p-1.5 hover:bg-emerald-50 dark:hover:bg-emerald-900/30 rounded-lg text-emerald-600 dark:text-emerald-400 transition-colors">
                        <Check className="w-4 h-4" />
                    </button>
                    <button onClick={handleDelete} className="p-1.5 hover:bg-red-50 dark:hover:bg-red-900/30 rounded-lg text-red-500 ml-auto transition-colors">
                        <Trash2 className="w-4 h-4" />
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div className="glass-panel p-4 rounded-xl hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group relative overflow-hidden">
            <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-emerald-200 dark:from-emerald-800 to-teal-100 dark:to-teal-900 opacity-50"></div>
            <div className="flex gap-4">
                <div className="w-10 h-10 bg-emerald-100 dark:bg-emerald-900/30 rounded-full flex items-center justify-center shrink-0 text-emerald-600 dark:text-emerald-400">
                    <MapPin className="w-5 h-5" />
                </div>
                <div className="flex-1 min-w-0">
                    <div className="flex justify-between items-start">
                        <h3 className="font-bold text-stone-900 dark:text-stone-100 truncate">{location.name}</h3>
                        <button
                            onClick={() => setIsEditing(true)}
                            className="opacity-0 group-hover:opacity-100 p-1 hover:bg-stone-100 dark:hover:bg-stone-700 rounded text-stone-400 transition-opacity"
                        >
                            <Edit2 className="w-3 h-3" />
                        </button>
                    </div>
                    <p className="text-sm text-stone-600 dark:text-stone-400 line-clamp-2 mt-1">
                        {location.description || "No description yet."}
                    </p>

                    {(location.sensorySight || location.sensorySound || location.sensorySmell || location.sensoryTouch || location.sensoryTaste) && (
                        <div className="mt-3 pt-3 border-t border-white/30 dark:border-stone-700/50 flex flex-wrap gap-2 text-[10px] font-medium text-stone-500 dark:text-stone-400 uppercase">
                            {location.sensorySight && <span className="bg-white/50 dark:bg-stone-700/50 px-2 py-0.5 rounded border border-stone-200/50 dark:border-stone-600/50" title={location.sensorySight}>👁️ {location.sensorySight.substring(0, 15)}...</span>}
                            {location.sensorySound && <span className="bg-white/50 dark:bg-stone-700/50 px-2 py-0.5 rounded border border-stone-200/50 dark:border-stone-600/50" title={location.sensorySound}>👂 {location.sensorySound.substring(0, 15)}...</span>}
                            {location.sensorySmell && <span className="bg-white/50 dark:bg-stone-700/50 px-2 py-0.5 rounded border border-stone-200/50 dark:border-stone-600/50" title={location.sensorySmell}>👃 {location.sensorySmell.substring(0, 15)}...</span>}
                            {location.sensoryTouch && <span className="bg-white/50 dark:bg-stone-700/50 px-2 py-0.5 rounded border border-stone-200/50 dark:border-stone-600/50" title={location.sensoryTouch}>✋ {location.sensoryTouch.substring(0, 15)}...</span>}
                            {location.sensoryTaste && <span className="bg-white/50 dark:bg-stone-700/50 px-2 py-0.5 rounded border border-stone-200/50 dark:border-stone-600/50" title={location.sensoryTaste}>👅 {location.sensoryTaste.substring(0, 15)}...</span>}
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
};
