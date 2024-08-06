import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.locator('label').filter({ hasText: 'Home' }).locator('svg').click();
	await page.getByRole('button', { name: 'Features' }).click();
	await page.locator('#features-desktop').getByRole('checkbox').first().check();
	await expect(
		page
			.locator('#features-desktop')
			.getByText('Be guided by the interactive map to your new favourite chill out spot! 🧘‍♀️')
	).toBeVisible();
});
