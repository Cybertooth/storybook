import { useState, useMemo } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { Plus, Trash2, X } from 'lucide-react';
import clsx from 'clsx';

const RELATIONSHIP_COLORS: Record<string, string> = {
    'Ally': '#22c55e',
    'Enemy': '#ef4444',
    'Lover': '#ec4899',
    'Sibling': '#3b82f6',
    'Parent': '#8b5cf6',
    'Mentor': '#f59e0b',
    'Rival': '#f97316',
    'Friend': '#14b8a6',
};

const RELATIONSHIP_TYPES = Object.keys(RELATIONSHIP_COLORS);

export const RelationshipGraph = () => {
    const { characters, relationships, createRelationship, deleteRelationship } = useStoryStore();
    const [isAdding, setIsAdding] = useState(false);
    const [sourceId, setSourceId] = useState('');
    const [targetId, setTargetId] = useState('');
    const [relType, setRelType] = useState('Ally');
    const [relDesc, setRelDesc] = useState('');
    const [hoveredRel, setHoveredRel] = useState<string | null>(null);
    const [hoveredChar, setHoveredChar] = useState<string | null>(null);

    // Position characters in a circle
    const layout = useMemo(() => {
        const cx = 400;
        const cy = 300;
        const radius = Math.min(220, 50 + characters.length * 30);
        return characters.map((char, i) => {
            const angle = (2 * Math.PI * i) / characters.length - Math.PI / 2;
            return {
                character: char,
                x: cx + radius * Math.cos(angle),
                y: cy + radius * Math.sin(angle),
            };
        });
    }, [characters]);

    const handleAdd = async () => {
        if (!sourceId || !targetId || sourceId === targetId) return;
        await createRelationship(sourceId, targetId, relType, relDesc);
        setIsAdding(false);
        setSourceId('');
        setTargetId('');
        setRelType('Ally');
        setRelDesc('');
    };

    const getCharPos = (id: string) => {
        const entry = layout.find(l => l.character.id === id);
        return entry ? { x: entry.x, y: entry.y } : { x: 400, y: 300 };
    };

    const getColor = (type: string) => RELATIONSHIP_COLORS[type] || '#a8a29e';

    if (characters.length === 0) {
        return (
            <div className="text-center py-16 text-stone-400 dark:text-stone-500">
                <p className="font-medium text-stone-500 dark:text-stone-400 text-lg">No characters yet.</p>
                <p className="text-sm mt-2">Add characters first to visualize their relationships.</p>
            </div>
        );
    }

    return (
        <div className="space-y-4">
            {/* Toolbar */}
            <div className="flex justify-between items-center">
                <div className="flex gap-3 flex-wrap">
                    {RELATIONSHIP_TYPES.map(type => (
                        <div key={type} className="flex items-center gap-1.5 text-xs text-stone-500 dark:text-stone-400">
                            <span className="w-3 h-3 rounded-full" style={{ backgroundColor: RELATIONSHIP_COLORS[type] }}></span>
                            {type}
                        </div>
                    ))}
                </div>
                <button
                    onClick={() => setIsAdding(true)}
                    className="flex items-center gap-2 px-3 py-1.5 bg-stone-900 dark:bg-stone-100 text-white dark:text-stone-900 rounded-md hover:bg-stone-700 dark:hover:bg-stone-300 transition-colors text-sm"
                >
                    <Plus className="w-4 h-4" />
                    Add Relationship
                </button>
            </div>

            {/* Add Relationship Form */}
            {isAdding && (
                <div className="glass-panel rounded-xl p-4 space-y-3 animate-in fade-in slide-in-from-top-2 duration-200">
                    <div className="flex justify-between items-center">
                        <h4 className="text-sm font-bold text-stone-700 dark:text-stone-300">New Relationship</h4>
                        <button onClick={() => setIsAdding(false)} className="p-1 hover:bg-stone-100 dark:hover:bg-stone-700 rounded">
                            <X className="w-4 h-4 text-stone-400" />
                        </button>
                    </div>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                        <select
                            value={sourceId}
                            onChange={e => setSourceId(e.target.value)}
                            className="px-2 py-1.5 text-sm border border-stone-200 dark:border-stone-600 dark:bg-stone-800 dark:text-stone-200 rounded-lg"
                        >
                            <option value="">From...</option>
                            {characters.map(c => <option key={c.id} value={c.id}>{c.name}</option>)}
                        </select>
                        <select
                            value={relType}
                            onChange={e => setRelType(e.target.value)}
                            className="px-2 py-1.5 text-sm border border-stone-200 dark:border-stone-600 dark:bg-stone-800 dark:text-stone-200 rounded-lg"
                        >
                            {RELATIONSHIP_TYPES.map(t => <option key={t} value={t}>{t}</option>)}
                        </select>
                        <select
                            value={targetId}
                            onChange={e => setTargetId(e.target.value)}
                            className="px-2 py-1.5 text-sm border border-stone-200 dark:border-stone-600 dark:bg-stone-800 dark:text-stone-200 rounded-lg"
                        >
                            <option value="">To...</option>
                            {characters.filter(c => c.id !== sourceId).map(c => <option key={c.id} value={c.id}>{c.name}</option>)}
                        </select>
                        <input
                            type="text"
                            value={relDesc}
                            onChange={e => setRelDesc(e.target.value)}
                            placeholder="Description (optional)"
                            className="px-2 py-1.5 text-sm border border-stone-200 dark:border-stone-600 dark:bg-stone-800 dark:text-stone-200 rounded-lg"
                        />
                    </div>
                    <div className="flex justify-end">
                        <button
                            onClick={handleAdd}
                            disabled={!sourceId || !targetId || sourceId === targetId}
                            className="px-4 py-1.5 bg-indigo-600 text-white text-sm rounded-lg hover:bg-indigo-700 disabled:opacity-40 transition-colors font-medium"
                        >
                            Add
                        </button>
                    </div>
                </div>
            )}

            {/* SVG Graph */}
            <div className="glass-panel rounded-xl overflow-hidden relative" style={{ minHeight: 600 }}>
                <svg width="100%" height="600" viewBox="0 0 800 600" className="select-none">
                    {/* Relationship edges */}
                    {relationships.map(rel => {
                        const from = getCharPos(rel.sourceId);
                        const to = getCharPos(rel.targetId);
                        const color = getColor(rel.type);
                        const isHovered = hoveredRel === rel.id;
                        const isCharHovered = hoveredChar === rel.sourceId || hoveredChar === rel.targetId;
                        const opacity = hoveredChar ? (isCharHovered ? 1 : 0.15) : (isHovered ? 1 : 0.6);

                        // Offset for parallel edges
                        const dx = to.x - from.x;
                        const dy = to.y - from.y;
                        const len = Math.sqrt(dx * dx + dy * dy) || 1;
                        const nx = -dy / len * 8;
                        const ny = dx / len * 8;

                        const mx = (from.x + to.x) / 2 + nx;
                        const my = (from.y + to.y) / 2 + ny;

                        return (
                            <g key={rel.id}
                                onMouseEnter={() => setHoveredRel(rel.id)}
                                onMouseLeave={() => setHoveredRel(null)}
                                className="cursor-pointer"
                            >
                                <path
                                    d={`M ${from.x} ${from.y} Q ${mx} ${my} ${to.x} ${to.y}`}
                                    fill="none"
                                    stroke={color}
                                    strokeWidth={isHovered ? 4 : 2.5}
                                    strokeLinecap="round"
                                    opacity={opacity}
                                    className="transition-all duration-200"
                                    style={{ filter: isHovered ? `drop-shadow(0 0 6px ${color})` : 'none' }}
                                />
                                {/* Edge label */}
                                <text
                                    x={mx}
                                    y={my - 8}
                                    textAnchor="middle"
                                    className={clsx(
                                        "text-[10px] font-bold uppercase tracking-wide pointer-events-none transition-opacity duration-200",
                                        isHovered || isCharHovered ? "opacity-100" : "opacity-0"
                                    )}
                                    fill={color}
                                >
                                    {rel.type}
                                </text>
                                {/* Hover description tooltip */}
                                {isHovered && rel.description && (
                                    <text
                                        x={mx}
                                        y={my + 12}
                                        textAnchor="middle"
                                        className="text-[9px] fill-stone-500 dark:fill-stone-400 pointer-events-none"
                                    >
                                        {rel.description}
                                    </text>
                                )}
                                {/* Delete button on hover */}
                                {isHovered && (
                                    <g onClick={(e) => { e.stopPropagation(); if (window.confirm('Delete this relationship?')) deleteRelationship(rel.id); }}>
                                        <circle cx={mx + 20} cy={my - 8} r={8} fill="#ef4444" className="cursor-pointer hover:opacity-80 transition-opacity" />
                                        <text x={mx + 20} y={my - 4} textAnchor="middle" className="text-[10px] fill-white font-bold pointer-events-none">×</text>
                                    </g>
                                )}
                            </g>
                        );
                    })}

                    {/* Character nodes */}
                    {layout.map(({ character, x, y }) => {
                        const charIndex = characters.indexOf(character);
                        const hue = charIndex * 137.5 % 360;
                        const isHovered = hoveredChar === character.id;
                        const isDimmed = hoveredChar !== null && hoveredChar !== character.id &&
                            !relationships.some(r =>
                                (r.sourceId === hoveredChar && r.targetId === character.id) ||
                                (r.targetId === hoveredChar && r.sourceId === character.id)
                            );

                        return (
                            <g key={character.id}
                                onMouseEnter={() => setHoveredChar(character.id)}
                                onMouseLeave={() => setHoveredChar(null)}
                                className="cursor-pointer"
                            >
                                {/* Glow ring on hover */}
                                {isHovered && (
                                    <circle
                                        cx={x} cy={y} r={34}
                                        fill="none"
                                        stroke={`hsl(${hue}, 70%, 60%)`}
                                        strokeWidth={2}
                                        opacity={0.5}
                                        className="animate-ping"
                                        style={{ animationDuration: '2s' }}
                                    />
                                )}
                                {/* Node circle */}
                                <circle
                                    cx={x} cy={y} r={28}
                                    fill={`hsl(${hue}, 70%, ${isDimmed ? '90' : '85'}%)`}
                                    stroke={`hsl(${hue}, 70%, ${isDimmed ? '75' : '55'}%)`}
                                    strokeWidth={isHovered ? 3 : 2}
                                    className="transition-all duration-200"
                                    opacity={isDimmed ? 0.3 : 1}
                                />
                                {/* Initials */}
                                <text
                                    x={x} y={y + 1}
                                    textAnchor="middle"
                                    dominantBaseline="middle"
                                    className="text-sm font-bold pointer-events-none transition-opacity duration-200"
                                    fill={`hsl(${hue}, 70%, 30%)`}
                                    opacity={isDimmed ? 0.3 : 1}
                                >
                                    {character.name.substring(0, 2).toUpperCase()}
                                </text>
                                {/* Name label */}
                                <text
                                    x={x} y={y + 44}
                                    textAnchor="middle"
                                    className="text-[11px] font-medium pointer-events-none fill-stone-600 dark:fill-stone-400 transition-opacity duration-200"
                                    opacity={isDimmed ? 0.3 : 1}
                                >
                                    {character.name}
                                </text>
                                {/* Role label */}
                                <text
                                    x={x} y={y + 56}
                                    textAnchor="middle"
                                    className="text-[9px] pointer-events-none fill-stone-400 dark:fill-stone-500 capitalize transition-opacity duration-200"
                                    opacity={isDimmed ? 0.2 : 0.7}
                                >
                                    {character.role}
                                </text>
                            </g>
                        );
                    })}
                </svg>
            </div>

            {/* Relationship List */}
            {relationships.length > 0 && (
                <div className="glass-panel rounded-xl p-4">
                    <h4 className="text-xs font-bold text-stone-400 dark:text-stone-500 uppercase tracking-wider mb-3">All Relationships ({relationships.length})</h4>
                    <div className="space-y-2">
                        {relationships.map(rel => {
                            const source = characters.find(c => c.id === rel.sourceId);
                            const target = characters.find(c => c.id === rel.targetId);
                            if (!source || !target) return null;
                            return (
                                <div key={rel.id} className="flex items-center justify-between py-1.5 px-3 bg-stone-50 dark:bg-stone-800/50 rounded-lg group hover:bg-stone-100 dark:hover:bg-stone-700/50 transition-colors">
                                    <div className="flex items-center gap-2 text-sm">
                                        <span className="font-medium text-stone-700 dark:text-stone-300">{source.name}</span>
                                        <span className="px-2 py-0.5 rounded-full text-[10px] font-bold text-white" style={{ backgroundColor: getColor(rel.type) }}>
                                            {rel.type}
                                        </span>
                                        <span className="font-medium text-stone-700 dark:text-stone-300">{target.name}</span>
                                        {rel.description && <span className="text-stone-400 dark:text-stone-500 text-xs ml-2">— {rel.description}</span>}
                                    </div>
                                    <button
                                        onClick={() => { if (window.confirm('Delete this relationship?')) deleteRelationship(rel.id); }}
                                        className="opacity-0 group-hover:opacity-100 p-1 hover:bg-red-100 dark:hover:bg-red-900/30 rounded text-red-400 transition-all"
                                    >
                                        <Trash2 className="w-3.5 h-3.5" />
                                    </button>
                                </div>
                            );
                        })}
                    </div>
                </div>
            )}
        </div>
    );
};
