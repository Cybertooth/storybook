import { Moon, Sun, Monitor } from 'lucide-react';
import { useTheme } from './ThemeProvider';
import clsx from 'clsx';
import { useState, useRef, useEffect } from 'react';

export function ThemeToggle() {
    const { theme, setTheme } = useTheme();
    const [isOpen, setIsOpen] = useState(false);
    const dropdownRef = useRef<HTMLDivElement>(null);

    // Close on click outside
    useEffect(() => {
        function handleClickOutside(event: MouseEvent) {
            if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
                setIsOpen(false);
            }
        }
        document.addEventListener("mousedown", handleClickOutside);
        return () => document.removeEventListener("mousedown", handleClickOutside);
    }, []);

    return (
        <div className="relative" ref={dropdownRef}>
            <button
                onClick={() => setIsOpen(!isOpen)}
                className="p-2 rounded-md hover:bg-stone-100 dark:hover:bg-stone-800 text-stone-500 dark:text-stone-400 transition-colors"
                title="Toggle Theme"
            >
                {theme === 'light' ? <Sun className="w-5 h-5" /> : theme === 'dark' ? <Moon className="w-5 h-5" /> : <Monitor className="w-5 h-5" />}
            </button>

            {isOpen && (
                <div className="absolute right-0 mt-2 w-36 bg-white dark:bg-stone-900 border border-stone-200 dark:border-stone-800 rounded-lg shadow-lg py-1 z-50 overflow-hidden animate-in fade-in slide-in-from-top-2 duration-200">
                    <button
                        onClick={() => { setTheme('light'); setIsOpen(false); }}
                        className={clsx(
                            "w-full flex items-center gap-2 px-3 py-2 text-sm transition-colors",
                            theme === 'light' ? "bg-stone-100 dark:bg-stone-800 text-stone-900 dark:text-stone-100" : "text-stone-600 dark:text-stone-400 hover:bg-stone-50 dark:hover:bg-stone-800"
                        )}
                    >
                        <Sun className="w-4 h-4" /> Light
                    </button>
                    <button
                        onClick={() => { setTheme('dark'); setIsOpen(false); }}
                        className={clsx(
                            "w-full flex items-center gap-2 px-3 py-2 text-sm transition-colors",
                            theme === 'dark' ? "bg-stone-100 dark:bg-stone-800 text-stone-900 dark:text-stone-100" : "text-stone-600 dark:text-stone-400 hover:bg-stone-50 dark:hover:bg-stone-800"
                        )}
                    >
                        <Moon className="w-4 h-4" /> Dark
                    </button>
                    <button
                        onClick={() => { setTheme('system'); setIsOpen(false); }}
                        className={clsx(
                            "w-full flex items-center gap-2 px-3 py-2 text-sm transition-colors",
                            theme === 'system' ? "bg-stone-100 dark:bg-stone-800 text-stone-900 dark:text-stone-100" : "text-stone-600 dark:text-stone-400 hover:bg-stone-50 dark:hover:bg-stone-800"
                        )}
                    >
                        <Monitor className="w-4 h-4" /> System
                    </button>
                </div>
            )}
        </div>
    );
}
