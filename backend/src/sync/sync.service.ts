import { BadRequestException, ForbiddenException, Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SyncService {
  constructor(private readonly prisma: PrismaService) { }

  private sanitizeData(record: Record<string, unknown> | null | undefined) {
    if (!record || typeof record !== 'object') {
      return {};
    }

    const {
      _status,
      id,
      createdAt,
      updatedAt,
      userId,
      ...data
    } = record as Record<string, unknown>;

    return data;
  }

  private async assertStoryOwnership(tx: any, storyId: string, userId: string) {
    const story = await tx.story.findFirst({ where: { id: storyId, userId }, select: { id: true } });
    if (!story) {
      throw new ForbiddenException('Story does not belong to user');
    }
  }

  private async createTombstone(tx: any, userId: string, entityId: string, entityType: string) {
    await tx.tombstone.upsert({
      where: { userId_entityId_entityType: { userId, entityId, entityType } },
      create: { userId, entityId, entityType },
      update: { deletedAt: new Date() },
    });
  }

  async push(userId: string, payload: any) {
    const changes = payload?.changes;
    if (!changes || typeof changes !== 'object') {
      return;
    }

    await this.prisma.$transaction(async (tx) => {
      if (Array.isArray(changes.stories)) {
        for (const rawStory of changes.stories) {
          const story = rawStory as Record<string, unknown>;
          const status = story?._status;
          const id = String(story?.id ?? '');

          if (!id || !['created', 'updated', 'deleted'].includes(String(status))) {
            continue;
          }

          if (status === 'deleted') {
            const deleted = await tx.story.deleteMany({ where: { id, userId } });
            if (deleted.count > 0) {
              await this.createTombstone(tx, userId, id, 'story');
            }
            continue;
          }

          const existing = await tx.story.findUnique({ where: { id }, select: { userId: true } });
          if (existing && existing.userId !== userId) {
            throw new ForbiddenException('Cannot modify another user\'s story');
          }

          const data = this.sanitizeData(story);
          if (existing) {
            await tx.story.update({ where: { id }, data });
          } else {
            await tx.story.create({ data: { id, userId, ...(data as any) } });
          }
        }
      }

      if (Array.isArray(changes.characters)) {
        for (const rawCharacter of changes.characters) {
          const character = rawCharacter as Record<string, unknown>;
          const status = character?._status;
          const id = String(character?.id ?? '');

          if (!id || !['created', 'updated', 'deleted'].includes(String(status))) {
            continue;
          }

          if (status === 'deleted') {
            const deleted = await tx.character.deleteMany({ where: { id, userId } });
            if (deleted.count > 0) {
              await this.createTombstone(tx, userId, id, 'character');
            }
            continue;
          }

          const existing = await tx.character.findUnique({ where: { id }, select: { userId: true, storyId: true } });
          if (existing && existing.userId !== userId) {
            throw new ForbiddenException('Cannot modify another user\'s character');
          }

          const data = this.sanitizeData(character);
          const storyId = String((data as any).storyId ?? existing?.storyId ?? '');
          if (!storyId) throw new BadRequestException('Character storyId is required');
          await this.assertStoryOwnership(tx, storyId, userId);

          if (existing) {
            await tx.character.update({ where: { id }, data });
          } else {
            await tx.character.create({ data: { id, userId, ...(data as any) } });
          }
        }
      }

      if (Array.isArray(changes.locations)) {
        for (const rawLocation of changes.locations) {
          const location = rawLocation as Record<string, unknown>;
          const status = location?._status;
          const id = String(location?.id ?? '');

          if (!id || !['created', 'updated', 'deleted'].includes(String(status))) {
            continue;
          }

          if (status === 'deleted') {
            const deleted = await tx.location.deleteMany({ where: { id, userId } });
            if (deleted.count > 0) {
              await this.createTombstone(tx, userId, id, 'location');
            }
            continue;
          }

          const existing = await tx.location.findUnique({ where: { id }, select: { userId: true, storyId: true } });
          if (existing && existing.userId !== userId) {
            throw new ForbiddenException('Cannot modify another user\'s location');
          }

          const data = this.sanitizeData(location);
          const storyId = String((data as any).storyId ?? existing?.storyId ?? '');
          if (!storyId) throw new BadRequestException('Location storyId is required');
          await this.assertStoryOwnership(tx, storyId, userId);

          if (existing) {
            await tx.location.update({ where: { id }, data });
          } else {
            await tx.location.create({ data: { id, userId, ...(data as any) } });
          }
        }
      }

      if (Array.isArray(changes.events)) {
        for (const rawEvent of changes.events) {
          const event = rawEvent as Record<string, unknown>;
          const status = event?._status;
          const id = String(event?.id ?? '');

          if (!id || !['created', 'updated', 'deleted'].includes(String(status))) {
            continue;
          }

          if (status === 'deleted') {
            const deleted = await tx.plotEvent.deleteMany({ where: { id, userId } });
            if (deleted.count > 0) {
              await this.createTombstone(tx, userId, id, 'event');
            }
            continue;
          }

          const existing = await tx.plotEvent.findUnique({ where: { id }, select: { userId: true, storyId: true } });
          if (existing && existing.userId !== userId) {
            throw new ForbiddenException('Cannot modify another user\'s event');
          }

          const data = this.sanitizeData(event);
          const storyId = String((data as any).storyId ?? existing?.storyId ?? '');
          if (!storyId) throw new BadRequestException('Event storyId is required');
          await this.assertStoryOwnership(tx, storyId, userId);

          if (existing) {
            await tx.plotEvent.update({ where: { id }, data });
          } else {
            await tx.plotEvent.create({ data: { id, userId, ...(data as any) } });
          }
        }
      }

      if (Array.isArray(changes.notes)) {
        for (const rawNote of changes.notes) {
          const note = rawNote as Record<string, unknown>;
          const status = note?._status;
          const id = String(note?.id ?? '');

          if (!id || !['created', 'updated', 'deleted'].includes(String(status))) {
            continue;
          }

          if (status === 'deleted') {
            const deleted = await tx.note.deleteMany({ where: { id, userId } });
            if (deleted.count > 0) {
              await this.createTombstone(tx, userId, id, 'note');
            }
            continue;
          }

          const existing = await tx.note.findUnique({ where: { id }, select: { userId: true, storyId: true } });
          if (existing && existing.userId !== userId) {
            throw new ForbiddenException('Cannot modify another user\'s note');
          }

          const data = this.sanitizeData(note);
          const storyId = String((data as any).storyId ?? existing?.storyId ?? '');
          if (!storyId) throw new BadRequestException('Note storyId is required');
          await this.assertStoryOwnership(tx, storyId, userId);

          if (existing) {
            await tx.note.update({ where: { id }, data });
          } else {
            await tx.note.create({ data: { id, userId, ...(data as any) } });
          }
        }
      }

      if (Array.isArray(changes.chapters)) {
        for (const rawChapter of changes.chapters) {
          const chapter = rawChapter as Record<string, unknown>;
          const status = chapter?._status;
          const id = String(chapter?.id ?? '');

          if (!id || !['created', 'updated', 'deleted'].includes(String(status))) {
            continue;
          }

          if (status === 'deleted') {
            const deleted = await tx.chapter.deleteMany({ where: { id, userId } });
            if (deleted.count > 0) {
              await this.createTombstone(tx, userId, id, 'chapter');
            }
            continue;
          }

          const existing = await tx.chapter.findUnique({ where: { id }, select: { userId: true, storyId: true } });
          if (existing && existing.userId !== userId) {
            throw new ForbiddenException('Cannot modify another user\'s chapter');
          }

          const data = this.sanitizeData(chapter);
          const storyId = String((data as any).storyId ?? existing?.storyId ?? '');
          if (!storyId) throw new BadRequestException('Chapter storyId is required');
          await this.assertStoryOwnership(tx, storyId, userId);

          if (existing) {
            await tx.chapter.update({ where: { id }, data });
          } else {
            await tx.chapter.create({ data: { id, userId, ...(data as any) } });
          }
        }
      }

      if (Array.isArray(changes.relationships)) {
        for (const rawRelationship of changes.relationships) {
          const relationship = rawRelationship as Record<string, unknown>;
          const status = relationship?._status;
          const id = String(relationship?.id ?? '');

          if (!id || !['created', 'updated', 'deleted'].includes(String(status))) {
            continue;
          }

          if (status === 'deleted') {
            const deleted = await tx.relationship.deleteMany({ where: { id, userId } });
            if (deleted.count > 0) {
              await this.createTombstone(tx, userId, id, 'relationship');
            }
            continue;
          }

          const existing = await tx.relationship.findUnique({ where: { id }, select: { userId: true, storyId: true } });
          if (existing && existing.userId !== userId) {
            throw new ForbiddenException('Cannot modify another user\'s relationship');
          }

          const data = this.sanitizeData(relationship);
          const storyId = String((data as any).storyId ?? existing?.storyId ?? '');
          if (!storyId) throw new BadRequestException('Relationship storyId is required');
          await this.assertStoryOwnership(tx, storyId, userId);

          if (existing) {
            await tx.relationship.update({ where: { id }, data });
          } else {
            await tx.relationship.create({ data: { id, userId, ...(data as any) } });
          }
        }
      }

      if (Array.isArray(changes.unresolvedQuestions)) {
        for (const rawQuestion of changes.unresolvedQuestions) {
          const question = rawQuestion as Record<string, unknown>;
          const status = question?._status;
          const id = String(question?.id ?? '');

          if (!id || !['created', 'updated', 'deleted'].includes(String(status))) {
            continue;
          }

          if (status === 'deleted') {
            const deleted = await tx.unresolvedQuestion.deleteMany({ where: { id, userId } });
            if (deleted.count > 0) {
              await this.createTombstone(tx, userId, id, 'unresolvedQuestion');
            }
            continue;
          }

          const existing = await tx.unresolvedQuestion.findUnique({ where: { id }, select: { userId: true, storyId: true } });
          if (existing && existing.userId !== userId) {
            throw new ForbiddenException('Cannot modify another user\'s unresolved question');
          }

          const data = this.sanitizeData(question);
          const storyId = String((data as any).storyId ?? existing?.storyId ?? '');
          if (!storyId) throw new BadRequestException('Question storyId is required');
          await this.assertStoryOwnership(tx, storyId, userId);

          if (existing) {
            await tx.unresolvedQuestion.update({ where: { id }, data });
          } else {
            await tx.unresolvedQuestion.create({ data: { id, userId, ...(data as any) } });
          }
        }
      }
    });
  }

  async pull(userId: string, payload: any) {
    const since = payload?.last_sync_timestamp ? new Date(payload.last_sync_timestamp) : new Date(0);
    if (Number.isNaN(since.getTime())) {
      throw new BadRequestException('Invalid last_sync_timestamp');
    }

    const [
      stories,
      characters,
      locations,
      events,
      notes,
      chapters,
      relationships,
      questions,
      tombstones,
    ] = await Promise.all([
      this.prisma.story.findMany({ where: { userId, updatedAt: { gt: since } } }),
      this.prisma.character.findMany({ where: { userId, story: { updatedAt: { gt: since } } } }),
      this.prisma.location.findMany({ where: { userId, story: { updatedAt: { gt: since } } } }),
      this.prisma.plotEvent.findMany({ where: { userId, story: { updatedAt: { gt: since } } } }),
      this.prisma.note.findMany({ where: { userId, createdAt: { gt: since } } }),
      this.prisma.chapter.findMany({ where: { userId, story: { updatedAt: { gt: since } } } }),
      this.prisma.relationship.findMany({ where: { userId, story: { updatedAt: { gt: since } } } }),
      this.prisma.unresolvedQuestion.findMany({ where: { userId, createdAt: { gt: since } } }),
      this.prisma.tombstone.findMany({ where: { userId, deletedAt: { gt: since } } }),
    ]);

    return {
      changes: {
        stories,
        characters,
        locations,
        events,
        notes,
        chapters,
        relationships,
        unresolvedQuestions: questions,
        tombstones,
      },
    };
  }
}
