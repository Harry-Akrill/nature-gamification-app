<script lang="ts">
	import { onMount } from 'svelte';
	import Icon from '@iconify/svelte';
	import accountIcon from '@iconify-icons/mdi/account';
	import mailIcon from '@iconify-icons/mdi/email';
	import helpIcon from '@iconify-icons/mdi/help';
	import forumIcon from '@iconify-icons/mdi/forum';
	import messageDrawIcon from '@iconify-icons/mdi/message-draw';
	import starIcon from '@iconify-icons/mdi/star';
	import { fade } from 'svelte/transition';
	import { cubicOut } from 'svelte/easing';

	let loading = true;
	let showSystemDetails = false;

	let averageReviewRating: number;
	let totalReviews: number;
	let questionsAsked: number;
	let questionsAnswered: number;
	let mailingListSignups: number;
	let customerUsersInSystem: number;

	onMount(async () => {
		const response = await fetch('/api/admin/stats/overall-details');
		if (!response.ok) return;
		const data = await response.json();

		questionsAsked = data.questions_asked;
		questionsAnswered = data.questions_answered;
		mailingListSignups = data.mailing_list_signups;
		customerUsersInSystem = data.customer_users_in_system;
		totalReviews = data.total_reviews;
		averageReviewRating = parseFloat(data.average_review_rating);

		loading = false;
	});
</script>

<div class="flex grow flex-col">
	<div class="sm:hidden flex justify-end grow mb-4">
		<button class="btn btn-xs btn-primary" on:click={() => (showSystemDetails = !showSystemDetails)}
			>{showSystemDetails ? 'Hide' : 'Show'} System Details</button
		>
	</div>
	{#if loading}
		{#if showSystemDetails}
			<div class="grow flex items-center justify-center card bg-base-300 p-6 sm:hidden mb-6">
				<span class="loading loading-ring loading-lg" />
			</div>
		{/if}
		<div class="grow sm:flex items-center justify-center card bg-base-300 p-6 hidden mb-6">
			<span class="loading loading-ring loading-lg" />
		</div>
	{:else}
		<!-- <div class="stat hidden md:inline-grid p-0">
			<div class="stat-figure text-primary">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					fill="none"
					viewBox="0 0 192 180"
					class="inline-block w-8 h-8 stroke-current"
					><path
						stroke-linecap="round"
						stroke-linejoin="round"
						stroke-width="16"
						d="m96 137.263-58.779 42.024 22.163-68.389L.894 68.481l72.476-.243L96 0l22.63 68.238 72.476.243-58.49 42.417 22.163 68.389z"
					/></svg
				>
			</div>
			<div class="stat-title">Average Review</div>
			<div class="stat-value text-primary">{averageReviewRating.toFixed(1)}</div>
		</div>
		<div class="stat hidden md:inline-grid p-0">
			<div class="stat-figure text-secondary">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					fill="none"
					viewBox="0 0 24 24"
					class="inline-block w-8 h-8 stroke-current"
					><path
						stroke-linecap="round"
						stroke-linejoin="round"
						stroke-width="2"
						d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"
					/></svg
				>
			</div>
			<div class="stat-title">No. of Reviews</div>
			<div class="stat-value">{totalReviews}</div>
		</div> -->
		<div class="sm:grid hidden grid-cols-2 lg:grid-cols-3 gap-4 items-stretch grow mb-6">
			<div class="stat card bg-base-300">
				<div class="stat-title">Total Customers</div>
				<div class="stat-value">{customerUsersInSystem}</div>
				<div class="stat-figure text-primary">
					<Icon icon={accountIcon} height={24} class="scale-125" />
				</div>
			</div>
			<div class="stat card bg-base-300">
				<div class="stat-title">Mailing List Signups</div>
				<div class="stat-value">{mailingListSignups}</div>
				<div class="stat-figure text-primary">
					<Icon icon={mailIcon} height={24} class="scale-125" />
				</div>
			</div>
			<div class="stat card bg-base-300">
				<div class="stat-title">No. of Reviews</div>
				<div class="stat-value">{totalReviews}</div>
				<div class="stat-figure text-primary">
					<Icon icon={forumIcon} height={24} class="scale-125" />
				</div>
			</div>
			<div class="stat card bg-base-300">
				<div class="stat-title">Average Review</div>
				<div class="stat-value">{averageReviewRating.toFixed(1)}</div>
				<div class="stat-figure text-primary">
					<Icon icon={starIcon} height={24} class="scale-125" />
				</div>
			</div>
			<div class="stat card bg-base-300">
				<div class="stat-title">Questions Asked</div>
				<div class="stat-value">{questionsAsked}</div>
				<div class="stat-figure text-primary">
					<Icon icon={helpIcon} height={24} class="scale-125" />
				</div>
			</div>
			<div class="stat card bg-base-300">
				<div class="stat-title">Questions Answered</div>
				<div class="stat-value">{questionsAnswered}</div>
				<div class="stat-figure text-primary">
					<Icon icon={messageDrawIcon} height={24} class="scale-125" />
				</div>
			</div>
		</div>
		{#if showSystemDetails}
			<div
				class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 items-stretch grow sm:hidden mb-6"
				in:fade={{ duration: 800, easing: cubicOut }}
			>
				<div class="stat card bg-base-300">
					<div class="stat-title">Total Customers</div>
					<div class="stat-value">{customerUsersInSystem}</div>
					<div class="stat-figure text-secondary">
						<Icon icon={accountIcon} height={24} class="scale-125" />
					</div>
				</div>
				<div class="stat card bg-base-300">
					<div class="stat-title">Mailing List Signups</div>
					<div class="stat-value">{mailingListSignups}</div>
					<div class="stat-figure text-secondary">
						<Icon icon={mailIcon} height={24} class="scale-125" />
					</div>
				</div>
				<div class="stat card bg-base-300">
					<div class="stat-title">No. of Reviews</div>
					<div class="stat-value">{totalReviews}</div>
					<div class="stat-figure text-secondary">
						<Icon icon={forumIcon} height={24} class="scale-125" />
					</div>
				</div>
				<div class="stat card bg-base-300">
					<div class="stat-title">Average Review</div>
					<div class="stat-value">{averageReviewRating.toFixed(1)}</div>
					<div class="stat-figure text-secondary">
						<Icon icon={starIcon} height={24} class="scale-125" />
					</div>
				</div>
				<div class="stat card bg-base-300">
					<div class="stat-title">Questions Asked</div>
					<div class="stat-value">{questionsAsked}</div>
					<div class="stat-figure text-secondary">
						<Icon icon={helpIcon} height={24} class="scale-125" />
					</div>
				</div>
				<div class="stat card bg-base-300">
					<div class="stat-title">Questions Answered</div>
					<div class="stat-value">{questionsAnswered}</div>
					<div class="stat-figure text-secondary">
						<Icon icon={messageDrawIcon} height={24} class="scale-125" />
					</div>
				</div>
			</div>
		{/if}
	{/if}
</div>
