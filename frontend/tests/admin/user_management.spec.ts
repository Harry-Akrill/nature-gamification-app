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

// test('Change role to Reporter', async ({ page }) => {
// 	await page.goto('/admin/users');
// 	await page.getByRole('button', { name: 'Edit' }).nth(0).click();
// 	await page.getByRole('combobox').selectOption('REPORTER');
// 	await page.getByRole('button', { name: 'Update' }).click();
// 	await expect(page.getByRole('cell', { name: 'REPORTER' })).toBeVisible;
// });

// test('Change role to Customer', async ({ page }) => {
// 	await page.goto('/admin/users');
// 	await page.getByRole('button', { name: 'Edit' }).nth(1).click();
// 	await page.getByRole('combobox').selectOption('CUSTOMER');
// 	await page.getByRole('button', { name: 'Update' }).click();
// 	await expect(page.getByRole('cell', { name: 'CUSTOMER' })).toBeVisible;
// });

// test('Change role to Admin', async ({ page }) => {
// 	await page.goto('/admin/users');
// 	await page.getByRole('button', { name: 'Edit' }).nth(1).click();
// 	await page.getByRole('combobox').selectOption('ADMIN');
// 	await page.getByRole('button', { name: 'Update' }).click();
// 	await expect(page.getByRole('cell', { name: 'ADMIN' })).toBeVisible;
// });

// test('Delete User', async ({ page }) => {
// 	await page.goto('/admin/users');
// 	await page.getByRole('button', { name: 'Delete' }).nth(1).click();
// 	await expect(page.getByRole('cell', { name: 'customer@test.com' })).toBeHidden;
// });
