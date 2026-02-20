import { create } from 'zustand';
import { v4 as uuidv4 } from 'uuid';

export interface ToastMessage {
    id: string;
    message: string;
    type: 'success' | 'error' | 'info';
    exiting?: boolean;
}

interface ToastState {
    toasts: ToastMessage[];
    toast: (message: string, type?: ToastMessage['type']) => void;
    dismiss: (id: string) => void;
}

export const useToastStore = create<ToastState>((set) => ({
    toasts: [],

    toast: (message, type = 'success') => {
        const id = uuidv4();
        set((state) => ({
            toasts: [...state.toasts, { id, message, type }]
        }));

        // Auto-dismiss after 3 seconds
        setTimeout(() => {
            set((state) => ({
                toasts: state.toasts.map(t =>
                    t.id === id ? { ...t, exiting: true } : t
                )
            }));
            // Remove from DOM after exit animation
            setTimeout(() => {
                set((state) => ({
                    toasts: state.toasts.filter(t => t.id !== id)
                }));
            }, 300);
        }, 3000);
    },

    dismiss: (id) => {
        set((state) => ({
            toasts: state.toasts.map(t =>
                t.id === id ? { ...t, exiting: true } : t
            )
        }));
        setTimeout(() => {
            set((state) => ({
                toasts: state.toasts.filter(t => t.id !== id)
            }));
        }, 300);
    }
}));
