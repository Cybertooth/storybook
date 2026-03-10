import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class EventsService {
  constructor(private prisma: PrismaService) { }

  private async assertStoryOwnership(userId: string, storyId: string) {
    const story = await this.prisma.story.findFirst({ where: { id: storyId, userId }, select: { id: true } });
    if (!story) throw new NotFoundException('Story not found');
  }

  private toData(data: any) {
    return {
      title: data?.title,
      description: data?.description,
      order: data?.order,
      chapterId: data?.chapterId,
      locationId: data?.locationId,
      status: data?.status,
      plotThread: data?.plotThread,
      emotionalValue: data?.emotionalValue,
    };
  }

  async create(userId: string, storyId: string, data: any) {
    await this.assertStoryOwnership(userId, storyId);
    return this.prisma.plotEvent.create({
      data: { ...this.toData(data), userId, storyId },
    });
  }

  async findAll(userId: string, storyId: string) {
    await this.assertStoryOwnership(userId, storyId);
    return this.prisma.plotEvent.findMany({ where: { userId, storyId } });
  }

  async findOne(userId: string, id: string) {
    const event = await this.prisma.plotEvent.findFirst({ where: { id, userId } });
    if (!event) throw new NotFoundException('Event not found');
    return event;
  }

  async update(userId: string, id: string, data: any) {
    await this.findOne(userId, id);

    const updated = await this.prisma.plotEvent.updateMany({
      where: { id, userId },
      data: this.toData(data),
    });

    if (updated.count === 0) throw new NotFoundException('Event not found');
    return this.findOne(userId, id);
  }

  async remove(userId: string, id: string) {
    const deleted = await this.prisma.plotEvent.deleteMany({ where: { id, userId } });
    if (deleted.count === 0) throw new NotFoundException('Event not found');
  }
}
