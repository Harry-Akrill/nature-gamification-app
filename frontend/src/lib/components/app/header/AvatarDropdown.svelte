<script lang="ts">
	import * as DropdownMenu from '$lib/components/ui/dropdown-menu';
	import * as Avatar from '$lib/components/ui/avatar';
	import { Button } from '$lib/components/ui/button';
	import { goto } from '$app/navigation';
	import { logOut } from '$lib/auth';
	import { authenticated } from '$lib/stores';
	import { onDestroy, onMount } from 'svelte';
	import { page } from '$app/stores';
	import { getContext } from 'svelte';
	import type { Writable } from 'svelte/store';
	import { ShieldHalf, User } from 'lucide-svelte';
	import Badges from '$lib/enums/Badges';
	import { cubicOut } from 'svelte/easing';

	let user: {
		nickname: string;
		email: string;
		description: string;
		profile_picture: string | undefined;
	};
	let totalPoints: {
		totalPoints: number;
		badge: keyof typeof Badges;
		threshold: number;
		previousThreshold: number;
	};
	let error = false;
	let loading = true;
	let badgeIconError = false;

	const refreshAvatarData: Writable<null | (() => Promise<void>)> = getContext('refreshAvatarData');

	let progressBarValue: number;

	const getUserProfileAndTotalPoints = async () => {
		const responseUserProfile = await fetch('/api/settings/profile');
		const dataUserProfile = await responseUserProfile.json();
		user = dataUserProfile;

		if (
			typeof user?.nickname !== 'string' ||
			typeof user?.email !== 'string' ||
			typeof user?.description !== 'string'
		) {
			error = true;
		}

		const responseTotalPoints = await fetch('/api/points-badges/avatar');
		const dataTotalPoints = await responseTotalPoints.json();
		totalPoints = dataTotalPoints;

		if (
			typeof totalPoints?.totalPoints !== 'number' ||
			typeof totalPoints?.badge !== 'string' ||
			!(totalPoints?.badge in Badges) ||
			typeof totalPoints?.threshold !== 'number' ||
			typeof totalPoints?.previousThreshold !== 'number'
		) {
			error = true;
		}

		progressBarValue = Math.round(
			((totalPoints.totalPoints - totalPoints.previousThreshold) * 100) /
				(totalPoints.threshold - totalPoints.previousThreshold)
		);
		if (progressBarValue > 100) {
			progressBarValue = 100;
		}
		loading = false;
	};

	refreshAvatarData.set(getUserProfileAndTotalPoints);

	const handleLogout = async () => {
		const logoutSuccessful = await logOut();
		logoutSuccessful && authenticated.verify();
	};

	let unsubscribe: () => void;

	onMount(() => {
		getUserProfileAndTotalPoints();
		unsubscribe = page.subscribe(getUserProfileAndTotalPoints);

		return () => unsubscribe();
	});

	let animateProgressBarValue = 0;

	let interval: ReturnType<typeof setTimeout>;
	let startTime: number;
	let duration = 2000;
	let initializedInterval = false;

	$: {
		if (!loading && !initializedInterval) {
			initializedInterval = true;
			startTime = Date.now();
			interval = setInterval(() => {
				const now = Date.now();
				const elapsed = now - startTime;
				if (elapsed < duration) {
					const t = elapsed / duration;
					animateProgressBarValue = progressBarValue * cubicOut(t);
				} else {
					animateProgressBarValue = progressBarValue;
					clearInterval(interval);
				}
			}, 2);
		}
	}

	onDestroy(() => clearInterval(interval));
</script>

<DropdownMenu.Root>
	<DropdownMenu.Trigger asChild let:builder>
		<Button variant="ghost" builders={[builder]} class="relative h-8 w-8 rounded-full mx-1">
			<Avatar.Root class="h-10 w-10">
				{#if loading}
					<Avatar.Fallback><span class="loading loading-ring loading-lg" /></Avatar.Fallback>
				{:else if !error}
					{#if user.profile_picture !== undefined}
						<Avatar.Image
							src={user.profile_picture}
							alt="Profile Picture"
							aria-label="Profile Picture"
							class="bg-card"
						/>
					{/if}
					<Avatar.Fallback aria-label="Profile Picture"><User class="h-5 w-5" /></Avatar.Fallback>
				{:else}
					<Avatar.Fallback aria-label="Profile Picture" class="bg-error text-2xl">!</Avatar.Fallback
					>
				{/if}
			</Avatar.Root>
		</Button>
	</DropdownMenu.Trigger>
	<DropdownMenu.Content class="w-56" align="end">
		{#if loading}
			<div class="h-16 flex items-center justify-center">
				<span class="loading loading-ring loading-lg" />
			</div>
		{:else if error}
			<DropdownMenu.Label class="font-normal">
				<div class="flex flex-col space-y-1">
					<p class="text-xs leading-none text-error">Failed To Fetch</p>
				</div>
			</DropdownMenu.Label>
		{:else}
			<DropdownMenu.Item class="font-normal cursor-pointer" on:click={() => goto('/app')}>
				<div class="flex flex-col space-y-1">
					<p class="text-sm font-medium leading-none">{user.nickname}</p>
					<p class="text-xs leading-none text-muted-foreground">@{user.nickname}</p>
				</div>
			</DropdownMenu.Item>
			<DropdownMenu.Separator />
			<DropdownMenu.Item
				class="font-normal cursor-pointer flex-col items-start gap-2"
				on:click={() => goto('/app/points-badges')}
			>
				<p class="text-sm font-medium leading-none">
					Total Points: {totalPoints.totalPoints}
				</p>
				<div class="flex flex-col space-y-1 items-center self-stretch">
					<div class="shrink-0">
						{#if !badgeIconError}
							<img
								src={Badges[totalPoints.badge]}
								class="h-14 w-14 -ml-0.5"
								alt="Current Total Points Badge Icon"
								on:error={() => (badgeIconError = true)}
							/>
						{:else}
							<ShieldHalf class="h-14 w-14 -ml-0.5" />
						{/if}
					</div>
					<p class="text-sm font-medium leading-none">{totalPoints.badge}</p>
					<div class="flex self-stretch gap-2 items-center">
						<p class="text-sm font-medium leading-none text-muted-foreground">
							{totalPoints.previousThreshold}
						</p>
						<progress
							class="progress progress-error grow"
							value={animateProgressBarValue}
							max="100"
						/>
						<p class="text-sm font-medium leading-none text-muted-foreground">
							{totalPoints.threshold}
						</p>
					</div>
				</div>
			</DropdownMenu.Item>
		{/if}
		<DropdownMenu.Separator />
		<DropdownMenu.Group>
			<DropdownMenu.Item class="cursor-pointer" on:click={() => goto('/app/settings')}
				>Settings</DropdownMenu.Item
			>
			<DropdownMenu.Item class="cursor-pointer" on:click={handleLogout}>Log out</DropdownMenu.Item>
		</DropdownMenu.Group>
	</DropdownMenu.Content>
</DropdownMenu.Root>
