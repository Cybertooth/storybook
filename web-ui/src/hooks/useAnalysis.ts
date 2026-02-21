import { useState } from 'react';
import { aiService } from '@/lib/ai';
import { useStoryStore } from '@/store/useStoryStore';
import { useToastStore } from '@/hooks/useToast';

export const useAnalysis = () => {
    const toast = useToastStore(s => s.toast);
    const [isAnalyzing, setIsAnalyzing] = useState(false);
    const [analysisResult, setAnalysisResult] = useState<any>(null);
    const { createCharacter, createLocation, createEvent } = useStoryStore();

    const analyze = async (plot: string) => {
        setIsAnalyzing(true);
        try {
            const resultJson = await aiService.analyzePlot(plot);
            // Basic cleanup to find JSON blob if LLM adds text around it
            const jsonMatch = resultJson.match(/\{[\s\S]*\}/);
            const jsonStr = jsonMatch ? jsonMatch[0] : resultJson;
            const parsed = JSON.parse(jsonStr);
            setAnalysisResult(parsed);
        } catch (error) {
            console.error("Analysis failed", error);
            toast((error as Error).message, 'error');
        } finally {
            setIsAnalyzing(false);
        }
    };

    const applyAnalysis = async () => {
        if (!analysisResult) return;

        // Process Characters
        if (analysisResult.characters) {
            for (const char of analysisResult.characters) {
                // Determine role based on description or default
                const role = char.role?.toLowerCase().includes('antagonist') ? 'antagonist' :
                    char.role?.toLowerCase().includes('protagonist') ? 'protagonist' : 'supporting';
                await createCharacter(char.Name || char.name, role);
                // We'd arguably want to update description too, but createCharacter is minimal signature currently.
                // For MVP polish, we might want to expand createCharacter or do an update immediately after.
            }
        }

        // Process Locations
        if (analysisResult.locations) {
            for (const loc of analysisResult.locations) {
                await createLocation(loc.Name || loc.name);
            }
        }

        // Process Events
        if (analysisResult.events) {
            for (const evt of analysisResult.events) {
                await createEvent(evt.Title || evt.title, 'Main');
            }
        }

        setAnalysisResult(null);
    };

    const discardAnalysis = () => setAnalysisResult(null);

    return {
        isAnalyzing,
        analysisResult,
        analyze,
        applyAnalysis,
        discardAnalysis
    };
};
