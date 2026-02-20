import { useState } from 'react';
import { PlotEvent } from '@/types';
import { Edit2, Trash2, Check, X, MapPin } from 'lucide-react';
import TextareaAutosize from 'react-textarea-autosize';

interface EventCardProps {
    event: PlotEvent;
    onUpdate: (id: string, updates: Partial<PlotEvent>) => void;
    onDelete: (id: string) => void;
}

export const EventCard = ({ event, onUpdate, onDelete }: EventCardProps) => {
    const [isEditing, setIsEditing] = useState(false);
    const [title, setTitle] = useState(event.title);
    const [description, setDescription] = useState(event.description);
    const [plotThread, setPlotThread] = useState(event.plotThread || 'Main');

    const handleSave = () => {
        onUpdate(event.id, { title, description, plotThread });
        setIsEditing(false);
    };

    if (isEditing) {
        return (
            <div className="bg-white p-3 rounded-md border border-stone-300 shadow-sm space-y-2">
                <input
                    type="text"
                    value={title}
                    onChange={(e) => setTitle(e.target.value)}
                    className="w-full px-2 py-1 border border-stone-300 rounded font-medium text-sm"
                    placeholder="Event Title"
                    autoFocus
                />
                <TextareaAutosize
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    placeholder="Description..."
                    className="w-full px-2 py-1 border border-stone-300 rounded text-xs min-h-[40px]"
                />
                <select
                    value={plotThread}
                    onChange={(e) => setPlotThread(e.target.value)}
                    className="w-full px-2 py-1 border border-stone-300 rounded text-xs text-stone-600"
                >
                    <option value="Main">Main Plot</option>
                    <option value="Subplot">Subplot</option>
                    <option value="Character Arc">Character Arc</option>
                    {/* Could add dynamic threads later */}
                </select>
                <div className="flex justify-end gap-2">
                    <button onClick={() => setIsEditing(false)} className="p-1 hover:bg-stone-100 rounded text-stone-500">
                        <X className="w-3 h-3" />
                    </button>
                    <button onClick={handleSave} className="p-1 hover:bg-stone-100 rounded text-green-600">
                        <Check className="w-3 h-3" />
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div className="glass-panel p-3 rounded-lg hover:shadow-lg hover:-translate-y-0.5 transition-all duration-300 group border-l-4 border-l-stone-300 hover:border-l-indigo-400">
            <div className="flex justify-between items-start gap-2">
                <h4 className="font-medium text-stone-800 text-sm leading-tight">{event.title}</h4>
                <div className="hidden group-hover:flex gap-1 shrink-0">
                    <button onClick={() => setIsEditing(true)} className="p-1 hover:bg-stone-100 rounded text-stone-400">
                        <Edit2 className="w-3 h-3" />
                    </button>
                    <button onClick={() => { if (window.confirm(`Delete "${event.title}"?`)) onDelete(event.id); }} className="p-1 hover:bg-red-50 rounded text-red-400">
                        <Trash2 className="w-3 h-3" />
                    </button>
                </div>
            </div>
            {event.description && (
                <p className="text-xs text-stone-500 mt-1 line-clamp-3">{event.description}</p>
            )}
            <div className="flex gap-2 mt-2">
                {event.locationId && (
                    <div className="flex items-center gap-1 text-[10px] text-stone-400">
                        <MapPin className="w-3 h-3" />
                        <span>Loc</span>
                    </div>
                )}
            </div>
        </div>
    );
};
