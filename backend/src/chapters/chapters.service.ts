import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ChaptersService {
    constructor(private prisma: PrismaService) { }

    async findAll(storyId: string, userId: string) {
        return this.prisma.chapter.findMany({
            where: { storyId, userId },
            orderBy: { order: 'asc' },
            select: {
                id: true,
                userId: true,
                storyId: true,
                title: true,
                order: true,
                status: true,
            }
        });
    }

    async findOne(id: string, userId: string) {
        const chapter = await this.prisma.chapter.findFirst({
            where: { id, userId },
            select: {
                id: true,
                userId: true,
                storyId: true,
                title: true,
                order: true,
                status: true,
            }
        });
        if (!chapter) throw new NotFoundException('Chapter not found');
        return chapter;
    }

    async getDraft(id: string, userId: string) {
        const chapter = await this.prisma.chapter.findFirst({
            where: { id, userId },
            select: { content: true }
        });
        if (!chapter) throw new NotFoundException('Chapter not found');
        return chapter;
    }

    async create(storyId: string, userId: string, data: any) {
        const { createdAt, updatedAt, id, storyId: _s, userId: _u, ...rest } = data;
        return this.prisma.chapter.create({
            data: { ...rest, userId, storyId },
        });
    }

    async update(id: string, userId: string, data: any) {
        const { createdAt, updatedAt, ...rest } = data;
        await this.findOne(id, userId); // verify existence
        return this.prisma.chapter.update({
            where: { id },
            data: rest,
            select: {
                id: true,
                userId: true,
                storyId: true,
                title: true,
                order: true,
                status: true,
            }
        });
    }

    async updateDraft(id: string, userId: string, content: string) {
        await this.findOne(id, userId); // verify existence
        return this.prisma.chapter.update({
            where: { id },
            data: { content },
            select: { content: true }
        });
    }

    async delete(id: string, userId: string) {
        await this.findOne(id, userId); // verify existence
        return this.prisma.chapter.delete({
            where: { id },
        });
    }
}
