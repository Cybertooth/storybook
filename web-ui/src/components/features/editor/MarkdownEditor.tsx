import { useState, useEffect } from 'react';
import TextareaAutosize from 'react-textarea-autosize';
import { Chapter } from '@storybook/api';
import { Loader2, Check, Eye, Edit2, Wand2, X } from 'lucide-react';
import { useDebounce } from '@/hooks/useDebounce';
import clsx from 'clsx';
import { aiService } from '@/lib/ai';
import { useStoryStore } from '@/store/useStoryStore';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';

interface MarkdownEditorProps {
    chapter: Chapter;
    onUpdate: (id: string, updates: Partial<Chapter>) => void;
}

export const MarkdownEditor = ({ chapter, onUpdate }: MarkdownEditorProps) => {
    const [content, setContent] = useState(chapter.content);
    const [title, setTitle] = useState(chapter.title);
    const [isDirty, setIsDirty] = useState(false);
    const [isSaving, setIsSaving] = useState(false);
    const [isPreview, setIsPreview] = useState(false);

    // Brainstorming State
    const [isBrainstorming, setIsBrainstorming] = useState(false);
    const [brainstormOptions, setBrainstormOptions] = useState<string[] | null>(null);
    const [brainstormError, setBrainstormError] = useState<string | null>(null);
    const { currentStory } = useStoryStore();

    useEffect(() => {
        setContent(chapter.content);
        setTitle(chapter.title);
        // Do not immediately trigger an auto-save upon switching chapters
        setIsDirty(false);
    }, [chapter.id]);

    const debouncedContent = useDebounce(content, 1500);
    const debouncedTitle = useDebounce(title, 1500);

    useEffect(() => {
        if (!isDirty) return;

        const performSave = async () => {
            setIsSaving(true);
            await onUpdate(chapter.id, { title: debouncedTitle, content: debouncedContent });
            setIsSaving(false);
            setIsDirty(false);
        };

        performSave();
    }, [debouncedContent, debouncedTitle]);

    const handleBrainstorm = async () => {
        if (!content.trim()) return;
        setIsBrainstorming(true);
        setBrainstormError(null);
        setBrainstormOptions(null);

        try {
            const plotContext = currentStory?.summary || '';
            const options = await aiService.brainstormNext(content, plotContext);
            setBrainstormOptions(options);
        } catch (err) {
            setBrainstormError((err as Error).message);
        } finally {
            setIsBrainstorming(false);
        }
    };

    const handleApplySuggestion = (suggestion: string) => {
        const newContent = content.trim() + '\n\n' + suggestion + ' ';
        setContent(newContent);
        setIsDirty(true);
        setBrainstormOptions(null);
    };

    return (
        <div className="flex flex-col h-full bg-white dark:bg-stone-950">
            <div className="border-b border-stone-200 dark:border-stone-800 px-8 py-4 flex justify-between items-center bg-white dark:bg-stone-900 sticky top-0 z-10">
                <input
                    type="text"
                    value={title}
                    onChange={(e) => { setTitle(e.target.value); setIsDirty(true); }}
                    className="text-2xl font-serif font-bold text-stone-900 dark:text-stone-100 border-none focus:ring-0 px-0 w-full placeholder:text-stone-300 dark:placeholder:text-stone-600 bg-transparent"
                    placeholder="Chapter Title"
                />

                <div className="flex items-center gap-4">
                    <button
                        onClick={() => setIsPreview(!isPreview)}
                        className={clsx(
                            "flex items-center gap-2 px-3 py-1.5 rounded-md transition-all font-medium text-xs border",
                            isPreview
                                ? "bg-indigo-50 dark:bg-indigo-900/30 border-indigo-200 dark:border-indigo-800 text-indigo-700 dark:text-indigo-400"
                                : "bg-white dark:bg-stone-800 border-stone-200 dark:border-stone-700 text-stone-600 dark:text-stone-400 hover:bg-stone-50 dark:hover:bg-stone-700"
                        )}
                        title="Toggle Preview"
                    >
                        {isPreview ? <Edit2 className="w-3 h-3" /> : <Eye className="w-3 h-3" />}
                        <span>{isPreview ? 'Edit' : 'Preview'}</span>
                    </button>

                    <button
                        onClick={handleBrainstorm}
                        disabled={isBrainstorming || !content.trim() || isPreview}
                        className={clsx(
                            "flex items-center gap-2 px-3 py-1.5 rounded-md transition-all font-medium text-xs border border-indigo-200 dark:border-indigo-800",
                            isBrainstorming ? "bg-indigo-100 dark:bg-indigo-900/50 text-indigo-400" : "bg-indigo-50 dark:bg-indigo-900/20 text-indigo-700 dark:text-indigo-400 hover:bg-indigo-100 dark:hover:bg-indigo-900/40"
                        )}
                        title="AI: What happens next?"
                    >
                        {isBrainstorming ? <Loader2 className="w-3 h-3 animate-spin" /> : <Wand2 className="w-3 h-3" />}
                        <span>Suggest Next</span>
                    </button>

                    <div
                        className={clsx(
                            "flex items-center gap-2 px-3 py-1.5 rounded-md transition-all font-medium text-xs",
                            isDirty || isSaving
                                ? "text-amber-600 dark:text-amber-500 bg-amber-50 dark:bg-amber-900/20"
                                : "text-emerald-600 dark:text-emerald-500 bg-emerald-50 dark:bg-emerald-900/20"
                        )}
                    >
                        {(isDirty || isSaving) ? <Loader2 className="w-3 h-3 animate-spin" /> : <Check className="w-3 h-3" />}
                        <span>{(isDirty || isSaving) ? 'Saving...' : 'Saved'}</span>
                    </div>
                </div>
            </div>

            <div className="flex-1 overflow-y-auto px-8 py-6 relative">
                {/* Brainstorming Floating Panel */}
                {brainstormOptions && (
                    <div className="absolute right-8 top-6 w-96 glass-panel rounded-xl shadow-2xl z-20 animate-in slide-in-from-right-4 duration-300 flex flex-col max-h-[calc(100%-3rem)]">
                        <div className="p-3 border-b border-indigo-100 dark:border-indigo-900/50 bg-indigo-50/80 dark:bg-indigo-900/40 backdrop-blur-md rounded-t-xl flex justify-between items-center sticky top-0">
                            <h4 className="font-bold text-indigo-900 dark:text-indigo-300 text-sm flex items-center gap-2">
                                <Wand2 className="w-4 h-4" />
                                What happens next?
                            </h4>
                            <button onClick={() => setBrainstormOptions(null)} className="p-1 hover:bg-indigo-200/50 dark:hover:bg-indigo-800/50 rounded text-indigo-700 dark:text-indigo-400 transition-colors">
                                <X className="w-4 h-4" />
                            </button>
                        </div>
                        <div className="p-4 space-y-4 overflow-y-auto">
                            {brainstormOptions.map((opt, idx) => (
                                <div key={idx} className="bg-white/80 dark:bg-stone-900/80 border border-indigo-100 dark:border-indigo-900/50 p-3 rounded-lg hover:border-indigo-300 dark:hover:border-indigo-500 transition-colors group">
                                    <p className="text-sm font-serif text-stone-700 dark:text-stone-300 mb-3">{opt}</p>
                                    <button
                                        onClick={() => handleApplySuggestion(opt)}
                                        className="w-full py-1.5 px-3 bg-indigo-50 dark:bg-indigo-900/30 text-indigo-700 dark:text-indigo-400 text-xs font-bold rounded flex justify-center items-center gap-2 hover:bg-indigo-100 dark:hover:bg-indigo-900/50 transition-colors opacity-0 group-hover:opacity-100"
                                    >
                                        <Check className="w-3 h-3" />
                                        Continue with this
                                    </button>
                                </div>
                            ))}
                        </div>
                    </div>
                )}
                {brainstormError && (
                    <div className="absolute right-8 top-6 w-80 p-3 bg-red-50 text-red-600 rounded-lg shadow border border-red-100 text-sm z-20 animate-in fade-in">
                        {brainstormError}
                    </div>
                )}

                <div className="max-w-3xl mx-auto">
                    {isPreview ? (
                        <div className="prose prose-stone dark:prose-invert prose-lg font-serif max-w-none min-h-[500px] leading-loose">
                            {content ? (
                                <ReactMarkdown remarkPlugins={[remarkGfm]}>
                                    {content}
                                </ReactMarkdown>
                            ) : (
                                <p className="text-stone-400 dark:text-stone-500 italic">No content to preview.</p>
                            )}
                        </div>
                    ) : (
                        <TextareaAutosize
                            value={content}
                            onChange={(e) => { setContent(e.target.value); setIsDirty(true); }}
                            placeholder="Start writing..."
                            className="w-full bg-transparent resize-none border-none focus:ring-0 text-lg leading-loose font-serif text-stone-800 dark:text-stone-200 placeholder:text-stone-300 dark:placeholder:text-stone-600 min-h-[500px]"
                            minRows={20}
                        />
                    )}
                </div>
            </div>
        </div >
    );
};
