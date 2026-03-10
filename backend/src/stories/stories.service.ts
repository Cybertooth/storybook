import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class StoriesService {
  constructor(private prisma: PrismaService) { }

  private toCreateData(data: any) {
    return {
      title: data?.title,
      summary: data?.summary,
      theme: data?.theme,
      coreQuestion: data?.coreQuestion,
    };
  }

  private toUpdateData(data: any) {
    return {
      title: data?.title,
      summary: data?.summary,
      theme: data?.theme,
      coreQuestion: data?.coreQuestion,
    };
  }

  async create(userId: string, data: any) {
    return this.prisma.story.create({
      data: {
        ...this.toCreateData(data),
        user: { connect: { id: userId } },
      },
    });
  }

  async findAll(userId: string) {
    return this.prisma.story.findMany({ where: { userId } });
  }

  async findOne(userId: string, id: string) {
    const story = await this.prisma.story.findFirst({ where: { id, userId } });
    if (!story) throw new NotFoundException('Story not found');
    return story;
  }

  async update(userId: string, id: string, data: any) {
    const story = await this.findOne(userId, id);

    if (data.updatedAt) {
      const clientDate = new Date(data.updatedAt);
      if (story.updatedAt > clientDate) {
        throw new ConflictException('Story was modified after the provided timestamp');
      }
    }

    const updateData = this.toUpdateData(data);

    const updated = await this.prisma.story.updateMany({
      where: { id, userId },
      data: updateData,
    });

    if (updated.count === 0) {
      throw new NotFoundException('Story not found');
    }

    return this.findOne(userId, id);
  }

  async remove(userId: string, id: string) {
    const deleted = await this.prisma.story.deleteMany({ where: { id, userId } });
    if (deleted.count === 0) {
      throw new NotFoundException('Story not found');
    }
  }
}
