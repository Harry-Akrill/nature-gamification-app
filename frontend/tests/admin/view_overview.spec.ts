import { test, expect } from '@playwright/test';

// test.beforeEach('Prevent user data modal from showing & navigate to index', async ({ page }) => {
//   await page.goto('/');
//   await page.getByRole('button', { name: 'I Understand' }).click();
//   await page.getByRole('link', { name: 'Login' }).click();
//   await page.getByRole('textbox', { name: 'email' }).click();
//   await page.getByRole('textbox', { name: 'email' }).fill('admin@test.com');
//   await page.getByPlaceholder('password').click();
//   await page.getByPlaceholder('password').fill('password');
//   await page.getByRole('button', { name: 'Login' }).click();
// });

test('View Overview of statistics', async ({ page }) => {
	await page.goto('/');
	await page.evaluate(() => localStorage.setItem('testingMode', 'true'));
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('admin@test.com');
	await page.getByTestId('password').click();
	await page.getByTestId('password').fill('password');
	await page.getByTestId('login-button').click();
	// await page.waitForTimeout(5000);
	// await page.screenshot({path: "test.png"})
	await page.waitForTimeout(5000);
	await expect(page.getByRole('heading', { name: 'Overview' })).toBeVisible;
});
