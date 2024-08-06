import { test, expect } from '@playwright/test';

test.beforeEach('Prevent user data modal from showing & navigate to index', async ({ page }) => {
	await page.goto('/');
	await page.evaluate(() => localStorage.setItem('userDataModalAccepted', 'true'));
});

test('Register new Email', async ({ page }) => {
	//await page.getByRole('button', { name: 'Register Interest' }).click();
	await page.getByRole('textbox', { name: 'Your Email Here' }).click();
	await page.getByRole('textbox', { name: 'Your Email Here' }).fill('test@test.com');
	await page.getByRole('button', { name: 'Register My Interest!' }).click();
	await expect(page.getByRole('heading', { name: 'Success! Your email has been recorded' }))
		.toBeVisible;
});

test('Register recorded email', async ({ page }) => {
	//await page.getByRole('button', { name: 'Register Interest' }).click();
	await page.getByRole('textbox', { name: 'Your Email Here' }).click();
	await page.getByRole('textbox', { name: 'Your Email Here' }).fill('testrecorded@test.com');
	await page.getByRole('button', { name: 'Register My Interest!' }).click();
	await page.getByRole('textbox', { name: 'Your Email Here' }).click();
	await page.getByRole('textbox', { name: 'Your Email Here' }).fill('testrecorded@test.com');
	await expect(page.getByRole('heading', { name: 'Email has already been recorded' })).toBeVisible;
});

test('Reject invalid email', async ({ page }) => {
	//await page.getByRole('button', { name: 'Register Interest' }).click();
	await page.getByRole('textbox', { name: 'Your Email Here' }).click();
	await page.getByRole('textbox', { name: 'Your Email Here' }).fill('testrecorded@test.com');
	await page.getByRole('button', { name: 'Register My Interest!' }).click();
	await page.getByRole('textbox', { name: 'Your Email Here' }).click();
	await page.getByRole('textbox', { name: 'Your Email Here' }).fill('testrecorded@test.com');
	await expect(page.getByRole('heading', { name: 'Please enter a valid email address' }))
		.toBeVisible;
});
