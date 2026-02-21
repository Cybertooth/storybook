import { Map } from 'lucide-react';
import { LocationList } from '../features/locations/LocationList';

export const LocationsPage = () => (
    <div className="max-w-6xl mx-auto space-y-8">
        <div className="flex items-center gap-3 mb-2">
            <div className="p-2 bg-emerald-100/50 dark:bg-emerald-900/30 rounded-lg text-emerald-700 dark:text-emerald-400">
                <Map className="w-5 h-5" />
            </div>
            <div>
                <h2 className="text-2xl font-serif font-bold text-stone-900 dark:text-stone-100 tracking-tight">World & Locations</h2>
                <p className="text-stone-500 dark:text-stone-400 text-xs font-medium uppercase tracking-wide">Map your story's universe</p>
            </div>
        </div>
        <LocationList />
    </div>
);
