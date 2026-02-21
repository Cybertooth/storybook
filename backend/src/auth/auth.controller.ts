import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import { AuthService } from './auth.service';

@Controller('api/v1/auth')
export class AuthController {
    constructor(private readonly authService: AuthService) { }

    @Post('register')
    async register(@Body() body: any) {
        const result = await this.authService.register(body);
        return { success: true, data: result };
    }

    @HttpCode(HttpStatus.OK)
    @Post('login')
    async login(@Body() body: any) {
        const result = await this.authService.login(body);
        return { success: true, data: result };
    }
}
