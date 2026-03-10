import { Controller, Post, Body, UseGuards, Request } from '@nestjs/common';
import { IsISO8601, IsObject, IsOptional, IsArray, ArrayMaxSize, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { SyncService } from './sync.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

// Maximum number of records per entity type in a single push.
// Prevents a single request from exhausting the DB transaction pool.
const SYNC_MAX_ITEMS_PER_TYPE = 500;

class SyncChangesDto {
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(SYNC_MAX_ITEMS_PER_TYPE)
  stories?: unknown[];

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(SYNC_MAX_ITEMS_PER_TYPE)
  characters?: unknown[];

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(SYNC_MAX_ITEMS_PER_TYPE)
  locations?: unknown[];

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(SYNC_MAX_ITEMS_PER_TYPE)
  events?: unknown[];

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(SYNC_MAX_ITEMS_PER_TYPE)
  notes?: unknown[];

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(SYNC_MAX_ITEMS_PER_TYPE)
  chapters?: unknown[];

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(SYNC_MAX_ITEMS_PER_TYPE)
  relationships?: unknown[];

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(SYNC_MAX_ITEMS_PER_TYPE)
  unresolvedQuestions?: unknown[];
}

class SyncPushDto {
  @IsOptional()
  @IsObject()
  @ValidateNested()
  @Type(() => SyncChangesDto)
  changes?: SyncChangesDto;
}

class SyncPullDto {
  @IsOptional()
  @IsISO8601()
  last_sync_timestamp?: string;
}

@UseGuards(JwtAuthGuard)
@Controller('api/v1/sync')
export class SyncController {
  constructor(private readonly syncService: SyncService) { }

  @Post('push')
  async push(@Request() req: any, @Body() payload: SyncPushDto) {
    const userId = req.user.id;
    await this.syncService.push(userId, payload);
    return { success: true };
  }

  @Post('pull')
  async pull(@Request() req: any, @Body() payload: SyncPullDto) {
    const userId = req.user.id;
    const data = await this.syncService.pull(userId, payload);
    return { success: true, data };
  }
}
