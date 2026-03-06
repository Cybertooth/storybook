import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from './../src/app.module';

import { PrismaService } from './../src/prisma/prisma.service';

describe('App Integration (e2e)', () => {
  let app: INestApplication;
  let token: string;
  let storyId: string;
  let prisma: PrismaService;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    prisma = app.get(PrismaService);
    await app.init();
  });

  afterAll(async () => {
    await prisma.$disconnect();
    await app.close();
  });

  it('/api/v1/auth/register (POST)', async () => {
    const email = `test-${Date.now()}@example.com`;
    const response = await request(app.getHttpServer())
      .post('/api/v1/auth/register')
      .send({ email, password: 'password123', name: 'Test User' })
      .expect(201);

    expect(response.body.success).toBe(true);
    expect(response.body.data.token).toBeDefined();
    token = response.body.data.token;
  });

  it('/api/v1/stories (POST) - Create a Story', async () => {
    const response = await request(app.getHttpServer())
      .post('/api/v1/stories')
      .set('Authorization', `Bearer ${token}`)
      .send({ title: 'My Integration Story', summary: 'This is a test.' })
      .expect(201);

    expect(response.body.success).toBe(true);
    expect(response.body.data.id).toBeDefined();
    storyId = response.body.data.id;
  });

  it('/api/v1/stories/:storyId/notes (POST) - Write to Scratchpad', async () => {
    const response = await request(app.getHttpServer())
      .post(`/api/v1/stories/${storyId}/notes`)
      .set('Authorization', `Bearer ${token}`)
      .send({ content: 'My first note' })
      .expect(201);

    expect(response.body.success).toBe(true);
    expect(response.body.data.content).toBe('My first note');
  });

  it('/api/v1/ai/suggest-next (POST) - LLM Mock Trigger', async () => {
    // If MOCK_LLM is true, this should return a mock response extremely fast
    const response = await request(app.getHttpServer())
      .post(`/api/v1/ai/suggest-next`)
      .set('Authorization', `Bearer ${token}`)
      .send({ priorText: 'Once upon a time', plotContext: '' })
      .expect(201);

    // The AiController returns raw data without wrapping in {success: true, data: {}}
    expect(response.body.mocked).toBe(true);
  });
});
