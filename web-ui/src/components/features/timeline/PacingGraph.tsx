import { useMemo, useState } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import clsx from 'clsx';

export const PacingGraph = ({ filterCharacterId }: { filterCharacterId?: string | null }) => {
    const { events, updateEvent } = useStoryStore();
    const [editingId, setEditingId] = useState<string | null>(null);
    const [hoveredIndex, setHoveredIndex] = useState<number | null>(null);

    const sortedEvents = useMemo(() => {
        let filtered = [...events];
        if (filterCharacterId) {
            filtered = filtered.filter(e => e.characters.some(c => c.id === filterCharacterId));
        }
        return filtered.sort((a, b) => a.order - b.order);
    }, [events, filterCharacterId]);

    // Graph dimensions
    const W = 800;
    const H = 320;
    const PAD_L = 50;
    const PAD_R = 30;
    const PAD_T = 30;
    const PAD_B = 50;
    const graphW = W - PAD_L - PAD_R;
    const graphH = H - PAD_T - PAD_B;

    const points = useMemo(() => {
        if (sortedEvents.length === 0) return [];
        const stepX = sortedEvents.length > 1 ? graphW / (sortedEvents.length - 1) : graphW / 2;
        return sortedEvents.map((ev, i) => {
            const val = ev.emotionalValue ?? 0;
            const x = PAD_L + i * stepX;
            const y = PAD_T + graphH / 2 - (val / 5) * (graphH / 2);
            return { x, y, event: ev, index: i };
        });
    }, [sortedEvents, graphW, graphH]);

    // Build the path
    const linePath = useMemo(() => {
        if (points.length < 2) return '';
        let d = `M ${points[0].x} ${points[0].y}`;
        for (let i = 1; i < points.length; i++) {
            const prev = points[i - 1];
            const curr = points[i];
            const cpx = (prev.x + curr.x) / 2;
            d += ` C ${cpx} ${prev.y}, ${cpx} ${curr.y}, ${curr.x} ${curr.y}`;
        }
        return d;
    }, [points]);

    // Gradient area fill
    const areaPath = useMemo(() => {
        if (points.length < 2) return '';
        const baseline = PAD_T + graphH / 2;
        let d = `M ${points[0].x} ${baseline}`;
        d += ` L ${points[0].x} ${points[0].y}`;
        for (let i = 1; i < points.length; i++) {
            const prev = points[i - 1];
            const curr = points[i];
            const cpx = (prev.x + curr.x) / 2;
            d += ` C ${cpx} ${prev.y}, ${cpx} ${curr.y}, ${curr.x} ${curr.y}`;
        }
        d += ` L ${points[points.length - 1].x} ${baseline} Z`;
        return d;
    }, [points, graphH]);

    const setEmotionalValue = (eventId: string, value: number) => {
        updateEvent(eventId, { emotionalValue: value });
    };

    if (sortedEvents.length === 0) {
        return (
            <div className="text-center py-16 text-stone-400 dark:text-stone-500">
                <p className="font-medium text-stone-500 dark:text-stone-400 text-lg">No events yet.</p>
                <p className="text-sm mt-2">Add events to visualize your story's emotional pacing.</p>
            </div>
        );
    }

    return (
        <div className="space-y-4">
            <div className="glass-panel rounded-xl p-4 overflow-hidden">
                <svg width="100%" height={H} viewBox={`0 0 ${W} ${H}`} className="select-none">
                    <defs>
                        <linearGradient id="pacingGradientPos" x1="0" y1="0" x2="0" y2="1">
                            <stop offset="0%" stopColor="#22c55e" stopOpacity="0.3" />
                            <stop offset="100%" stopColor="#22c55e" stopOpacity="0" />
                        </linearGradient>
                        <linearGradient id="pacingGradientNeg" x1="0" y1="0" x2="0" y2="1">
                            <stop offset="0%" stopColor="#ef4444" stopOpacity="0" />
                            <stop offset="100%" stopColor="#ef4444" stopOpacity="0.3" />
                        </linearGradient>
                    </defs>

                    {/* Y-axis labels */}
                    {[-5, -3, 0, 3, 5].map(val => {
                        const y = PAD_T + graphH / 2 - (val / 5) * (graphH / 2);
                        return (
                            <g key={val}>
                                <line x1={PAD_L - 5} y1={y} x2={W - PAD_R} y2={y}
                                    stroke={val === 0 ? '#a8a29e' : '#e7e5e4'}
                                    strokeWidth={val === 0 ? 1.5 : 0.5}
                                    strokeDasharray={val === 0 ? '' : '4 4'}
                                    className="dark:opacity-30"
                                />
                                <text x={PAD_L - 10} y={y + 4} textAnchor="end"
                                    className="text-[10px] fill-stone-400 dark:fill-stone-500 font-mono">
                                    {val > 0 ? `+${val}` : val}
                                </text>
                            </g>
                        );
                    })}

                    {/* Y-axis label text */}
                    <text x={12} y={PAD_T + 4} className="text-[9px] fill-emerald-500 font-bold uppercase">High</text>
                    <text x={12} y={PAD_T + graphH} className="text-[9px] fill-red-400 font-bold uppercase">Low</text>

                    {/* Area fill */}
                    {areaPath && (
                        <>
                            <clipPath id="aboveMid">
                                <rect x={PAD_L} y={PAD_T} width={graphW} height={graphH / 2} />
                            </clipPath>
                            <clipPath id="belowMid">
                                <rect x={PAD_L} y={PAD_T + graphH / 2} width={graphW} height={graphH / 2} />
                            </clipPath>
                            <path d={areaPath} fill="url(#pacingGradientPos)" clipPath="url(#aboveMid)" />
                            <path d={areaPath} fill="url(#pacingGradientNeg)" clipPath="url(#belowMid)" />
                        </>
                    )}

                    {/* Line */}
                    {linePath && (
                        <path d={linePath} fill="none" stroke="#6366f1" strokeWidth={2.5} strokeLinecap="round"
                            className="drop-shadow-sm" />
                    )}

                    {/* Data points */}
                    {points.map((pt, i) => {
                        const val = pt.event.emotionalValue ?? 0;
                        const color = val > 0 ? '#22c55e' : val < 0 ? '#ef4444' : '#a8a29e';
                        const isHovered = hoveredIndex === i;

                        return (
                            <g key={pt.event.id}
                                onMouseEnter={() => setHoveredIndex(i)}
                                onMouseLeave={() => setHoveredIndex(null)}
                                onClick={() => setEditingId(editingId === pt.event.id ? null : pt.event.id)}
                                className="cursor-pointer"
                            >
                                {/* Hover ring */}
                                {isHovered && (
                                    <circle cx={pt.x} cy={pt.y} r={12} fill="none" stroke={color} strokeWidth={2} opacity={0.3} />
                                )}
                                {/* Point */}
                                <circle cx={pt.x} cy={pt.y} r={6} fill={color} stroke="white" strokeWidth={2}
                                    className="transition-all duration-150 dark:stroke-stone-800"
                                    style={{ transform: isHovered ? 'scale(1.3)' : '', transformOrigin: `${pt.x}px ${pt.y}px` }}
                                />
                                {/* X-axis label */}
                                <text x={pt.x} y={H - 10} textAnchor="middle"
                                    className={clsx("text-[9px] fill-stone-400 dark:fill-stone-500 font-medium",
                                        isHovered && "fill-stone-700 dark:fill-stone-200 font-bold"
                                    )}>
                                    {pt.event.title.substring(0, 12)}{pt.event.title.length > 12 ? '…' : ''}
                                </text>

                                {/* Hover tooltip */}
                                {isHovered && (
                                    <g>
                                        <rect x={pt.x - 70} y={pt.y - 45} width={140} height={30} rx={6}
                                            className="fill-stone-800 dark:fill-stone-200" opacity={0.9}
                                        />
                                        <text x={pt.x} y={pt.y - 28} textAnchor="middle"
                                            className="text-[10px] fill-white dark:fill-stone-800 font-medium">
                                            {pt.event.title} ({val > 0 ? '+' : ''}{val})
                                        </text>
                                    </g>
                                )}
                            </g>
                        );
                    })}
                </svg>
            </div>

            {/* Event intensity editor */}
            <div className="glass-panel rounded-xl p-4">
                <h4 className="text-xs font-bold text-stone-400 dark:text-stone-500 uppercase tracking-wider mb-3">
                    Scene Intensity Ratings
                </h4>
                <div className="space-y-2">
                    {sortedEvents.map(ev => {
                        const val = ev.emotionalValue ?? 0;
                        const isEditing = editingId === ev.id;
                        return (
                            <div key={ev.id}
                                className={clsx(
                                    "flex items-center gap-3 py-2 px-3 rounded-lg transition-colors",
                                    isEditing ? "bg-indigo-50 dark:bg-indigo-900/20 ring-1 ring-indigo-200 dark:ring-indigo-700" : "bg-stone-50 dark:bg-stone-800/50 hover:bg-stone-100 dark:hover:bg-stone-700/50"
                                )}
                                onClick={() => setEditingId(isEditing ? null : ev.id)}
                            >
                                <span className="text-[10px] font-mono text-stone-400 w-5">#{ev.order}</span>
                                <span className="text-sm font-medium text-stone-700 dark:text-stone-300 flex-1 truncate">{ev.title}</span>
                                <div className="flex items-center gap-2">
                                    {isEditing ? (
                                        <div className="flex items-center gap-1" onClick={e => e.stopPropagation()}>
                                            <span className="text-[10px] text-red-400 font-bold">-5</span>
                                            <input
                                                type="range"
                                                min={-5}
                                                max={5}
                                                step={1}
                                                value={val}
                                                onChange={e => setEmotionalValue(ev.id, parseInt(e.target.value))}
                                                className="w-32 h-1.5 accent-indigo-600"
                                            />
                                            <span className="text-[10px] text-emerald-500 font-bold">+5</span>
                                        </div>
                                    ) : null}
                                    <span className={clsx(
                                        "text-xs font-bold px-2 py-0.5 rounded-full min-w-[32px] text-center",
                                        val > 0 ? "bg-emerald-100 dark:bg-emerald-900/30 text-emerald-700 dark:text-emerald-400" :
                                            val < 0 ? "bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400" :
                                                "bg-stone-100 dark:bg-stone-700 text-stone-500 dark:text-stone-400"
                                    )}>
                                        {val > 0 ? `+${val}` : val}
                                    </span>
                                </div>
                            </div>
                        );
                    })}
                </div>
            </div>
        </div>
    );
};
