<script lang="ts">
	import type { BadgeStatus } from '../PointsBadges.svelte';
	import SummaryCardTotalPoints from './SummaryCardTotalPoints.svelte';
	import SummaryCardTotalCheckIns from './SummaryCardTotalCheckIns.svelte';
	import SummaryCardTotalPoiPhotos from './SummaryCardTotalPoiPhotos.svelte';
	import SummaryCardTotalPoiReviews from './SummaryCardTotalPoiReviews.svelte';
	import { Separator } from '$lib/components/ui/separator';

	export let totalPoints: number;
	export let totalCheckInCounts: number;
	export let totalPoiPhotoCounts: number;
	export let totalPoiReviewCounts: number;
	export let inProgressTotalPoints: BadgeStatus;
	export let inProgressTotalCheckIns: BadgeStatus;
	export let inProgressTotalPoiPhotos: BadgeStatus;
	export let inProgressTotalPoiReviews: BadgeStatus;
</script>

<p class="text-lg font-medium leading-none text-muted-foreground mb-3">Your Progression</p>
<div class="grid grid-cols-4 max-sm:grid-cols-2 max-sm:grid-rows-2 gap-2">
	<SummaryCardTotalPoints {totalPoints} {inProgressTotalPoints} />
	<SummaryCardTotalCheckIns {totalCheckInCounts} {inProgressTotalCheckIns} />
	<SummaryCardTotalPoiPhotos {totalPoiPhotoCounts} {inProgressTotalPoiPhotos} />
	<SummaryCardTotalPoiReviews {totalPoiReviewCounts} {inProgressTotalPoiReviews} />
</div>
<Separator class="mt-3 mb-4" />
