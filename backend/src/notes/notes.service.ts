import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class NotesService {
  constructor(private prisma: PrismaService) { }

  private async assertStoryOwnership(userId: string, storyId: string) {
    const story = await this.prisma.story.findFirst({ where: { id: storyId, userId }, select: { id: true } });
    if (!story) throw new NotFoundException('Story not found');
  }

  private toData(data: any) {
    return {
      content: data?.content,
    };
  }

  async create(userId: string, storyId: string, data: any) {
    await this.assertStoryOwnership(userId, storyId);
    return this.prisma.note.create({
      data: { ...this.toData(data), userId, storyId },
    });
  }

  async findAll(userId: string, storyId: string) {
    await this.assertStoryOwnership(userId, storyId);
    return this.prisma.note.findMany({
      where: { userId, storyId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async findOne(userId: string, id: string) {
    const note = await this.prisma.note.findFirst({ where: { id, userId } });
    if (!note) throw new NotFoundException('Note not found');
    return note;
  }

  async update(userId: string, id: string, data: any) {
    await this.findOne(userId, id);

    const updated = await this.prisma.note.updateMany({
      where: { id, userId },
      data: this.toData(data),
    });

    if (updated.count === 0) throw new NotFoundException('Note not found');
    return this.findOne(userId, id);
  }

  async remove(userId: string, id: string) {
    const deleted = await this.prisma.note.deleteMany({ where: { id, userId } });
    if (deleted.count === 0) throw new NotFoundException('Note not found');
  }
}
