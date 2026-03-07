import { test, expect, registerUser, createStory, injectAuthState, API_BASE } from './helpers';

test.describe('Scratchpad', () => {
    let token: string;
    let story: any;

    test.beforeEach(async ({ page, request }) => {
        const auth = await registerUser(request, 'scratch');
        token = auth.token;
        story = await createStory(request, token, 'Scratchpad Story');

        await injectAuthState(page, token, auth.user);
        await page.goto('/scratchpad');
    });

    test('should display the scratchpad page', async ({ page }) => {
        // The scratchpad page should load — verify by checking the page is not auth
        await expect(page).not.toHaveURL(/\/auth/);
        await expect(page.locator('body')).toBeVisible();
    });

    test('should show an input for adding notes', async ({ page }) => {
        // Look for any input or textarea on the scratchpad page
        const hasInput = await page.locator('input, textarea').first().isVisible({ timeout: 5000 }).catch(() => false);
        expect(hasInput).toBeTruthy();
    });
});
