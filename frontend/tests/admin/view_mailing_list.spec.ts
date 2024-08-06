import { test, expect } from '@playwright/test';

test.use({ screenshot: 'only-on-failure' });

test('View Mailing List', async ({ page }) => {
	await page.goto('/');
	await page.evaluate(() => localStorage.setItem('testingMode', 'true'));
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('admin@test.com');
	await page.getByTestId('password').click();
	await page.getByTestId('password').fill('password');
	await page.getByTestId('login-button').click();
	await page.waitForTimeout(5000);
	await expect(page.getByRole('heading', { name: 'Overview' })).toBeVisible;
	// await page.waitForTimeout(1000);
	await page.goto('/admin/mailing-list');
	// await page.waitForTimeout(500);
	// await page.getByTestId('mailing-list-button').first().click();
	await expect(page.getByRole('heading', { name: 'Mailing List' })).toBeVisible;
});
