import { useState } from 'react';
import { useStoryStore, useTemporalStoryStore } from '@/store/useStoryStore';
import { HelpCircle, X, Plus, ChevronDown, CheckCircle2, Circle, Trash2, Edit2, Undo2 } from 'lucide-react';
import clsx from 'clsx';
import TextareaAutosize from 'react-textarea-autosize';

export const UnresolvedQuestionsPanel = () => {
    const { currentStory, unresolvedQuestions, createUnresolvedQuestion, updateUnresolvedQuestion, deleteUnresolvedQuestion } = useStoryStore();
    const { undo, pastStates } = useTemporalStoryStore((state) => state);
    const [isOpen, setIsOpen] = useState(false);
    const [isCreating, setIsCreating] = useState(false);
    const [editingId, setEditingId] = useState<string | null>(null);

    const [newQuestion, setNewQuestion] = useState('');
    const [newDetails, setNewDetails] = useState('');

    const [editQuestion, setEditQuestion] = useState('');
    const [editDetails, setEditDetails] = useState('');
    const [editAnswer, setEditAnswer] = useState('');

    if (!currentStory) return null;

    const handleCreate = async () => {
        if (!newQuestion.trim()) return;
        await createUnresolvedQuestion(newQuestion.trim(), newDetails.trim());
        setNewQuestion('');
        setNewDetails('');
        setIsCreating(false);
    };

    const startEditing = (q: any) => {
        setEditingId(q.id);
        setEditQuestion(q.question);
        setEditDetails(q.details || '');
        setEditAnswer(q.answer || '');
    };

    const handleSaveEdit = async (id: string) => {
        await updateUnresolvedQuestion(id, {
            question: editQuestion.trim(),
            details: editDetails.trim(),
            answer: editAnswer.trim()
        });
        setEditingId(null);
    };

    const toggleResolved = async (id: string, currentStatus: boolean) => {
        await updateUnresolvedQuestion(id, { isResolved: !currentStatus });
    };

    const questionsDisplay = unresolvedQuestions || [];
    const openQuestions = questionsDisplay.filter(q => !q.isResolved);
    const resolvedQuestions = questionsDisplay.filter(q => q.isResolved);

    return (
        <div className="fixed bottom-24 right-6 z-50 flex flex-col items-end">
            {/* The Panel */}
            {isOpen && (
                <div className="w-[400px] max-h-[600px] mb-4 bg-white/90 dark:bg-stone-900/90 backdrop-blur-xl border border-stone-200 dark:border-stone-700/50 rounded-2xl shadow-2xl flex flex-col overflow-hidden animate-in slide-in-from-bottom-4 duration-300">
                    <div className="px-4 py-3 border-b border-stone-200 dark:border-stone-800 flex justify-between items-center bg-stone-50/50 dark:bg-stone-950/50">
                        <h3 className="font-bold font-serif text-stone-800 dark:text-stone-100 flex items-center gap-2">
                            <HelpCircle className="w-5 h-5 text-indigo-500" />
                            Unresolved Questions
                        </h3>
                        <div className="flex items-center gap-1">
                            <button
                                onClick={() => undo()}
                                disabled={pastStates.length === 0}
                                title="Undo last change"
                                className="p-1.5 hover:bg-stone-200 dark:hover:bg-stone-800 rounded-lg transition-colors text-stone-500 disabled:opacity-30"
                            >
                                <Undo2 className="w-4 h-4" />
                            </button>
                            <button
                                onClick={() => setIsOpen(false)}
                                className="p-1.5 hover:bg-stone-200 dark:hover:bg-stone-800 rounded-lg transition-colors"
                            >
                                <X className="w-4 h-4 text-stone-500" />
                            </button>
                        </div>
                    </div>

                    <div className="flex-1 overflow-y-auto p-4 space-y-6">
                        {/* Empty State */}
                        {questionsDisplay.length === 0 && !isCreating && (
                            <div className="text-center py-8 px-4">
                                <HelpCircle className="w-12 h-12 text-stone-300 dark:text-stone-700 mx-auto mb-3" />
                                <p className="text-sm text-stone-500 dark:text-stone-400">
                                    Track plot holes, mysteries, and unanswered questions here.
                                </p>
                            </div>
                        )}

                        {/* Open Questions List */}
                        {openQuestions.length > 0 && (
                            <div className="space-y-3">
                                <h4 className="text-xs font-bold uppercase tracking-wider text-amber-600 dark:text-amber-500 flex items-center gap-2">
                                    Active Mysteries ({openQuestions.length})
                                </h4>
                                {openQuestions.map(q => (
                                    <div key={q.id} className="bg-white dark:bg-stone-800 border border-stone-200 dark:border-stone-700 rounded-xl p-3 shadow-sm group">
                                        {editingId === q.id ? (
                                            <div className="space-y-2">
                                                <input
                                                    type="text"
                                                    value={editQuestion}
                                                    onChange={e => setEditQuestion(e.target.value)}
                                                    className="w-full text-sm font-medium bg-stone-50 dark:bg-stone-900 border-none rounded p-2 focus:ring-1 focus:ring-indigo-500"
                                                    placeholder="The question..."
                                                />
                                                <TextareaAutosize
                                                    value={editDetails}
                                                    onChange={e => setEditDetails(e.target.value)}
                                                    className="w-full text-xs bg-stone-50 dark:bg-stone-900 border-none rounded p-2 focus:ring-1 focus:ring-indigo-500 resize-none"
                                                    placeholder="More details (optional)..."
                                                    minRows={2}
                                                />
                                                <div className="flex justify-end gap-2 pt-2">
                                                    <button onClick={() => setEditingId(null)} className="text-xs px-3 py-1.5 text-stone-500 hover:bg-stone-100 dark:hover:bg-stone-800 rounded">Cancel</button>
                                                    <button onClick={() => handleSaveEdit(q.id)} className="text-xs px-3 py-1.5 bg-indigo-600 text-white rounded hover:bg-indigo-700">Save</button>
                                                </div>
                                            </div>
                                        ) : (
                                            <div>
                                                <div className="flex items-start gap-3">
                                                    <button onClick={() => toggleResolved(q.id, q.isResolved)} className="mt-0.5 text-stone-300 hover:text-emerald-500 transition-colors" title="Mark as Answered">
                                                        <Circle className="w-4 h-4" />
                                                    </button>
                                                    <div className="flex-1 min-w-0">
                                                        <p className="text-sm font-medium text-stone-800 dark:text-stone-200 leading-snug">{q.question}</p>
                                                        {q.details && <p className="text-xs text-stone-500 dark:text-stone-400 mt-1.5 leading-relaxed">{q.details}</p>}
                                                    </div>
                                                </div>
                                                <div className="flex justify-end gap-1 mt-2 opacity-0 group-hover:opacity-100 transition-opacity">
                                                    <button onClick={() => startEditing(q)} className="p-1 hover:bg-stone-100 dark:hover:bg-stone-700 text-stone-400 hover:text-stone-600 dark:hover:text-stone-300 rounded"><Edit2 className="w-3.5 h-3.5" /></button>
                                                    <button onClick={() => deleteUnresolvedQuestion(q.id)} className="p-1 hover:bg-red-50 dark:hover:bg-red-900/30 text-stone-400 hover:text-red-600 dark:hover:text-red-400 rounded"><Trash2 className="w-3.5 h-3.5" /></button>
                                                </div>
                                            </div>
                                        )}
                                    </div>
                                ))}
                            </div>
                        )}

                        {/* Resolved Questions List */}
                        {resolvedQuestions.length > 0 && (
                            <div className="space-y-3 pt-4 border-t border-stone-200 dark:border-stone-800 border-dashed">
                                <h4 className="text-xs font-bold uppercase tracking-wider text-emerald-600 dark:text-emerald-500 flex items-center gap-2">
                                    Answered ({resolvedQuestions.length})
                                </h4>
                                {resolvedQuestions.map(q => (
                                    <div key={q.id} className="bg-stone-50/50 dark:bg-stone-900/50 border border-stone-200/50 dark:border-stone-800 rounded-xl p-3 group opacity-75 hover:opacity-100 transition-opacity">
                                        {editingId === q.id ? (
                                            <div className="space-y-2">
                                                <input type="text" value={editQuestion} onChange={e => setEditQuestion(e.target.value)} className="w-full text-sm font-medium bg-white dark:bg-stone-950 border-none rounded p-2 focus:ring-1 focus:ring-indigo-500" />
                                                <TextareaAutosize value={editAnswer} onChange={e => setEditAnswer(e.target.value)} className="w-full text-xs font-medium text-emerald-700 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-100 dark:border-emerald-800/50 rounded p-2 focus:ring-1 focus:ring-emerald-500 resize-none" placeholder="The answer..." minRows={2} />
                                                <div className="flex justify-end gap-2 pt-2">
                                                    <button onClick={() => setEditingId(null)} className="text-xs px-3 py-1.5 text-stone-500 hover:bg-stone-200 dark:hover:bg-stone-800 rounded">Cancel</button>
                                                    <button onClick={() => handleSaveEdit(q.id)} className="text-xs px-3 py-1.5 bg-indigo-600 text-white rounded hover:bg-indigo-700">Save</button>
                                                </div>
                                            </div>
                                        ) : (
                                            <div>
                                                <div className="flex items-start gap-3">
                                                    <button onClick={() => toggleResolved(q.id, q.isResolved)} className="mt-0.5 text-emerald-500 hover:text-stone-400 transition-colors" title="Mark as Unanswered">
                                                        <CheckCircle2 className="w-4 h-4" />
                                                    </button>
                                                    <div className="flex-1 min-w-0">
                                                        <p className="text-sm font-medium text-stone-600 dark:text-stone-400 line-through decoration-stone-300 dark:decoration-stone-600 leading-snug">{q.question}</p>
                                                        {q.answer ? (
                                                            <div className="mt-2 p-2 bg-emerald-50 dark:bg-emerald-900/20 rounded border border-emerald-100 dark:border-emerald-800/50">
                                                                <p className="text-xs font-medium text-emerald-800 dark:text-emerald-300">{q.answer}</p>
                                                            </div>
                                                        ) : (
                                                            <p className="text-xs italic text-stone-400 mt-1">No answer recorded.</p>
                                                        )}
                                                    </div>
                                                </div>
                                                <div className="flex justify-end gap-1 mt-2 opacity-0 group-hover:opacity-100 transition-opacity">
                                                    <button onClick={() => startEditing(q)} className="p-1 hover:bg-stone-200 dark:hover:bg-stone-800 text-stone-400 hover:text-stone-600 dark:hover:text-stone-300 rounded"><Edit2 className="w-3.5 h-3.5" /></button>
                                                    <button onClick={() => deleteUnresolvedQuestion(q.id)} className="p-1 hover:bg-red-50 dark:hover:bg-red-900/30 text-stone-400 hover:text-red-600 dark:hover:text-red-400 rounded"><Trash2 className="w-3.5 h-3.5" /></button>
                                                </div>
                                            </div>
                                        )}
                                    </div>
                                ))}
                            </div>
                        )}

                        {/* Empty Space for scrolling */}
                        <div className="h-4"></div>
                    </div>

                    {/* Create New Form */}
                    <div className="p-4 border-t border-stone-200 dark:border-stone-800 bg-stone-50/50 dark:bg-stone-950/50">
                        {isCreating ? (
                            <div className="space-y-3 animate-in fade-in slide-in-from-bottom-2">
                                <input
                                    autoFocus
                                    type="text"
                                    value={newQuestion}
                                    onChange={e => setNewQuestion(e.target.value)}
                                    placeholder="What is the unresolved question?"
                                    className="w-full text-sm font-medium bg-white dark:bg-stone-900 border border-stone-200 dark:border-stone-700 rounded-lg p-2.5 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                                />
                                <TextareaAutosize
                                    value={newDetails}
                                    onChange={e => setNewDetails(e.target.value)}
                                    placeholder="Context or details (optional)..."
                                    minRows={2}
                                    className="w-full text-xs bg-white dark:bg-stone-900 border border-stone-200 dark:border-stone-700 rounded-lg p-2.5 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 resize-none"
                                />
                                <div className="flex justify-end gap-2 pt-1">
                                    <button
                                        onClick={() => { setIsCreating(false); setNewQuestion(''); setNewDetails(''); }}
                                        className="px-4 py-2 text-sm font-medium text-stone-600 hover:bg-stone-200 dark:hover:bg-stone-800 rounded-lg transition-colors"
                                    >
                                        Cancel
                                    </button>
                                    <button
                                        onClick={handleCreate}
                                        disabled={!newQuestion.trim()}
                                        className="px-4 py-2 text-sm font-bold bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 disabled:opacity-50 disabled:hover:bg-indigo-600 transition-colors shadow-sm"
                                    >
                                        Add Question
                                    </button>
                                </div>
                            </div>
                        ) : (
                            <button
                                onClick={() => setIsCreating(true)}
                                className="w-full py-2.5 px-4 bg-white dark:bg-stone-800 border border-stone-200 dark:border-stone-700 border-dashed rounded-xl text-stone-500 hover:text-indigo-600 hover:border-indigo-300 dark:hover:border-indigo-700 hover:bg-indigo-50 dark:hover:bg-indigo-900/20 transition-all flex items-center justify-center gap-2 font-medium text-sm group"
                            >
                                <Plus className="w-4 h-4 transition-transform group-hover:scale-110 group-hover:rotate-90" />
                                Add Unresolved Question
                            </button>
                        )}
                    </div>
                </div>
            )}

            {/* Floating Action Button */}
            <button
                onClick={() => setIsOpen(!isOpen)}
                className={clsx(
                    "flex items-center justify-center shadow-2xl transition-all duration-300",
                    isOpen
                        ? "w-12 h-12 bg-stone-800 hover:bg-stone-900 dark:bg-stone-100 dark:hover:bg-white text-white dark:text-stone-900 rounded-full"
                        : "w-14 h-14 bg-indigo-600 hover:bg-indigo-700 hover:scale-105 text-white rounded-2xl"
                )}
            >
                {isOpen ? <ChevronDown className="w-6 h-6" /> : (
                    <div className="relative">
                        <HelpCircle className="w-6 h-6" />
                        {openQuestions.length > 0 && (
                            <span className="absolute -top-1.5 -right-1.5 flex h-4 w-4">
                                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
                                <span className="relative inline-flex rounded-full h-4 w-4 bg-amber-500 items-center justify-center text-[9px] font-bold text-white">
                                    {openQuestions.length}
                                </span>
                            </span>
                        )}
                    </div>
                )}
            </button>
        </div>
    );
};
