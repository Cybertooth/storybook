import { Controller, Get, Post, Body, Put, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { NotesService } from './notes.service';

@UseGuards(JwtAuthGuard)
@Controller('api/v1')
export class NotesController {
    constructor(private readonly notesService: NotesService) { }

    @Post('stories/:storyId/notes')
    async create(@Request() req: any, @Param('storyId') storyId: string, @Body() data: any) {
        const uid = req.user.id;
        return { success: true, data: await this.notesService.create(uid, storyId, data) };
    }

    @Get('stories/:storyId/notes')
    async findAll(@Request() req: any, @Param('storyId') storyId: string) {
        const uid = req.user.id;
        return { success: true, data: await this.notesService.findAll(uid, storyId) };
    }

    @Get('notes/:id')
    async findOne(@Request() req: any, @Param('id') id: string) {
        const uid = req.user.id;
        return { success: true, data: await this.notesService.findOne(uid, id) };
    }

    @Put('notes/:id')
    async update(@Request() req: any, @Param('id') id: string, @Body() data: any) {
        const uid = req.user.id;
        return { success: true, data: await this.notesService.update(uid, id, data) };
    }

    @Delete('notes/:id')
    async remove(@Request() req: any, @Param('id') id: string) {
        const uid = req.user.id;
        await this.notesService.remove(uid, id);
        return { success: true };
    }
}
