import { useState } from 'react';
import { Chapter } from '@/types';
import { Plus, FileText, Trash2, GripVertical } from 'lucide-react';
import clsx from 'clsx';

interface ChapterListProps {
    chapters: Chapter[];
    selectedId: string | null;
    onSelect: (id: string) => void;
    onCreate: (title: string) => void;
    onDelete: (id: string) => void;
}

export const ChapterList = ({ chapters, selectedId, onSelect, onCreate, onDelete }: ChapterListProps) => {
    const [isCreating, setIsCreating] = useState(false);
    const [newTitle, setNewTitle] = useState('');

    const handleCreate = (e: React.FormEvent) => {
        e.preventDefault();
        if (newTitle.trim()) {
            onCreate(newTitle);
            setNewTitle('');
            setIsCreating(false);
        }
    };

    return (
        <div className="w-64 border-r border-stone-200 h-full flex flex-col bg-stone-50">
            <div className="p-4 border-b border-stone-200 flex justify-between items-center">
                <h3 className="font-serif font-bold text-stone-700">Chapters</h3>
                <button onClick={() => setIsCreating(true)} className="p-1 hover:bg-stone-200 rounded">
                    <Plus className="w-4 h-4 text-stone-600" />
                </button>
            </div>

            {isCreating && (
                <form onSubmit={handleCreate} className="p-2 border-b border-stone-200">
                    <input
                        autoFocus
                        type="text"
                        value={newTitle}
                        onChange={(e) => setNewTitle(e.target.value)}
                        placeholder="Chapter Title"
                        className="w-full px-2 py-1 text-sm border border-stone-300 rounded"
                        onBlur={() => !newTitle && setIsCreating(false)}
                    />
                </form>
            )}

            <div className="flex-1 overflow-y-auto">
                {chapters.map((chapter) => (
                    <div
                        key={chapter.id}
                        onClick={() => onSelect(chapter.id)}
                        className={clsx(
                            "group flex items-center gap-2 px-4 py-3 cursor-pointer border-b border-stone-100 transition-colors",
                            selectedId === chapter.id ? "bg-white border-l-4 border-l-stone-800" : "hover:bg-stone-100 border-l-4 border-l-transparent"
                        )}
                    >
                        <GripVertical className="w-3 h-3 text-stone-300 opacity-0 group-hover:opacity-100 cursor-grab" />
                        <FileText className={clsx("w-4 h-4", selectedId === chapter.id ? "text-stone-800" : "text-stone-400")} />
                        <span className={clsx("text-sm font-medium truncate flex-1", selectedId === chapter.id ? "text-stone-900" : "text-stone-600")}>
                            {chapter.title}
                        </span>
                        <button
                            onClick={(e) => { e.stopPropagation(); if (window.confirm(`Delete "${chapter.title}"?`)) onDelete(chapter.id); }}
                            className="opacity-0 group-hover:opacity-100 p-1 hover:bg-red-50 rounded text-red-400"
                        >
                            <Trash2 className="w-3 h-3" />
                        </button>
                    </div>
                ))}

                {chapters.length === 0 && !isCreating && (
                    <div className="p-8 text-center text-stone-400 space-y-2">
                        <FileText className="w-8 h-8 mx-auto text-stone-300" />
                        <p className="text-xs">No chapters yet.</p>
                        <p className="text-[10px]">Click + to start writing.</p>
                    </div>
                )}
            </div>
        </div>
    );
};
