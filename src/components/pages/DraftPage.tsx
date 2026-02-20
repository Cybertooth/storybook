import { useState } from 'react';
import { useStoryStore } from '@/store/useStoryStore';
import { ChapterList } from '../features/editor/ChapterList';
import { MarkdownEditor } from '../features/editor/MarkdownEditor';
import { Edit3 } from 'lucide-react';

export const DraftPage = () => {
    const { chapters, createChapter, updateChapter, deleteChapter } = useStoryStore();
    const [selectedId, setSelectedId] = useState<string | null>(null);

    const activeChapter = chapters.find(c => c.id === selectedId);

    const handleCreate = async (title: string) => {
        await createChapter(title);
    };

    return (
        <div className="flex h-[calc(100vh-96px)] -mx-8 -mb-12 lg:-mx-12 rounded-tl-2xl overflow-hidden border border-stone-200/50 shadow-sm">
            <ChapterList
                chapters={chapters}
                selectedId={selectedId}
                onSelect={setSelectedId}
                onCreate={handleCreate}
                onDelete={deleteChapter}
            />

            <div className="flex-1 bg-white h-full overflow-hidden">
                {activeChapter ? (
                    <MarkdownEditor
                        chapter={activeChapter}
                        onUpdate={updateChapter}
                    />
                ) : (
                    <div className="h-full flex flex-col items-center justify-center text-stone-400 space-y-3">
                        <div className="w-16 h-16 bg-stone-100 rounded-2xl flex items-center justify-center">
                            <Edit3 className="w-8 h-8 text-stone-300" />
                        </div>
                        <div className="text-center">
                            <p className="font-medium text-stone-500">Select a chapter to start writing</p>
                            <p className="text-sm mt-1">Or create a new one from the sidebar</p>
                        </div>
                    </div>
                )}
            </div>
        </div>
    );
};
