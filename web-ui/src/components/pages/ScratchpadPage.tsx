import { useState } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { Lightbulb, Plus, Trash2 } from 'lucide-react';
import TextareaAutosize from 'react-textarea-autosize';

export const ScratchpadPage = () => {
    const { notes, createNote, updateNote, deleteNote } = useStoryStore();
    const [newNoteContent, setNewNoteContent] = useState('');

    const handleCreate = async () => {
        if (!newNoteContent.trim()) return;
        await createNote(newNoteContent);
        setNewNoteContent('');
    };

    return (
        <div className="h-full flex flex-col pt-4">
            <div className="flex justify-between items-center mb-6 px-2">
                <div>
                    <h2 className="text-3xl font-serif font-bold text-stone-900 dark:text-stone-100 flex items-center gap-3">
                        <Lightbulb className="w-8 h-8 text-amber-500" />
                        Scratchpad
                    </h2>
                    <p className="text-stone-500 dark:text-stone-400 mt-1">
                        A frictionless space for unformed ideas, research links, and random thoughts.
                    </p>
                </div>
            </div>

            {/* Quick Add Bar */}
            <div className="mb-8">
                <div className="bg-white dark:bg-stone-800 rounded-xl p-3 shadow-sm border border-stone-200 dark:border-stone-700 flex gap-3 focus-within:ring-2 focus-within:ring-amber-500/50 transition-all">
                    <TextareaAutosize
                        autoFocus
                        value={newNoteContent}
                        onChange={(e) => setNewNoteContent(e.target.value)}
                        onKeyDown={(e) => {
                            if (e.key === 'Enter' && !e.shiftKey) {
                                e.preventDefault();
                                handleCreate();
                            }
                        }}
                        placeholder="Jot down a quick thought... (Press Enter to save)"
                        className="flex-1 bg-transparent border-none resize-none px-2 py-1 text-stone-900 dark:text-stone-100 focus:outline-none placeholder:text-stone-400"
                        minRows={1}
                        maxRows={5}
                    />
                    <button
                        onClick={handleCreate}
                        disabled={!newNoteContent.trim()}
                        className="bg-amber-100 hover:bg-amber-200 text-amber-800 px-4 rounded-lg font-medium transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center shrink-0"
                    >
                        <Plus className="w-5 h-5" />
                    </button>
                </div>
            </div>

            {/* Notes Grid (Masonry style approx) */}
            <div className="flex-1 overflow-y-auto pb-8 pr-2 custom-scrollbar">
                {notes.length === 0 ? (
                    <div className="text-center py-20 text-stone-400 bg-stone-50/50 dark:bg-stone-800/20 rounded-2xl border-2 border-dashed border-stone-200 dark:border-stone-700">
                        <div className="w-16 h-16 bg-amber-50 dark:bg-amber-900/20 rounded-full flex items-center justify-center mx-auto mb-4">
                            <Lightbulb className="w-8 h-8 text-amber-300 dark:text-amber-500/50" />
                        </div>
                        <p className="font-medium text-stone-500 dark:text-stone-400 text-lg">Your mind is clear.</p>
                        <p className="text-sm mt-2">Any random thoughts or inspiration can be dumped here before they belong to the formal outline.</p>
                    </div>
                ) : (
                    <div className="columns-1 md:columns-2 lg:columns-3 gap-6 space-y-6">
                        {notes.map(note => (
                            <div
                                key={note.id}
                                className="break-inside-avoid bg-amber-50/50 hover:bg-amber-50 dark:bg-stone-800 dark:hover:bg-stone-750 p-5 rounded-2xl border border-amber-100 dark:border-stone-700 shadow-sm hover:shadow-md hover:-translate-y-1 transition-all duration-300 group relative"
                            >
                                <TextareaAutosize
                                    value={note.content}
                                    onChange={(e) => updateNote(note.id, { content: e.target.value })}
                                    className="w-full bg-transparent border-none resize-none focus:outline-none text-stone-800 dark:text-stone-200 text-sm leading-relaxed"
                                />
                                <div className="mt-4 flex justify-between items-center opacity-0 group-hover:opacity-100 transition-opacity">
                                    <span className="text-[10px] text-stone-400 select-none">
                                        {new Date(note.createdAt).toLocaleString(undefined, { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' })}
                                    </span>
                                    <button
                                        onClick={() => { if (window.confirm('Delete this note?')) deleteNote(note.id); }}
                                        className="p-1.5 hover:bg-red-100 dark:hover:bg-red-900/30 text-stone-400 hover:text-red-500 rounded-lg transition-colors"
                                        title="Delete Note"
                                    >
                                        <Trash2 className="w-4 h-4" />
                                    </button>
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </div>
        </div>
    );
};
