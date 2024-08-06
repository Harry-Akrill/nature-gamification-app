<script lang="ts">
	import {
		authenticated,
		newLandingPageVisitRegisteredPromise,
		pathToRegistrationAppendCurrentCallStack
	} from '$lib/stores';
	import { onDestroy, onMount } from 'svelte';
	import HeaderDesktop from '$lib/components/landing/header/HeaderDesktop.svelte';
	import HeaderMobile from '$lib/components/landing/header/HeaderMobile.svelte';
	import { scale } from 'svelte/transition';
	import UserType from '$lib/enums/userType';
	import { registerNewLandingPageVisit } from '$lib/utils';
	import { POLLING_INTERVAL_FOR_TIME_SPENT_ON_PAGE } from '$lib/config';

	const timeOnPageMountInMs = Date.now();
	let timeSpentInMs = 0;
	let interval: ReturnType<typeof setTimeout>;
	let newLandingPageVisitRegisteredPromiseAssigned = false;
	let userDataModal: HTMLDialogElement;

	$newLandingPageVisitRegisteredPromise;
	$pathToRegistrationAppendCurrentCallStack;

	onMount(async () => {
		await authenticated.verify();

		$newLandingPageVisitRegisteredPromise = new Promise((resolve) =>
			registerNewLandingPageVisit().then(() => resolve())
		);

		newLandingPageVisitRegisteredPromiseAssigned = true;

		await $newLandingPageVisitRegisteredPromise;

		interval = setInterval(async () => {
			timeSpentInMs = Date.now() - timeOnPageMountInMs;

			const response = await fetch('/api/stats/landing/update-page-visit', {
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

	$: loading = $authenticated === null || !newLandingPageVisitRegisteredPromiseAssigned;
	$: if (userDataModal) localStorage.getItem('userDataModalAccepted') ?? userDataModal.showModal();
	$: {
		switch ($authenticated) {
			case UserType.CUSTOMER:
				window.location.href = '/app';
				break;
			case UserType.ADMIN:
				window.location.href = '/admin';
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
	<title>Natreon&#8482;</title>
</svelte:head>

<main class="h-screen w-screen full-dynamic-viewport-height full-dynamic-viewport-width flex">
	{#if loading}
		<div class="grow flex items-center justify-center">
			<span class="loading loading-ring loading-lg" />
		</div>
	{:else}
		<div
			class="flex flex-col grow overflow-x-hidden relative"
			in:scale={{ start: 0.9, duration: 500, opacity: 0 }}
		>
			<HeaderDesktop />
			<HeaderMobile />
			<div class="height flex flex-col">
				<slot />
			</div>
			<dialog bind:this={userDataModal} class="modal modal-bottom sm:modal-middle">
				<div class="modal-box">
					<h3 class="font-bold text-lg">Welcome!</h3>
					<p class="py-4">
						This app collects user metrics to improve user experience and make data-driven
						decisions. By using the app, you agree to the collection and analysis of your usage data
						for these purposes.
					</p>
					<div class="modal-action">
						<form
							method="dialog"
							on:submit={() => localStorage.setItem('userDataModalAccepted', 'true')}
						>
							<button class="btn">I Understand</button>
						</form>
					</div>
				</div>
				<form
					method="dialog"
					class="modal-backdrop"
					on:submit={() => localStorage.setItem('userDataModalAccepted', 'true')}
				>
					<button>Close</button>
				</form>
			</dialog>
		</div>
	{/if}
</main>

<style>
	.height {
		height: calc(100% - 64px);
		margin-top: 64px;
	}

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
