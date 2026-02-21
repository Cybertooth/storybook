import { useMemo, useState } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { PlotEvent } from '@storybook/api';
import { Plus, MapPin } from 'lucide-react';
import clsx from 'clsx';

export const TimelineGraph = ({ filterCharacterId: _filterCharacterId }: { filterCharacterId?: string | null }) => {
    const { events, characters, createEvent } = useStoryStore();
    const [hoveredEvent, setHoveredEvent] = useState<string | null>(null);
    const [isCreating, setIsCreating] = useState<{ thread: string, order: number } | null>(null);
    const [newEventTitle, setNewEventTitle] = useState('');

    // 1. Organize Events by Plot Thread (Y-axis) and Order (X-axis)
    const graphData = useMemo(() => {
        // Identify all unique threads
        const threads = Array.from(new Set(events.map(e => e.plotThread || 'Main'))).sort();
        if (!threads.includes('Main')) threads.unshift('Main');

        // Group events by thread
        const eventsByThread: Record<string, PlotEvent[]> = {};
        threads.forEach(t => eventsByThread[t] = []);

        // Sort globally by order to determine X-position
        const sortedEvents = [...events].sort((a, b) => a.order - b.order);

        // We need a stable X-index for each event regardless of thread
        // Let's use the global sorted index as the "Time Step"
        const eventNodes = sortedEvents.map((e, index) => {
            const threadIndex = threads.indexOf(e.plotThread || 'Main');
            return {
                event: e,
                xIndex: index,
                yIndex: threadIndex,
                thread: e.plotThread || 'Main'
            };
        });

        return { threads, eventNodes, totalSteps: sortedEvents.length };
    }, [events]);

    // Dimensions
    const NODE_WIDTH = 180;
    const NODE_HEIGHT = 80;
    const X_SPACING = 250;
    const Y_SPACING = 180;
    const PADDING_X = 100;
    const PADDING_Y = 100;

    const width = Math.max(800, (graphData.totalSteps * X_SPACING) + PADDING_X * 2);
    const height = Math.max(600, (graphData.threads.length * Y_SPACING) + PADDING_Y * 2);

    // Helpers
    const getCoords = (xIndex: number, yIndex: number) => ({
        x: PADDING_X + (xIndex * X_SPACING),
        y: PADDING_Y + (yIndex * Y_SPACING)
    });

    // Handle Creation
    const handleCreate = async () => {
        if (!isCreating || !newEventTitle.trim()) return;
        await createEvent(newEventTitle, isCreating.thread); // Store needs to handle order auto-increment or we pass it
        // Ideally createEvent updates state, which triggers re-render
        setIsCreating(null);
        setNewEventTitle('');
    };

    return (
        <div className="h-full flex flex-col bg-stone-50 overflow-hidden relative">
            {/* Toolbar / Legend */}
            <div className="absolute top-4 right-4 z-20 flex gap-2 bg-white/80 dark:bg-stone-900/80 backdrop-blur p-2 rounded-lg shadow-sm border border-stone-200 dark:border-stone-700">
                <div className="flex items-center gap-2 text-xs text-stone-500 dark:text-stone-400 px-2">
                    <span className="w-3 h-3 rounded-full bg-indigo-500"></span> Character Paths
                </div>
                <div className="flex items-center gap-2 text-xs text-stone-500 dark:text-stone-400 px-2">
                    <span className="w-3 h-3 border border-stone-400 dark:border-stone-500 bg-white dark:bg-stone-800"></span> Event Nodes
                </div>
            </div>

            <div className="flex-1 overflow-auto relative">
                <svg
                    width={width}
                    height={height}
                    className="absolute top-0 left-0 pointer-events-none"
                >
                    {/* Plot Thread "Lanes" (Background) */}
                    {graphData.threads.map((thread, i) => {
                        const y = PADDING_Y + (i * Y_SPACING);
                        return (
                            <g key={`thread-bg-${thread}`}>
                                <text x={20} y={y} className="text-sm fill-stone-300 font-bold uppercase tracking-widest">{thread}</text>
                                <line x1={0} y1={y} x2={width} y2={y} stroke="#e7e5e4" strokeWidth="1" strokeDasharray="4 4" />
                            </g>
                        );
                    })}

                    {/* Character Paths */}
                    {characters.map((char, i) => {
                        // Find sequence of nodes for this character
                        const charNodes = graphData.eventNodes
                            .filter(n => n.event.characterIds?.includes(char.id))
                            .sort((a, b) => a.xIndex - b.xIndex);

                        if (charNodes.length < 2) return null;

                        // Build Bezier Path
                        let d = "";
                        charNodes.forEach((node, idx) => {
                            const { x, y } = getCoords(node.xIndex, node.yIndex);

                            // Offset lines slightly so they don't overlap perfectly
                            const yOffset = (i - characters.length / 2) * 6;

                            if (idx === 0) {
                                d += `M ${x} ${y + yOffset}`;
                            } else {
                                const prevNode = charNodes[idx - 1];
                                const prevCoords = getCoords(prevNode.xIndex, prevNode.yIndex);
                                const prevYOffset = (i - characters.length / 2) * 6;

                                // Cubic Bezier Control Points
                                const cp1x = prevCoords.x + (X_SPACING / 2);
                                const cp1y = prevCoords.y + prevYOffset;
                                const cp2x = x - (X_SPACING / 2);
                                const cp2y = y + yOffset;

                                d += ` C ${cp1x} ${cp1y}, ${cp2x} ${cp2y}, ${x} ${y + yOffset}`;
                            }
                        });

                        const color = `hsl(${i * 137.5 % 360}, 70%, 45%)`; // Golden angle for distinct colors

                        return (
                            <path
                                key={char.id}
                                d={d}
                                fill="none"
                                stroke={color}
                                strokeWidth="3"
                                strokeLinecap="round"
                                strokeLinejoin="round"
                                className="opacity-60 hover:opacity-100 transition-opacity duration-300"
                                style={{ filter: 'drop-shadow(0px 1px 1px rgba(0,0,0,0.1))' }}
                            />
                        );
                    })}
                </svg>

                {/* HTML Layer for Interactive Elements */}
                <div style={{ width, height }} className="relative">
                    {graphData.eventNodes.map((node) => {
                        const { x, y } = getCoords(node.xIndex, node.yIndex);
                        const isHovered = hoveredEvent === node.event.id;

                        return (
                            <div
                                key={node.event.id}
                                style={{
                                    left: x,
                                    top: y,
                                    width: NODE_WIDTH,
                                    height: NODE_HEIGHT,
                                    marginLeft: -(NODE_WIDTH / 2),
                                    marginTop: -(NODE_HEIGHT / 2)
                                }}
                                className={clsx(
                                    "absolute p-3 rounded-xl border bg-white dark:bg-stone-800 shadow-sm transition-all duration-200 cursor-pointer group flex flex-col justify-between",
                                    isHovered ? "border-indigo-400 shadow-lg scale-105 z-10" : "border-stone-200 dark:border-stone-700 hover:border-indigo-300 dark:hover:border-indigo-500"
                                )}
                                onMouseEnter={() => setHoveredEvent(node.event.id)}
                                onMouseLeave={() => setHoveredEvent(null)}
                            >
                                <div>
                                    <div className="flex justify-between items-start mb-1">
                                        <span className="text-[10px] font-mono text-stone-400">#{node.event.order}</span>
                                        {node.event.locationId && <MapPin className="w-3 h-3 text-stone-400" />}
                                    </div>
                                    <h4 className="font-bold text-sm text-stone-800 dark:text-stone-100 leading-tight line-clamp-2" title={node.event.title}>
                                        {node.event.title}
                                    </h4>
                                </div>

                                {/* Character Avatars (Mini) */}
                                <div className="flex -space-x-1 mt-2">
                                    {characters.filter(c => node.event.characterIds?.includes(c.id)).slice(0, 4).map((c) => (
                                        <div key={c.id} className="w-4 h-4 rounded-full ring-2 ring-white flex items-center justify-center text-[8px] font-bold shadow-sm" style={{ backgroundColor: `hsl(${characters.indexOf(c) * 137.5 % 360}, 70%, 90%)`, color: `hsl(${characters.indexOf(c) * 137.5 % 360}, 70%, 30%)` }}>
                                            {c.name[0]}
                                        </div>
                                    ))}
                                </div>
                            </div>
                        );
                    })}

                    {/* "Add Event" Buttons at end of threads */}
                    {graphData.threads.map((thread, i) => {
                        const threadEvents = graphData.eventNodes.filter(n => n.thread === thread);
                        const lastEventXIndex = threadEvents.length > 0 ? Math.max(...threadEvents.map(e => e.xIndex)) : -1;
                        const nextXIndex = lastEventXIndex + 1;
                        const { x, y } = getCoords(nextXIndex, i);

                        if (isCreating?.thread === thread) {
                            return (
                                <div
                                    key={`new-input-${thread}`}
                                    className="absolute bg-white p-3 rounded-xl border border-indigo-500 shadow-xl z-20 flex flex-col gap-2 w-64 animate-in zoom-in-50 duration-200"
                                    style={{ left: x, top: y, marginLeft: -(NODE_WIDTH / 2), marginTop: -(NODE_HEIGHT / 2) }}
                                >
                                    <h5 className="text-xs font-bold text-indigo-600 uppercase">New Event in {thread}</h5>
                                    <input
                                        autoFocus
                                        className="w-full text-sm border-stone-200 rounded-md focus:ring-indigo-500 focus:border-indigo-500"
                                        placeholder="Event Title..."
                                        value={newEventTitle}
                                        onChange={e => setNewEventTitle(e.target.value)}
                                        onKeyDown={e => {
                                            if (e.key === 'Enter') handleCreate();
                                            if (e.key === 'Escape') setIsCreating(null);
                                        }}
                                    />
                                    <div className="flex justify-end gap-2">
                                        <button onClick={() => setIsCreating(null)} className="text-xs px-2 py-1 text-stone-500">Cancel</button>
                                        <button onClick={handleCreate} className="text-xs bg-indigo-600 text-white px-2 py-1 rounded-md font-bold">Create</button>
                                    </div>
                                </div>
                            )
                        }

                        return (
                            <button
                                key={`add-btn-${thread}`}
                                onClick={() => setIsCreating({ thread, order: 999 })} // Setup for next available
                                className="absolute w-8 h-8 rounded-full bg-white border border-stone-300 hover:border-indigo-500 hover:bg-indigo-50 hover:text-indigo-600 text-stone-400 shadow-sm flex items-center justify-center transition-all group"
                                style={{ left: x, top: y, marginLeft: -16, marginTop: -16 }}
                                title={`Add event to ${thread}`}
                            >
                                <Plus className="w-5 h-5 group-hover:scale-110 transition-transform" />
                            </button>
                        );
                    })}
                </div>
            </div>
        </div>
    );
};
