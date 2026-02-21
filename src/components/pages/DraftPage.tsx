import { useState } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { ChapterList } from '../features/editor/ChapterList';
import { MarkdownEditor } from '../features/editor/MarkdownEditor';
import { Edit3, LayoutPanelLeft, Focus, Target, Pin } from 'lucide-react';
import clsx from 'clsx';
import { ShowDontTell } from '../features/draft/ShowDontTell';

export const DraftPage = () => {
    const { chapters, createChapter, updateChapter, deleteChapter, characters, locations, events, pinnedRefs, togglePin } = useStoryStore();
    const [selectedId, setSelectedId] = useState<string | null>(null);
    const [isFocusMode, setIsFocusMode] = useState(false);
    const [showSidebar, setShowSidebar] = useState(false);
    const [referenceType, setReferenceType] = useState<'characters' | 'locations' | 'events' | 'prose'>('characters');

    const activeChapter = chapters.find(c => c.id === selectedId);

    const handleCreate = async (title: string) => {
        await createChapter(title);
    };

    // Calculate total word count
    const totalWords = chapters.reduce((total, chapter) => {
        return total + (chapter.content.trim() ? chapter.content.trim().split(/\s+/).length : 0);
    }, 0);
    const dailyGoal = 1667; // standard nanowrimo goal
    const goalProgress = Math.min((totalWords / dailyGoal) * 100, 100);

    return (
        <div className={clsx(
            "flex h-[calc(100vh-96px)] -mx-8 -mb-12 lg:-mx-12 rounded-tl-2xl overflow-hidden border border-stone-200/50 shadow-sm transition-all duration-500",
            isFocusMode ? "fixed inset-0 z-50 h-screen m-0 rounded-none" : ""
        )}>
            {!isFocusMode && (
                <ChapterList
                    chapters={chapters}
                    selectedId={selectedId}
                    onSelect={setSelectedId}
                    onCreate={handleCreate}
                    onDelete={deleteChapter}
                />
            )}

            <div className="flex-1 bg-white dark:bg-stone-950 h-full flex flex-col overflow-hidden relative transition-all duration-300">
                {/* Editor Header Tools */}
                <div className="absolute top-4 right-8 z-20 flex gap-2">
                    <div className="flex items-center gap-2 px-3 py-1.5 bg-stone-100 dark:bg-stone-900 rounded-md text-xs font-medium text-stone-600 dark:text-stone-300 shadow-sm mr-4" title="Total Word Count">
                        <Target className="w-3 h-3 text-indigo-500" />
                        <span>{totalWords.toLocaleString()} / {dailyGoal.toLocaleString()}</span>
                        <div className="w-16 h-1.5 bg-stone-200 rounded-full overflow-hidden ml-1">
                            <div className="h-full bg-indigo-500" style={{ width: `${goalProgress}%` }}></div>
                        </div>
                    </div>
                    <button
                        onClick={() => setIsFocusMode(!isFocusMode)}
                        className={clsx(
                            "p-2 rounded-md transition-colors shadow-sm",
                            isFocusMode ? "bg-indigo-100 dark:bg-indigo-900/50 text-indigo-700 dark:text-indigo-300" : "bg-white dark:bg-stone-900 border border-stone-200 dark:border-stone-800 text-stone-500 dark:text-stone-400 hover:bg-stone-50 dark:hover:bg-stone-800"
                        )}
                        title="Toggle Focus Mode"
                    >
                        <Focus className="w-4 h-4" />
                    </button>
                    {!isFocusMode && (
                        <button
                            onClick={() => setShowSidebar(!showSidebar)}
                            className={clsx(
                                "p-2 rounded-md transition-colors shadow-sm flex items-center gap-2 text-xs font-medium",
                                showSidebar ? "bg-indigo-100 dark:bg-indigo-900/50 text-indigo-700 dark:text-indigo-300" : "bg-white dark:bg-stone-900 border border-stone-200 dark:border-stone-800 text-stone-500 dark:text-stone-400 hover:bg-stone-50 dark:hover:bg-stone-800"
                            )}
                            title="Toggle Reference Sidebar"
                        >
                            <LayoutPanelLeft className="w-4 h-4" />
                            <span>Reference</span>
                        </button>
                    )}
                </div>

                {activeChapter ? (
                    <MarkdownEditor
                        chapter={activeChapter}
                        onUpdate={updateChapter}
                    />
                ) : (
                    <div className="h-full flex flex-col items-center justify-center text-stone-400 space-y-3">
                        <div className="w-16 h-16 bg-stone-100 rounded-2xl flex items-center justify-center">
                            <Edit3 className="w-8 h-8 text-stone-300" />
                        </div>
                        <div className="text-center">
                            <p className="font-medium text-stone-500">Select a chapter to start writing</p>
                            <p className="text-sm mt-1">Or create a new one from the sidebar</p>
                        </div>
                    </div>
                )}
            </div>

            {/* Reference Sidebar Pane */}
            {!isFocusMode && showSidebar && (
                <div className="w-80 bg-stone-50 dark:bg-stone-900/50 h-full border-l border-stone-200 dark:border-stone-800 overflow-y-auto hidden lg:flex flex-col animate-in slide-in-from-right-8 duration-300">
                    <div className="p-4 border-b border-stone-200 dark:border-stone-800 sticky top-0 bg-stone-50/90 dark:bg-stone-900/90 backdrop-blur z-10">
                        <h3 className="font-bold text-stone-800 dark:text-stone-200 flex items-center gap-2 mb-3">
                            <LayoutPanelLeft className="w-4 h-4 text-indigo-500" />
                            Project Reference
                        </h3>
                        <div className="flex bg-stone-200/50 dark:bg-stone-800/50 p-1 rounded-lg">
                            <button
                                onClick={() => setReferenceType('characters')}
                                className={clsx("flex-1 text-xs py-1 px-2 rounded-md font-medium transition-all", referenceType === 'characters' ? "bg-white dark:bg-stone-700 shadow text-stone-800 dark:text-stone-100" : "text-stone-500 dark:text-stone-400 hover:text-stone-700 dark:hover:text-stone-200")}
                            >
                                Chars
                            </button>
                            <button
                                onClick={() => setReferenceType('locations')}
                                className={clsx("flex-1 text-xs py-1 px-2 rounded-md font-medium transition-all", referenceType === 'locations' ? "bg-white dark:bg-stone-700 shadow text-stone-800 dark:text-stone-100" : "text-stone-500 dark:text-stone-400 hover:text-stone-700 dark:hover:text-stone-200")}
                            >
                                Locs
                            </button>
                            <button
                                onClick={() => setReferenceType('events')}
                                className={clsx("flex-1 text-xs py-1 px-2 rounded-md font-medium transition-all", referenceType === 'events' ? "bg-white dark:bg-stone-700 shadow text-stone-800 dark:text-stone-100" : "text-stone-500 dark:text-stone-400 hover:text-stone-700 dark:hover:text-stone-200")}
                            >
                                Plot
                            </button>
                            <button
                                onClick={() => setReferenceType('prose')}
                                className={clsx("flex-1 text-xs py-1 px-2 rounded-md font-medium transition-all", referenceType === 'prose' ? "bg-white dark:bg-stone-700 shadow text-stone-800 dark:text-stone-100" : "text-stone-500 dark:text-stone-400 hover:text-stone-700 dark:hover:text-stone-200")}
                            >
                                Prose
                            </button>
                        </div>
                    </div>
                    <div className="p-4 space-y-6">
                        {/* Pinned Items Section */}
                        {pinnedRefs.length > 0 && (
                            <div className="space-y-4">
                                <h3 className="text-xs font-bold text-stone-400 uppercase tracking-widest flex items-center gap-2">
                                    <Pin className="w-3 h-3" />
                                    Pinned Reference
                                </h3>
                                <div className="space-y-3">
                                    {pinnedRefs.map(ref => {
                                        if (ref.type === 'character') {
                                            const c = characters.find(c => c.id === ref.id);
                                            if (!c) return null;
                                            return (
                                                <div key={`pin-${c.id}`} className="bg-stone-800 p-3 rounded-xl border border-stone-700 shadow-sm relative group">
                                                    <button onClick={() => togglePin(c.id, 'character')} className="absolute top-2 right-2 p-1 text-indigo-400 hover:text-indigo-300 opacity-0 group-hover:opacity-100 transition-opacity">
                                                        <Pin className="w-3 h-3 fill-current" />
                                                    </button>
                                                    <h4 className="font-bold text-stone-100 text-sm flex justify-between items-start pr-6">
                                                        {c.name}
                                                    </h4>
                                                    <p className="text-xs text-stone-300 mt-2 line-clamp-3">{c.description}</p>
                                                </div>
                                            );
                                        }
                                        if (ref.type === 'location') {
                                            const l = locations.find(l => l.id === ref.id);
                                            if (!l) return null;
                                            return (
                                                <div key={`pin-${l.id}`} className="bg-stone-800 p-3 rounded-xl border border-stone-700 shadow-sm relative group">
                                                    <button onClick={() => togglePin(l.id, 'location')} className="absolute top-2 right-2 p-1 text-indigo-400 hover:text-indigo-300 opacity-0 group-hover:opacity-100 transition-opacity">
                                                        <Pin className="w-3 h-3 fill-current" />
                                                    </button>
                                                    <h4 className="font-bold text-stone-100 text-sm pr-6">{l.name}</h4>
                                                    <p className="text-xs text-stone-300 mt-2 line-clamp-3">{l.description}</p>
                                                </div>
                                            );
                                        }
                                        if (ref.type === 'event') {
                                            const e = events.find(e => e.id === ref.id);
                                            if (!e) return null;
                                            return (
                                                <div key={`pin-${e.id}`} className="bg-stone-800 p-3 rounded-xl border border-stone-700 shadow-sm relative group">
                                                    <button onClick={() => togglePin(e.id, 'event')} className="absolute top-2 right-2 p-1 text-indigo-400 hover:text-indigo-300 opacity-0 group-hover:opacity-100 transition-opacity">
                                                        <Pin className="w-3 h-3 fill-current" />
                                                    </button>
                                                    <h4 className="font-bold text-stone-100 text-sm pr-6">{e.title}</h4>
                                                    <p className="text-xs text-stone-300 mt-2 line-clamp-3">{e.description}</p>
                                                </div>
                                            );
                                        }
                                        return null;
                                    })}
                                </div>
                                <hr className="border-stone-200 dark:border-stone-800" />
                            </div>
                        )}

                        {/* Standard Tabbed Items */}
                        <div className="space-y-4">
                            {referenceType === 'characters' && characters.map(c => {
                                const isPinned = pinnedRefs.some(p => p.id === c.id);
                                return (
                                    <div key={c.id} className={clsx("p-3 rounded-xl border transition-colors shadow-sm relative group", isPinned ? "bg-indigo-50 dark:bg-indigo-900/10 border-indigo-200 dark:border-indigo-800/50" : "bg-white dark:bg-stone-800 border-stone-200 dark:border-stone-700 hover:border-indigo-200 dark:hover:border-indigo-500/50")}>
                                        <button onClick={() => togglePin(c.id, 'character')} className={clsx("absolute top-2 right-2 p-1 transition-opacity", isPinned ? "text-indigo-500 opacity-100" : "text-stone-400 opacity-0 group-hover:opacity-100 hover:text-indigo-500")}>
                                            <Pin className={clsx("w-3 h-3", isPinned && "fill-current")} />
                                        </button>
                                        <h4 className={clsx("font-bold text-sm flex justify-between items-start pr-6", isPinned ? "text-indigo-900 dark:text-indigo-300" : "text-stone-800 dark:text-stone-200")}>
                                            {c.name}
                                            <span className="text-[10px] font-normal uppercase bg-stone-100 dark:bg-stone-900 px-1.5 py-0.5 rounded text-stone-500 dark:text-stone-400">{c.role}</span>
                                        </h4>
                                        <p className="text-xs text-stone-600 dark:text-stone-400 mt-2 line-clamp-4">{c.description}</p>
                                        {(c.arcLie || c.arcTruth) && (
                                            <div className="mt-2 pt-2 border-t border-stone-100 dark:border-stone-700 flex flex-col gap-1 text-[10px]">
                                                {c.arcLie && <span className="text-red-600/80 dark:text-red-400/80 line-clamp-1"><span className="font-semibold text-stone-500 dark:text-stone-400">Lie:</span> {c.arcLie}</span>}
                                                {c.arcTruth && <span className="text-emerald-600/80 dark:text-emerald-400/80 line-clamp-1"><span className="font-semibold text-stone-500 dark:text-stone-400">Truth:</span> {c.arcTruth}</span>}
                                            </div>
                                        )}
                                    </div>
                                )
                            })}
                            {referenceType === 'locations' && locations.map(l => {
                                const isPinned = pinnedRefs.some(p => p.id === l.id);
                                return (
                                    <div key={l.id} className={clsx("p-3 rounded-xl border transition-colors shadow-sm relative group", isPinned ? "bg-emerald-50 dark:bg-emerald-900/10 border-emerald-200 dark:border-emerald-800/50" : "bg-white dark:bg-stone-800 border-stone-200 dark:border-stone-700 hover:border-emerald-200 dark:hover:border-emerald-500/50")}>
                                        <button onClick={() => togglePin(l.id, 'location')} className={clsx("absolute top-2 right-2 p-1 transition-opacity", isPinned ? "text-emerald-500 opacity-100" : "text-stone-400 opacity-0 group-hover:opacity-100 hover:text-emerald-500")}>
                                            <Pin className={clsx("w-3 h-3", isPinned && "fill-current")} />
                                        </button>
                                        <h4 className={clsx("font-bold text-sm pr-6", isPinned ? "text-emerald-900 dark:text-emerald-300" : "text-stone-800 dark:text-stone-200")}>{l.name}</h4>
                                        <p className="text-xs text-stone-600 dark:text-stone-400 mt-2">{l.description}</p>
                                    </div>
                                )
                            })}
                            {referenceType === 'events' && events.map(e => {
                                const isPinned = pinnedRefs.some(p => p.id === e.id);
                                return (
                                    <div key={e.id} className={clsx("p-3 rounded-xl border transition-colors shadow-sm relative pl-4 group", isPinned ? "bg-amber-50 dark:bg-amber-900/10 border-amber-200 dark:border-amber-800/50" : "bg-white dark:bg-stone-800 border-stone-200 dark:border-stone-700 hover:border-amber-200 dark:hover:border-amber-500/50")}>
                                        <div className="absolute left-0 top-0 bottom-0 w-1 bg-amber-400 rounded-l-xl"></div>
                                        <button onClick={() => togglePin(e.id, 'event')} className={clsx("absolute top-2 right-2 p-1 transition-opacity", isPinned ? "text-amber-500 opacity-100" : "text-stone-400 opacity-0 group-hover:opacity-100 hover:text-amber-500")}>
                                            <Pin className={clsx("w-3 h-3", isPinned && "fill-current")} />
                                        </button>
                                        <h4 className={clsx("font-bold text-sm pr-6", isPinned ? "text-amber-900 dark:text-amber-300" : "text-stone-800 dark:text-stone-200")}>{e.title}</h4>
                                        <p className="text-xs text-stone-600 mt-1">{e.description}</p>
                                    </div>
                                )
                            })}
                            {referenceType === 'prose' && activeChapter && (
                                <ShowDontTell
                                    draftText={activeChapter.content}
                                    onApplySuggestion={(original, replacement) => {
                                        const newContent = activeChapter.content.replace(original, replacement);
                                        updateChapter(activeChapter.id, { content: newContent });
                                    }}
                                />
                            )}
                            {referenceType === 'prose' && !activeChapter && (
                                <div className="text-center py-8 text-stone-400 dark:text-stone-500">
                                    <p className="text-sm">Select a chapter first to analyze its prose.</p>
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};
