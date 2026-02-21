import { useRef, useEffect } from 'react';
import { useAiLogStore, AiLog } from '@/store/useAiLogStore';
import { X, Terminal, ArrowUp, ArrowDown, Trash2, Clock, Info } from 'lucide-react';
import clsx from 'clsx';

export const AiConsole = () => {
    const { logs, isOpen, toggleOpen, clearLogs } = useAiLogStore();
    const bottomRef = useRef<HTMLDivElement>(null);

    // Auto-scroll to bottom of logs
    useEffect(() => {
        if (isOpen && bottomRef.current) {
            bottomRef.current.scrollIntoView({ behavior: 'smooth' });
        }
    }, [logs, isOpen]);

    if (!isOpen) {
        return (
            <button
                onClick={toggleOpen}
                className="fixed bottom-4 right-4 bg-stone-900 text-white p-3 rounded-full shadow-lg hover:bg-stone-800 transition-transform active:scale-95 z-50 flex items-center gap-2"
                title="Open AI Console"
            >
                <Terminal className="w-5 h-5" />
                {logs.length > 0 && (
                    <span className="absolute -top-1 -right-1 flex h-4 w-4 items-center justify-center rounded-full bg-red-500 text-[10px] font-bold">
                        {logs.length}
                    </span>
                )}
            </button>
        );
    }

    return (
        <div className="fixed inset-y-0 right-0 w-80 md:w-96 bg-stone-900 shadow-2xl z-50 flex flex-col font-mono text-sm border-l border-stone-800">
            {/* Header */}
            <div className="flex items-center justify-between p-4 border-b border-stone-800 bg-stone-900">
                <div className="flex items-center gap-2 text-stone-100 font-bold">
                    <Terminal className="w-4 h-4 text-emerald-500" />
                    <span>AI Console</span>
                </div>
                <div className="flex items-center gap-1">
                    <button onClick={clearLogs} className="p-1.5 hover:bg-stone-800 rounded text-stone-400 hover:text-red-400 transition-colors" title="Clear Logs">
                        <Trash2 className="w-4 h-4" />
                    </button>
                    <button onClick={toggleOpen} className="p-1.5 hover:bg-stone-800 rounded text-stone-400 transition-colors">
                        <X className="w-4 h-4" />
                    </button>
                </div>
            </div>

            {/* Logs Area */}
            <div className="flex-1 overflow-y-auto p-4 space-y-4 bg-stone-950">
                {logs.length === 0 ? (
                    <div className="h-full flex flex-col items-center justify-center text-stone-600 space-y-2 opacity-50">
                        <Terminal className="w-8 h-8" />
                        <p>No activity yet.</p>
                    </div>
                ) : (
                    logs.map(log => (
                        <LogEntry key={log.id} log={log} />
                    ))
                )}
                <div ref={bottomRef} />
            </div>
        </div>
    );
};

const LogEntry = ({ log }: { log: AiLog }) => {
    const isError = log.type === 'error';
    const isRequest = log.type === 'request';

    return (
        <div className={clsx(
            "rounded border p-3 space-y-2 text-xs break-words",
            isError ? "bg-red-950/30 border-red-900/50 text-red-200" :
                isRequest ? "bg-stone-900 border-stone-800 text-stone-300" :
                    "bg-emerald-950/20 border-emerald-900/30 text-emerald-100"
        )}>
            <div className="flex items-center justify-between opacity-70">
                <div className="flex items-center gap-1.5 uppercase font-bold tracking-wider text-[10px]">
                    {isRequest ? <ArrowUp className="w-3 h-3" /> : isError ? <Info className="w-3 h-3" /> : <ArrowDown className="w-3 h-3" />}
                    <span>{log.type}</span>
                </div>
                <div className="flex items-center gap-1">
                    <Clock className="w-3 h-3" />
                    <span>{new Date(log.timestamp).toLocaleTimeString()}</span>
                </div>
            </div>

            <div className="font-semibold text-stone-100">
                {log.metadata?.action || 'Unknown Action'}
            </div>

            <div className="opacity-80 leading-relaxed whitespace-pre-wrap font-mono">
                {log.content}
            </div>

            <div className="flex justify-between items-center text-[10px] opacity-50 pt-1 border-t border-white/5">
                <span>{log.model}</span>
                {log.metadata?.latency && (
                    <span>{log.metadata.latency}ms</span>
                )}
            </div>
        </div>
    );
};
