import { useState } from 'react';
import { aiService } from '@/lib/ai';
import { Wand2, Check, RefreshCw, X, Sparkles, Plus, ArrowUp, ArrowDown, Trash2 } from 'lucide-react';

interface PlotExpanderProps {
    currentPlot: string;
    onApply: (newPlot: string) => void;
    onCancel: () => void;
}

export const PlotExpander = ({ currentPlot, onApply, onCancel }: PlotExpanderProps) => {
    const [options, setOptions] = useState<string[]>([]);

    // We now track composed fragments as an array of strings (sentences)
    const [composedFragments, setComposedFragments] = useState<string[]>(currentPlot ? [currentPlot] : []);
    const [isLoading, setIsLoading] = useState(false);

    // Initial load
    const generateOptions = async (text: string) => {
        setIsLoading(true);
        try {
            const opts = await aiService.generatePlotOptions(text);
            setOptions(opts);
        } catch (e) {
            console.error(e);
        } finally {
            setIsLoading(false);
        }
    };

    // Split text into sentences for "Chips"
    const splitIntoSentences = (text: string): string[] => {
        // Simple regex for splitting by . ! ? follow by space or end
        // This keeps the punctuation.
        const match = text.match(/[^.!?]+[.!?]+(\s|$)|[^.!?]+$/g);
        return match ? match.map(s => s.trim()) : [text];
    };

    const handleAddFragment = (text: string) => {
        setComposedFragments(prev => [...prev, text]);
    };

    const handleMove = (index: number, direction: 'up' | 'down') => {
        if (direction === 'up' && index === 0) return;
        if (direction === 'down' && index === composedFragments.length - 1) return;

        const newFragments = [...composedFragments];
        const targetIndex = direction === 'up' ? index - 1 : index + 1;
        [newFragments[index], newFragments[targetIndex]] = [newFragments[targetIndex], newFragments[index]];

        setComposedFragments(newFragments);
    };

    const handleDelete = (index: number) => {
        setComposedFragments(prev => prev.filter((_, i) => i !== index));
    };

    const handleStreamline = async () => {
        setIsLoading(true);
        try {
            const fullText = composedFragments.join(' ');
            const streamlined = await aiService.streamlinePlot(fullText);
            setComposedFragments([streamlined]); // Replace with streamlined version
        } catch (e) {
            console.error(e);
        } finally {
            setIsLoading(false);
        }
    };

    if (options.length === 0 && !isLoading) {
        return (
            <div className="glass-panel p-6 rounded-xl space-y-4 text-center">
                <div className="w-12 h-12 bg-indigo-100 rounded-full flex items-center justify-center mx-auto text-indigo-600">
                    <Wand2 className="w-6 h-6" />
                </div>
                <div>
                    <h3 className="text-lg font-bold text-stone-800">Expand Your Plot</h3>
                    <p className="text-stone-500 max-w-md mx-auto">
                        The AI will generate 3 distinct directions for your story. Pick and choose the best sentences to build your narrative.
                    </p>
                </div>
                <div className="flex justify-center gap-3">
                    <button onClick={onCancel} className="px-4 py-2 text-stone-500 hover:text-stone-800">Cancel</button>
                    <button
                        onClick={() => generateOptions(currentPlot)}
                        className="px-6 py-2 bg-indigo-600 text-white rounded-lg font-bold hover:bg-indigo-700 transition-all hover:scale-105 shadow-lg shadow-indigo-500/20"
                    >
                        Generate Options
                    </button>
                </div>
            </div>
        );
    }

    if (isLoading) {
        return (
            <div className="glass-panel p-12 rounded-xl flex flex-col items-center justify-center space-y-4">
                <div className="relative">
                    <div className="w-12 h-12 border-4 border-indigo-200 rounded-full animate-spin border-t-indigo-600"></div>
                    <div className="absolute inset-0 flex items-center justify-center">
                        <Wand2 className="w-5 h-5 text-indigo-600" />
                    </div>
                </div>
                <p className="text-stone-500 font-medium animate-pulse">Dreaming up possibilities...</p>
            </div>
        );
    }

    return (
        <div className="glass-panel rounded-xl overflow-hidden flex flex-col h-[700px]">
            {/* Header */}
            <div className="p-4 border-b border-indigo-100 bg-indigo-50/50 flex justify-between items-center">
                <h3 className="font-bold text-indigo-900 flex items-center gap-2">
                    <Wand2 className="w-4 h-4" />
                    Plot Expander
                </h3>
                <button onClick={onCancel} className="p-1 hover:bg-stone-200 rounded text-stone-400">
                    <X className="w-4 h-4" />
                </button>
            </div>

            <div className="flex-1 flex overflow-hidden">
                {/* Options Column */}
                <div className="w-1/2 p-4 border-r border-stone-200 overflow-y-auto space-y-6 bg-stone-50/30">
                    <h4 className="text-xs font-bold text-stone-400 uppercase tracking-wider mb-2">AI Options</h4>
                    {options.map((opt, i) => (
                        <div key={i} className="space-y-2">
                            <h5 className="text-xs font-semibold text-indigo-600 uppercase tracking-wide">Option {i + 1}</h5>
                            <div className="flex flex-wrap gap-2">
                                {splitIntoSentences(opt).map((sentence, sIdx) => (
                                    <button
                                        key={sIdx}
                                        onClick={() => handleAddFragment(sentence)}
                                        className="text-left text-sm bg-white border border-stone-200 rounded-md px-3 py-2 hover:border-indigo-400 hover:shadow-sm hover:-translate-y-0.5 transition-all group"
                                    >
                                        <span className="text-stone-700 group-hover:text-stone-900">{sentence}</span>
                                        <span className="ml-2 inline-flex opacity-0 group-hover:opacity-100 text-indigo-500">
                                            <Plus className="w-3 h-3" />
                                        </span>
                                    </button>
                                ))}
                            </div>
                        </div>
                    ))}
                    <div className="flex gap-2">
                        <button
                            onClick={() => generateOptions(composedFragments.join('\n'))}
                            className="flex-1 py-3 text-xs font-medium text-stone-500 hover:text-indigo-600 bg-white border border-stone-200 rounded-lg shadow-sm hover:shadow-md transition-all flex items-center justify-center gap-2"
                            title="Generate based on your current composition"
                        >
                            <RefreshCw className="w-3 h-3" />
                            Refine
                        </button>
                        <button
                            onClick={() => generateOptions(currentPlot)}
                            className="flex-1 py-3 text-xs font-medium text-stone-500 hover:text-emerald-600 bg-white border border-stone-200 rounded-lg shadow-sm hover:shadow-md transition-all flex items-center justify-center gap-2"
                            title="Generate fresh ideas from original seed"
                        >
                            <Sparkles className="w-3 h-3" />
                            From Seed
                        </button>
                    </div>
                </div>

                {/* Composer Column */}
                <div className="w-1/2 flex flex-col bg-white">
                    <div className="p-4 border-b border-stone-100 flex justify-between items-center">
                        <h4 className="text-xs font-bold text-stone-400 uppercase tracking-wider">Your Composition</h4>
                        <button
                            onClick={handleStreamline}
                            className="text-xs flex items-center gap-1 text-amber-600 hover:text-amber-700 font-medium px-2 py-1 bg-amber-50 rounded hover:bg-amber-100 transition-colors"
                        >
                            <Sparkles className="w-3 h-3" />
                            Streamline
                        </button>
                    </div>

                    <div className="flex-1 overflow-y-auto p-4 space-y-2">
                        {composedFragments.length === 0 ? (
                            <div className="h-full flex flex-col items-center justify-center text-stone-400 text-sm italic">
                                Click on sentences from the left to add them here.
                            </div>
                        ) : (
                            composedFragments.map((frag, idx) => (
                                <div key={idx} className="flex gap-2 group animate-in slide-in-from-right-2 duration-300">
                                    <div className="flex-1 p-3 bg-stone-50 rounded-lg border border-stone-100 text-stone-800 text-sm leading-relaxed group-hover:border-indigo-100 transition-colors">
                                        {frag}
                                    </div>
                                    <div className="flex flex-col gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                                        <button onClick={() => handleMove(idx, 'up')} disabled={idx === 0} className="p-1 hover:bg-stone-100 rounded text-stone-400 hover:text-stone-600 disabled:opacity-30">
                                            <ArrowUp className="w-3 h-3" />
                                        </button>
                                        <button onClick={() => handleMove(idx, 'down')} disabled={idx === composedFragments.length - 1} className="p-1 hover:bg-stone-100 rounded text-stone-400 hover:text-stone-600 disabled:opacity-30">
                                            <ArrowDown className="w-3 h-3" />
                                        </button>
                                        <button onClick={() => handleDelete(idx)} className="p-1 hover:bg-red-50 rounded text-stone-400 hover:text-red-500">
                                            <Trash2 className="w-3 h-3" />
                                        </button>
                                    </div>
                                </div>
                            ))
                        )}
                    </div>

                    <div className="p-4 border-t border-stone-100 bg-stone-50 flex justify-end gap-3">
                        <button onClick={onCancel} className="px-4 py-2 text-sm text-stone-500 hover:text-stone-800">Cancel</button>
                        <button
                            onClick={() => onApply(composedFragments.join(' '))}
                            className="px-6 py-2 bg-stone-900 text-white rounded-lg text-sm font-bold hover:bg-stone-800 shadow-lg shadow-stone-900/10 flex items-center gap-2"
                        >
                            <Check className="w-4 h-4" />
                            Apply into Story
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
};


