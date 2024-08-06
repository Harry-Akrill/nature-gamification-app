<script lang="ts">
	import type { BadgeCount } from '../PointsBadges.svelte';
	import { Separator } from '$lib/components/ui/separator';
	import TotalPointsItem from './TotalPointsItem.svelte';

	export let totalPointsBadgeCounts: BadgeCount[];
</script>

<p class="text-sm font-medium leading-none text-muted-foreground mb-3">
	Total Point Badges Achieved By Users
</p>
<div class="flex w-full overflow-x-auto gap-2">
	{#each totalPointsBadgeCounts as badgeItem (badgeItem.badge)}
		<TotalPointsItem {badgeItem} />
	{/each}
</div>
<Separator class="mt-3 mb-4" />
