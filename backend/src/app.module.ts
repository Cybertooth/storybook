import { Module } from '@nestjs/common';
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

@Module({
  imports: [
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
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }
