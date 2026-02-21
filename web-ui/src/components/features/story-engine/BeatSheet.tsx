import { useState } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { Layers, ChevronDown, ChevronRight, Check, Wand2 } from 'lucide-react';
import clsx from 'clsx';

interface Beat {
    name: string;
    description: string;
    percentage: number; // Where it falls in the story (0-100)
    color: string;
}

const BEAT_SHEETS: Record<string, { label: string; description: string; beats: Beat[] }> = {
    'save-the-cat': {
        label: 'Save the Cat!',
        description: 'Blake Snyder\'s 15-beat structure for compelling screenplays.',
        beats: [
            { name: 'Opening Image', description: 'A snapshot of the protagonist\'s world before the adventure begins.', percentage: 1, color: '#6366f1' },
            { name: 'Theme Stated', description: 'Someone tells the hero what the story is really about — they just don\'t get it yet.', percentage: 5, color: '#8b5cf6' },
            { name: 'Set-Up', description: 'The hero\'s world is established. Stakes, characters, flaws are laid out.', percentage: 10, color: '#a855f7' },
            { name: 'Catalyst', description: 'The inciting incident. Life will never be the same.', percentage: 12, color: '#ec4899' },
            { name: 'Debate', description: 'The hero hesitates. Should they go on this journey?', percentage: 17, color: '#f43f5e' },
            { name: 'Break into Two', description: 'The hero decides to act and enters the \"upside-down\" world.', percentage: 25, color: '#ef4444' },
            { name: 'B Story', description: 'A new character (often the love interest) enters, carrying the theme.', percentage: 30, color: '#f97316' },
            { name: 'Fun and Games', description: 'The promise of the premise is delivered. This is why we came.', percentage: 40, color: '#f59e0b' },
            { name: 'Midpoint', description: 'False victory or false defeat. The stakes are raised.', percentage: 50, color: '#eab308' },
            { name: 'Bad Guys Close In', description: 'External pressure mounts. Internal flaws are exploited.', percentage: 60, color: '#84cc16' },
            { name: 'All Is Lost', description: 'The hero hits rock bottom. A \"whiff of death\" hangs in the air.', percentage: 75, color: '#22c55e' },
            { name: 'Dark Night of the Soul', description: 'Despair. The hero reflects and discovers the truth.', percentage: 80, color: '#14b8a6' },
            { name: 'Break into Three', description: 'The hero figures out the solution, combining the A and B stories.', percentage: 85, color: '#06b6d4' },
            { name: 'Finale', description: 'The hero applies what they\'ve learned. The old world is destroyed.', percentage: 90, color: '#3b82f6' },
            { name: 'Final Image', description: 'The opposite of the opening image, showing how much has changed.', percentage: 99, color: '#6366f1' },
        ]
    },
    'heros-journey': {
        label: "Hero's Journey",
        description: 'Joseph Campbell\'s mythological monomyth structure.',
        beats: [
            { name: 'Ordinary World', description: 'The hero\'s normal life before the story begins.', percentage: 5, color: '#6366f1' },
            { name: 'Call to Adventure', description: 'Something shakes up the situation. A challenge or quest is presented.', percentage: 10, color: '#8b5cf6' },
            { name: 'Refusal of the Call', description: 'The hero is reluctant and fears the unknown.', percentage: 15, color: '#a855f7' },
            { name: 'Meeting the Mentor', description: 'The hero encounters a wise figure who gives guidance.', percentage: 20, color: '#ec4899' },
            { name: 'Crossing the Threshold', description: 'The hero leaves the ordinary world and enters the special world.', percentage: 25, color: '#ef4444' },
            { name: 'Tests, Allies, Enemies', description: 'The hero makes allies, confronts enemies, and learns the rules.', percentage: 40, color: '#f97316' },
            { name: 'Approach to the Inmost Cave', description: 'The hero nears the center of the story and the ultimate danger.', percentage: 50, color: '#eab308' },
            { name: 'The Ordeal', description: 'The hero faces their greatest fear or a near-death experience.', percentage: 60, color: '#84cc16' },
            { name: 'Reward (Seizing the Sword)', description: 'After surviving, the hero takes possession of the treasure.', percentage: 70, color: '#22c55e' },
            { name: 'The Road Back', description: 'The hero begins the journey home but dangers are not over.', percentage: 80, color: '#14b8a6' },
            { name: 'Resurrection', description: 'The climax. The hero faces a final test using everything learned.', percentage: 90, color: '#3b82f6' },
            { name: 'Return with the Elixir', description: 'The hero returns home transformed, bearing the prize.', percentage: 98, color: '#6366f1' },
        ]
    },
    'three-act': {
        label: '3-Act Structure',
        description: 'The classic beginning-middle-end framework.',
        beats: [
            { name: 'Act I — Setup', description: 'Introduce the world, characters, and the central conflict.', percentage: 5, color: '#6366f1' },
            { name: 'Inciting Incident', description: 'The event that sets the story in motion.', percentage: 12, color: '#8b5cf6' },
            { name: 'Plot Point 1', description: 'A turning point that spins the story into Act II.', percentage: 25, color: '#ef4444' },
            { name: 'Act II — Confrontation', description: 'Rising action. The hero encounters obstacles.', percentage: 35, color: '#f97316' },
            { name: 'Midpoint', description: 'A major reversal or revelation that changes the stakes.', percentage: 50, color: '#eab308' },
            { name: 'Plot Point 2', description: 'A final turning point that pushes the hero toward the climax.', percentage: 75, color: '#22c55e' },
            { name: 'Act III — Resolution', description: 'The climax and falling action. All threads are resolved.', percentage: 85, color: '#3b82f6' },
            { name: 'Denouement', description: 'The new normal. Loose ends are tied up.', percentage: 95, color: '#6366f1' },
        ]
    }
};

