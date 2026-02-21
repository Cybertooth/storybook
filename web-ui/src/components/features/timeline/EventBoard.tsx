import React, { useState, useMemo } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { EventCard } from './EventCard';
import { Plus } from 'lucide-react';
import { PlotEvent } from '@storybook/api';
import clsx from 'clsx';
import {
    DndContext,
    closestCenter,
    KeyboardSensor,
    PointerSensor,
    useSensor,
    useSensors,
    DragEndEvent,
    useDroppable
} from '@dnd-kit/core';
import { sortableKeyboardCoordinates } from '@dnd-kit/sortable';

const TimelineCell = ({ thread, order, events, isCreating, setIsCreating, handleCreate, newEventTitle, setNewEventTitle }: any) => {
    const { isOver, setNodeRef } = useDroppable({
        id: `cell-${thread}-${order}`,
        data: { thread, order }
    });

    return (
        <div
            ref={setNodeRef}
            className={`min-h-[120px] p-2 border border-stone-200 dark:border-stone-800 transition-colors ${isOver ? 'bg-indigo-50/50 dark:bg-indigo-900/20 shadow-inner' : 'bg-transparent'}`}
        >
            <div className="flex flex-col gap-2 h-full">
                {events.map((event: PlotEvent) => (
                    <EventCard
                        key={event.id}
                        event={event}
                        onUpdate={useStoryStore.getState().updateEvent}
                        onDelete={useStoryStore.getState().deleteEvent}
                    />
                ))}

                {isCreating ? (
                    <div className="bg-white dark:bg-stone-800 p-2 rounded-md border border-stone-300 dark:border-stone-700 shadow-sm space-y-2 mt-auto">
                        <input
                            autoFocus
                            type="text"
                            value={newEventTitle}
                            onChange={(e) => setNewEventTitle(e.target.value)}
                            placeholder="New Event..."
                            className="w-full px-2 py-1 border border-stone-300 dark:border-stone-600 dark:bg-stone-900 dark:text-stone-100 rounded text-xs"
                            onKeyDown={(e) => {
                                if (e.key === 'Enter') handleCreate(thread, order);
                                if (e.key === 'Escape') setIsCreating(null);
                            }}
                        />
                        <div className="flex justify-end gap-2">
                            <button onClick={() => setIsCreating(null)} className="text-[10px] text-stone-500 hover:text-stone-700">Cancel</button>
                            <button onClick={() => handleCreate(thread, order)} className="text-[10px] bg-stone-800 text-white px-2 py-1 rounded">Add</button>
                        </div>
                    </div>
                ) : (
                    <button
                        onClick={() => { setIsCreating(`${thread}-${order}`); setNewEventTitle(''); }}
                        className="w-full h-8 mt-auto text-stone-400 hover:text-stone-600 dark:hover:text-stone-300 hover:bg-stone-100 dark:hover:bg-stone-800/50 rounded flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity border-dashed border border-transparent hover:border-stone-300 dark:hover:border-stone-600"
                    >
                        <Plus className="w-4 h-4" />
                    </button>
                )}
            </div>
        </div>
    );
};

