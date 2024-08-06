<script lang="ts">
	import * as Card from '$lib/components/ui/card';
	import { onMount } from 'svelte';
	import type { BadgeStatus } from '../PointsBadges.svelte';
	import { ShieldHalf } from 'lucide-svelte';
	import Badges from '$lib/enums/Badges';
	import { cubicOut } from 'svelte/easing';

	export let totalPoiReviewCounts: number;
	export let inProgressTotalPoiReviews: BadgeStatus;

	let badgeIconError = false;
	let progressBarValue: number;
	let animateProgressBarValue = 0;

	let interval: ReturnType<typeof setTimeout>;
	let startTime: number;
	let duration = 2000;

	onMount(() => {
		progressBarValue = Math.round(
			((totalPoiReviewCounts - inProgressTotalPoiReviews.previous_threshold) * 100) /
				(inProgressTotalPoiReviews.threshold - inProgressTotalPoiReviews.previous_threshold)
		);
		if (progressBarValue > 100) {
			progressBarValue = 100;
		}
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

		return () => clearInterval(interval);
	});
</script>

<Card.Root>
	<Card.Header class="p-2">
		<Card.Title class="text-xs">Total Reviews: {totalPoiReviewCounts}</Card.Title>
		<Card.Description>
			<div class="flex flex-col space-y-1 items-center self-stretch">
				<div class="shrink-0">
					{#if !badgeIconError}
						<img
							src={Badges[inProgressTotalPoiReviews.badge]}
							class="h-14 w-14 -ml-0.5"
							alt="Badge Icon"
							on:error={() => (badgeIconError = true)}
						/>
					{:else}
						<ShieldHalf class="h-14 w-14 -ml-0.5" />
					{/if}
				</div>
				<p class="text-sm font-medium leading-none">{inProgressTotalPoiReviews.badge}</p>
				<div class="flex self-stretch gap-2 items-center">
					<p class="text-sm font-medium leading-none text-muted-foreground">
						{inProgressTotalPoiReviews.previous_threshold}
					</p>
					<progress
						class="progress progress-error grow"
						value={animateProgressBarValue}
						max="100"
					/>
					<p class="text-sm font-medium leading-none text-muted-foreground">
						{inProgressTotalPoiReviews.threshold}
					</p>
				</div>
			</div>
		</Card.Description>
	</Card.Header>
</Card.Root>
