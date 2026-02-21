import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class LocationsService {
    constructor(private prisma: PrismaService) { }

    async create(userId: string, storyId: string, data: any) {
        return this.prisma.location.create({
            data: { ...data, userId, storyId },
        });
    }

    async findAll(userId: string, storyId: string) {
        return this.prisma.location.findMany({ where: { userId, storyId } });
    }

    async findOne(userId: string, id: string) {
        const loc = await this.prisma.location.findFirst({ where: { id, userId } });
        if (!loc) throw new NotFoundException('Location not found');
        return loc;
    }

    async update(userId: string, id: string, data: any) {
        await this.findOne(userId, id);
        return this.prisma.location.update({ where: { id }, data });
    }

    async remove(userId: string, id: string) {
        await this.findOne(userId, id);
        return this.prisma.location.delete({ where: { id } });
    }
}
