import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { StoriesModule } from './stories/stories.module';
import { CharactersModule } from './characters/characters.module';
import { LocationsModule } from './locations/locations.module';
import { EventsModule } from './events/events.module';
import { AiModule } from './ai/ai.module';
import { AuthModule } from './auth/auth.module';
import { NotesModule } from './notes/notes.module';
import { ChaptersModule } from './chapters/chapters.module';
import { RelationshipsModule } from './relationships/relationships.module';
import { QuestionsModule } from './questions/questions.module';
import { SyncModule } from './sync/sync.module';

@Module({
  imports: [
    ThrottlerModule.forRoot([
      {
        ttl: 60000,
        limit: 60,
      },
    ]),
    PrismaModule,
    StoriesModule,
    CharactersModule,
    LocationsModule,
    EventsModule,
    AiModule,
    AuthModule,
    NotesModule,
    ChaptersModule,
    RelationshipsModule,
    QuestionsModule,
    SyncModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule { }
