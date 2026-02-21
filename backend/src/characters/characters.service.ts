import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class CharactersService {
    constructor(private prisma: PrismaService) { }

    async create(userId: string, storyId: string, data: any) {
        return this.prisma.character.create({
            data: { ...data, userId, storyId },
        });
    }

    async findAll(userId: string, storyId: string) {
        return this.prisma.character.findMany({ where: { userId, storyId } });
    }

    async findOne(userId: string, id: string) {
        const char = await this.prisma.character.findFirst({ where: { id, userId } });
        if (!char) throw new NotFoundException('Character not found');
        return char;
    }

    async update(userId: string, id: string, data: any) {
        await this.findOne(userId, id);
        return this.prisma.character.update({ where: { id }, data });
    }

    async remove(userId: string, id: string) {
        await this.findOne(userId, id);
        return this.prisma.character.delete({ where: { id } });
    }
}
