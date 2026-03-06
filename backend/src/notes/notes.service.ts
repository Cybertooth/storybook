import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class NotesService {
    constructor(private prisma: PrismaService) { }

    async create(userId: string, storyId: string, data: any) {
        const { createdAt, ...safeData } = data;
        return this.prisma.note.create({
            data: { ...safeData, userId, storyId },
        });
    }

    async findAll(userId: string, storyId: string) {
        return this.prisma.note.findMany({
            where: { userId, storyId },
            orderBy: { createdAt: 'desc' },
        });
    }

    async findOne(userId: string, id: string) {
        const note = await this.prisma.note.findFirst({ where: { id, userId } });
        if (!note) throw new NotFoundException('Note not found');
        return note;
    }

    async update(userId: string, id: string, data: any) {
        await this.findOne(userId, id);
        const { createdAt, ...safeData } = data;
        return this.prisma.note.update({ where: { id }, data: safeData });
    }

    async remove(userId: string, id: string) {
        await this.findOne(userId, id);
        return this.prisma.note.delete({ where: { id } });
    }
}
