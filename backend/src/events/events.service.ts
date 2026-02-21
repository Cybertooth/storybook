import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class EventsService {
    constructor(private prisma: PrismaService) { }

    async create(userId: string, storyId: string, data: any) {
        return this.prisma.plotEvent.create({
            data: { ...data, userId, storyId },
        });
    }

    async findAll(userId: string, storyId: string) {
        return this.prisma.plotEvent.findMany({ where: { userId, storyId } });
    }

    async findOne(userId: string, id: string) {
        const event = await this.prisma.plotEvent.findFirst({ where: { id, userId } });
        if (!event) throw new NotFoundException('Event not found');
        return event;
    }

    async update(userId: string, id: string, data: any) {
        await this.findOne(userId, id);
        return this.prisma.plotEvent.update({ where: { id }, data });
    }

    async remove(userId: string, id: string) {
        await this.findOne(userId, id);
        return this.prisma.plotEvent.delete({ where: { id } });
    }
}
