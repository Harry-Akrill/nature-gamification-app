import { test, expect } from '@playwright/test';

test('An account can be successfully created', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByRole('link', { name: 'Create An Account' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('test1@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByPlaceholder('nickname').click();
	await page.getByPlaceholder('nickname').fill('featuretest');
	await page.getByText('Introduce yourself').click();
	await page.getByPlaceholder('description').click();
	await page.getByPlaceholder('description').fill('this is a feature test');
	await page.getByPlaceholder('password', { exact: true }).click();
	await page.getByPlaceholder('password', { exact: true }).fill('password');
	await page.getByPlaceholder('confirm password').click();
	await page.getByPlaceholder('confirm password').fill('password');
	await page.getByRole('button', { name: 'Create Account' }).click();
	await expect(page.getByRole('link', { name: 'Home' })).toBeVisible();
});

test('Cannnot create account with invalid email', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByRole('link', { name: 'Create An Account' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('wrong@testemail');
	await page.getByPlaceholder('nickname').click();
	await page.getByPlaceholder('nickname').fill('emailwrong');
	await page.getByPlaceholder('description').click();
	await page.getByPlaceholder('description').fill('testwillfail');
	await page.getByPlaceholder('password', { exact: true }).click();
	await page.getByPlaceholder('password', { exact: true }).fill('password');
	await page.getByPlaceholder('confirm password').click();
	await page.getByPlaceholder('confirm password').fill('password');
	await page.getByRole('button', { name: 'Create Account' }).click();
	await expect(page.getByRole('button', { name: 'Create Account' })).toBeVisible;
	await expect(page.getByText('Email Not Valid')).toBeVisible();
});

test('Cannot create account with invalid nickname', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByRole('link', { name: 'Create An Account' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('test2@test.com');
	await page.getByPlaceholder('nickname').click();
	await page.getByPlaceholder('nickname').fill('in');
	await page.getByPlaceholder('password', { exact: true }).click();
	await page.getByPlaceholder('password', { exact: true }).fill('password');
	await page.getByPlaceholder('password', { exact: true }).press('Tab');
	await page.getByPlaceholder('confirm password').fill('password');
	await page.getByPlaceholder('password', { exact: true }).click();
	await page.getByPlaceholder('password', { exact: true }).fill('password');
	await page.getByPlaceholder('confirm password').click();
	await page.getByPlaceholder('confirm password').fill('password');
	await page.getByRole('button', { name: 'Create Account' }).click();
	await expect(page.getByRole('button', { name: 'Create Account' })).toBeVisible();
	await expect(page.getByText('Nickname Needs To Be At Least 3 Characters Long')).toBeVisible();
});

test('Cannot create account with invalid password', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByRole('link', { name: 'Create An Account' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('test3@test.com');
	await page.getByPlaceholder('nickname').click();
	await page.getByPlaceholder('nickname').fill('valid');
	await page.getByPlaceholder('password', { exact: true }).click();
	await page.getByPlaceholder('password', { exact: true }).fill('passwor');
	await page.getByPlaceholder('confirm password').click();
	await page.getByPlaceholder('confirm password').fill('passwor');
	await page.getByRole('button', { name: 'Create Account' }).click();
	await expect(page.getByRole('button', { name: 'Create Account' })).toBeVisible();
	await expect(page.getByText('Password Too Short (min. 8 characters)')).toBeVisible();
});

test('Cannot create account as passwords do not match', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByRole('link', { name: 'Create An Account' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('test4@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByPlaceholder('nickname').click();
	await page.getByPlaceholder('nickname').fill('test');
	await page.getByPlaceholder('password', { exact: true }).click();
	await page.getByPlaceholder('password', { exact: true }).fill('password1');
	await page.getByPlaceholder('password', { exact: true }).press('Tab');
	await page.getByPlaceholder('confirm password').click();
	await page.getByPlaceholder('confirm password').fill('password2');
	await page.getByRole('button', { name: 'Create Account' }).click();
	await expect(page.getByRole('button', { name: 'Create Account' })).toBeVisible();
	await expect(page.getByText('Passwords Do Not Match')).toBeVisible();
});
