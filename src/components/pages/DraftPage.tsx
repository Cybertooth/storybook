import { useState } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { ChapterList } from '../features/editor/ChapterList';
import { MarkdownEditor } from '../features/editor/MarkdownEditor';
import { Edit3, LayoutPanelLeft, Focus, Target } from 'lucide-react';
import clsx from 'clsx';

export const DraftPage = () => {
    const { chapters, createChapter, updateChapter, deleteChapter, characters, locations, events } = useStoryStore();
    const [selectedId, setSelectedId] = useState<string | null>(null);
    const [isFocusMode, setIsFocusMode] = useState(false);
    const [showSidebar, setShowSidebar] = useState(false);
    const [referenceType, setReferenceType] = useState<'characters' | 'locations' | 'events'>('characters');

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
                        </div>
                    </div>
                    <div className="p-4 space-y-4">
                        {referenceType === 'characters' && characters.map(c => (
                            <div key={c.id} className="bg-white dark:bg-stone-800 p-3 rounded-xl border border-stone-200 dark:border-stone-700 hover:border-indigo-200 dark:hover:border-indigo-500/50 transition-colors shadow-sm">
                                <h4 className="font-bold text-stone-800 dark:text-stone-200 text-sm flex justify-between items-start">
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
                        ))}
                        {referenceType === 'locations' && locations.map(l => (
                            <div key={l.id} className="bg-white dark:bg-stone-800 p-3 rounded-xl border border-stone-200 dark:border-stone-700 hover:border-emerald-200 dark:hover:border-emerald-500/50 transition-colors shadow-sm">
                                <h4 className="font-bold text-stone-800 dark:text-stone-200 text-sm">{l.name}</h4>
                                <p className="text-xs text-stone-600 dark:text-stone-400 mt-2">{l.description}</p>
                            </div>
                        ))}
                        {referenceType === 'events' && events.map(e => (
                            <div key={e.id} className="bg-white dark:bg-stone-800 p-3 rounded-xl border border-stone-200 dark:border-stone-700 hover:border-amber-200 dark:hover:border-amber-500/50 transition-colors shadow-sm relative pl-4">
                                <div className="absolute left-0 top-0 bottom-0 w-1 bg-amber-400 rounded-l-xl"></div>
                                <h4 className="font-bold text-stone-800 dark:text-stone-200 text-sm">{e.title}</h4>
                                <p className="text-xs text-stone-600 mt-1">{e.description}</p>
                            </div>
                        ))}
                    </div>
                </div>
            )}
        </div>
    );
};
