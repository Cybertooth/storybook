import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class RelationshipsService {
    constructor(private prisma: PrismaService) { }

    async findAll(storyId: string, userId: string) {
        return this.prisma.relationship.findMany({
            where: { storyId, userId },
        });
    }

    async findOne(id: string, userId: string) {
        const relationship = await this.prisma.relationship.findFirst({
            where: { id, userId },
        });
        if (!relationship) throw new NotFoundException('Relationship not found');
        return relationship;
    }

    async create(storyId: string, userId: string, data: any) {
        const { createdAt, updatedAt, ...rest } = data;
        return this.prisma.relationship.create({
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
        return this.prisma.relationship.update({
            where: { id },
            data: rest,
        });
    }

    async delete(id: string, userId: string) {
        await this.findOne(id, userId);
        return this.prisma.relationship.delete({
            where: { id },
        });
    }
}
