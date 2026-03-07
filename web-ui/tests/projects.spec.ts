import { test, expect, registerUser, createStory, injectAuthState, API_BASE } from './helpers';

test.describe('Navigation & Pages', () => {
    let token: string;
    let story: any;

    test.beforeEach(async ({ page, request }) => {
        const auth = await registerUser(request, 'nav');
        token = auth.token;
        story = await createStory(request, token, 'Navigation Story');

        await injectAuthState(page, token, auth.user);
    });

    test('should navigate to all main sections without errors', async ({ page }) => {
        const routes = [
            '/',
            '/scratchpad',
            '/write',
            '/characters',
            '/locations',
            '/timeline',
            '/dashboard',
            '/settings',
        ];

        for (const route of routes) {
            await page.goto(route);
            await expect(page.locator('body')).toBeVisible();
            // Should not redirect to auth
            await expect(page).not.toHaveURL(/\/auth/);
        }
    });

    test('should show the app shell with navigation sidebar', async ({ page }) => {
        await page.goto('/');

        // The AppShell should have a nav element — use .first() to avoid strict mode violation
        await expect(page.locator('nav').first()).toBeVisible({ timeout: 5000 });
    });
});
