import { useState } from 'react';
import { PlotEvent } from '@/types';
import { Edit2, Trash2, Check, X, MapPin, GripVertical } from 'lucide-react';
import TextareaAutosize from 'react-textarea-autosize';
import { useDraggable } from '@dnd-kit/core';
import { CSS } from '@dnd-kit/utilities';

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

    const {
        attributes,
        listeners,
        setNodeRef,
        transform,
        isDragging,
    } = useDraggable({ id: event.id, data: { event } });

    const style = {
        transform: CSS.Translate.toString(transform),
        opacity: isDragging ? 0.3 : 1,
        position: isDragging ? 'relative' : 'static',
        zIndex: isDragging ? 50 : 1,
    } as React.CSSProperties;

    const handleSave = () => {
        onUpdate(event.id, { title, description, plotThread });
        setIsEditing(false);
    };

    if (isEditing) {
        return (
            <div className="bg-white dark:bg-stone-800 p-3 rounded-md border border-stone-300 dark:border-stone-600 shadow-sm space-y-2">
                <input
                    type="text"
                    value={title}
                    onChange={(e) => setTitle(e.target.value)}
                    className="w-full px-2 py-1 border border-stone-300 dark:border-stone-600 dark:bg-stone-900 dark:text-stone-100 rounded font-medium text-sm"
                    placeholder="Event Title"
                    autoFocus
                />
                <TextareaAutosize
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    placeholder="Description..."
                    className="w-full px-2 py-1 border border-stone-300 dark:border-stone-600 dark:bg-stone-900 dark:text-stone-200 rounded text-xs min-h-[40px]"
                />
                <select
                    value={plotThread}
                    onChange={(e) => setPlotThread(e.target.value)}
                    className="w-full px-2 py-1 border border-stone-300 dark:border-stone-600 dark:bg-stone-900 rounded text-xs text-stone-600 dark:text-stone-300"
                >
                    <option value="Main">Main Plot</option>
                    <option value="Subplot">Subplot</option>
                    <option value="Character Arc">Character Arc</option>
                    {/* Could add dynamic threads later */}
                </select>
                <div className="flex justify-end gap-2">
                    <button onClick={() => setIsEditing(false)} className="p-1 hover:bg-stone-100 dark:hover:bg-stone-700/50 rounded text-stone-500 dark:text-stone-400">
                        <X className="w-3 h-3" />
                    </button>
                    <button onClick={handleSave} className="p-1 hover:bg-stone-100 dark:hover:bg-stone-700/50 rounded text-green-600 dark:text-green-500">
                        <Check className="w-3 h-3" />
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div
            ref={setNodeRef}
            style={style}
            className={`glass-panel p-3 rounded-lg hover:shadow-lg hover:-translate-y-0.5 transition-all duration-300 group border-l-4 border-l-stone-300 dark:border-l-stone-600 hover:border-l-indigo-400 dark:hover:border-l-indigo-500 relative ${isDragging ? 'shadow-xl scale-105 rotate-2' : ''}`}
        >
            <div className="flex justify-between items-start gap-2">
                <div
                    {...attributes}
                    {...listeners}
                    className="absolute -left-3 top-1/2 -translate-y-1/2 p-1 text-transparent group-hover:text-stone-300 dark:group-hover:text-stone-600 hover:!text-stone-500 dark:hover:!text-stone-400 cursor-grab active:cursor-grabbing"
                >
                    <GripVertical className="w-4 h-4" />
                </div>
                <h4 className="font-medium text-stone-800 dark:text-stone-200 text-sm leading-tight ml-2">{event.title}</h4>
                <div className="hidden group-hover:flex gap-1 shrink-0">
                    <button onClick={() => setIsEditing(true)} className="p-1 hover:bg-stone-100 dark:hover:bg-stone-700/50 rounded text-stone-400 hover:text-stone-600 dark:hover:text-stone-300">
                        <Edit2 className="w-3 h-3" />
                    </button>
                    <button onClick={() => { if (window.confirm(`Delete "${event.title}"?`)) onDelete(event.id); }} className="p-1 hover:bg-red-50 dark:hover:bg-red-900/30 rounded text-red-400 hover:text-red-500">
                        <Trash2 className="w-3 h-3" />
                    </button>
                </div>
            </div>
            {
                event.description && (
                    <p className="text-xs text-stone-500 mt-1 line-clamp-3">{event.description}</p>
                )
            }
            <div className="flex gap-2 mt-2">
                {event.locationId && (
                    <div className="flex items-center gap-1 text-[10px] text-stone-400">
                        <MapPin className="w-3 h-3" />
                        <span>Loc</span>
                    </div>
                )}
            </div>
        </div >
    );
};
