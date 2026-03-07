import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SyncService {
    constructor(private readonly prisma: PrismaService) { }

    async push(userId: string, payload: any) {
        const { changes } = payload;
        if (!changes) return;

        await this.prisma.$transaction(async (tx) => {
            // Handle Stores
            if (changes.stories) {
                for (const story of changes.stories) {
                    const { _status, id, createdAt, updatedAt, ...data } = story;
                    if (_status === 'created' || _status === 'updated') {
                        await tx.story.upsert({
                            where: { id },
                            create: { ...data, id, userId },
                            update: { ...data },
                        });
                    } else if (_status === 'deleted') {
                        await tx.story.delete({ where: { id } }).catch(() => { });
                        await tx.tombstone.create({ data: { entityId: id, entityType: 'story' } });
                    }
                }
            }

            // Handle Characters
            if (changes.characters) {
                for (const character of changes.characters) {
                    const { _status, id, createdAt, updatedAt, ...data } = character;
                    if (_status === 'created' || _status === 'updated') {
                        await tx.character.upsert({
                            where: { id },
                            create: { ...data, id, userId },
                            update: { ...data },
                        });
                    } else if (_status === 'deleted') {
                        await tx.character.delete({ where: { id } }).catch(() => { });
                        await tx.tombstone.create({ data: { entityId: id, entityType: 'character' } });
                    }
                }
            }

            // Handle Locations
            if (changes.locations) {
                for (const location of changes.locations) {
                    const { _status, id, createdAt, updatedAt, ...data } = location;
                    if (_status === 'created' || _status === 'updated') {
                        await tx.location.upsert({
                            where: { id },
                            create: { ...data, id, userId },
                            update: { ...data },
                        });
                    } else if (_status === 'deleted') {
                        await tx.location.delete({ where: { id } }).catch(() => { });
                        await tx.tombstone.create({ data: { entityId: id, entityType: 'location' } });
                    }
                }
            }

            // Handle PlotEvents
            if (changes.events) {
                for (const event of changes.events) {
                    const { _status, id, createdAt, updatedAt, ...data } = event;
                    if (_status === 'created' || _status === 'updated') {
                        await tx.plotEvent.upsert({
                            where: { id },
                            create: { ...data, id, userId },
                            update: { ...data },
                        });
                    } else if (_status === 'deleted') {
                        await tx.plotEvent.delete({ where: { id } }).catch(() => { });
                        await tx.tombstone.create({ data: { entityId: id, entityType: 'event' } });
                    }
                }
            }

            // Handle Notes
            if (changes.notes) {
                for (const note of changes.notes) {
                    const { _status, id, createdAt, updatedAt, ...data } = note;
                    if (_status === 'created' || _status === 'updated') {
                        await tx.note.upsert({
                            where: { id },
                            create: { ...data, id, userId },
                            update: { ...data },
                        });
                    } else if (_status === 'deleted') {
                        await tx.note.delete({ where: { id } }).catch(() => { });
                        await tx.tombstone.create({ data: { entityId: id, entityType: 'note' } });
                    }
                }
            }

            // Handle Chapters
            if (changes.chapters) {
                for (const chapter of changes.chapters) {
                    const { _status, id, createdAt, updatedAt, ...data } = chapter;
                    if (_status === 'created' || _status === 'updated') {
                        await tx.chapter.upsert({
                            where: { id },
                            create: { ...data, id, userId },
                            update: { ...data },
                        });
                    } else if (_status === 'deleted') {
                        await tx.chapter.delete({ where: { id } }).catch(() => { });
                        await tx.tombstone.create({ data: { entityId: id, entityType: 'chapter' } });
                    }
                }
            }

            // Handle Relationships
            if (changes.relationships) {
                for (const relationship of changes.relationships) {
                    const { _status, id, createdAt, updatedAt, ...data } = relationship;
                    if (_status === 'created' || _status === 'updated') {
                        await tx.relationship.upsert({
                            where: { id },
                            create: { ...data, id, userId },
                            update: { ...data },
                        });
                    } else if (_status === 'deleted') {
                        await tx.relationship.delete({ where: { id } }).catch(() => { });
                        await tx.tombstone.create({ data: { entityId: id, entityType: 'relationship' } });
                    }
                }
            }

            // Handle UnresolvedQuestions
            if (changes.unresolvedQuestions) {
                for (const question of changes.unresolvedQuestions) {
                    const { _status, id, createdAt, updatedAt, ...data } = question;
                    if (_status === 'created' || _status === 'updated') {
                        await tx.unresolvedQuestion.upsert({
                            where: { id },
                            create: { ...data, id, userId },
                            update: { ...data },
                        });
                    } else if (_status === 'deleted') {
                        await tx.unresolvedQuestion.delete({ where: { id } }).catch(() => { });
                        await tx.tombstone.create({ data: { entityId: id, entityType: 'unresolvedQuestion' } });
                    }
                }
            }
        });
    }

    async pull(userId: string, payload: any) {
        const { last_sync_timestamp } = payload;
        const since = new Date(last_sync_timestamp || 0);

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
            this.prisma.tombstone.findMany({ where: { deletedAt: { gt: since } } }),
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
            }
        };
    }
}
