import { test, expect } from '@playwright/test';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

test('A customer can log in to the map page', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('customer@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('login-button').click();
	await expect(page.locator('[data-testid="logout-button"]').first()).toBeAttached();
});

test('A customer can log in and see their profile', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('customer@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('login-button').click();
	await page.locator('[data-testid="settings-button"]').first().click();
	await expect(page.getByText('Nickname:')).toBeVisible();
	await expect(page.getByText('Email:')).toBeVisible();
	await expect(page.getByText('Description:')).toBeVisible();
	await expect(page.getByRole('heading', { name: 'Profile Picture' })).toBeVisible();
});

test('A customer can edit their nickname', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('customer@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('login-button').click();
	await page.locator('[data-testid="settings-button"]').first().click();
	await page.getByRole('button', { name: 'Edit Profile' }).click();
	await page.locator('#edit-nickname').click();
	await page.locator('#edit-nickname').fill('customer223');
	await page.getByRole('button', { name: 'Save Changes' }).click();
	//await page.getByRole('list').click();
	await page.getByRole('link', { name: 'Home' }).click();
	await page.getByRole('link', { name: 'Settings' }).click();
	await expect(page.getByLabel('Nickname:')).toHaveValue('customer223');
});

test('A customer can edit their description', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('customer@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('login-button').click();
	await page.locator('[data-testid="settings-button"]').first().click();
	await page.getByRole('button', { name: 'Edit Profile' }).click();
	await page.getByLabel('Edit Description:').click();
	await page.getByLabel('Edit Description:').fill('this is a description');
	await page.getByRole('button', { name: 'Save Changes' }).click();
	await page.getByRole('link', { name: 'Home' }).click();
	await page.getByRole('link', { name: 'Settings' }).click();
	await expect(page.getByLabel('Description:')).toHaveValue('this is a description');
});

test('A customer can upload a profile picture', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('customer@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('login-button').click();
	await page.locator('[data-testid="settings-button"]').first().click();
	const __filename = fileURLToPath(import.meta.url);
	const __dirname = dirname(__filename);
	const imagePath = path.join(__dirname, 'image0001.jpeg');
	const inputFile = await page.getByLabel('Profile Picture:');
	await inputFile.setInputFiles(imagePath);
	await page.getByRole('button', { name: 'Upload Profile Picture' }).click();
	//await page.waitForTimeout(5000);
	await page.getByRole('link', { name: 'Home' }).click();
	await page.getByRole('link', { name: 'Settings' }).click();
	await expect(page.getByText('You do not currently have a profile picture...')).not.toBeVisible();
});
