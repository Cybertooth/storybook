import { Controller, Get, Post, Body, Put, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CharactersService } from './characters.service';

@UseGuards(JwtAuthGuard)
@Controller('api/v1')
export class CharactersController {
    constructor(private readonly charactersService: CharactersService) { }

    @Post('stories/:storyId/characters')
    async create(@Request() req: any, @Param('storyId') storyId: string, @Body() data: any) {
        const uid = req.user.id;
        return { success: true, data: await this.charactersService.create(uid, storyId, data) };
    }

    @Get('stories/:storyId/characters')
    async findAll(@Request() req: any, @Param('storyId') storyId: string) {
        const uid = req.user.id;
        return { success: true, data: await this.charactersService.findAll(uid, storyId) };
    }

    @Get('characters/:id')
    async findOne(@Request() req: any, @Param('id') id: string) {
        const uid = req.user.id;
        return { success: true, data: await this.charactersService.findOne(uid, id) };
    }

    @Put('characters/:id')
    async update(@Request() req: any, @Param('id') id: string, @Body() data: any) {
        const uid = req.user.id;
        return { success: true, data: await this.charactersService.update(uid, id, data) };
    }

    @Delete('characters/:id')
    async remove(@Request() req: any, @Param('id') id: string) {
        const uid = req.user.id;
        await this.charactersService.remove(uid, id);
        return { success: true };
    }
}
