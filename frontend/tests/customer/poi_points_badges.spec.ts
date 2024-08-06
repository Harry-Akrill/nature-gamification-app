import { test, expect } from '@playwright/test';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
/*
test('A customer can log in and upload a picture to a poi, earning them points', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: 'I Understand' }).click();
  await page.getByRole('link', { name: 'Login' }).click();
  await page.getByTestId('email').click();
  await page.getByTestId('email').fill('customer@test.com');
  await page.getByTestId('email').press('Tab');
  await page.getByTestId('password').fill('password');
  await page.getByTestId('password').press('Enter');
  await page.getByTestId('map-canvas').click({
    position: {
      x: 472,
      y: 232
    }
  });
  await page.getByTestId('map-canvas').click({
    position: {
      x: 482,
      y: 379
    }
  });
  await page.locator('div:nth-child(6) > .text-xl > .lucide-icon').click();
  await page.getByRole('button', { name: 'View Details' }).click();
  await page.getByLabel('Upload a picture of this').click();
  const __filename = fileURLToPath(import.meta.url);
  const __dirname = dirname(__filename);
  const imagePath = path.join(__dirname, 'image0001.jpeg');
  const inputFile = await page.getByLabel('Upload a picture of this');
  await inputFile.setInputFiles(imagePath);
  await page.getByRole('button', { name: 'Upload Picture' }).click();
  await expect(page.getByText('New Total Points Milestone:')).toBeVisible();
  await expect(page.getByText('Successfully added picture')).toBeVisible();
});
*/
