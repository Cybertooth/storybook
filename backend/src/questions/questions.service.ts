import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class QuestionsService {
    constructor(private prisma: PrismaService) { }

    async findAll(storyId: string, userId: string) {
        return this.prisma.unresolvedQuestion.findMany({
            where: { storyId, userId },
            orderBy: { createdAt: 'desc' },
        });
    }

    async findOne(id: string, userId: string) {
        const question = await this.prisma.unresolvedQuestion.findFirst({
            where: { id, userId },
        });
        if (!question) throw new NotFoundException('Question not found');
        return question;
    }

    async create(storyId: string, userId: string, data: any) {
        const { createdAt, updatedAt, id, storyId: _s, userId: _u, ...rest } = data;
        return this.prisma.unresolvedQuestion.create({
            data: { ...rest, userId, storyId },
        });
    }

    async update(id: string, userId: string, data: any) {
        const { createdAt, updatedAt, ...rest } = data;
        await this.findOne(id, userId);
        return this.prisma.unresolvedQuestion.update({
            where: { id },
            data: rest,
        });
    }

    async delete(id: string, userId: string) {
        await this.findOne(id, userId);
        return this.prisma.unresolvedQuestion.delete({
            where: { id },
        });
    }
}
