<script lang="ts">
	import type { BadgeStatus } from '../PointsBadges.svelte';
	import UpcomingMilestonesItem from './UpcomingMilestonesItem.svelte';
	import { Separator } from '$lib/components/ui/separator';
	import * as Dialog from '$lib/components/ui/dialog';
	import { Button } from '$lib/components/ui/button';

	export let lockedTotalPoints: BadgeStatus[];
	export let lockedTotalCheckIns: BadgeStatus[];
	export let lockedTotalPoiPhotos: BadgeStatus[];
	export let lockedTotalPoiReviews: BadgeStatus[];

	const badgeStatusArrayToExtendedObject = (badgeStatuses: BadgeStatus[], appendix: string) =>
		badgeStatuses.map((badgeStatus) => ({ value: badgeStatus, appendix }));

	const collapsedViewData = [
		badgeStatusArrayToExtendedObject(lockedTotalPoints, 'Total Points')[0],
		badgeStatusArrayToExtendedObject(lockedTotalCheckIns, 'Total Check-ins')[0],
		badgeStatusArrayToExtendedObject(lockedTotalPoiPhotos, 'Total Photos')[0],
		badgeStatusArrayToExtendedObject(lockedTotalPoiReviews, 'Total Reviews')[0]
	]
		.concat([
			...badgeStatusArrayToExtendedObject(lockedTotalPoints.slice(1), 'Total Points'),
			...badgeStatusArrayToExtendedObject(lockedTotalCheckIns.slice(1), 'Total Check-ins'),
			...badgeStatusArrayToExtendedObject(lockedTotalPoiPhotos.slice(1), 'Total Photos'),
			...badgeStatusArrayToExtendedObject(lockedTotalPoiReviews.slice(1), 'Total Reviews')
		])
		.filter((item) => item !== undefined)
		.slice(0, 4);

	const expandedViewData = [
		...badgeStatusArrayToExtendedObject(lockedTotalPoints, 'Total Points'),
		...badgeStatusArrayToExtendedObject(lockedTotalCheckIns, 'Total Check-ins'),
		...badgeStatusArrayToExtendedObject(lockedTotalPoiPhotos, 'Total Photos'),
		...badgeStatusArrayToExtendedObject(lockedTotalPoiReviews, 'Total Reviews')
	].filter(
		(item) =>
			item !== undefined && !collapsedViewData.some(({ value: _value }) => _value === item.value)
	);
</script>

<p class="text-lg font-medium leading-none text-muted-foreground mb-3">Upcoming Milestones</p>
{#if collapsedViewData.length === 0}
	<div class="flex justify-center items-center p-4">
		<p>You have achieved all possible milestones, congratulations!</p>
	</div>
{:else}
	<div class="grid grid-cols-4 max-sm:grid-cols-2 max-sm:grid-rows-2 gap-2 mb-3">
		{#each collapsedViewData as item (item)}
			<UpcomingMilestonesItem badgeStatus={item.value} appendix={item.appendix} />
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
				<Dialog.Title class="mb-4">All Other Upcoming Milestones</Dialog.Title>
				<Dialog.Description>
					<div class="grid grid-cols-4 max-sm:grid-cols-2 max-sm:grid-rows-2 gap-2">
						{#each expandedViewData as item (item)}
							<UpcomingMilestonesItem badgeStatus={item.value} appendix={item.appendix} />
						{/each}
					</div>
				</Dialog.Description>
			</Dialog.Header>
		</Dialog.Content>
	</Dialog.Root>
{/if}
<Separator class="mt-3 mb-4" />
