import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards, Request } from '@nestjs/common';
import { QuestionsService } from './questions.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller()
export class QuestionsController {
    constructor(private readonly questionsService: QuestionsService) { }

    @Get('api/v1/stories/:storyId/questions')
    async findAll(@Param('storyId') storyId: string, @Request() req: any) {
        const data = await this.questionsService.findAll(storyId, req.user.id);
        return { success: true, data };
    }

    @Post('api/v1/stories/:storyId/questions')
    async create(@Param('storyId') storyId: string, @Body() body: any, @Request() req: any) {
        const data = await this.questionsService.create(storyId, req.user.id, body);
        return { success: true, data };
    }

    @Put('api/v1/questions/:id')
    async update(@Param('id') id: string, @Body() body: any, @Request() req: any) {
        const data = await this.questionsService.update(id, req.user.id, body);
        return { success: true, data };
    }

    @Delete('api/v1/questions/:id')
    async delete(@Param('id') id: string, @Request() req: any) {
        await this.questionsService.delete(id, req.user.id);
        return { success: true };
    }
}
