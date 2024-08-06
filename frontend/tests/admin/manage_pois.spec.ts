import { test, expect } from '@playwright/test';

test('An admin can create a poi with one feature, and valid name, longitude, and latitude', async ({
	page
}) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('admin@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('password').press('Enter');
	await page.getByRole('link', { name: 'Manage POIs' }).click();
	await page.getByRole('button', { name: 'Create New POI' }).click();
	await page.getByLabel('Name').click();
	await page.getByLabel('Name').fill('test1');
	await page.getByLabel('Name').press('Tab');
	await page.getByLabel('Description').fill('this is a test');
	await page.getByLabel('Location').fill('this is a location');
	await page.getByRole('button', { name: 'Create', exact: true }).click();
	await page.getByRole('link', { name: 'Mailing List' }).click();
	await page.getByRole('link', { name: 'Manage POIs' }).click();
	await expect(page.getByRole('cell', { name: 'test1', exact: true })).toBeAttached();
});

test('An admin cannot create a poi with an invalid name', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('admin@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('password').press('Enter');
	await page.getByRole('link', { name: 'Manage POIs' }).click();
	await page.getByRole('button', { name: 'Create New POI' }).click();
	await page.getByLabel('Name').click();
	await page.getByLabel('Name').fill('te');
	await page.getByLabel('Description').click();
	await page.getByLabel('Location').fill('this is a location');
	await page.getByRole('button', { name: 'Create', exact: true }).click();
	await expect(page.getByText('Name Not Valid')).toBeAttached();
});

test('An admin cannot create a poi with invalid latitude', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('admin@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('password').press('Enter');
	await page.getByRole('link', { name: 'Manage POIs' }).click();
	await page.getByRole('button', { name: 'Create New POI' }).click();
	await page.getByLabel('Name').click();
	await page.getByLabel('Name').fill('test');
	await page.getByLabel('Location').fill('this is a location');
	await page.getByLabel('Latitude').click();
	await page.getByLabel('Latitude').fill('200');
	await page.getByRole('button', { name: 'Create', exact: true }).click();
	await expect(page.getByText('Latitude not Valid')).toBeAttached();
});

test('An admin cannot create a poi with invalid longitude', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('admin@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('password').press('Enter');
	await page.getByRole('link', { name: 'Manage POIs' }).click();
	await page.getByRole('button', { name: 'Create New POI' }).click();
	await page.getByLabel('Name').click();
	await page.getByLabel('Name').fill('test');
	await page.getByLabel('Name').press('Tab');
	await page.getByLabel('Location').fill('this is a location');
	await page.getByRole('button', { name: 'Create New POI' }).click();
	await page.getByLabel('Longitude').click();
	await page.getByLabel('Longitude').fill('2000');
	await page.getByRole('button', { name: 'Create', exact: true }).click();
	await expect(page.getByText('Longitude not Valid')).toBeAttached();
});

test('An admin can add multiple features to a valid poi', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('admin@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('password').press('Enter');
	await page.getByRole('link', { name: 'Manage POIs' }).click();
	await page.getByRole('button', { name: 'Create New POI' }).click();
	await page.getByLabel('Name').click();
	await page.getByLabel('Name').fill('test2');
	await page.getByLabel('Location').fill('this is a location');
	await page.getByRole('button', { name: 'Add Feature' }).click();
	const selectElements = await page.$$('select');
	await selectElements[1].selectOption({ index: 0 });
	await page.getByRole('button', { name: 'Create', exact: true }).click();
	await expect(page.getByRole('cell', { name: 'test2', exact: true })).toBeAttached();
});

test('An admin can change the default location when creating a poi', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('admin@test.com');
	await page.getByTestId('password').click();
	await page.getByTestId('password').fill('password');
	await page.getByTestId('password').press('Tab');
	await page.getByTestId('login-button').press('Enter');
	await page.getByRole('link', { name: 'Manage POIs' }).click();
	await page.getByRole('button', { name: 'Create New POI' }).click();
	await page.getByLabel('Name').click();
	await page.getByLabel('Name').fill('test');
	await page.getByLabel('Location').fill('Manchester');
	await page.getByRole('button', { name: 'Create', exact: true }).click();
	await page.getByRole('link', { name: 'Mailing List' }).click();
	await page.getByRole('link', { name: 'Manage POIs' }).click();
	await expect(page.getByRole('cell', { name: 'Manchester' }).first()).toBeAttached();
});
/** 
test('An admin can create and delete a poi', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: 'I Understand' }).click();
  await page.getByRole('link', { name: 'Login' }).click();
  await page.getByTestId('email').click();
  await page.getByTestId('email').fill('admin@test.com');
  await page.getByTestId('email').press('Tab');
  await page.getByTestId('password').fill('password');
  await page.getByTestId('password').press('Enter');
  await page.getByRole('link', { name: 'Manage POIs' }).click();
  await page.getByRole('button', { name: 'Create New POI' }).click();
  await page.getByLabel('Name').click();
  await page.getByLabel('Name').fill('test');
  await page.getByRole('button', { name: 'Create', exact: true }).click();
  await page.getByRole('link', { name: 'Mailing List' }).click();
  await page.getByRole('link', { name: 'Manage POIs' }).click();
  await page.getByRole('button', { name: 'Delete' }).click();
});
*/
