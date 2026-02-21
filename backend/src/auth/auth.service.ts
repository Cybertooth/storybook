import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
    constructor(
        private prisma: PrismaService,
        private jwtService: JwtService,
    ) { }

    async register(data: any) {
        const existingUser = await this.prisma.user.findUnique({
            where: { email: data.email },
        });

        if (existingUser) {
            throw new ConflictException('User with that email already exists');
        }

        const salt = await bcrypt.genSalt();
        const hashedPassword = await bcrypt.hash(data.password, salt);

        const user = await this.prisma.user.create({
            data: {
                id: data.id || crypto.randomUUID(), // Let frontend provide ID or generate one
                email: data.email,
                password: hashedPassword,
            },
        });

        return this.generateToken(user);
    }

    async login(data: any) {
        const user = await this.prisma.user.findUnique({
            where: { email: data.email },
        });

        if (!user) {
            throw new UnauthorizedException('Invalid credentials');
        }

        const isPasswordValid = await bcrypt.compare(data.password, user.password);

        if (!isPasswordValid) {
            throw new UnauthorizedException('Invalid credentials');
        }

        return this.generateToken(user);
    }

    private generateToken(user: any) {
        const payload = { email: user.email, sub: user.id };
        return {
            token: this.jwtService.sign(payload),
            user: { id: user.id, email: user.email }
        };
    }
}
