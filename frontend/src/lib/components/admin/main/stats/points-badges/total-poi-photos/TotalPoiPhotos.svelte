<script lang="ts">
	import type { BadgeCount } from '../PointsBadges.svelte';
	import { Separator } from '$lib/components/ui/separator';
	import TotalPoiPhotosItem from './TotalPoiPhotosItem.svelte';

	export let totalPoiPhotosBadgeCounts: BadgeCount[];
</script>

<p class="text-sm font-medium leading-none text-muted-foreground mb-3">
	Total POI Photo Badges Achieved By Users
</p>
<div class="flex w-full overflow-x-auto gap-2">
	{#each totalPoiPhotosBadgeCounts as badgeItem (badgeItem.badge)}
		<TotalPoiPhotosItem {badgeItem} />
	{/each}
</div>
<Separator class="mt-3 mb-4" />
