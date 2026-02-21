import { useAiLogStore } from '@/store/useAiLogStore';
import { apiClient } from './apiClient';

export interface AiResponse {
    text: string;
}

export interface PlotCritique {
    summary: string;
    details: string;
    severity: 'small' | 'medium' | 'major';
}

async function proxyCall<T>(actionName: string, endpoint: string, payload: any): Promise<T> {
    const logStore = useAiLogStore.getState();
    const startTime = Date.now();

    logStore.addLog({
        type: 'request',
        provider: 'gemini',
        model: 'gemini-1.5-flash',
        content: `Action: ${actionName}\n\nPayload: ${JSON.stringify(payload).substring(0, 500)}...`,
        metadata: { action: actionName }
    });

    try {
        const { data } = await apiClient.post<T>(`/ai/${endpoint}`, payload);

        logStore.addLog({
            type: 'response',
            provider: 'gemini',
            model: 'gemini-1.5-flash',
            content: typeof data === 'string' ? data : JSON.stringify(data).substring(0, 500),
            metadata: { action: actionName, latency: Date.now() - startTime }
        });

        return data;
    } catch (error: any) {
        logStore.addLog({
            type: 'error',
            provider: 'gemini',
            model: 'gemini-1.5-flash',
            content: error.message || 'Error communicating with backend AI proxy.',
            metadata: { action: actionName, latency: Date.now() - startTime }
        });
        throw error;
    }
}

export const aiService = {
    expandPlot: async (currentPlot: string): Promise<string> => {
        const res = await proxyCall<any>('Expand Plot', 'expand-plot', { currentPlot });
        return res?.expansion || currentPlot;
    },

    analyzePlot: async (plot: string): Promise<string> => {
        const prompt = `You are an expert Story Editor analyzing a narrative.
## Context
A user has provided a raw plot summary.

## Objective
Extract the key structural elements from the text into a strict JSON format.

## Instructions
1. Identify all named or implied Characters. (Include Name, Role, Brief Description).
2. Identify all Locations mentioned. (Include Name, Description).
3. Identify all Key Events in chronological order. (Include Title, Description).

## Output Format
Return ONLY valid JSON matching this structure. Do NOT wrap it in markdown codeblocks like \`\`\`json.
{
  "characters": [{ "name": "...", "role": "...", "description": "..." }],
  "locations": [{ "name": "...", "description": "..." }],
  "events": [{ "title": "...", "description": "..." }]
}`;
        const res = await proxyCall<any>("Analyze Plot", 'generic', { prompt, context: plot });
        return res?.text || '';
    },

    generatePlotOptions: async (plot: string): Promise<string[]> => {
        const prompt = `You are a Master Storyteller and Plotting Consultant.
## Context
The user has a story idea and needs creative directions to expand it.

## Objective
Generate 3 distinct, compelling plot continuations or variations that push the story forward.

## Instructions
1. Write 3 distinct options.
2. Each option must be a concrete sequence of 3-5 events.
3. Keep the pacing tight.

## Output Format
Return ONLY a valid JSON array of strings. Do NOT wrap it in markdown codeblocks.
[
  "Option 1 description...",
  "Option 2 description...",
  "Option 3 description..."
]`;
        const res = await proxyCall<any>("Generate Plot Options", 'generic', { prompt, context: plot });
        try {
            const raw = res?.text || '[]';
            const jsonMatch = raw.match(/\[[\s\S]*\]/);
            return JSON.parse(jsonMatch ? jsonMatch[0] : raw);
        } catch (e) { return [res?.text]; }
    },

    streamlinePlot: async (fragmentedPlot: string): Promise<string> => {
        const prompt = `You are an expert Fiction Editor. Streamline the fragmented plot points into a cohesive, flowing narrative summary. Output ONLY the improved text.`;
        const res = await proxyCall<any>("Streamline Plot", 'generic', { prompt, context: fragmentedPlot });
        return res?.text || fragmentedPlot;
    },

    generateCritiques: async (context: string): Promise<PlotCritique[]> => {
        const res = await proxyCall<any>("Generate Critiques", 'critique', { draft: context, context: "Story Bible Context" });
        return res || [];
    },

    suggestCharacter: async (context: string): Promise<string> => {
        const prompt = `You are a Character Design Expert. Suggest a compelling new character that fits this story. Output ONLY the character details.`;
        const res = await proxyCall<any>("Suggest Character", 'generic', { prompt, context });
        return res?.text || '';
    },

    generateRevisionsFromCritiques: async (currentPlot: string, selectedCritiques: PlotCritique[]): Promise<string[]> => {
        const maxims = selectedCritiques.map(c => `${c.summary}: ${c.details}`);
        const res = await proxyCall<any>("Generate Revisions from Critiques", 'revise-draft', { draft: currentPlot, maxims });
        return res?.revisions || [currentPlot];
    },

    brainstormNext: async (currentText: string, plotContext?: string): Promise<string[]> => {
        const res = await proxyCall<any>("Brainstorm Next", 'suggest-next', { priorText: currentText.slice(-2000), plotContext: plotContext || '' });
        return res?.suggestions || [];
    },

    checkConsistency: async (context: string): Promise<any[]> => {
        const res = await proxyCall<any>("Consistency Check", 'plot-hole-check', { storyContext: context });
        return res || [];
    },

    highlightShowDontTell: async (proseText: string): Promise<any[]> => {
        const res = await proxyCall<any>("Show Don't Tell", 'show-dont-tell', { prose: proseText });
        return res || [];
    },

    generateCharacterPortrait: async (characterDescription: string): Promise<string> => {
        const res = await proxyCall<any>('Generate Portrait', 'generate-portrait', { characterDescription });
        return res?.imageUrl || '';
    },

    analyzeTropes: async (context: string): Promise<any[]> => {
        const res = await proxyCall<any>("Tropes & Clichés Analysis", 'analyze-tropes', { storyContext: context });
        return res || [];
    }
};
