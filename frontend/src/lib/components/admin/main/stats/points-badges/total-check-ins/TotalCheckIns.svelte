<script lang="ts">
	import type { BadgeCount } from '../PointsBadges.svelte';
	import { Separator } from '$lib/components/ui/separator';
	import TotalCheckInsItem from './TotalCheckInsItem.svelte';

	export let totalCheckInsBadgeCounts: BadgeCount[];
</script>

<p class="text-sm font-medium leading-none text-muted-foreground mb-3">
	Total Check-in Badges Achieved By Users
</p>
<div class="flex w-full overflow-x-auto gap-2">
	{#each totalCheckInsBadgeCounts as badgeItem (badgeItem.badge)}
		<TotalCheckInsItem {badgeItem} />
	{/each}
</div>
<Separator class="mt-3 mb-4" />