export const BeatSheet = () => {
    const { events, createEvent } = useStoryStore();
    const [selectedTemplate, setSelectedTemplate] = useState<string>('save-the-cat');
    const [expandedBeat, setExpandedBeat] = useState<string | null>(null);

    const template = BEAT_SHEETS[selectedTemplate];
    const sortedEvents = [...events].sort((a, b) => a.order - b.order);

    // Match events to beats (simple: by order position relative to total)
    const beatMatches = template.beats.map(beat => {
        const totalEvents = sortedEvents.length;
        if (totalEvents === 0) return null;
        const idealIndex = Math.round((beat.percentage / 100) * (totalEvents - 1));
        return sortedEvents[idealIndex] || null;
    });

    const handleCreateFromBeat = async (beatName: string) => {
        await createEvent(beatName, 'Main');
    };

    return (
        <div className="space-y-6">
            {/* Template Selector */}
            <div className="flex items-center gap-4">
                <div className="flex items-center gap-2">
                    <Layers className="w-5 h-5 text-indigo-600 dark:text-indigo-400" />
                    <span className="text-sm font-bold text-stone-700 dark:text-stone-300">Template:</span>
                </div>
                <div className="flex gap-2">
                    {Object.entries(BEAT_SHEETS).map(([key, val]) => (
                        <button
                            key={key}
                            onClick={() => { setSelectedTemplate(key); setExpandedBeat(null); }}
                            className={clsx(
                                "px-3 py-1.5 rounded-lg text-xs font-medium transition-all",
                                selectedTemplate === key
                                    ? "bg-indigo-100 dark:bg-indigo-900/40 text-indigo-700 dark:text-indigo-300 ring-1 ring-indigo-200 dark:ring-indigo-700"
                                    : "bg-stone-100 dark:bg-stone-800 text-stone-500 dark:text-stone-400 hover:bg-stone-200 dark:hover:bg-stone-700"
                            )}
                        >
                            {val.label}
                        </button>
                    ))}
                </div>
            </div>

            <p className="text-sm text-stone-500 dark:text-stone-400">{template.description}</p>

            {/* Visual Timeline Bar */}
            <div className="glass-panel rounded-xl p-4">
                <div className="relative h-16 bg-stone-100 dark:bg-stone-800 rounded-full overflow-hidden">
                    {/* Progress gradient */}
                    <div className="absolute inset-0 bg-gradient-to-r from-indigo-100 via-amber-50 to-emerald-100 dark:from-indigo-900/20 dark:via-amber-900/10 dark:to-emerald-900/20 opacity-50 rounded-full" />

                    {/* Beat markers */}
                    {template.beats.map((beat, i) => (
                        <button
                            key={i}
                            onClick={() => setExpandedBeat(expandedBeat === beat.name ? null : beat.name)}
                            className="absolute top-1/2 -translate-y-1/2 group z-10"
                            style={{ left: `${beat.percentage}%` }}
                            title={beat.name}
                        >
                            <div
                                className={clsx(
                                    "w-4 h-4 rounded-full border-2 border-white dark:border-stone-900 shadow-md transition-all duration-200",
                                    expandedBeat === beat.name ? "scale-150 ring-2 ring-offset-1" : "group-hover:scale-125"
                                )}
                                style={{ backgroundColor: beat.color }}
                            />
                            <div className="absolute -bottom-6 left-1/2 -translate-x-1/2 whitespace-nowrap opacity-0 group-hover:opacity-100 transition-opacity text-[8px] font-bold text-stone-500 dark:text-stone-400 uppercase tracking-wider">
                                {beat.name}
                            </div>
                        </button>
                    ))}
                </div>

                {/* Act markers */}
                <div className="flex justify-between mt-2 text-[10px] font-medium text-stone-400 dark:text-stone-500 uppercase tracking-wider">
                    <span>Act I</span>
                    <span>Act II</span>
                    <span>Act III</span>
                </div>
            </div>

            {/* Beat Detail List */}
            <div className="space-y-1">
                {template.beats.map((beat, i) => {
                    const isExpanded = expandedBeat === beat.name;
                    const matchedEvent = beatMatches[i];

                    return (
                        <div key={i} className="group">
                            <button
                                onClick={() => setExpandedBeat(isExpanded ? null : beat.name)}
                                className={clsx(
                                    "w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all text-left",
                                    isExpanded
                                        ? "bg-white dark:bg-stone-800 shadow-sm ring-1 ring-stone-200 dark:ring-stone-700"
                                        : "hover:bg-stone-50 dark:hover:bg-stone-800/50"
                                )}
                            >
                                <div className="w-3 h-3 rounded-full shrink-0" style={{ backgroundColor: beat.color }} />
                                <span className="flex-1 text-sm font-medium text-stone-700 dark:text-stone-300">{beat.name}</span>
                                <span className="text-[10px] font-mono text-stone-400 dark:text-stone-500">{beat.percentage}%</span>
                                {matchedEvent && (
                                    <span className="flex items-center gap-1 px-2 py-0.5 bg-emerald-50 dark:bg-emerald-900/20 text-emerald-600 dark:text-emerald-400 rounded-full text-[10px] font-medium">
                                        <Check className="w-3 h-3" />
                                        Mapped
                                    </span>
                                )}
                                {isExpanded ? <ChevronDown className="w-4 h-4 text-stone-400" /> : <ChevronRight className="w-4 h-4 text-stone-400" />}
                            </button>

                            {isExpanded && (
                                <div className="ml-10 mt-1 mb-3 p-3 bg-stone-50 dark:bg-stone-800/50 rounded-lg border border-stone-100 dark:border-stone-700 animate-in fade-in slide-in-from-top-1 duration-200">
                                    <p className="text-sm text-stone-600 dark:text-stone-400">{beat.description}</p>
                                    {matchedEvent ? (
                                        <div className="mt-2 flex items-center gap-2 text-xs text-stone-500 dark:text-stone-400">
                                            <Check className="w-3 h-3 text-emerald-500" />
                                            Closest event: <span className="font-medium text-stone-700 dark:text-stone-300">"{matchedEvent.title}"</span>
                                        </div>
                                    ) : (
                                        <button
                                            onClick={() => handleCreateFromBeat(beat.name)}
                                            className="mt-2 flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium bg-indigo-50 dark:bg-indigo-900/30 text-indigo-600 dark:text-indigo-400 rounded-lg hover:bg-indigo-100 dark:hover:bg-indigo-900/50 transition-colors"
                                        >
                                            <Wand2 className="w-3 h-3" />
                                            Create event from this beat
                                        </button>
                                    )}
                                </div>
                            )}
                        </div>
                    );
                })}
            </div>
        </div>
    );
};
