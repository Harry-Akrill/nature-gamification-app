import UserType from '$lib/enums/userType';

/**
 * Checks if the user is authenticated / Determines userType by making a request to the server.
 * @returns A promise that resolves to false if user is not authenticated or a UserType Enum value otherwise.
 */
export const authenticationStatus = async () => {
	try {
		const response = await fetch('/api/auth/status');
		const data = await response.json();

		switch (data.userType) {
			case 'customer':
				return UserType.CUSTOMER;
			case 'admin':
				return UserType.ADMIN;
			case 'reporter':
				return UserType.REPORTER;
			default:
				return false;
		}
	} catch (error) {
		return false;
	}
};

/**
 * Logs in a user with the given email and password.
 * @param email The user's email address.
 * @param password The user's password.
 * @returns A Promise that resolves to a boolean indicating whether the login was successful.
 */
export const logIn = async (email: string, password: string) => {
	try {
		const response = await fetch('/api/auth/login', {
			method: 'POST',
			body: JSON.stringify({ user: { email, password } }),
			headers: {
				'Content-Type': 'application/json'
			}
		});
		return response.status === 200;
	} catch (error) {
		return false;
	}
};

/**
 * Signs up a user with the given email and password.
 * @param email The email of the user to sign up.
 * @param password The password of the user to sign up.
 * @returns A Promise that resolves to a boolean indicating whether the sign up was successful.
 */
export const signUp = async (
	email: string,
	nickname: string,
	description: string,
	password: string
) => {
	try {
		const response = await fetch('/api/auth/signup', {
			method: 'POST',
			body: JSON.stringify({ user: { email, nickname, description, password } }),
			headers: {
				'Content-Type': 'application/json'
			}
		});
		return response.status === 200;
	} catch (error) {
		return false;
	}
};

/**
 * Logs out the current user by sending a DELETE request to the '/api/auth/logout' endpoint.
 * @returns A Promise that resolves to a boolean indicating whether the logout was successful.
 */
export const logOut = async () => {
	try {
		const response = await fetch('/api/auth/logout', {
			method: 'DELETE'
		});
		return response.status === 200;
	} catch (error) {
		return false;
	}
};
