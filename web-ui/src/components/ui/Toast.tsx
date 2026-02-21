import { useToastStore } from '@/hooks/useToast';
import { Check, AlertCircle, Info, X } from 'lucide-react';
import clsx from 'clsx';

const iconMap = {
    success: Check,
    error: AlertCircle,
    info: Info,
};

const styleMap = {
    success: 'bg-emerald-50 border-emerald-200 text-emerald-800',
    error: 'bg-red-50 border-red-200 text-red-800',
    info: 'bg-indigo-50 border-indigo-200 text-indigo-800',
};

const iconStyleMap = {
    success: 'bg-emerald-100 text-emerald-600',
    error: 'bg-red-100 text-red-600',
    info: 'bg-indigo-100 text-indigo-600',
};

export const ToastContainer = () => {
    const { toasts, dismiss } = useToastStore();

    if (toasts.length === 0) return null;

    return (
        <div className="fixed top-4 right-4 z-[100] flex flex-col gap-2 pointer-events-none">
            {toasts.map((toast) => {
                const Icon = iconMap[toast.type];
                return (
                    <div
                        key={toast.id}
                        className={clsx(
                            "pointer-events-auto flex items-center gap-3 px-4 py-3 rounded-xl border shadow-lg backdrop-blur-sm min-w-[280px] max-w-[400px]",
                            styleMap[toast.type],
                            toast.exiting ? 'toast-exit' : 'toast-enter'
                        )}
                    >
                        <div className={clsx("w-6 h-6 rounded-full flex items-center justify-center shrink-0", iconStyleMap[toast.type])}>
                            <Icon className="w-3.5 h-3.5" />
                        </div>
                        <span className="text-sm font-medium flex-1">{toast.message}</span>
                        <button
                            onClick={() => dismiss(toast.id)}
                            className="p-1 hover:bg-black/5 rounded-md transition-colors shrink-0"
                        >
                            <X className="w-3.5 h-3.5 opacity-50" />
                        </button>
                    </div>
                );
            })}
        </div>
    );
};
