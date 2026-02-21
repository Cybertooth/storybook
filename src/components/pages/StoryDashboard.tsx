import { useState, useEffect, useMemo } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { storage } from '@/lib/storage';
import { Story } from '@/types';
import { BookOpen, Plus, Trash2, Clock, FileText, Users, Map, GitBranch, Flame, Target, TrendingUp } from 'lucide-react';
import clsx from 'clsx';

export const StoryDashboard = () => {
    const { currentStory, characters, locations, events, chapters, loadStory, createStory } = useStoryStore();
    const [stories, setStories] = useState<Story[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [showCreate, setShowCreate] = useState(false);
    const [newTitle, setNewTitle] = useState('');

    // Load all stories on mount
    useEffect(() => {
        loadStories();
    }, []);

    const loadStories = async () => {
        setIsLoading(true);
        const list = await storage.getAllStories();
        setStories(list);
        setIsLoading(false);
    };

    const handleCreate = async () => {
        if (!newTitle.trim()) return;
        await createStory(newTitle.trim());
        setNewTitle('');
        setShowCreate(false);
        await loadStories();
    };

    const handleDelete = async (id: string) => {
        if (!window.confirm('Delete this story? This cannot be undone.')) return;
        await storage.deleteStory(id);
        if (currentStory?.id === id) {
            // Load another story or clear
            const remaining = stories.filter(s => s.id !== id);
            if (remaining.length > 0) {
                await loadStory(remaining[0].id);
            }
        }
        await loadStories();
    };

    // Writing stats for current story
    const totalWords = useMemo(() => {
        return chapters.reduce((total, ch) => {
            return total + (ch.content.trim() ? ch.content.trim().split(/\s+/).length : 0);
        }, 0);
    }, [chapters]);

    const totalChaptersDone = chapters.filter(c => c.status === 'completed').length;

    // Simple streak calculation based on story updatedAt
    const daysSinceUpdate = currentStory
        ? Math.floor((Date.now() - currentStory.updatedAt) / (1000 * 60 * 60 * 24))
        : 0;

    const streakEmoji = daysSinceUpdate === 0 ? '🔥' : daysSinceUpdate === 1 ? '✨' : daysSinceUpdate < 7 ? '💪' : '😴';

    return (
        <div className="max-w-6xl mx-auto space-y-8">
            {/* Header */}
            <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                    <div className="p-2 bg-indigo-100/50 dark:bg-indigo-900/30 rounded-lg text-indigo-700 dark:text-indigo-400">
                        <BookOpen className="w-5 h-5" />
                    </div>
                    <div>
                        <h2 className="text-2xl font-serif font-bold text-stone-900 dark:text-stone-100 tracking-tight">Story Dashboard</h2>
                        <p className="text-stone-500 dark:text-stone-400 text-xs font-medium uppercase tracking-wide">Your creative workspace</p>
                    </div>
                </div>
                <button
                    onClick={() => setShowCreate(true)}
                    className="flex items-center gap-2 px-4 py-2 bg-stone-900 dark:bg-stone-100 text-white dark:text-stone-900 rounded-lg hover:bg-stone-700 dark:hover:bg-stone-300 transition-colors text-sm font-medium"
                >
                    <Plus className="w-4 h-4" />
                    New Story
                </button>
            </div>

            {/* Create Story Form */}
            {showCreate && (
                <div className="glass-panel rounded-xl p-4 animate-in fade-in slide-in-from-top-2 duration-200">
                    <div className="flex gap-3">
                        <input
                            autoFocus
                            type="text"
                            value={newTitle}
                            onChange={e => setNewTitle(e.target.value)}
                            placeholder="What's your story called?"
                            className="flex-1 px-4 py-2 border border-stone-200 dark:border-stone-600 dark:bg-stone-800 dark:text-stone-200 rounded-lg text-sm focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                            onKeyDown={e => { if (e.key === 'Enter') handleCreate(); if (e.key === 'Escape') setShowCreate(false); }}
                        />
                        <button onClick={handleCreate} className="px-4 py-2 bg-indigo-600 text-white text-sm rounded-lg hover:bg-indigo-700 font-medium">Create</button>
                        <button onClick={() => setShowCreate(false)} className="px-3 py-2 text-stone-500 hover:text-stone-700 dark:hover:text-stone-300 text-sm">Cancel</button>
                    </div>
                </div>
            )}

            {/* Current Story Stats */}
            {currentStory && (
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <div className="glass-panel rounded-xl p-4">
                        <div className="flex items-center gap-2 text-stone-400 dark:text-stone-500 mb-2">
                            <FileText className="w-4 h-4" />
                            <span className="text-[10px] font-bold uppercase tracking-wider">Word Count</span>
                        </div>
                        <div className="text-2xl font-bold text-stone-900 dark:text-stone-100">{totalWords.toLocaleString()}</div>
                        <div className="mt-2 flex items-center gap-2">
                            <div className="flex-1 h-1.5 bg-stone-100 dark:bg-stone-700 rounded-full overflow-hidden">
                                <div className="h-full bg-indigo-500 rounded-full transition-all" style={{ width: `${Math.min((totalWords / 50000) * 100, 100)}%` }}></div>
                            </div>
                            <span className="text-[10px] text-stone-400">/ 50k</span>
                        </div>
                    </div>

                    <div className="glass-panel rounded-xl p-4">
                        <div className="flex items-center gap-2 text-stone-400 dark:text-stone-500 mb-2">
                            <Target className="w-4 h-4" />
                            <span className="text-[10px] font-bold uppercase tracking-wider">Progress</span>
                        </div>
                        <div className="text-2xl font-bold text-stone-900 dark:text-stone-100">{totalChaptersDone}/{chapters.length}</div>
                        <p className="text-xs text-stone-400 dark:text-stone-500 mt-1">chapters completed</p>
                    </div>

                    <div className="glass-panel rounded-xl p-4">
                        <div className="flex items-center gap-2 text-stone-400 dark:text-stone-500 mb-2">
                            <TrendingUp className="w-4 h-4" />
                            <span className="text-[10px] font-bold uppercase tracking-wider">Assets</span>
                        </div>
                        <div className="flex items-center gap-3 mt-1">
                            <span className="flex items-center gap-1 text-sm font-medium text-stone-700 dark:text-stone-300">
                                <Users className="w-3 h-3 text-amber-500" /> {characters.length}
                            </span>
                            <span className="flex items-center gap-1 text-sm font-medium text-stone-700 dark:text-stone-300">
                                <Map className="w-3 h-3 text-emerald-500" /> {locations.length}
                            </span>
                            <span className="flex items-center gap-1 text-sm font-medium text-stone-700 dark:text-stone-300">
                                <GitBranch className="w-3 h-3 text-indigo-500" /> {events.length}
                            </span>
                        </div>
                    </div>

                    <div className="glass-panel rounded-xl p-4">
                        <div className="flex items-center gap-2 text-stone-400 dark:text-stone-500 mb-2">
                            <Flame className="w-4 h-4" />
                            <span className="text-[10px] font-bold uppercase tracking-wider">Streak</span>
                        </div>
                        <div className="text-2xl font-bold text-stone-900 dark:text-stone-100">{streakEmoji}</div>
                        <p className="text-xs text-stone-400 dark:text-stone-500 mt-1">
                            {daysSinceUpdate === 0 ? 'Updated today!' : daysSinceUpdate === 1 ? 'Updated yesterday' : `${daysSinceUpdate} days ago`}
                        </p>
                    </div>
                </div>
            )}

            {/* Story List */}
            <div>
                <h3 className="text-xs font-bold text-stone-400 dark:text-stone-500 uppercase tracking-wider mb-3">
                    All Stories ({stories.length})
                </h3>
                {isLoading ? (
                    <div className="text-center py-12 text-stone-400">Loading stories...</div>
                ) : stories.length === 0 ? (
                    <div className="glass-panel rounded-xl p-12 text-center">
                        <BookOpen className="w-12 h-12 mx-auto text-stone-300 dark:text-stone-600 mb-4" />
                        <p className="text-stone-500 dark:text-stone-400 font-medium">No stories yet</p>
                        <p className="text-sm text-stone-400 dark:text-stone-500 mt-1">Create your first story to get started!</p>
                    </div>
                ) : (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                        {stories.sort((a, b) => b.updatedAt - a.updatedAt).map(story => {
                            const isActive = currentStory?.id === story.id;
                            const ago = Math.floor((Date.now() - story.updatedAt) / (1000 * 60 * 60 * 24));
                            return (
                                <div
                                    key={story.id}
                                    className={clsx(
                                        "glass-panel rounded-xl p-5 cursor-pointer transition-all group relative",
                                        isActive
                                            ? "ring-2 ring-indigo-400 dark:ring-indigo-500 bg-indigo-50/30 dark:bg-indigo-900/10"
                                            : "hover:shadow-md hover:-translate-y-0.5"
                                    )}
                                    onClick={() => !isActive && loadStory(story.id)}
                                >
                                    {isActive && (
                                        <span className="absolute top-3 right-3 text-[9px] font-bold bg-indigo-100 dark:bg-indigo-900/40 text-indigo-600 dark:text-indigo-400 px-2 py-0.5 rounded-full uppercase tracking-wider">
                                            Active
                                        </span>
                                    )}
                                    {!isActive && (
                                        <button
                                            onClick={(e) => { e.stopPropagation(); handleDelete(story.id); }}
                                            className="absolute top-3 right-3 p-1 opacity-0 group-hover:opacity-100 text-stone-400 hover:text-red-500 transition-all"
                                        >
                                            <Trash2 className="w-3.5 h-3.5" />
                                        </button>
                                    )}
                                    <h4 className="font-bold text-stone-800 dark:text-stone-200 text-lg font-serif">{story.title}</h4>
                                    {story.summary && (
                                        <p className="text-xs text-stone-500 dark:text-stone-400 mt-2 line-clamp-2">{story.summary}</p>
                                    )}
                                    <div className="flex items-center gap-2 mt-3 text-[10px] text-stone-400 dark:text-stone-500">
                                        <Clock className="w-3 h-3" />
                                        {ago === 0 ? 'Today' : ago === 1 ? 'Yesterday' : `${ago} days ago`}
                                    </div>
                                </div>
                            );
                        })}
                    </div>
                )}
            </div>
        </div>
    );
};
