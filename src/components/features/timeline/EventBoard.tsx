import { useState, useMemo } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { EventCard } from './EventCard';
import { Plus } from 'lucide-react';
import { PlotEvent } from '@/types';

export const EventBoard = () => {
    const { events, createEvent, updateEvent, deleteEvent } = useStoryStore();
    const [isCreating, setIsCreating] = useState<string | null>(null); // column id
    const [newEventTitle, setNewEventTitle] = useState('');

    // Group events by plotThread
    const columns = useMemo(() => {
        const groups: Record<string, PlotEvent[]> = {};
        const threads = new Set<string>();

        // Ensure Main exists
        threads.add('Main');

        events.forEach(e => {
            const thread = e.plotThread || 'Main';
            threads.add(thread);
            if (!groups[thread]) groups[thread] = [];
            groups[thread].push(e);
        });

        // Sort events within threads by order
        Object.keys(groups).forEach(key => {
            groups[key].sort((a, b) => a.order - b.order);
        });

        return Array.from(threads).map(thread => ({
            id: thread,
            title: thread,
            events: groups[thread] || []
        }));
    }, [events]);

    const handleCreate = async (thread: string) => {
        if (newEventTitle.trim()) {
            await createEvent(newEventTitle, thread);
            setNewEventTitle('');
            setIsCreating(null);
        }
    };

    return (
        <div className="h-full flex flex-col">
            <div className="flex-1 overflow-x-auto pb-4 p-4">
                <div className="flex gap-6 h-full min-w-max">
                    {columns.map(col => (
                        <div key={col.id} className="w-80 flex flex-col bg-stone-100/80 rounded-xl p-3 max-h-full">
                            <h3 className="font-bold text-stone-700 mb-3 px-1 flex justify-between">
                                {col.title}
                                <span className="text-stone-400 text-xs font-normal bg-stone-200 px-2 py-0.5 rounded-full">
                                    {col.events.length}
                                </span>
                            </h3>

                            <div className="flex-1 overflow-y-auto space-y-3 min-h-[100px] p-1">
                                {col.events.map(event => (
                                    <EventCard
                                        key={event.id}
                                        event={event}
                                        onUpdate={updateEvent}
                                        onDelete={deleteEvent}
                                    />
                                ))}

                                {isCreating === col.id ? (
                                    <div className="bg-white p-3 rounded-md border border-stone-300 shadow-sm space-y-2">
                                        <input
                                            autoFocus
                                            type="text"
                                            value={newEventTitle}
                                            onChange={(e) => setNewEventTitle(e.target.value)}
                                            placeholder="New Event..."
                                            className="w-full px-2 py-1 border border-stone-300 rounded text-sm"
                                            onKeyDown={(e) => {
                                                if (e.key === 'Enter') handleCreate(col.id);
                                                if (e.key === 'Escape') setIsCreating(null);
                                            }}
                                        />
                                        <div className="flex justify-end gap-2">
                                            <button onClick={() => setIsCreating(null)} className="text-xs text-stone-500 hover:text-stone-700">Cancel</button>
                                            <button onClick={() => handleCreate(col.id)} className="text-xs bg-stone-800 text-white px-2 py-1 rounded">Add</button>
                                        </div>
                                    </div>
                                ) : (
                                    <button
                                        onClick={() => { setIsCreating(col.id); setNewEventTitle(''); }}
                                        className="w-full py-2 text-stone-400 hover:text-stone-600 hover:bg-stone-200/50 rounded flex items-center justify-center gap-1 text-sm border border-transparent hover:border-stone-300 border-dashed transition-all"
                                    >
                                        <Plus className="w-4 h-4" />
                                        Add Event
                                    </button>
                                )}
                            </div>
                        </div>
                    ))}

                    {/* Add Column Button (Placeholder for now, or simple implementation) */}
                    <div className="w-80 shrink-0 flex items-start justify-center pt-10 opacity-40 hover:opacity-70 transition-opacity">
                        <div className="text-center p-4 border-2 border-dashed border-stone-300 rounded-xl">
                            <p className="text-sm text-stone-400 font-medium">New threads appear when</p>
                            <p className="text-sm text-stone-400">you assign events to them</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};
