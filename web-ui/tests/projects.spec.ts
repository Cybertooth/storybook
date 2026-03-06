import { test, expect } from '@playwright/test';

test.describe('Projects Dashboard', () => {
    let email = '';
    let token = '';

    test.beforeEach(async ({ page, request }) => {
        email = `proj-${Date.now()}@example.com`;
        const res = await request.post('http://localhost:3000/api/v1/auth/register', {
            data: { email, password: 'password123', name: 'Proj User' }
        });
        const { data } = await res.json();
        token = data.token;

        // Set JWT in local storage directly to maintain session
        await page.addInitScript((jwt) => {
            window.localStorage.setItem('auth-storage', JSON.stringify({
                state: { token: jwt, isAuthenticated: true, user: null },
                version: 0
            }));
        }, token);

        await page.goto('/projects');
    });

    test('should create a new project', async ({ page, request }) => {
        await page.getByRole('button', { name: /create new project/i }).click();

        // Verify it navigates to the new story (Scratchpad or Draft as default)
        await expect(page).toHaveURL(/\/(scratchpad|draft)/);

        // StoryStore should now contain an Untitled Project
        // Check if header says "Untitled Project"
        await expect(page.getByText('Untitled Project')).toBeVisible();
    });
});