export const EventBoard = ({ filterCharacterId }: { filterCharacterId?: string | null }) => {
    const { events, createEvent, updateEvent } = useStoryStore();
    const [isCreating, setIsCreating] = useState<string | null>(null); // cell id: `${thread}-${order}`
    const [newEventTitle, setNewEventTitle] = useState('');

    // Pre-calculate threads and max order
    const threads = useMemo(() => {
        const uniqueThreads = new Set(['Main']);
        events.forEach(e => {
            if (e.plotThread) uniqueThreads.add(e.plotThread);
        });
        return Array.from(uniqueThreads).sort();
    }, [events]);

    const maxColIndex = useMemo(() => {
        const maxOrder = events.length > 0 ? Math.max(...events.map(e => e.order)) : -1;
        return Math.max(4, maxOrder + 1); // At least 5 columns, or slightly past the last event
    }, [events]);

    const handleCreate = async (thread: string, order: number) => {
        if (newEventTitle.trim()) {
            await createEvent(newEventTitle, thread);

            // The newly created event needs its order updated to match the cell
            const newestEvents = useStoryStore.getState().events;
            const newEvent = newestEvents[newestEvents.length - 1]; // Assume the last created is the newest
            if (newEvent) {
                await updateEvent(newEvent.id, { order });
            }

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
        const overId = over.id as string; // cell-${thread}-${order}

        if (overId.startsWith('cell-')) {
            const [, threadStr, orderStr] = overId.split('-');
            const order = parseInt(orderStr, 10);

            // Optional: shift events at that order if there's a collision?
            // For a true 2D timeline, we can just place it there.
            await updateEvent(activeId, { plotThread: threadStr, order });
        }
    };

    return (
        <div className="h-full flex flex-col bg-white dark:bg-stone-900 rounded-xl overflow-hidden shadow-sm border border-stone-200 dark:border-stone-800">
            <DndContext
                sensors={sensors}
                collisionDetection={closestCenter}
                onDragEnd={handleDragEnd}
            >
                <div className="flex-1 overflow-auto custom-scrollbar p-0">
                    <div
                        className="grid min-w-max"
                        style={{
                            gridTemplateColumns: `200px repeat(${maxColIndex + 1}, minmax(280px, 1fr))`
                        }}
                    >
                        {/* Header Row */}
                        <div className="sticky top-0 left-0 bg-stone-50/95 dark:bg-stone-900/95 backdrop-blur-sm z-20 font-bold p-4 text-stone-500 dark:text-stone-400 border-b border-r border-stone-200 dark:border-stone-800 shadow-sm flex items-center shadow-sm">
                            Plot Threads
                        </div>
                        {Array.from({ length: maxColIndex + 1 }).map((_, c) => (
                            <div key={c} className="sticky top-0 bg-stone-50/95 dark:bg-stone-900/95 backdrop-blur-sm z-10 font-bold p-4 text-stone-500 dark:text-stone-400 border-b border-stone-200 dark:border-stone-800 flex flex-col justify-center">
                                <span className="text-xs uppercase tracking-wider text-stone-400">Beat / Chap {c + 1}</span>
                            </div>
                        ))}

                        {/* Grid Rows */}
                        {threads.map(thread => (
                            <React.Fragment key={thread}>
                                <div className="sticky left-0 bg-stone-50/95 dark:bg-stone-900/95 backdrop-blur-sm z-10 font-bold p-4 text-stone-700 dark:text-stone-300 border-r border-b border-stone-200 dark:border-stone-800 flex items-center shadow-sm">
                                    <div className="flex items-center gap-2">
                                        <div className={`w-3 h-3 rounded-full ${thread === 'Main' ? 'bg-indigo-500' : 'bg-emerald-500'}`}></div>
                                        {thread}
                                    </div>
                                </div>
                                {Array.from({ length: maxColIndex + 1 }).map((_, c) => {
                                    const cellEvents = events.filter(e => e.plotThread === thread && e.order === c);
                                    const cellId = `${thread}-${c}`;
                                    const isDimmed = filterCharacterId && cellEvents.length > 0 && !cellEvents.some(e => e.characterIds.includes(filterCharacterId));

                                    return (
                                        <div key={cellId} className={clsx("border-b border-stone-200 dark:border-stone-800 group relative transition-opacity", isDimmed && "opacity-25")}>
                                            <TimelineCell
                                                thread={thread}
                                                order={c}
                                                events={cellEvents}
                                                isCreating={isCreating === cellId}
                                                setIsCreating={setIsCreating}
                                                handleCreate={handleCreate}
                                                newEventTitle={newEventTitle}
                                                setNewEventTitle={setNewEventTitle}
                                            />
                                        </div>
                                    );
                                })}
                            </React.Fragment>
                        ))}
                    </div>
                </div>
            </DndContext>
        </div>
    );
};
