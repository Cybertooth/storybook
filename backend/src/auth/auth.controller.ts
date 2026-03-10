import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { AuthService } from './auth.service';
import { LoginDto, RegisterDto } from './auth.dto';

// Tighter rate limit for auth endpoints: 10 attempts per minute per IP.
// This overrides the global 60/min limit to mitigate brute-force attacks.
const AUTH_THROTTLE = { default: { limit: 10, ttl: 60000 } };

@Throttle(AUTH_THROTTLE)
@Controller('api/v1/auth')
export class AuthController {
  constructor(private readonly authService: AuthService) { }

  @Post('register')
  async register(@Body() body: RegisterDto) {
    const result = await this.authService.register(body);
    return { success: true, data: result };
  }

  @HttpCode(HttpStatus.OK)
  @Post('login')
  async login(@Body() body: LoginDto) {
    const result = await this.authService.login(body);
    return { success: true, data: result };
  }
}
