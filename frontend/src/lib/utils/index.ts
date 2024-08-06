import {
	newLandingPageVisitRegisteredPromise,
	pathToRegistrationAppendCurrentCallStack
} from '$lib/stores';
import { get } from 'svelte/store';

export const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

export const registerNewLandingPageVisit = async () => {
	// Register new visit if time spent is above 5 seconds
	await sleep(5000);
	const response = await fetch('/api/stats/landing/register-new-page-visit');
	if (!response.ok) {
		const response = await fetch('https://api.ipify.org?format=json');
		const data = await response.json();
		const ip = data.ip;

		if (!response.ok) return;

		const secondResponse = await fetch('/api/stats/landing/register-new-page-visit-with-ip-param', {
			method: 'POST',
			body: JSON.stringify({ ip }),
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!secondResponse.ok) return;
	}
};

// Use a svelte store to avoid race conditions and call the relevant API endpoint in order
export const pathToRegistrationAppend = (path: string) => {
	pathToRegistrationAppendCurrentCallStack.update((previous) =>
		previous.then(async () => {
			await get(newLandingPageVisitRegisteredPromise);
			await fetch('/api/stats/landing/path-to-registration-append', {
				method: 'POST',
				body: JSON.stringify({ path }),
				headers: {
					'Content-Type': 'application/json'
				}
			});
		})
	);
};
