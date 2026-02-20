import { useState, useEffect } from 'react';
import TextareaAutosize from 'react-textarea-autosize';
import { Chapter } from '@/types';
import { Save, Loader2 } from 'lucide-react';

interface MarkdownEditorProps {
    chapter: Chapter;
    onUpdate: (id: string, updates: Partial<Chapter>) => void;
}

export const MarkdownEditor = ({ chapter, onUpdate }: MarkdownEditorProps) => {
    const [content, setContent] = useState(chapter.content);
    const [title, setTitle] = useState(chapter.title);
    const [isDirty, setIsDirty] = useState(false);
    const [isSaving, setIsSaving] = useState(false);

    useEffect(() => {
        setContent(chapter.content);
        setTitle(chapter.title);
        setIsDirty(false);
    }, [chapter.id]); // Reset when chapter changes

    const handleSave = async () => {
        setIsSaving(true);
        await onUpdate(chapter.id, { title, content });
        setIsSaving(false);
        setIsDirty(false);
    };

    // Auto-save debounce effect could be added here, 
    // but explicit save is safer for MVP.

    return (
        <div className="flex flex-col h-full bg-white">
            <div className="border-b border-stone-200 px-8 py-4 flex justify-between items-center bg-white sticky top-0 z-10">
                <input
                    type="text"
                    value={title}
                    onChange={(e) => { setTitle(e.target.value); setIsDirty(true); }}
                    className="text-2xl font-serif font-bold text-stone-900 border-none focus:ring-0 px-0 w-full placeholder:text-stone-300"
                    placeholder="Chapter Title"
                />
                <button
                    onClick={handleSave}
                    disabled={!isDirty || isSaving}
                    className="flex items-center gap-2 px-4 py-2 bg-stone-900 text-white rounded-md hover:bg-stone-800 disabled:opacity-50 disabled:cursor-not-allowed transition-all"
                >
                    {isSaving ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
                    <span>Save</span>
                </button>
            </div>

            <div className="flex-1 overflow-y-auto px-8 py-6">
                <div className="max-w-3xl mx-auto">
                    <TextareaAutosize
                        value={content}
                        onChange={(e) => { setContent(e.target.value); setIsDirty(true); }}
                        placeholder="Start writing..."
                        className="w-full resize-none border-none focus:ring-0 text-lg leading-loose font-serif text-stone-800 placeholder:text-stone-300 min-h-[500px]"
                        minRows={20}
                    />
                </div>
            </div>
        </div>
    );
};
