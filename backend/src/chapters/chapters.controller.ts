import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards, Request } from '@nestjs/common';
import { ChaptersService } from './chapters.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller()
export class ChaptersController {
    constructor(private readonly chaptersService: ChaptersService) { }

    @Get('api/v1/stories/:storyId/chapters')
    async findAll(@Param('storyId') storyId: string, @Request() req: any) {
        const data = await this.chaptersService.findAll(storyId, req.user.id);
        return { success: true, data };
    }

    @Post('api/v1/stories/:storyId/chapters')
    async create(@Param('storyId') storyId: string, @Body() body: any, @Request() req: any) {
        const data = await this.chaptersService.create(storyId, req.user.id, body);
        return { success: true, data };
    }

    @Get('api/v1/chapters/:id')
    async findOne(@Param('id') id: string, @Request() req: any) {
        const data = await this.chaptersService.findOne(id, req.user.id);
        return { success: true, data };
    }

    @Put('api/v1/chapters/:id')
    async update(@Param('id') id: string, @Body() body: any, @Request() req: any) {
        const data = await this.chaptersService.update(id, req.user.id, body);
        return { success: true, data };
    }

    @Delete('api/v1/chapters/:id')
    async delete(@Param('id') id: string, @Request() req: any) {
        await this.chaptersService.delete(id, req.user.id);
        return { success: true };
    }
}
