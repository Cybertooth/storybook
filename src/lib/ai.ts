import { useSettingsStore } from '@/store/useSettingsStore';
import { useAiLogStore } from '@/store/useAiLogStore';

export interface AiResponse {
    text: string;
}

export interface PlotCritique {
    summary: string;
    details: string;
    severity: 'small' | 'medium' | 'major';
}

export const aiService = {
    expandPlot: async (currentPlot: string): Promise<string> => {
        return await makeAiCall("Expand this plot slightly:", currentPlot, "Expand Plot");
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
        return await makeAiCall(prompt, plot, "Analyze Plot");
    },

    generatePlotOptions: async (plot: string): Promise<string[]> => {
        const prompt = `You are a Master Storyteller and Plotting Consultant.
## Context
The user has a story idea and needs creative directions to expand it.

## Objective
Generate 3 distinct, compelling plot continuations or variations that push the story forward.

## Instructions
1. Write 3 distinct options (e.g., action-heavy, character-focused, twist-driven).
2. Each option must be a concrete sequence of 3-5 events.
3. Show, don't tell. Focus on cause-and-effect action. No dialogue.
4. Keep the pacing tight.

## Output Format
Return ONLY a valid JSON array of strings. Each string is one full option. Do NOT wrap it in markdown codeblocks. Example:
[
  "Option 1 description...",
  "Option 2 description...",
  "Option 3 description..."
]`;

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
        const prompt = `You are an expert Fiction Editor.
## Objective
Transform a rough, fragmented sequence of plot points into a cohesive, flowing narrative summary.

## Instructions
1. Smooth out the transitions between ideas.
2. Fix any logical inconsistencies or tonal clashes.
3. Maintain the original core events but make them read like a professional back-cover blurb or treatment.
4. Output ONLY the improved text. Do not add conversational filler.`;
        return await makeAiCall(prompt, fragmentedPlot, "Streamline Plot");
    },

    generateCritiques: async (context: string): Promise<PlotCritique[]> => {
        const prompt = `You are a brilliant Developmental Editor and Story Fixer.
## Context
The user has provided their story bible, including plot, characters, events, and locations.

## Objective
Identify the 3 biggest weaknesses in the story (e.g., plot holes, weak motivation, pacing issues). DO NOT rewrite the plot, just provide the critiques.

## Instructions
1. Analyze the narrative for structural flaws.
2. Generate exactly 3 critiques.
3. For each critique, provide a short 'summary' of the issue.
4. Provide 'details' explaining why it's a problem and how to fix it.
5. Assign a 'severity' level to each critique: 'small', 'medium', or 'major'.

## Output Format
Return ONLY valid JSON containing an array of exactly 3 objects. Do NOT wrap in markdown codeblocks like \`\`\`json.
[
  {
    "summary": "Pacing sags in the middle...",
    "details": "To fix this, the protagonist needs...",
    "severity": "major"
  }
]`;
        const response = await makeAiCall(prompt, context, "Generate Critiques");
        try {
            const jsonMatch = response.match(/\[[\s\S]*\]/);
            const jsonStr = jsonMatch ? jsonMatch[0] : response;
            return JSON.parse(jsonStr) as PlotCritique[];
        } catch (e) {
            console.error("Failed to parse critique options", e);
            throw new Error("Failed to parse AI critique options into actionable data.");
        }
    },

    suggestCharacter: async (context: string): Promise<string> => {
        const prompt = `You are a Character Design Expert for novelists.
## Objective
Suggest a compelling new character that would fit perfectly into the provided story context but create interesting new dynamics.

## Instructions
1. Analyze the current story context.
2. Identify a gap in the character roster (e.g. a foil, a mentor, an antagonist, a wild card).
3. Generate a character with: Name, Role, a brief Description, and a unique Quirk or flaw.
4. Output ONLY the character details as a readable paragraph or bullet points. Do not add conversational filler.`;
        return await makeAiCall(prompt, context, "Suggest Character");
    },

    generateRevisionsFromCritiques: async (currentPlot: string, selectedCritiques: PlotCritique[]): Promise<string[]> => {
        const context = `
CURRENT PLOT:
${currentPlot}

SELECTED CRITIQUES TO ADDRESS:
${selectedCritiques.map(c => `- ${c.summary}: ${c.details} (Severity: ${c.severity})`).join('\n')}
`;
        const prompt = `You are an expert Story Editor rewriting a plot to address specific feedback.
## Context
The user has provided their current plot summary and a list of specific critiques they want to address.

## Objective
Generate 3 distinct, full-text rewrites of the plot summary. Each rewrite must address ALL of the selected critiques, but they can approach the solutions in slightly different ways (e.g., one changes the villain's motivation, another changes a key set piece).

## Instructions
1. Read the current plot and the critiques carefully.
2. Write 3 distinct, full-length plot summaries that resolve the issues.
3. The style and tone should remain consistent with the original plot.
4. Output ONLY the 3 rewrites. Do not add introductory text.

## Output Format
Return ONLY a valid JSON array of 3 strings. Each string is a full plot rewrite. Do NOT wrap it in markdown codeblocks. Example:
[
  "Rewrite option 1...",
  "Rewrite option 2...",
  "Rewrite option 3..."
]`;
        const response = await makeAiCall(prompt, context, "Generate Revisions from Critiques");
        try {
            const jsonMatch = response.match(/\[[\s\S]*\]/);
            const jsonStr = jsonMatch ? jsonMatch[0] : response;
            return JSON.parse(jsonStr) as string[];
        } catch (e) {
            console.error("Failed to parse revision options", e);
            throw new Error("Failed to parse AI revision options into actionable data.");
        }
    },

    brainstormNext: async (currentText: string, plotContext?: string): Promise<string[]> => {
        const context = `
CURRENT CHAPTER DRAFT (OR END OF DRAFT):
${currentText.slice(-2000)} // Only look at the most recent ~500 words for context to maintain narrative flow.

${plotContext ? `OVERALL PLOT CONTEXT:\n${plotContext}` : ''}
`;
        const prompt = `You are an AI Co-Writer and Brainstorming Partner.
## Context
The user is writing a chapter and is stuck on what should happen next.

## Objective
Generate 3 distinct, short continuations (1-3 sentences each) that seamlessly pick up right where the current draft leaves off.

## Instructions
1. Analyze the tone, style, and immediate situation of the recent draft text.
2. Provide 3 different directions the scene could take right now.
3. Option 1: The Logical Next Step.
4. Option 2: The Unexpected Obstacle/Complication.
5. Option 3: A Shift in Focus (e.g., an interruption, a sensory detail, an internal realization).
6. Write in the same tense and POV as the provided draft text.
7. Do NOT provide meta-commentary. Output ONLY the actual story text continuations.

## Output Format
Return ONLY a valid JSON array of 3 strings. Do NOT wrap it in markdown codeblocks like \`\`\`json. Example:
[
  "He reached for the handle, but a sudden loud bang echoed...",
  "The door swung open to reveal an empty room...",
  "Before he could turn the knob, he noticed a strange smell..."
]`;
        const response = await makeAiCall(prompt, context, "Brainstorm Next");
        try {
            const jsonMatch = response.match(/\[[\s\S]*\]/);
            const jsonStr = jsonMatch ? jsonMatch[0] : response;
            return JSON.parse(jsonStr) as string[];
        } catch (e) {
            console.error("Failed to parse brainstorm options", e);
            throw new Error("Failed to parse AI brainstorm options.");
        }
    }
};

async function makeAiCall(systemPrompt: string, userContent: string, actionName: string): Promise<string> {
    const settings = useSettingsStore.getState();
    const logStore = useAiLogStore.getState();
    const apiKey = settings.llmProvider === 'gemini' ? settings.geminiKey : settings.openaiKey;
    const provider = settings.llmProvider;
    const model = provider === 'gemini' ? (settings.geminiModel || 'gemini-3-flash-preview') : 'gpt-4o';

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
            responseText = await callGemini(apiKey, model, systemPrompt, userContent);
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

async function callGemini(apiKey: string, model: string, systemPrompt: string, userContent: string): Promise<string> {
    const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`;

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
