import { test as base, expect, Page, APIRequestContext } from '@playwright/test';

/**
 * Shared test helper that provides an authenticated page with an active story.
 * API calls use the backend URL from the VITE_API_URL environment variable
 * or default to http://localhost:3001/api/v1 for the test environment.
 */

const API_BASE = process.env.VITE_API_URL || 'http://localhost:3001/api/v1';

/** Register a fresh user via API and return token + user info. */
export async function registerUser(request: APIRequestContext, prefix: string) {
    const email = `${prefix}-${Date.now()}@example.com`;
    const res = await request.post(`${API_BASE}/auth/register`, {
        data: { email, password: 'password123', name: `${prefix} User` },
    });
    expect(res.ok(), `Registration failed: ${res.status()}`).toBeTruthy();
    const body = await res.json();
    return { token: body.data.token as string, user: body.data.user, email };
}

/** Create a story via API and return the story object. */
export async function createStory(request: APIRequestContext, token: string, title = 'Test Story') {
    const res = await request.post(`${API_BASE}/stories`, {
        headers: { Authorization: `Bearer ${token}` },
        data: { title, summary: 'Automated test story.' },
    });
    expect(res.ok(), `Story creation failed: ${res.status()}`).toBeTruthy();
    const body = await res.json();
    return body.data;
}

/** Inject auth + story state into the browser via localStorage before navigating. */
export async function injectAuthState(page: Page, token: string, user?: any) {
    await page.addInitScript(({ token, user }) => {
        window.localStorage.setItem('storybook-auth', JSON.stringify({
            state: { token, user: user || null },
            version: 0,
        }));
    }, { token, user });
}

export { base as test, expect, API_BASE };
