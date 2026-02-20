import React from 'react';
import { NavLink, Outlet } from 'react-router-dom';
import { BookOpen, Users, Map, GitGraph, Edit3, Settings, Check, Loader2 } from 'lucide-react';
import clsx from 'clsx';
import { useStoryStore } from '@/store/useStoryStore';

import { AiConsole } from '../ui/AiConsole';

const NavItem = ({ to, icon: Icon, label }: { to: string; icon: React.ElementType; label: string }) => (
    <NavLink to={to}>
        {({ isActive }) => (
            <div
                className={clsx(
                    "flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-300 text-sm font-medium relative overflow-hidden group",
                    isActive
                        ? "text-stone-900 bg-white/60 shadow-sm ring-1 ring-stone-900/5 backdrop-blur-sm"
                        : "text-stone-600 hover:text-stone-900 hover:bg-white/40"
                )}
            >
                <Icon className={clsx("w-4 h-4 transition-transform duration-300 group-hover:scale-110", isActive && "text-indigo-600")} />
                <span>{label}</span>
                {isActive && <div className="absolute left-0 top-1/2 -translate-y-1/2 w-1 h-8 bg-indigo-600 rounded-r-full" />}
            </div>
        )}
    </NavLink>
);

export const AppShell = () => {
    return (
        <div className="flex h-screen font-sans text-stone-900 overflow-hidden">
            {/* Sidebar - Floating Glass */}
            <aside className="w-72 p-4 flex flex-col z-20">
                <div className="flex-1 glass-panel rounded-2xl flex flex-col overflow-hidden">
                    <div className="p-6 border-b border-white/20">
                        <h1 className="text-2xl font-serif font-bold tracking-tight flex items-center gap-3 text-stone-800">
                            <div className="w-8 h-8 rounded-lg bg-indigo-600 flex items-center justify-center text-white shadow-lg shadow-indigo-500/30">
                                <BookOpen className="w-5 h-5" />
                            </div>
                            Storybook
                        </h1>
                    </div>

                    <nav className="flex-1 p-4 space-y-2 overflow-y-auto">
                        <NavItem to="/" icon={BookOpen} label="Story Engine" />
                        <NavItem to="/characters" icon={Users} label="Characters" />
                        <NavItem to="/locations" icon={Map} label="World" />
                        <NavItem to="/timeline" icon={GitGraph} label="Timeline" />
                        <NavItem to="/write" icon={Edit3} label="Draft" />
                    </nav>

                    <div className="p-4 border-t border-white/20 space-y-2">
                        <div className="px-4 py-2 text-xs font-medium text-stone-500 flex items-center justify-between">
                            <span>Status</span>
                            {useStoryStore(s => s.isSaving) ? (
                                <span className="flex items-center gap-1.5 text-indigo-600 animate-pulse">
                                    <Loader2 className="w-3 h-3 animate-spin" />
                                    Saving...
                                </span>
                            ) : (
                                <span className="flex items-center gap-1.5 text-emerald-600">
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
            <main className="flex-1 overflow-auto relative z-10">
                <div className="max-w-6xl mx-auto p-8 lg:p-12">
                    <Outlet />
                </div>
            </main>
            <AiConsole />
        </div>
    );
};
