import { useSettingsStore } from '@/store/useSettingsStore';
import { useAiLogStore } from '@/store/useAiLogStore';

export interface AiResponse {
    text: string;
}

export const aiService = {
    expandPlot: async (currentPlot: string): Promise<string> => {
        return await makeAiCall("Expand this plot slightly:", currentPlot, "Expand Plot");
    },

    analyzePlot: async (plot: string): Promise<string> => {
        const prompt = `Analyze the following plot summary and extract:
1. Characters (Name, Role, Brief Description)
2. Locations (Name, Description)
3. Key Events (Title, Description)

Return the result as valid JSON with keys: "characters", "locations", "events". Do not wrap in markdown code blocks.`;
        return await makeAiCall(prompt, plot, "Analyze Plot");
    },

    generatePlotOptions: async (plot: string): Promise<string[]> => {
        const prompt = `You are a master plotter. Generate 3 distinct, tight plot continuations or variations for the following story idea.
        
Rules:
1. Each option should be a sequence of 3-5 concrete events.
2. No dialogue, just action and cause-and-effect.
3. Make them distinct (e.g., one action-heavy, one character-focused, one twisty).
4. Return ONLY a valid JSON array of strings, where each string is a full option. Example: ["Option 1 text...", "Option 2 text...", "Option 3 text..."]. Do not wrap in markdown.`;

        const response = await makeAiCall(prompt, plot, "Generate Plot Options");
        try {
            // Basic cleanup to look for JSON array
            const jsonMatch = response.match(/\[[\s\S]*\]/);
            const jsonStr = jsonMatch ? jsonMatch[0] : response;
            return JSON.parse(jsonStr);
        } catch (e) {
            console.error("Failed to parse plot options", e);
            return [response]; // Fallback to raw text as single option
        }
    },

    streamlinePlot: async (fragmentedPlot: string): Promise<string> => {
        const prompt = "The following is a rough sequence of plot points combined from different ideas. Smooth it out into a cohesive, flowing narrative summary. Fix any logical inconsistencies or tonal clashes.";
        return await makeAiCall(prompt, fragmentedPlot, "Streamline Plot");
    },

    critiqueStory: async (context: string): Promise<string> => {
        const prompt = "Act as a critical editor. Review the following story bible (plot, characters, events) and identify plot holes, inconsistencies, and pacing issues. Be constructive but sharp.";
        return await makeAiCall(prompt, context, "Critique Story");
    },

    suggestCharacter: async (context: string): Promise<string> => {
        const prompt = "Suggest a new interesting character that would fit into this story. Provide Name, Role, and a brief Description and Quirk.";
        return await makeAiCall(prompt, context, "Suggest Character");
    }
};

async function makeAiCall(systemPrompt: string, userContent: string, actionName: string): Promise<string> {
    const settings = useSettingsStore.getState();
    const logStore = useAiLogStore.getState();
    const apiKey = settings.llmProvider === 'gemini' ? settings.geminiKey : settings.openaiKey;
    const provider = settings.llmProvider;
    const model = provider === 'gemini' ? 'gemini-3-flash-preview' : 'gpt-4o';

    if (!apiKey) {
        const error = `Please configure your ${provider} API Key in Settings.`;
        logStore.addLog({
            type: 'error',
            provider,
            model,
            content: error,
            metadata: { action: actionName }
        });
        throw new Error(error);
    }

    // Log Request
    logStore.addLog({
        type: 'request',
        provider,
        model,
        content: `Action: ${actionName}\n\nSystem: ${systemPrompt}\n\nUser Context (truncated): ${userContent.substring(0, 500)}...`,
        metadata: { action: actionName }
    });

    const startTime = Date.now();
    let responseText = '';

    try {
        if (provider === 'gemini') {
            responseText = await callGemini(apiKey, systemPrompt, userContent);
        } else {
            responseText = await callOpenAI(apiKey, systemPrompt, userContent);
        }

        // Log Response
        logStore.addLog({
            type: 'response',
            provider,
            model,
            content: responseText,
            metadata: {
                action: actionName,
                latency: Date.now() - startTime
            }
        });

        return responseText;

    } catch (error) {
        // Log Error
        logStore.addLog({
            type: 'error',
            provider,
            model,
            content: (error as Error).message,
            metadata: {
                action: actionName,
                latency: Date.now() - startTime
            }
        });
        throw error;
    }
}

async function callGemini(apiKey: string, systemPrompt: string, userContent: string): Promise<string> {
    const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=${apiKey}`;

    const body = {
        contents: [{
            parts: [{ text: `${systemPrompt}\n\nContext:\n${userContent}` }]
        }]
    };

    const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
    });

    if (!response.ok) {
        const err = await response.json();
        throw new Error(err.error?.message || 'Gemini API Error');
    }

    const data = await response.json();
    return data.candidates?.[0]?.content?.parts?.[0]?.text || '';
}

async function callOpenAI(apiKey: string, systemPrompt: string, userContent: string): Promise<string> {
    const url = 'https://api.openai.com/v1/chat/completions';

    const body = {
        model: 'gpt-4o',
        messages: [
            { role: "system", content: systemPrompt },
            { role: "user", content: userContent }
        ]
    };

    const response = await fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${apiKey}`
        },
        body: JSON.stringify(body)
    });

    if (!response.ok) {
        const err = await response.json();
        throw new Error(err.error?.message || 'OpenAI API Error');
    }

    const data = await response.json();
    return data.choices?.[0]?.message?.content || '';
}
