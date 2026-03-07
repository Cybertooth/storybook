import { Controller, Post, Body, UseGuards, Request } from '@nestjs/common';
import { SyncService } from './sync.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/v1/sync')
export class SyncController {
    constructor(private readonly syncService: SyncService) { }

    @Post('push')
    async push(@Request() req: any, @Body() payload: any) {
        const userId = req.user.id;
        await this.syncService.push(userId, payload);
        return { success: true };
    }

    @Post('pull')
    async pull(@Request() req: any, @Body() payload: any) {
        const userId = req.user.id;
        const data = await this.syncService.pull(userId, payload);
        return { success: true, data };
    }
}
