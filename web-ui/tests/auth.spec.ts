import { test, expect } from '@playwright/test';

test.describe('Authentication', () => {
    const uniqEmail = `test-${Date.now()}@example.com`;

    test('should allow user to sign up and redirect to dashboard', async ({ page }) => {
        await page.goto('/login');

        // Switch to signup tab if necessary
        await page.getByRole('tab', { name: 'Sign up' }).click();

        // Fill signup form
        await page.getByLabel('Name').fill('Test User');
        await page.getByLabel('Email').fill(uniqEmail);
        await page.getByLabel('Password', { exact: true }).fill('password123');

        // Submit
        await page.getByRole('button', { name: 'Let\'s Write' }).click();

        // Expect to land on projects page or dashboard
        await expect(page).toHaveURL(/\/projects/);
        await expect(page.getByText('Your Projects')).toBeVisible();
    });

    test('should allow existing user to log in', async ({ page }) => {
        // First register the user to ensure it exists
        const loginUser = `login-${Date.now()}@example.com`;
        await page.request.post('http://localhost:3000/api/v1/auth/register', {
            data: {
                email: loginUser,
                password: 'password123',
                name: 'Login Test User'
            }
        });

        await page.goto('/login');

        // Fill login form
        await page.getByLabel('Email').fill(loginUser);
        await page.getByLabel('Password', { exact: true }).fill('password123');

        // Submit
        await page.getByRole('button', { name: 'Login' }).click();

        // Expect to land on projects page
        await expect(page).toHaveURL(/\/projects/);
    });
});
