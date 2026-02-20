import { useState, useMemo } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { EventCard } from './EventCard';
import { Plus } from 'lucide-react';
import { PlotEvent } from '@/types';
import {
    DndContext,
    closestCenter,
    KeyboardSensor,
    PointerSensor,
    useSensor,
    useSensors,
    DragEndEvent
} from '@dnd-kit/core';
import {
    arrayMove,
    SortableContext,
    sortableKeyboardCoordinates,
    verticalListSortingStrategy,
} from '@dnd-kit/sortable';

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

    const sensors = useSensors(
        useSensor(PointerSensor, { activationConstraint: { distance: 5 } }),
        useSensor(KeyboardSensor, {
            coordinateGetter: sortableKeyboardCoordinates,
        })
    );

    const handleDragEnd = async (event: DragEndEvent) => {
        const { active, over } = event;

        if (!over) return;

        const activeId = active.id as string;
        const overId = over.id as string;

        if (activeId !== overId) {
            // Find the active and over events
            const activeEvent = events.find(e => e.id === activeId);
            const overEvent = events.find(e => e.id === overId);

            if (activeEvent && overEvent) {
                // If dragging between different columns/threads
                if (activeEvent.plotThread !== overEvent.plotThread) {

                    // Update thread and basic order
                    await updateEvent(activeId, { plotThread: overEvent.plotThread });

                    // To do a full reorder we'd need a reorderStore function that takes an array 
                    // of {id, order}. For MVP, just dropping it into the thread is enough,
                    // but we can try to roughly insert it here by updating order.
                    const newOrder = overEvent.order;
                    // Just simple insert for now
                    await updateEvent(activeId, { order: newOrder });
                } else {
                    // Same column sorting
                    const threadEvents = events
                        .filter(e => e.plotThread === activeEvent.plotThread)
                        .sort((a, b) => a.order - b.order);

                    const oldIndex = threadEvents.findIndex(e => e.id === activeId);
                    const newIndex = threadEvents.findIndex(e => e.id === overId);

                    const reordered = arrayMove(threadEvents, oldIndex, newIndex);

                    // Re-calculate orders for all affected items
                    // In a production app, we'd batch this in Zustand to avoid multiple renders
                    for (let i = 0; i < reordered.length; i++) {
                        if (reordered[i].order !== i) {
                            await updateEvent(reordered[i].id, { order: i });
                        }
                    }
                }
            }
        }
    };

    return (
        <div className="h-full flex flex-col">
            <DndContext
                sensors={sensors}
                collisionDetection={closestCenter}
                onDragEnd={handleDragEnd}
            >
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
                                    <SortableContext
                                        items={col.events.map(e => e.id)}
                                        strategy={verticalListSortingStrategy}
                                    >
                                        {col.events.map(event => (
                                            <EventCard
                                                key={event.id}
                                                event={event}
                                                onUpdate={updateEvent}
                                                onDelete={deleteEvent}
                                            />
                                        ))}
                                    </SortableContext>

                                    {isCreating === col.id ? (
                                        <div className="bg-white dark:bg-stone-800 p-3 rounded-md border border-stone-300 dark:border-stone-700 shadow-sm space-y-2">
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
            </DndContext>
        </div>
    );
};
