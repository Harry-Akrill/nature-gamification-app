<script lang="ts">
	import { confettiAction, notifyAction } from 'svelte-legos';
	import IntersectionObserver from 'svelte-intersection-observer';
	import { MINIMUM_TIME_ON_SLIDE_FOR_PATH_REGISTRATION_MS } from '$lib/config';
	import { pathToRegistrationAppend } from '$lib/utils';

	let timeout: ReturnType<typeof setTimeout>;

	$: {
		if (intersecting) {
			timeout = setTimeout(() => {
				if (intersecting) {
					pathToRegistrationAppend('/register-interest');
				}
			}, MINIMUM_TIME_ON_SLIDE_FOR_PATH_REGISTRATION_MS);
		} else {
			clearTimeout(timeout);
		}
	}

	let element: HTMLDivElement;
	let intersecting: boolean;

	let notificationSuccessButton: HTMLButtonElement;
	let notificationInvalidEmailButton: HTMLButtonElement;
	let notificationEmailAlreadySubmittedButton: HTMLButtonElement;
	let email = '';
	//const EMAIL_REGEX = /^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+$/;
	const EMAIL_REGEX = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

	const validateEmail = (): boolean => {
		return EMAIL_REGEX.test(email);
	};

	const handleSubmit = async () => {
		if (!validateEmail()) {
			notificationInvalidEmailButton.click();
			return;
		}

		const response = await fetch('/api/mailinglist', {
			method: 'POST',
			body: JSON.stringify({
				email: email
			}),
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			//const responsedata = await response.json();
			notificationEmailAlreadySubmittedButton.click();
			return;
		}

		notificationSuccessButton.click();
	};
</script>

<IntersectionObserver {element} bind:intersecting threshold={0.1}>
	<div
		class="flex flex-col h-full items-center justify-center relative select-none background-image"
		id="home"
		bind:this={element}
	>
		<div class="hero">
			<div class="hero-content text-center">
				<form class="max-w-2xl" on:submit|preventDefault={handleSubmit}>
					<h1 class="text-5xl font-bold">Register your interest here!</h1>
					<p class="py-6">
						Be among the first to experience our solution and keep up to date with our progress by
						filling in your email below!
					</p>
					<input
						bind:value={email}
						type="text"
						placeholder="Your Email Here"
						class="input input-bordered w-full mb-3"
					/>
					<button class="btn btn-primary">Register My Interest!</button>
				</form>
			</div>
		</div>
		<button
			class="hidden"
			bind:this={notificationSuccessButton}
			use:notifyAction={{
				title: 'Success! Your email has been recorded',
				type: 'success',
				duration: 4000
			}}
			use:confettiAction={{ type: 'school-pride' }}
		/>
		<button
			class="hidden"
			bind:this={notificationInvalidEmailButton}
			use:notifyAction={{
				title: 'Please enter a valid email address',
				type: 'error',
				duration: 4000
			}}
		/>
		<button
			class="hidden"
			bind:this={notificationEmailAlreadySubmittedButton}
			use:notifyAction={{
				title: 'Email has already been recorded',
				type: 'error',
				duration: 4000
			}}
		/>
	</div>
</IntersectionObserver>

<style>
	.background-image {
		background-image: url('/nature.jpg');
		background-size: cover;
	}
</style>
