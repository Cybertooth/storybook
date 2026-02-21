import { Controller, Get, Post, Body, Put, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { EventsService } from './events.service';

@UseGuards(JwtAuthGuard)
@Controller('api/v1')
export class EventsController {
    constructor(private readonly eventsService: EventsService) { }

    @Post('stories/:storyId/events')
    async create(@Request() req: any, @Param('storyId') storyId: string, @Body() data: any) {
        const uid = req.user.id;
        return { success: true, data: await this.eventsService.create(uid, storyId, data) };
    }

    @Get('stories/:storyId/events')
    async findAll(@Request() req: any, @Param('storyId') storyId: string) {
        const uid = req.user.id;
        return { success: true, data: await this.eventsService.findAll(uid, storyId) };
    }

    @Put('events/:id')
    async update(@Request() req: any, @Param('id') id: string, @Body() data: any) {
        const uid = req.user.id;
        return { success: true, data: await this.eventsService.update(uid, id, data) };
    }

    @Delete('events/:id')
    async remove(@Request() req: any, @Param('id') id: string) {
        const uid = req.user.id;
        await this.eventsService.remove(uid, id);
        return { success: true };
    }
}
