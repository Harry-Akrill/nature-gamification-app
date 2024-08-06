<script lang="ts">
	import type { BadgeStatus } from '../PointsBadges.svelte';
	import PastAchievementsItem from './PastAchievementsItem.svelte';
	import { Separator } from '$lib/components/ui/separator';
	import * as Dialog from '$lib/components/ui/dialog';
	import { Button } from '$lib/components/ui/button';

	export let achievedTotalPoints: BadgeStatus[];
	export let achievedTotalCheckIns: BadgeStatus[];
	export let achievedTotalPoiPhotos: BadgeStatus[];
	export let achievedTotalPoiReviews: BadgeStatus[];

	const badgeStatusArrayToExtendedObject = (badgeStatuses: BadgeStatus[], appendix: string) =>
		badgeStatuses.map((badgeStatus) => ({ value: badgeStatus, appendix }));

	const collapsedViewData = [
		badgeStatusArrayToExtendedObject(achievedTotalPoints, 'Total Points')[0],
		badgeStatusArrayToExtendedObject(achievedTotalCheckIns, 'Total Check-ins')[0],
		badgeStatusArrayToExtendedObject(achievedTotalPoiPhotos, 'Total Photos')[0],
		badgeStatusArrayToExtendedObject(achievedTotalPoiReviews, 'Total Reviews')[0]
	]
		.concat([
			...badgeStatusArrayToExtendedObject(achievedTotalPoints.slice(1), 'Total Points'),
			...badgeStatusArrayToExtendedObject(achievedTotalCheckIns.slice(1), 'Total Check-ins'),
			...badgeStatusArrayToExtendedObject(achievedTotalPoiPhotos.slice(1), 'Total Photos'),
			...badgeStatusArrayToExtendedObject(achievedTotalPoiReviews.slice(1), 'Total Reviews')
		])
		.filter((item) => item !== undefined)
		.slice(0, 4);

	const expandedViewData = [
		...badgeStatusArrayToExtendedObject(achievedTotalPoints, 'Total Points'),
		...badgeStatusArrayToExtendedObject(achievedTotalCheckIns, 'Total Check-ins'),
		...badgeStatusArrayToExtendedObject(achievedTotalPoiPhotos, 'Total Photos'),
		...badgeStatusArrayToExtendedObject(achievedTotalPoiReviews, 'Total Reviews')
	].filter(
		(item) =>
			item !== undefined && !collapsedViewData.some(({ value: _value }) => _value === item.value)
	);
</script>

<p class="text-lg font-medium leading-none text-muted-foreground mb-3">Past Achievements</p>
{#if collapsedViewData.length === 0}
	<div class="flex justify-center items-center p-4">
		<p>Currently you do not have any past achievements…</p>
	</div>
{:else}
	<div class="grid grid-cols-4 max-sm:grid-cols-2 max-sm:grid-rows-2 gap-2 mb-3">
		{#each collapsedViewData as item (item)}
			<PastAchievementsItem badgeStatus={item.value} appendix={item.appendix} />
		{/each}
	</div>
{/if}
{#if expandedViewData.length > 0}
	<Dialog.Root>
		<Dialog.Trigger class="flex"
			><Button class="grow" variant="outline">Show All Others</Button></Dialog.Trigger
		>
		<Dialog.Content class="max-h-[90%] max-w-[90%] overflow-y-auto p-4">
			<Dialog.Header>
				<Dialog.Title class="mb-4">All Other Past Achievements</Dialog.Title>
				<Dialog.Description>
					<div class="grid grid-cols-4 max-sm:grid-cols-2 max-sm:grid-rows-2 gap-2">
						{#each expandedViewData as item (item)}
							<PastAchievementsItem badgeStatus={item.value} appendix={item.appendix} />
						{/each}
					</div>
				</Dialog.Description>
			</Dialog.Header>
		</Dialog.Content>
	</Dialog.Root>
{/if}
