import { Controller, Get } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) { }

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  // Health check is polled by load balancers and monitoring systems —
  // exclude it from per-IP throttle quota so it never gets rate-limited.
  @SkipThrottle()
  @Get('api/v1/health')
  getHealth() {
    return { status: 'ok' };
  }
}
