<script lang="ts">
	import { onMount } from 'svelte';
	import { Label } from '$lib/components/ui/label';
	import { Input } from '$lib/components/ui/input';
	import { Button } from '$lib/components/ui/button';
	import { Textarea } from '$lib/components/ui/textarea';
	import * as Card from '$lib/components/ui/card';
	import { getContext } from 'svelte';
	import type { Writable } from 'svelte/store';
	import { Separator } from '$lib/components/ui/separator';

	const refreshAvatarData: Writable<null | (() => Promise<void>)> = getContext('refreshAvatarData');

	let isEditing = false;
	// let files: File[] = [];
	let selectedFile: File | undefined;
	let nicknameMin3 = '';
	let error = false;
	let loading = true;

	let user: {
		nickname: string;
		email: string;
		description: string;
		profile_picture: string | undefined;
	};

	async function getUserProfile() {
		const response = await fetch('/api/settings/profile');
		const data = await response.json();
		user = data;

		if (
			user?.nickname === undefined ||
			user?.email === undefined ||
			user?.description === undefined
		) {
			error = true;
		}

		loading = false;
	}

	function toggleEdit() {
		isEditing = !isEditing;
	}

	$: {
		if (user && typeof user.nickname === 'string' && user.nickname.length < 3) {
			nicknameMin3 = 'Nickname must be at least 3 characters long';
		} else {
			nicknameMin3 = '';
		}
	}

	async function saveChanges() {
		if (nicknameMin3) {
			return;
		}
		loading = true;
		const response = await fetch('/api/settings/profile', {
			method: 'PUT',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ user: { ...user, email: undefined, profile_picture: undefined } })
		});
		const data = await response.json();
		user = data;

		if (
			user?.nickname === undefined ||
			user?.email === undefined ||
			user?.description === undefined
		) {
			error = true;
		}

		loading = false;
		isEditing = false;

		$refreshAvatarData !== null && $refreshAvatarData();
	}

	async function handleUpload() {
		if (selectedFile) {
			const formData = new FormData();
			formData.append('profile_picture', selectedFile);
			loading = true;
			const response = await fetch('/api/settings/profile/update-picture', {
				method: 'POST',
				body: formData
			});

			if (response.ok) {
				const data = await response.json();
				user = data;

				if (
					user?.nickname === undefined ||
					user?.email === undefined ||
					user?.description === undefined
				) {
					error = true;
				}

				isEditing = false;
			} else {
				error = true;
			}

			loading = false;

			$refreshAvatarData !== null && $refreshAvatarData();
		}
	}

	const VALID_TYPES = ['image/png', 'image/jpeg'];
	function selectFile(event: Event) {
		const input = event.target as HTMLInputElement;
		if (
			input &&
			input.files &&
			input.files.length > 0 &&
			VALID_TYPES.includes(input.files[0].type)
		) {
			selectedFile = input.files[0];
		} else {
			selectedFile = undefined;
		}
	}

	onMount(getUserProfile);
</script>

<div class="flex max-lg:flex-col max-lg:items-center gap-4 justify-between">
	{#if loading}
		<div class="grow flex items-center justify-center">
			<span class="loading loading-ring loading-lg" />
		</div>
	{:else if error}
		<div class="grow flex items-center justify-center">
			<Label class="text-error"
				>Failed to fetch or update data. Contact admin for more details.</Label
			>
		</div>
	{:else}
		<div
			class="relative card h-full w-full md:w-3/4 max-w-3xl md:max-h-[32rem] max-h-none flex bg-base-200 shadow-xl p-6 flex-col"
		>
			{#if !isEditing}
				<div class="mb-4">
					<h2 class="text-2xl font-bold mb-2">User Details</h2>
					<div>
						<Label for="nickname">Nickname:</Label>
						<Input
							id="nickname"
							bind:value={user.nickname}
							readonly
							class={'mt-1 block w-full rounded-md shadow-sm ' +
								(isEditing ? 'bg-card' : 'bg-muted')}
						/>
						{#if nicknameMin3}
							<Label class="text-error">{nicknameMin3}</Label>
						{/if}
					</div>
				</div>

				<div class="mb-4">
					<Label for="email">Email:</Label>
					<Input
						id="email"
						type="text"
						value={user.email}
						readonly
						class="mt-1 block w-full rounded-md shadow-sm  bg-muted"
					/>
				</div>

				<div>
					<Label for="description">Description:</Label>
					<Textarea
						id="description"
						rows={5}
						cols={50}
						bind:value={user.description}
						readonly
						class={'mt-1 block w-full rounded-md shadow-sm bg-muted ' +
							(isEditing ? 'bg-card' : 'bg-muted')}
					/>
				</div>
				<Button on:click={toggleEdit}>Edit Profile</Button>
			{/if}

			{#if isEditing}
				<h2 class="text-2xl font-bold mb-2">Editing User Details</h2>
				<div>
					<Label for="edit-email">Edit Nickname:</Label>
					<Input
						id="edit-nickname"
						type="text"
						bind:value={user.nickname}
						class="mt-1 block w-full rounded-md shadow-sm focus:border-green-300 bg-muted "
					/>
				</div>

				<div>
					<Label for="edit-description">Edit Description:</Label>
					<Textarea
						id="edit-description"
						rows={5}
						cols={50}
						bind:value={user.description}
						class="mt-1 block w-full rounded-md shadow-sm focus:border-green-300 bg-muted"
					/>
				</div>
				<Button on:click={saveChanges}>Save Changes</Button>
			{/if}
		</div>
		<Separator orientation="horizontal" class="lg:hidden" />
		<Separator orientation="vertical" class="max-lg:hidden" />
		<div
			class="relative card h-full w-full md:w-3/4 max-w-3xl max-h-none flex bg-base-200 shadow-xl p-6 flex-col"
		>
			<h2 class="text-2xl font-bold mb-2">Profile Picture</h2>
			{#if user.profile_picture === undefined}
				<Card.Root class="mb-2">
					<Card.Content class="p-2">
						<p class="text-center">You do not currently have a profile picture...</p>
					</Card.Content>
				</Card.Root>
			{:else}
				<Card.Root class="mb-2">
					<Card.Content class="p-2 flex justify-center relative">
						<!-- svelte-ignore a11y-img-redundant-alt -->
						<img
							src={user.profile_picture}
							class="object-contain rounded-xl"
							alt="Profile Picture"
							style="width: max(200px, 75%); max-height: 320px;"
						/>
					</Card.Content>
				</Card.Root>
			{/if}
			<label for="profile-picture">Profile Picture:</label>
			<input
				id="profile-picture"
				type="file"
				accept="image/png, image/jpeg"
				on:change={selectFile}
				class="mt-1 block w-full rounded-md text-white shadow-sm focus:border-green-300"
			/>

			<Button on:click={handleUpload}>Upload Profile Picture</Button>
		</div>
	{/if}
</div>
