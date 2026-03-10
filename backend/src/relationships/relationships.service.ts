import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class RelationshipsService {
  constructor(private prisma: PrismaService) { }

  private async assertStoryOwnership(storyId: string, userId: string) {
    const story = await this.prisma.story.findFirst({ where: { id: storyId, userId }, select: { id: true } });
    if (!story) throw new NotFoundException('Story not found');
  }

  private toData(data: any) {
    return {
      sourceId: data?.sourceId,
      targetId: data?.targetId,
      type: data?.type,
      description: data?.description,
    };
  }

  async findAll(storyId: string, userId: string) {
    await this.assertStoryOwnership(storyId, userId);
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
    await this.assertStoryOwnership(storyId, userId);
    return this.prisma.relationship.create({
      data: {
        ...this.toData(data),
        storyId,
        userId,
      },
    });
  }

  async update(id: string, userId: string, data: any) {
    await this.findOne(id, userId);

    const updated = await this.prisma.relationship.updateMany({
      where: { id, userId },
      data: this.toData(data),
    });

    if (updated.count === 0) throw new NotFoundException('Relationship not found');
    return this.findOne(id, userId);
  }

  async delete(id: string, userId: string) {
    const deleted = await this.prisma.relationship.deleteMany({ where: { id, userId } });
    if (deleted.count === 0) throw new NotFoundException('Relationship not found');
  }
}
