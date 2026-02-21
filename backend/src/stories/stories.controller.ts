import { Controller, Get, Post, Body, Put, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { StoriesService } from './stories.service';

@UseGuards(JwtAuthGuard)
@Controller('api/v1/stories')
export class StoriesController {
    constructor(private readonly storiesService: StoriesService) { }

    @Post()
    async create(@Request() req: any, @Body() createStoryDto: any) {
        const uid = req.user.id;
        const data = await this.storiesService.create(uid, createStoryDto);
        return { success: true, data };
    }

    @Get()
    async findAll(@Request() req: any) {
        const uid = req.user.id;
        const data = await this.storiesService.findAll(uid);
        return { success: true, data };
    }

    @Get(':id')
    async findOne(@Request() req: any, @Param('id') id: string) {
        const uid = req.user.id;
        const data = await this.storiesService.findOne(uid, id);
        return { success: true, data };
    }

    @Put(':id')
    async update(@Request() req: any, @Param('id') id: string, @Body() updateStoryDto: any) {
        const uid = req.user.id;
        const data = await this.storiesService.update(uid, id, updateStoryDto);
        return { success: true, data };
    }

    @Delete(':id')
    async remove(@Request() req: any, @Param('id') id: string) {
        const uid = req.user.id;
        await this.storiesService.remove(uid, id);
        return { success: true };
    }
}
