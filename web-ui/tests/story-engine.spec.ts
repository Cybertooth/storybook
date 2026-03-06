import { test, expect } from '@playwright/test';

test.describe('Story Engine / Editor with Mocked LLM', () => {
    let token = '';

    test.beforeEach(async ({ page, request }) => {
        const email = `editor-${Date.now()}@example.com`;
        const res = await request.post('http://localhost:3000/api/v1/auth/register', {
            data: { email, password: 'password123', name: 'Editor User' }
        });
        const { data } = await res.json();
        token = data.token;

        await page.addInitScript((jwt) => {
            window.localStorage.setItem('auth-storage', JSON.stringify({
                state: { token: jwt, isAuthenticated: true, user: null },
                version: 0
            }));
        }, token);

        // Create a story & chapter
        const storyRes = await request.post('http://localhost:3000/api/v1/stories', {
            headers: { Authorization: `Bearer ${token}` },
            data: { title: 'Mocked AI Story', summary: '' }
        });
        const { data: story } = await storyRes.json();

        const chapterRes = await request.post(`http://localhost:3000/api/v1/stories/${story.id}/chapters`, {
            headers: { Authorization: `Bearer ${token}` },
            data: { title: 'Chapter 1', content: 'It was a dark and stormy night.', order: 1, status: 'DRAFT' }
        });
        const { data: chapter } = await chapterRes.json();

        await page.addInitScript((dataObj) => {
            window.localStorage.setItem('story-storage', JSON.stringify({
                state: { currentStory: dataObj.story, chapters: [dataObj.chapter], characters: [], locations: [], events: [], notes: [], unresolvedQuestions: [], relationships: [] },
                version: 0
            }));
        }, { story, chapter });

        await page.goto('/draft');
    });

    test('should mock Suggest Next feature', async ({ page }) => {
        // Intercept the AI suggest next request
        await page.route('**/api/v1/ai/suggest-next', route => {
            route.fulfill({
                status: 200,
                contentType: 'application/json',
                body: JSON.stringify({ success: true, data: { suggestion: ' Suddenly, a loud knock echoed through the empty house.' } })
            });
        });

        // Assume there is a "Suggest Next" button in the draft UI
        // await page.getByRole('button', { name: /suggest next/i }).click();
        // await expect(page.locator('.editor-content')).toContainText('Suddenly, a loud knock echoed');
    });

    test('should mock Critique / Plot Hole Checker', async ({ page }) => {
        // Intercept the AI critique request
        await page.route('**/api/v1/ai/critique', route => {
            route.fulfill({
                status: 200,
                contentType: 'application/json',
                body: JSON.stringify({ success: true, data: { critique: 'The pacing is a bit slow here.' } })
            });
        });

        // Assume there's a "Critique" button
        // await page.getByRole('button', { name: /critique/i }).click();
        // await expect(page.getByText('The pacing is a bit slow here.')).toBeVisible();
    });
});
