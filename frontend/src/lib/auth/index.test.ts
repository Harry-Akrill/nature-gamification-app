import { describe, it, expect, vi, beforeEach } from 'vitest';
import { signUp, logIn, logOut, authenticationStatus } from '$lib/auth';
import 'isomorphic-fetch';
import UserType from '$lib/enums/userType';

const EMAIL = 'test@example.com';
const NICKNAME = 'nick';
const DESCRIPTION = 'description';
const PASSWORD = 'password';
const mockFetch = vi.fn();

describe('signUp', () => {
	beforeEach(() => {
		global.fetch = mockFetch.mockReset();
	});

	it('returns true when the server responds with 200', async () => {
		mockFetch.mockResolvedValueOnce({ status: 200 });
		const result = await signUp(EMAIL, NICKNAME, DESCRIPTION, PASSWORD);
		expect(result).toBe(true);
		expect(mockFetch).toHaveBeenCalledWith('/api/auth/signup', {
			method: 'POST',
			body: JSON.stringify({
				user: { email: EMAIL, nickname: NICKNAME, description: DESCRIPTION, password: PASSWORD }
			}),
			headers: {
				'Content-Type': 'application/json'
			}
		});
	});

	it('returns false when the server responds with an error', async () => {
		mockFetch.mockResolvedValueOnce({ status: 500 });
		const result = await signUp(EMAIL, NICKNAME, DESCRIPTION, PASSWORD);
		expect(result).toBe(false);
		expect(mockFetch).toHaveBeenCalledWith('/api/auth/signup', {
			method: 'POST',
			body: JSON.stringify({
				user: { email: EMAIL, nickname: NICKNAME, description: DESCRIPTION, password: PASSWORD }
			}),
			headers: {
				'Content-Type': 'application/json'
			}
		});
	});

	it('returns false when the server does not respond', async () => {
		mockFetch.mockRejectedValueOnce(new Error('Network error'));
		const result = await signUp(EMAIL, NICKNAME, DESCRIPTION, PASSWORD);
		expect(result).toBe(false);
		expect(mockFetch).toHaveBeenCalledWith('/api/auth/signup', {
			method: 'POST',
			body: JSON.stringify({
				user: { email: EMAIL, nickname: NICKNAME, description: DESCRIPTION, password: PASSWORD }
			}),
			headers: {
				'Content-Type': 'application/json'
			}
		});
	});
});

describe('logIn', () => {
	beforeEach(() => {
		global.fetch = mockFetch.mockReset();
	});

	it('returns true when the server responds with 200', async () => {
		mockFetch.mockResolvedValueOnce({ status: 200 });
		const result = await logIn(EMAIL, PASSWORD);
		expect(result).toBe(true);
		expect(mockFetch).toHaveBeenCalledWith('/api/auth/login', {
			method: 'POST',
			body: JSON.stringify({ user: { email: EMAIL, password: PASSWORD } }),
			headers: {
				'Content-Type': 'application/json'
			}
		});
	});

	it('returns false when the server responds with an error', async () => {
		mockFetch.mockResolvedValueOnce({ status: 500 });
		const result = await logIn(EMAIL, PASSWORD);
		expect(result).toBe(false);
		expect(mockFetch).toHaveBeenCalledWith('/api/auth/login', {
			method: 'POST',
			body: JSON.stringify({ user: { email: EMAIL, password: PASSWORD } }),
			headers: {
				'Content-Type': 'application/json'
			}
		});
	});

	it('returns false when the server does not respond', async () => {
		mockFetch.mockRejectedValueOnce(new Error('Network error'));
		const result = await logIn(EMAIL, PASSWORD);
		expect(result).toBe(false);
		expect(mockFetch).toHaveBeenCalledWith('/api/auth/login', {
			method: 'POST',
			body: JSON.stringify({ user: { email: EMAIL, password: PASSWORD } }),
			headers: {
				'Content-Type': 'application/json'
			}
		});
	});
});

describe('logOut', () => {
	beforeEach(() => {
		global.fetch = mockFetch.mockReset();
	});

	it('returns true when the server responds with 200', async () => {
		mockFetch.mockResolvedValueOnce({ status: 200 });
		const result = await logOut();
		expect(result).toBe(true);
		expect(mockFetch).toHaveBeenCalledWith('/api/auth/logout', {
			method: 'DELETE'
		});
	});

	it('returns false when the server responds with an error', async () => {
		mockFetch.mockResolvedValueOnce({ status: 500 });
		const result = await logOut();
		expect(result).toBe(false);
		expect(mockFetch).toHaveBeenCalledWith('/api/auth/logout', {
			method: 'DELETE'
		});
	});

	it('returns false when the server does not respond', async () => {
		mockFetch.mockRejectedValueOnce(new Error('Network error'));
		const result = await logOut();
		expect(result).toBe(false);
		expect(mockFetch).toHaveBeenCalledWith('/api/auth/logout', {
			method: 'DELETE'
		});
	});
});

describe('authenticationStatus', () => {
	it("returns UserType.CUSTOMER if the server responds with a 200 status code body: { userType: 'customer' }", async () => {
		const mockFetch = vi.spyOn(global, 'fetch');
		mockFetch.mockResolvedValueOnce(
			new Response(JSON.stringify({ userType: 'customer' }), { status: 200 })
		);
		const result = await authenticationStatus();
		expect(result).toBe(UserType.CUSTOMER);
	});

	it("returns UserType.ADMIN if the server responds with a 200 status code body: { userType: 'admin' }", async () => {
		const mockFetch = vi.spyOn(global, 'fetch');
		mockFetch.mockResolvedValueOnce(
			new Response(JSON.stringify({ userType: 'admin' }), { status: 200 })
		);
		const result = await authenticationStatus();
		expect(result).toBe(UserType.ADMIN);
	});

	it("returns UserType.REPORTER if the server responds with a 200 status code body: { userType: 'reporter' }", async () => {
		const mockFetch = vi.spyOn(global, 'fetch');
		mockFetch.mockResolvedValueOnce(
			new Response(JSON.stringify({ userType: 'reporter' }), { status: 200 })
		);
		const result = await authenticationStatus();
		expect(result).toBe(UserType.REPORTER);
	});

	it('returns false if the server responds with a 401 status code', async () => {
		const mockFetch = vi.spyOn(global, 'fetch');
		mockFetch.mockResolvedValueOnce({ status: 401 } as Response);
		const result = await authenticationStatus();
		expect(result).toBe(false);
	});

	it('returns false if the fetch function throws an error', async () => {
		const mockFetch = vi.spyOn(global, 'fetch');
		mockFetch.mockRejectedValueOnce(new Error('Network error'));
		const result = await authenticationStatus();
		expect(result).toBe(false);
	});
});
