<script lang="ts">
	import { authenticated } from '$lib/stores';
	import { onDestroy, onMount } from 'svelte';
	import { scale } from 'svelte/transition';
	import UserType from '$lib/enums/userType';
	import { sleep } from '$lib/utils';
	import { POLLING_INTERVAL_FOR_TIME_SPENT_ON_PAGE } from '$lib/config';

	const timeOnPageMountInMs = Date.now();
	let timeSpentInMs = 0;
	let interval: ReturnType<typeof setTimeout>;

	onMount(async () => {
		await authenticated.verify();

		// Register new visit if time spent is above 5 seconds
		await sleep(5000);
		const response = await fetch('/api/stats/admin/register-new-page-visit');
		if (!response.ok) {
			const response = await fetch('https://api.ipify.org?format=json');
			const data = await response.json();
			const ip = data.ip;

			if (!response.ok) return;

			const secondResponse = await fetch('/api/stats/admin/register-new-page-visit-with-ip-param', {
				method: 'POST',
				body: JSON.stringify({ ip }),
				headers: {
					'Content-Type': 'application/json'
				}
			});

			if (!secondResponse.ok) return;
		}

		interval = setInterval(async () => {
			timeSpentInMs = Date.now() - timeOnPageMountInMs;

			const response = await fetch('/api/stats/admin/update-page-visit', {
				method: 'POST',
				body: JSON.stringify({ time_spent_seconds: Math.floor(timeSpentInMs / 1000) }),
				headers: {
					'Content-Type': 'application/json'
				}
			});

			if (!response.ok) {
				clearInterval(interval);
			}
		}, POLLING_INTERVAL_FOR_TIME_SPENT_ON_PAGE);
	});

	onDestroy(() => clearInterval(interval));

	$: loading = $authenticated === null;
	$: {
		switch ($authenticated) {
			case false:
				window.location.href = '/login';
				break;
			case UserType.CUSTOMER:
				window.location.href = '/app';
				break;
			case UserType.REPORTER:
				window.location.href = '/metrics';
				break;
			default:
				break;
		}
	}
</script>

<svelte:head>
	<title>Admin Dashboard</title>
</svelte:head>

<main class="h-screen w-screen full-dynamic-viewport-height full-dynamic-viewport-width flex">
	{#if loading}
		<div class="grow flex items-center justify-center">
			<span class="loading loading-ring loading-lg" />
		</div>
	{:else}
		<div
			class="flex flex-col grow overflow-x-hidden"
			in:scale={{ start: 0.9, duration: 500, opacity: 0 }}
		>
			<slot />
		</div>
	{/if}
</main>

<style>
	@supports (height: 100dvh) {
		.full-dynamic-viewport-height {
			height: 100dvh;
		}
	}

	@supports (width: 100dvw) {
		.full-dynamic-viewport-width {
			width: 100dvw;
		}
	}
</style>
