import React from 'react';
import { NavLink, Outlet } from 'react-router-dom';
import { BookOpen, Users, Map, GitGraph, Edit3, Settings, Check, Loader2, Save, FolderOpen, FilePlus, Lightbulb, Undo2, Redo2, LayoutDashboard } from 'lucide-react';
import clsx from 'clsx';
import { useStoryStore, useTemporalStoryStore } from '@/store/useStoryStore';
import { useToastStore } from '@/hooks/useToast';
import { ThemeToggle } from '../ThemeToggle';
import { AiConsole } from '../ui/AiConsole';
import { UnresolvedQuestionsPanel } from '../ui/UnresolvedQuestionsPanel';

const NavItem = ({ to, icon: Icon, label }: { to: string; icon: React.ElementType; label: string }) => (
    <NavLink to={to}>
        {({ isActive }) => (
            <div
                className={clsx(
                    "flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-300 text-sm font-medium relative overflow-hidden group",
                    isActive
                        ? "text-stone-900 dark:text-stone-100 bg-white/60 dark:bg-stone-700/60 shadow-sm ring-1 ring-stone-900/5 dark:ring-stone-500/20 backdrop-blur-sm"
                        : "text-stone-600 dark:text-stone-400 hover:text-stone-900 dark:hover:text-stone-100 hover:bg-white/40 dark:hover:bg-stone-700/40"
                )}
            >
                <Icon className={clsx("w-4 h-4 transition-transform duration-300 group-hover:scale-110", isActive && "text-indigo-600 dark:text-indigo-400")} />
                <span>{label}</span>
                {isActive && <div className="absolute left-0 top-1/2 -translate-y-1/2 w-1 h-8 bg-indigo-600 dark:bg-indigo-400 rounded-r-full" />}
            </div>
        )}
    </NavLink>
);

