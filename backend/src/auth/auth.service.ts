import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';
import { LoginDto, RegisterDto } from './auth.dto';

const BCRYPT_ROUNDS = 12;
const DUMMY_HASH = '$2b$12$Q7Qm3kN9KTo6n95Q02wfiOclF3q6dWWR8fTRmJ4kXxH9M1N5jR9qS';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) { }

  async register(data: RegisterDto) {
    // Always hash first to prevent timing-based account enumeration:
    // an attacker measuring registration response time must not be able to
    // distinguish "email already registered" from "new registration".
    const hashedPassword = await bcrypt.hash(data.password, BCRYPT_ROUNDS);

    const existingUser = await this.prisma.user.findUnique({
      where: { email: data.email.toLowerCase() },
    });

    if (existingUser) {
      throw new ConflictException('User with that email already exists');
    }

    const user = await this.prisma.user.create({
      data: {
        email: data.email.toLowerCase(),
        password: hashedPassword,
      },
    });

    return this.generateToken(user.id, user.email);
  }

  async login(data: LoginDto) {
    const email = data.email.toLowerCase();

    const user = await this.prisma.user.findUnique({
      where: { email },
    });

    const passwordHash = user?.password ?? DUMMY_HASH;
    const isPasswordValid = await bcrypt.compare(data.password, passwordHash);

    if (!user || !isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    return this.generateToken(user.id, user.email);
  }

  private generateToken(userId: string, email: string) {
    const payload = { email, sub: userId };
    return {
      token: this.jwtService.sign(payload),
      user: { id: userId, email },
    };
  }
}
