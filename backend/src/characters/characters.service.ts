import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class CharactersService {
  constructor(private prisma: PrismaService) { }

  private async assertStoryOwnership(userId: string, storyId: string) {
    const story = await this.prisma.story.findFirst({ where: { id: storyId, userId }, select: { id: true } });
    if (!story) throw new NotFoundException('Story not found');
  }

  private toData(data: any) {
    return {
      name: data?.name,
      role: data?.role,
      description: data?.description,
      traits: Array.isArray(data?.traits) ? data.traits : [],
      arcLie: data?.arcLie,
      arcTruth: data?.arcTruth,
      arcGhost: data?.arcGhost,
      avatarUrl: data?.avatarUrl,
    };
  }

  async create(userId: string, storyId: string, data: any) {
    await this.assertStoryOwnership(userId, storyId);
    return this.prisma.character.create({
      data: { ...this.toData(data), userId, storyId },
    });
  }

  async findAll(userId: string, storyId: string) {
    await this.assertStoryOwnership(userId, storyId);
    return this.prisma.character.findMany({ where: { userId, storyId } });
  }

  async findOne(userId: string, id: string) {
    const char = await this.prisma.character.findFirst({ where: { id, userId } });
    if (!char) throw new NotFoundException('Character not found');
    return char;
  }

  async update(userId: string, id: string, data: any) {
    await this.findOne(userId, id);

    const updated = await this.prisma.character.updateMany({
      where: { id, userId },
      data: this.toData(data),
    });

    if (updated.count === 0) throw new NotFoundException('Character not found');
    return this.findOne(userId, id);
  }

  async remove(userId: string, id: string) {
    const deleted = await this.prisma.character.deleteMany({ where: { id, userId } });
    if (deleted.count === 0) throw new NotFoundException('Character not found');
  }
}