export const AppShell = () => {
    const toast = useToastStore(s => s.toast);
    const storyTitle = useStoryStore(s => s.currentStory?.title);
    const projectFileName = useStoryStore(s => s.projectFileName);
    const saveProjectToFile = useStoryStore(s => s.saveProjectToFile);
    const loadProjectFromFile = useStoryStore(s => s.loadProjectFromFile);
    const newProject = useStoryStore(s => s.newProject);

    // Zundo time-travel
    const { undo, redo, pastStates, futureStates } = useTemporalStoryStore((state) => state);

    React.useEffect(() => {
        useStoryStore.getState().init();
    }, []);

    const handleSave = async () => {
        await saveProjectToFile();
        toast('Project saved!', 'success');
    };

    const handleLoad = async () => {
        await loadProjectFromFile();
        toast('Project loaded!', 'success');
    };

    const handleNew = async () => {
        if (!window.confirm('Create a new project? Make sure to save your current work first.')) return;
        await newProject();
        toast('New project created!', 'info');
    };

    return (
        <div className="flex h-screen font-sans text-stone-900 dark:text-stone-100 overflow-hidden">
            {/* Sidebar - Floating Glass */}
            <aside className="w-72 p-4 flex flex-col z-20">
                <div className="flex-1 glass-panel rounded-2xl flex flex-col overflow-hidden">
                    <div className="p-6 border-b border-white/20 dark:border-stone-800/50">
                        <div className="flex items-center justify-between">
                            <h1 className="text-2xl font-serif font-bold tracking-tight flex items-center gap-3 text-stone-800 dark:text-stone-100">
                                <div className="w-8 h-8 rounded-lg bg-indigo-600 flex items-center justify-center text-white shadow-lg shadow-indigo-500/30">
                                    <BookOpen className="w-5 h-5" />
                                </div>
                                Storybook
                            </h1>
                            <div className="flex items-center gap-2">
                                <div className="flex bg-stone-100 dark:bg-stone-800/50 rounded-lg p-1 mr-2 border border-stone-200 dark:border-stone-700/50">
                                    <button
                                        onClick={() => undo()}
                                        disabled={pastStates.length === 0}
                                        className="p-1.5 rounded-md text-stone-500 hover:text-stone-800 dark:hover:text-stone-200 hover:bg-white dark:hover:bg-stone-700 disabled:opacity-30 transition-all"
                                        title="Undo (Ctrl+Z)"
                                    >
                                        <Undo2 className="w-4 h-4" />
                                    </button>
                                    <button
                                        onClick={() => redo()}
                                        disabled={futureStates.length === 0}
                                        className="p-1.5 rounded-md text-stone-500 hover:text-stone-800 dark:hover:text-stone-200 hover:bg-white dark:hover:bg-stone-700 disabled:opacity-30 transition-all"
                                        title="Redo (Ctrl+Y)"
                                    >
                                        <Redo2 className="w-4 h-4" />
                                    </button>
                                </div>
                                <ThemeToggle />
                            </div>
                        </div>

                        {/* Project info */}
                        <div className="mt-3 space-y-2">
                            <p className="text-sm text-stone-700 dark:text-stone-300 font-medium truncate">
                                {storyTitle || 'No project'}
                            </p>
                            {projectFileName && (
                                <p className="text-[10px] text-stone-400 dark:text-stone-500 font-mono truncate" title={projectFileName}>
                                    📁 {projectFileName}
                                </p>
                            )}
                            <div className="flex gap-1.5">
                                <button
                                    onClick={handleSave}
                                    title="Save Project"
                                    className="flex items-center gap-1.5 px-2.5 py-1.5 text-xs font-medium text-stone-600 dark:text-stone-400 hover:text-stone-900 dark:hover:text-stone-100 bg-white/30 dark:bg-stone-700/30 hover:bg-white/60 dark:hover:bg-stone-700/60 rounded-lg transition-all border border-white/20 dark:border-stone-600/30"
                                >
                                    <Save className="w-3 h-3" />
                                    Save
                                </button>
                                <button
                                    onClick={handleLoad}
                                    title="Load Project"
                                    className="flex items-center gap-1.5 px-2.5 py-1.5 text-xs font-medium text-stone-600 dark:text-stone-400 hover:text-stone-900 dark:hover:text-stone-100 bg-white/30 dark:bg-stone-700/30 hover:bg-white/60 dark:hover:bg-stone-700/60 rounded-lg transition-all border border-white/20 dark:border-stone-600/30"
                                >
                                    <FolderOpen className="w-3 h-3" />
                                    Load
                                </button>
                                <button
                                    onClick={handleNew}
                                    title="New Project"
                                    className="flex items-center gap-1.5 px-2.5 py-1.5 text-xs font-medium text-stone-600 dark:text-stone-400 hover:text-stone-900 dark:hover:text-stone-100 bg-white/30 dark:bg-stone-700/30 hover:bg-white/60 dark:hover:bg-stone-700/60 rounded-lg transition-all border border-white/20 dark:border-stone-600/30"
                                >
                                    <FilePlus className="w-3 h-3" />
                                    New
                                </button>
                            </div>
                        </div>
                    </div>

                    <nav className="flex-1 p-4 space-y-2 overflow-y-auto">
                        <NavItem to="/" icon={BookOpen} label="Story Engine" />
                        <NavItem to="/characters" icon={Users} label="Characters" />
                        <NavItem to="/locations" icon={Map} label="World" />
                        <NavItem to="/scratchpad" icon={Lightbulb} label="Scratchpad" />
                        <NavItem to="/timeline" icon={GitGraph} label="Timeline" />
                        <NavItem to="/write" icon={Edit3} label="Draft" />
                        <NavItem to="/dashboard" icon={LayoutDashboard} label="Dashboard" />
                    </nav>

                    <div className="p-4 border-t border-white/20 dark:border-stone-800/50 space-y-2">
                        <div className="px-4 py-2 text-xs font-medium text-stone-500 dark:text-stone-400 flex items-center justify-between">
                            <span>Status</span>
                            {useStoryStore(s => s.isSaving) ? (
                                <span className="flex items-center gap-1.5 text-indigo-600 dark:text-indigo-400 animate-pulse">
                                    <Loader2 className="w-3 h-3 animate-spin" />
                                    Saving...
                                </span>
                            ) : (
                                <span className="flex items-center gap-1.5 text-emerald-600 dark:text-emerald-400">
                                    <Check className="w-3 h-3" />
                                    Saved
                                </span>
                            )}
                        </div>
                        <NavItem to="/settings" icon={Settings} label="Settings" />
                    </div>
                </div>
            </aside>

            {/* Main Content */}
            <main className="flex-1 overflow-auto relative z-10 bg-stone-50/50 dark:bg-stone-900/50 text-stone-900 dark:text-stone-100">
                <div className="max-w-6xl mx-auto p-8 lg:p-12">
                    <Outlet />
                </div>
            </main>
            <AiConsole />
            <UnresolvedQuestionsPanel />
        </div>
    );
};
