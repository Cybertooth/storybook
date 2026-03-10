import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class QuestionsService {
  constructor(private prisma: PrismaService) { }

  private async assertStoryOwnership(storyId: string, userId: string) {
    const story = await this.prisma.story.findFirst({ where: { id: storyId, userId }, select: { id: true } });
    if (!story) throw new NotFoundException('Story not found');
  }

  private toData(data: any) {
    return {
      question: data?.question,
      details: data?.details,
      isResolved: data?.isResolved,
      answer: data?.answer,
    };
  }

  async findAll(storyId: string, userId: string) {
    await this.assertStoryOwnership(storyId, userId);
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
    await this.assertStoryOwnership(storyId, userId);
    return this.prisma.unresolvedQuestion.create({
      data: { ...this.toData(data), userId, storyId },
    });
  }

  async update(id: string, userId: string, data: any) {
    await this.findOne(id, userId);

    const updated = await this.prisma.unresolvedQuestion.updateMany({
      where: { id, userId },
      data: this.toData(data),
    });

    if (updated.count === 0) throw new NotFoundException('Question not found');
    return this.findOne(id, userId);
  }

  async delete(id: string, userId: string) {
    const deleted = await this.prisma.unresolvedQuestion.deleteMany({ where: { id, userId } });
    if (deleted.count === 0) throw new NotFoundException('Question not found');
  }
}
