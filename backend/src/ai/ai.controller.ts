import { Controller, Post, Body, UseGuards } from '@nestjs/common';
import { IsArray, IsOptional, IsString, MaxLength, ArrayMaxSize } from 'class-validator';
import { AiService } from './ai.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

class GeneratePortraitDto {
  @IsString()
  @MaxLength(4000)
  characterDescription!: string;
}

class StoryContextDto {
  @IsString()
  @MaxLength(20000)
  storyContext!: string;
}

class ExpandPlotDto {
  @IsString()
  @MaxLength(20000)
  currentPlot!: string;
}

class CritiqueDto {
  @IsString()
  @MaxLength(30000)
  draft!: string;

  @IsString()
  @MaxLength(20000)
  context!: string;
}

class ReviseDraftDto {
  @IsString()
  @MaxLength(30000)
  draft!: string;

  @IsArray()
  @ArrayMaxSize(30)
  @IsString({ each: true })
  @MaxLength(200, { each: true })
  maxims!: string[];
}

class ShowDontTellDto {
  @IsString()
  @MaxLength(30000)
  prose!: string;
}

class SuggestNextDto {
  @IsString()
  @MaxLength(30000)
  priorText!: string;

  @IsString()
  @MaxLength(20000)
  plotContext!: string;
}

class GenericPromptDto {
  @IsString()
  @MaxLength(30000)
  prompt!: string;

  @IsOptional()
  @IsString()
  @MaxLength(20000)
  context?: string;
}

@UseGuards(JwtAuthGuard)
@Controller('api/v1/ai')
export class AiController {
  constructor(private readonly aiService: AiService) { }

  @Post('generate-portrait')
  async generatePortrait(@Body() body: GeneratePortraitDto) {
    return this.aiService.generatePortrait(body.characterDescription);
  }

  @Post('analyze-tropes')
  async analyzeTropes(@Body() body: StoryContextDto) {
    return this.aiService.analyzeTropes(body.storyContext);
  }

  @Post('plot-hole-check')
  async plotHoleCheck(@Body() body: StoryContextDto) {
    return this.aiService.plotHoleCheck(body.storyContext);
  }

  @Post('expand-plot')
  async expandPlot(@Body() body: ExpandPlotDto) {
    return this.aiService.expandPlot(body.currentPlot);
  }

  @Post('critique')
  async critique(@Body() body: CritiqueDto) {
    return this.aiService.critique(body.draft, body.context);
  }

  @Post('revise-draft')
  async reviseDraft(@Body() body: ReviseDraftDto) {
    return this.aiService.reviseDraft(body.draft, body.maxims);
  }

  @Post('show-dont-tell')
  async showDontTell(@Body() body: ShowDontTellDto) {
    return this.aiService.showDontTell(body.prose);
  }

  @Post('suggest-next')
  async suggestNext(@Body() body: SuggestNextDto) {
    return this.aiService.suggestNext(body.priorText, body.plotContext);
  }

  @Post('generic')
  async generic(@Body() body: GenericPromptDto) {
    return this.aiService.generic(body.prompt, body.context);
  }
}
