import { Injectable, BadRequestException, InternalServerErrorException } from '@nestjs/common';

@Injectable()
export class AiService {
  private readonly GEMINI_API_KEY = process.env.GEMINI_API_KEY || '';

  private async callGemini(prompt: string, systemInstruction?: string): Promise<string> {
    if (process.env.MOCK_LLM === 'true') {
      return JSON.stringify({ mocked: true, response: 'This is a mocked LLM response for testing purposes.' });
    }

    if (!this.GEMINI_API_KEY) {
      throw new BadRequestException('Gemini API Key is not configured on the server.');
    }

    const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent`;

    const contents = [{ role: 'user', parts: [{ text: prompt }] }];
    const payload: any = { contents };
    if (systemInstruction) {
      payload.systemInstruction = { parts: [{ text: systemInstruction }] };
    }

    let response: Response;
    try {
      response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': this.GEMINI_API_KEY,
        },
        body: JSON.stringify(payload),
        signal: AbortSignal.timeout(15000),
      });
    } catch {
      throw new InternalServerErrorException('LLM provider request failed');
    }

    if (!response.ok) {
      throw new BadRequestException('LLM provider rejected the request');
    }

    const data = await response.json();
    try {
      return data.candidates[0].content.parts[0].text;
    } catch {
      throw new BadRequestException('Unexpected response format from Gemini');
    }
  }

  private parseJsonSafe(text: string) {
    try {
      const cleanText = text.replace(/```json/g, '').replace(/```/g, '').trim();
      return JSON.parse(cleanText);
    } catch {
      return null;
    }
  }

  async generatePortrait(characterDescription: string) {
    return { imageUrl: `https://api.dicebear.com/7.x/bottts/svg?seed=${encodeURIComponent(characterDescription)}` };
  }

  async analyzeTropes(storyContext: string) {
    const prompt = `Analyze the following story context and identify key literary or narrative tropes. Return strictly a JSON array of objects with 'name' and 'description' keys.\n\nContext:\n${storyContext}`;
    return this.parseJsonSafe(await this.callGemini(prompt)) || [];
  }

  async plotHoleCheck(storyContext: string) {
    const prompt = `Analyze this story for plot holes or logical inconsistencies. Return strictly a JSON array of objects with 'issue' and 'suggestion' keys.\n\nContext:\n${storyContext}`;
    return this.parseJsonSafe(await this.callGemini(prompt)) || [];
  }

  async expandPlot(currentPlot: string) {
    const prompt = `Expand the following plot. Return strictly a JSON object with an 'expansion' key.\n\nPlot:\n${currentPlot}`;
    return this.parseJsonSafe(await this.callGemini(prompt)) || { expansion: currentPlot };
  }

  async critique(draft: string, context: string) {
    const prompt = `Critique the following draft given its context. Return strictly a JSON array of objects with 'point' and 'detail' keys.\n\nContext:\n${context}\n\nDraft:\n${draft}`;
    return this.parseJsonSafe(await this.callGemini(prompt)) || [];
  }

  async reviseDraft(draft: string, maxims: string[]) {
    const prompt = `Revise the following draft honoring these maxims: ${maxims.join(', ')}. Return strictly a JSON object with a 'revisions' array of revised paragraphs.\n\nDraft:\n${draft}`;
    return this.parseJsonSafe(await this.callGemini(prompt)) || { revisions: [draft] };
  }

  async showDontTell(prose: string) {
    const prompt = `Improve this prose using 'show, don't tell'. Return strictly a JSON array of objects with 'original' and 'suggestion' keys.\n\nProse:\n${prose}`;
    return this.parseJsonSafe(await this.callGemini(prompt)) || [];
  }

  async suggestNext(priorText: string, plotContext: string) {
    const prompt = `Suggest what happens next based on the prior text and plot context. Return strictly a JSON object with a 'suggestions' string array.\n\nContext:\n${plotContext}\n\nPrior Text:\n${priorText}`;
    return this.parseJsonSafe(await this.callGemini(prompt)) || { suggestions: ['...keep writing...'] };
  }

  async generic(prompt: string, context?: string) {
    const fullPrompt = context ? `${prompt}\n\nContext:\n${context}` : prompt;
    const result = await this.callGemini(fullPrompt);
    return { text: result };
  }
}
