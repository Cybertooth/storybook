import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ChaptersService {
    constructor(private prisma: PrismaService) { }

    async findAll(storyId: string, userId: string) {
        return this.prisma.chapter.findMany({
            where: { storyId, userId },
            orderBy: { order: 'asc' },
        });
    }

    async findOne(id: string, userId: string) {
        const chapter = await this.prisma.chapter.findFirst({
            where: { id, userId },
        });
        if (!chapter) throw new NotFoundException('Chapter not found');
        return chapter;
    }

    async create(storyId: string, userId: string, data: any) {
        // Strip timestamps if provided by frontend
        const { createdAt, updatedAt, ...rest } = data;
        return this.prisma.chapter.create({
            data: {
                ...rest,
                storyId,
                userId,
            },
        });
    }

    async update(id: string, userId: string, data: any) {
        const { createdAt, updatedAt, ...rest } = data;
        await this.findOne(id, userId);
        return this.prisma.chapter.update({
            where: { id },
            data: rest,
        });
    }

    async delete(id: string, userId: string) {
        await this.findOne(id, userId);
        return this.prisma.chapter.delete({
            where: { id },
        });
    }
}
