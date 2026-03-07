import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards, Request } from '@nestjs/common';
import { RelationshipsService } from './relationships.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller()
export class RelationshipsController {
    constructor(private readonly relationshipsService: RelationshipsService) { }

    @Get('api/v1/stories/:storyId/relationships')
    async findAll(@Param('storyId') storyId: string, @Request() req: any) {
        const data = await this.relationshipsService.findAll(storyId, req.user.id);
        return { success: true, data };
    }

    @Post('api/v1/stories/:storyId/relationships')
    async create(@Param('storyId') storyId: string, @Body() body: any, @Request() req: any) {
        const data = await this.relationshipsService.create(storyId, req.user.id, body);
        return { success: true, data };
    }

    @Put('api/v1/relationships/:id')
    async update(@Param('id') id: string, @Body() body: any, @Request() req: any) {
        const data = await this.relationshipsService.update(id, req.user.id, body);
        return { success: true, data };
    }

    @Delete('api/v1/relationships/:id')
    async delete(@Param('id') id: string, @Request() req: any) {
        await this.relationshipsService.delete(id, req.user.id);
        return { success: true };
    }
}
