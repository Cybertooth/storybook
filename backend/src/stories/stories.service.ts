import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class StoriesService {
    constructor(private prisma: PrismaService) { }

    async create(userId: string, data: any) {
        // Strip out any frontend-provided timestamps which come in as Ints instead of Dates
        const { createdAt, updatedAt, ...safeData } = data;

        return this.prisma.story.create({
            data: {
                ...safeData,
                user: { connectOrCreate: { where: { id: userId }, create: { id: userId, email: `${userId}@example.com`, password: 'pwd' } } },
            },
        });
    }

    async findAll(userId: string) {
        return this.prisma.story.findMany({ where: { userId } });
    }

    async findOne(userId: string, id: string) {
        const story = await this.prisma.story.findFirst({ where: { id, userId } });
        if (!story) throw new NotFoundException('Story not found');
        return story;
    }

    async update(userId: string, id: string, data: any) {
        await this.findOne(userId, id);
        const { createdAt, updatedAt, ...safeData } = data;
        return this.prisma.story.update({ where: { id }, data: safeData });
    }

    async remove(userId: string, id: string) {
        await this.findOne(userId, id);
        return this.prisma.story.delete({ where: { id } });
    }
}
