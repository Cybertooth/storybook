import { test, expect, registerUser, createStory, injectAuthState, API_BASE } from './helpers';

test.describe('Story Engine / Draft Editor', () => {
    let token: string;
    let story: any;

    test.beforeEach(async ({ page, request }) => {
        const auth = await registerUser(request, 'engine');
        token = auth.token;
        story = await createStory(request, token, 'Engine Story');

        // Create a chapter for the story
        const chapterRes = await request.post(`${API_BASE}/stories/${story.id}/chapters`, {
            headers: { Authorization: `Bearer ${token}` },
            data: { title: 'Chapter 1', content: 'It was a dark and stormy night.', order: 1, status: 'draft' },
        });
        expect(chapterRes.ok()).toBeTruthy();

        await injectAuthState(page, token, auth.user);
    });

    test('should load the story engine page', async ({ page }) => {
        await page.goto('/');
        // The root route loads the PlotGerminator — just verify it's not the auth page
        await expect(page).not.toHaveURL(/\/auth/);
        await expect(page.locator('body')).toBeVisible();
    });

    test('should load the draft/write page', async ({ page }) => {
        await page.goto('/write');
        await expect(page).not.toHaveURL(/\/auth/);
        await expect(page.locator('body')).toBeVisible();
    });

    test('should mock Suggest Next API call', async ({ page }) => {
        await page.route('**/api/v1/ai/suggest-next', route => {
            route.fulfill({
                status: 200,
                contentType: 'application/json',
                body: JSON.stringify({
                    mocked: true,
                    suggestion: 'Suddenly, a loud knock echoed through the empty house.',
                }),
            });
        });

        await page.goto('/write');
        await expect(page.locator('body')).toBeVisible();
    });
});
