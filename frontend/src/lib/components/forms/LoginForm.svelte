<script lang="ts">
	import { logIn } from '$lib/auth';
	import { authenticated } from '$lib/stores';
	import Icon from '@iconify/svelte';
	import errorIcon from '@iconify-icons/mdi/close-box';
	import { onMount } from 'svelte';
	import { pathToRegistrationAppend } from '$lib/utils';
	import { MINIMUM_TIME_ON_REVIEWS_QUESTIONS_LOGIN_SIGNUP_PAGES_FOR_PATH_REGISTRATION_MS } from '$lib/config';

	let timeout: ReturnType<typeof setTimeout>;

	onMount(() => {
		timeout = setTimeout(
			() => pathToRegistrationAppend('/login'),
			MINIMUM_TIME_ON_REVIEWS_QUESTIONS_LOGIN_SIGNUP_PAGES_FOR_PATH_REGISTRATION_MS
		);
		return () => clearTimeout(timeout);
	});

	let formData = { email: '', password: '' };
	let emailOrPasswordInvalid = false;

	const handleSubmit = async () => {
		const loginSuccessful = await logIn(formData.email, formData.password);

		if (loginSuccessful) {
			authenticated.verify();
		} else {
			emailOrPasswordInvalid = true;
		}
	};
</script>

<form
	class="card flex-shrink-0 w-full max-w-sm shadow-2xl bg-base-100"
	on:submit|preventDefault={handleSubmit}
>
	<div class="card-body">
		<h2 class="card-title">Login</h2>
		<div class="form-control">
			<label class="label" for="email">
				<span class="label-text">Email</span>
			</label>
			<input
				type="text"
				placeholder="email"
				class="input input-bordered"
				id="email"
				data-testid="email"
				bind:value={formData.email}
				on:input={() => (emailOrPasswordInvalid = false)}
			/>
		</div>
		<div class="form-control">
			<label class="label" for="password">
				<span class="label-text">Password</span>
			</label>
			<input
				type="password"
				placeholder="password"
				class="input input-bordered"
				id="password"
				data-testid="password"
				bind:value={formData.password}
				on:input={() => (emailOrPasswordInvalid = false)}
			/>
		</div>
		{#if emailOrPasswordInvalid}
			<div class="flex mt-1">
				<Icon icon={errorIcon} height={24} class="scale-125" color="oklch(var(--er))" />
				<p class="ml-3">Email Or Password Invalid</p>
			</div>
		{/if}
		<div class="divider my-1" />
		<div class="form-control">
			<button class="btn btn-neutral btn-sm" data-testid="login-button">Login</button>
		</div>
		<div class="form-control">
			<a class="btn btn-primary btn-sm mt-2" href="/signup">Create An Account</a>
		</div>
	</div>
</form>
