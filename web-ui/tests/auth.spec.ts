import { test, expect, registerUser, API_BASE } from './helpers';

test.describe('Authentication', () => {

    test('should display the auth page and allow sign up', async ({ page, request }) => {
        // Intercept auth API calls and proxy to the correct test backend
        await page.route('**/api/v1/auth/**', async (route) => {
            const url = new URL(route.request().url());
            const targetUrl = `${API_BASE}/auth${url.pathname.split('/auth')[1]}`;
            const response = await request.fetch(targetUrl, {
                method: route.request().method(),
                headers: route.request().headers(),
                data: route.request().postDataJSON(),
            });
            const body = await response.json();
            await route.fulfill({
                status: response.status(),
                contentType: 'application/json',
                body: JSON.stringify(body),
            });
        });

        await page.goto('/auth');

        // The default view should be "Sign In" — switch to "Sign Up"
        await expect(page.getByText('Welcome Back')).toBeVisible();
        await page.getByText('Create one').click();
        await expect(page.getByText('Create Account')).toBeVisible();

        // Fill the sign-up form
        const email = `signup-${Date.now()}@example.com`;
        await page.locator('input[type="email"]').fill(email);
        await page.locator('input[type="password"]').fill('password123');
        await page.getByRole('button', { name: /sign up/i }).click();

        // After successful sign-up, user should be redirected (client-side route)
        await expect(page).not.toHaveURL(/\/auth/, { timeout: 10000 });
    });

    test('should allow existing user to log in', async ({ page, request }) => {
        const { email } = await registerUser(request, 'login-test');

        // Intercept auth API calls and proxy to the correct test backend
        await page.route('**/api/v1/auth/**', async (route) => {
            const url = new URL(route.request().url());
            const targetUrl = `${API_BASE}/auth${url.pathname.split('/auth')[1]}`;
            const response = await request.fetch(targetUrl, {
                method: route.request().method(),
                headers: route.request().headers(),
                data: route.request().postDataJSON(),
            });
            const body = await response.json();
            await route.fulfill({
                status: response.status(),
                contentType: 'application/json',
                body: JSON.stringify(body),
            });
        });

        await page.goto('/auth');
        await expect(page.getByText('Welcome Back')).toBeVisible();

        // Fill login form
        await page.locator('input[type="email"]').fill(email);
        await page.locator('input[type="password"]').fill('password123');
        await page.getByRole('button', { name: /sign in/i }).click();

        // After login, user should be on the main app
        await expect(page).not.toHaveURL(/\/auth/, { timeout: 10000 });
    });

    test('should redirect unauthenticated users to /auth', async ({ page }) => {
        await page.goto('/scratchpad');
        await expect(page).toHaveURL(/\/auth/);
    });

    test('should show error for invalid credentials', async ({ page }) => {
        // Intercept auth API calls and return an error
        await page.route('**/api/v1/auth/**', async (route) => {
            await route.fulfill({
                status: 401,
                contentType: 'application/json',
                body: JSON.stringify({ message: 'Invalid credentials' }),
            });
        });

        await page.goto('/auth');

        await page.locator('input[type="email"]').fill('nonexistent@example.com');
        await page.locator('input[type="password"]').fill('wrongpassword');
        await page.getByRole('button', { name: /sign in/i }).click();

        // Should show an error message and stay on auth page
        await expect(page.getByText(/failed|invalid|error/i)).toBeVisible({ timeout: 5000 });
        await expect(page).toHaveURL(/\/auth/);
    });
});
