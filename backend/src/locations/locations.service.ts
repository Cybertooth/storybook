import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class LocationsService {
  constructor(private prisma: PrismaService) { }

  private async assertStoryOwnership(userId: string, storyId: string) {
    const story = await this.prisma.story.findFirst({ where: { id: storyId, userId }, select: { id: true } });
    if (!story) throw new NotFoundException('Story not found');
  }

  private toData(data: any) {
    return {
      name: data?.name,
      description: data?.description,
      sensorySight: data?.sensorySight,
      sensorySound: data?.sensorySound,
      sensorySmell: data?.sensorySmell,
      sensoryTouch: data?.sensoryTouch,
      sensoryTaste: data?.sensoryTaste,
    };
  }

  async create(userId: string, storyId: string, data: any) {
    await this.assertStoryOwnership(userId, storyId);
    return this.prisma.location.create({
      data: { ...this.toData(data), userId, storyId },
    });
  }

  async findAll(userId: string, storyId: string) {
    await this.assertStoryOwnership(userId, storyId);
    return this.prisma.location.findMany({ where: { userId, storyId } });
  }

  async findOne(userId: string, id: string) {
    const loc = await this.prisma.location.findFirst({ where: { id, userId } });
    if (!loc) throw new NotFoundException('Location not found');
    return loc;
  }

  async update(userId: string, id: string, data: any) {
    await this.findOne(userId, id);

    const updated = await this.prisma.location.updateMany({
      where: { id, userId },
      data: this.toData(data),
    });

    if (updated.count === 0) throw new NotFoundException('Location not found');
    return this.findOne(userId, id);
  }

  async remove(userId: string, id: string) {
    const deleted = await this.prisma.location.deleteMany({ where: { id, userId } });
    if (deleted.count === 0) throw new NotFoundException('Location not found');
  }
}
