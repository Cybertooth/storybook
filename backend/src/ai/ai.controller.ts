import { Controller, Post, Body, UseGuards } from '@nestjs/common';
import { AiService } from './ai.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/v1/ai')
export class AiController {
    constructor(private readonly aiService: AiService) { }

    @Post('generate-portrait')
    async generatePortrait(@Body() body: { characterDescription: string }) {
        return this.aiService.generatePortrait(body.characterDescription);
    }

    @Post('analyze-tropes')
    async analyzeTropes(@Body() body: { storyContext: string }) {
        return this.aiService.analyzeTropes(body.storyContext);
    }

    @Post('plot-hole-check')
    async plotHoleCheck(@Body() body: { storyContext: string }) {
        return this.aiService.plotHoleCheck(body.storyContext);
    }

    @Post('expand-plot')
    async expandPlot(@Body() body: { currentPlot: string }) {
        return this.aiService.expandPlot(body.currentPlot);
    }

    @Post('critique')
    async critique(@Body() body: { draft: string; context: string }) {
        return this.aiService.critique(body.draft, body.context);
    }

    @Post('revise-draft')
    async reviseDraft(@Body() body: { draft: string; maxims: string[] }) {
        return this.aiService.reviseDraft(body.draft, body.maxims);
    }

    @Post('show-dont-tell')
    async showDontTell(@Body() body: { prose: string }) {
        return this.aiService.showDontTell(body.prose);
    }

    @Post('suggest-next')
    async suggestNext(@Body() body: { priorText: string; plotContext: string }) {
        return this.aiService.suggestNext(body.priorText, body.plotContext);
    }

    @Post('generic')
    async generic(@Body() body: { prompt: string; context?: string }) {
        return this.aiService.generic(body.prompt, body.context);
    }
}
