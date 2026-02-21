import React from 'react';
import { diffSentences, Change } from 'diff';
import clsx from 'clsx';

interface DiffViewerProps {
    oldText: string;
    newText: string;
    className?: string;
}

export const DiffViewer: React.FC<DiffViewerProps> = ({ oldText, newText, className }) => {
    const diffs: Change[] = diffSentences(oldText, newText);

    return (
        <div className={clsx("font-serif leading-relaxed whitespace-pre-wrap text-[15px]", className)}>
            {diffs.map((part, index) => {
                if (part.added) {
                    return (
                        <span key={index} className="bg-emerald-200/50 dark:bg-emerald-900/40 text-emerald-900 dark:text-emerald-100 px-0.5 rounded-sm">
                            {part.value}
                        </span>
                    );
                }
                if (part.removed) {
                    return (
                        <span key={index} className="bg-red-200/50 dark:bg-red-900/40 text-red-900 dark:text-red-200 line-through px-0.5 rounded-sm opacity-60">
                            {part.value}
                        </span>
                    );
                }
                return (
                    <span key={index} className="text-stone-700 dark:text-stone-300">
                        {part.value}
                    </span>
                );
            })}
        </div>
    );
};
