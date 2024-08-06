<script lang="ts">
	import type { BadgeCount } from '../PointsBadges.svelte';
	import TotalPoiReviewsItem from './TotalPoiReviewsItem.svelte';

	export let totalPoiReviewsBadgeCounts: BadgeCount[];
</script>

<p class="text-sm font-medium leading-none text-muted-foreground mb-3">
	Total POI Review Badges Achieved By Users
</p>
<div class="flex w-full overflow-x-auto gap-2">
	{#each totalPoiReviewsBadgeCounts as badgeItem (badgeItem.badge)}
		<TotalPoiReviewsItem {badgeItem} />
	{/each}
</div>
