import { test, expect } from '@playwright/test';

test.beforeEach('Prevent user data modal from showing & navigate to index', async ({ page }) => {
	await page.goto('/');
	await page.evaluate(() => localStorage.setItem('userDataModalAccepted', 'true'));
});

test('Pricing page content visible', async ({ page }) => {
	await page.locator('label').filter({ hasText: 'Home' }).locator('svg').click();
	await page.getByRole('button', { name: 'Pricing' }).click();
	await page.locator('#pricing-desktop #home').click();
	await expect(page.getByRole('button', { name: 'Donate £15' })).toBeVisible();
});

test('Donation button on pricing page can be clicked with an appropriate response', async ({
	page
}) => {
	await page.locator('label').filter({ hasText: 'Home' }).locator('svg').click();
	await page.getByRole('button', { name: 'Pricing' }).click();
	await page.getByRole('button', { name: 'Donate £10' }).click();
	await expect(
		page.getByRole('heading', {
			name: 'We appreciate your willingness to donate! Unfortunately this feature is not yet implemented.'
		})
	).toBeVisible();
});

test('Content of the funding options can be viewed by clicking on the checkbox', async ({
	page
}) => {
	await page.locator('label').filter({ hasText: 'Home' }).locator('svg').click();
	await page.getByRole('button', { name: 'Pricing' }).click();
	await page.locator('#pricing-desktop').getByRole('checkbox').first().check();
	await expect(
		page
			.locator('#pricing-desktop')
			.getByText('A Marketplace for affiliate companies to sell their products. We will prioritize')
	).toBeVisible();
});
