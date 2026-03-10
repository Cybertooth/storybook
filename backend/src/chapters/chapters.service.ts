import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ChaptersService {
  constructor(private prisma: PrismaService) { }

  private async assertStoryOwnership(storyId: string, userId: string) {
    const story = await this.prisma.story.findFirst({ where: { id: storyId, userId }, select: { id: true } });
    if (!story) throw new NotFoundException('Story not found');
  }

  private chapterProjection = {
    id: true,
    userId: true,
    storyId: true,
    title: true,
    order: true,
    status: true,
  };

  private toData(data: any) {
    return {
      title: data?.title,
      content: data?.content,
      order: data?.order,
      status: data?.status,
    };
  }

  async findAll(storyId: string, userId: string) {
    await this.assertStoryOwnership(storyId, userId);
    return this.prisma.chapter.findMany({
      where: { storyId, userId },
      orderBy: { order: 'asc' },
      select: this.chapterProjection,
    });
  }

  async findOne(id: string, userId: string) {
    const chapter = await this.prisma.chapter.findFirst({
      where: { id, userId },
      select: this.chapterProjection,
    });
    if (!chapter) throw new NotFoundException('Chapter not found');
    return chapter;
  }

  async getDraft(id: string, userId: string) {
    const chapter = await this.prisma.chapter.findFirst({
      where: { id, userId },
      select: { content: true },
    });
    if (!chapter) throw new NotFoundException('Chapter not found');
    return chapter;
  }

  async create(storyId: string, userId: string, data: any) {
    await this.assertStoryOwnership(storyId, userId);
    return this.prisma.chapter.create({
      data: { ...this.toData(data), userId, storyId },
      select: this.chapterProjection,
    });
  }

  async update(id: string, userId: string, data: any) {
    await this.findOne(id, userId);

    const updated = await this.prisma.chapter.updateMany({
      where: { id, userId },
      data: this.toData(data),
    });

    if (updated.count === 0) throw new NotFoundException('Chapter not found');
    return this.findOne(id, userId);
  }

  async updateDraft(id: string, userId: string, content: string) {
    await this.findOne(id, userId);

    const updated = await this.prisma.chapter.updateMany({
      where: { id, userId },
      data: { content },
    });

    if (updated.count === 0) throw new NotFoundException('Chapter not found');
    return this.getDraft(id, userId);
  }

  async delete(id: string, userId: string) {
    const deleted = await this.prisma.chapter.deleteMany({ where: { id, userId } });
    if (deleted.count === 0) throw new NotFoundException('Chapter not found');
  }
}
