import { test, expect } from '@playwright/test';

test.use({ screenshot: 'only-on-failure' });

test.beforeEach('Login using admin', async ({ page }) => {
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
});

// test('Delete Review', async ({ page }) => {
// 	await page.goto('/admin/reviews');
// 	await page.getByRole('button', { name: 'Delete' }).nth(1).click();
// 	await expect(page.getByRole('cell', { name: 'author_2' })).toBeHidden;
// });

test('View Review', async ({ page }) => {
	// await page.waitForTimeout(500);
	// await page.waitForTimeout(5000);
	// await page.screenshot({path: "testpre.png"})
	await page.goto('/admin/reviews');
	// await page.waitForTimeout(1000);
	await page.getByRole('button', { name: 'View' }).nth(0).click();
	// await page.waitForTimeout(5000);
	// await page.screenshot({path: "test.png"})
	await expect(page.getByRole('cell', { name: 'author_1' })).toBeVisible;
});
