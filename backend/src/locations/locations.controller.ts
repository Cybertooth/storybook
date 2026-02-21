import { Controller, Get, Post, Body, Put, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { LocationsService } from './locations.service';

@UseGuards(JwtAuthGuard)
@Controller('api/v1')
export class LocationsController {
    constructor(private readonly locationsService: LocationsService) { }

    @Post('stories/:storyId/locations')
    async create(@Request() req: any, @Param('storyId') storyId: string, @Body() data: any) {
        const uid = req.user.id;
        return { success: true, data: await this.locationsService.create(uid, storyId, data) };
    }

    @Get('stories/:storyId/locations')
    async findAll(@Request() req: any, @Param('storyId') storyId: string) {
        const uid = req.user.id;
        return { success: true, data: await this.locationsService.findAll(uid, storyId) };
    }

    @Put('locations/:id')
    async update(@Request() req: any, @Param('id') id: string, @Body() data: any) {
        const uid = req.user.id;
        return { success: true, data: await this.locationsService.update(uid, id, data) };
    }

    @Delete('locations/:id')
    async remove(@Request() req: any, @Param('id') id: string) {
        const uid = req.user.id;
        await this.locationsService.remove(uid, id);
        return { success: true };
    }
}
