import { test, expect } from '@playwright/test';
import { first } from 'svelte-legos';

test('A customer can create a post', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('customer@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('password').press('Enter');
	await page.getByRole('link', { name: 'Social Network' }).click();
	await page.getByPlaceholder("What's on your mind?").click();
	await page.getByPlaceholder("What's on your mind?").click();
	await page.getByPlaceholder("What's on your mind?").fill('Hi ');
	await page.getByRole('button', { name: 'Post' }).click();
	await page.getByText('Hi').click();
	await expect(page.getByText('Hi')).toHaveText('Hi');
});

test('A customer can create and like a post', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('customer@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('password').press('Enter');
	await page.getByRole('link', { name: 'Social Network' }).click();
	await page.getByPlaceholder("What's on your mind?").click();
	await page.getByPlaceholder("What's on your mind?").click();
	await page.getByPlaceholder("What's on your mind?").fill('This is a test post');
	await page.getByRole('button', { name: 'Post' }).click();
	await page.getByRole('button', { name: '0' }).first().click();
	await expect(page.getByRole('button', { name: '1' })).toBeVisible();
});

test('A customer can create a post and write a comment', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('customer@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('password').press('Enter');
	await page.getByRole('link', { name: 'Social Network' }).click();
	await page.getByRole('link', { name: 'Social Network' }).click();
	await page.getByPlaceholder("What's on your mind?").click();
	await page.getByPlaceholder("What's on your mind?").click();
	await page.getByPlaceholder("What's on your mind?").fill('test');
	await page.getByRole('button', { name: 'Post' }).click();
	await page.getByPlaceholder('Write a comment...').first().click();
	await page.getByPlaceholder('Write a comment...').first().fill('This is a comment');
	await page.getByRole('button', { name: 'Submit' }).first().click();
	await expect(page.getByText('This is a comment')).toBeVisible();
});

test('A customer can send a friend request', async ({ page }) => {
	await page.goto('/');
	await page.getByRole('button', { name: 'I Understand' }).click();
	await page.getByRole('link', { name: 'Login' }).click();
	await page.getByTestId('email').click();
	await page.getByTestId('email').fill('customer@test.com');
	await page.getByTestId('email').press('Tab');
	await page.getByTestId('password').fill('password');
	await page.getByTestId('password').press('Enter');
	await page.getByRole('link', { name: 'Social Network' }).click();
	await page.getByTestId('social-network-connections-button').click();
	await page.locator('.p-6 > .inline-flex').first().click();
	await page.getByRole('link', { name: 'Home' }).click();
	await page.getByRole('link', { name: 'Social Network' }).click();
	await page.getByTestId('social-network-connections-button').click();
});
