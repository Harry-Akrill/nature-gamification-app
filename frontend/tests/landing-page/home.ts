import { expect, test } from '@playwright/test';

test.beforeEach('Prevent user data modal from showing & navigate to index', async ({ page }) => {
	await page.goto('/');
	await page.evaluate(() => localStorage.setItem('userDataModalAccepted', 'true'));
});

test('login button visible', async ({ page }) => {
	await expect(page.getByRole('link', { name: 'Login' })).toBeVisible();
});

test('animated logo visible after navigation: Home -> Login -> Home', async ({ page }) => {
	await page.getByRole('link', { name: 'Login' }).first().click();
	await page.locator('label', { hasText: 'Home' }).first().click();
	await page.getByRole('button', { name: 'Home' }).first().click();
	await expect(page.getByTestId('animated-logo')).toBeVisible();
});

test('signup header visible after navigation: Home -> Login -> Signup', async ({ page }) => {
	await page.getByRole('link', { name: 'Login' }).first().click();
	await page.getByRole('link', { name: 'Create An Account' }).first().click();
	await expect(page.getByRole('heading', { name: 'Signup' })).toBeVisible();
});
