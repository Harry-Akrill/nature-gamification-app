<script lang="ts" context="module">
	import * as t from 'io-ts';

	export const BadgeStatusType = t.type({
		status: t.union([t.literal('ACHIEVED'), t.literal('IN PROGRESS'), t.literal('LOCKED')]),
		badge: t.keyof(Badges),
		threshold: t.number,
		previous_threshold: t.number
	});

	export type BadgeStatus = t.TypeOf<typeof BadgeStatusType>;
</script>

<script lang="ts">
	import { onMount } from 'svelte';
	import * as Card from '$lib/components/ui/card';
	import { Separator } from '$lib/components/ui/separator';
	import Badges from '$lib/enums/Badges';
	import { isRight } from 'fp-ts/lib/Either';
	import SummaryCard from './summary-card/SummaryCard.svelte';
	import * as Popover from '$lib/components/ui/popover';
	import { Button } from '$lib/components/ui/button';
	import { Info } from 'lucide-svelte';
	import UpcomingMilestones from './upcoming-milestones/UpcomingMilestones.svelte';
	import PastAchievements from './past-achievements/PastAchievements.svelte';

	let cardHeader: HTMLDivElement;
	let cardHeaderHeight = 64;

	const updateLayoutOffsets = () => {
		const height = cardHeader.offsetHeight;
		if (height !== undefined) {
			cardHeaderHeight = height;
		}
	};

	onMount(updateLayoutOffsets);

	let loading = true;
	let totalPoints: number;
	let totalCheckInCounts: number;
	let totalPoiPhotoCounts: number;
	let totalPoiReviewCounts: number;
	let badgeStatusesTotalPoints: BadgeStatus[];
	let badgeStatusesTotalCheckInCounts: BadgeStatus[];
	let badgeStatusesTotalPoiPhotoCounts: BadgeStatus[];
	let badgeStatusesTotalPoiReviewCounts: BadgeStatus[];

	const validateBadgeStatuses = (badgeStatusesUnsafe: any) => {
		if (!Array.isArray(badgeStatusesUnsafe)) {
			console.error('Badge statuses are not an array');
			return [];
		}

		const dataIntermediate: BadgeStatus[] = [];

		badgeStatusesUnsafe.forEach((badgeStatus: any) => {
			const validationResult = BadgeStatusType.decode(badgeStatus);

			if (isRight(validationResult)) {
				const badgeStatusValidated: BadgeStatus = validationResult.right;
				dataIntermediate.push(badgeStatusValidated);
			} else {
				console.error('Invalid BadgeStatus object received from API: ', validationResult.left);
			}
		});

		return dataIntermediate;
	};

	const getData = async () => {
		const KEYS = [
			'totalPoints',
			'totalCheckInCounts',
			'totalPoiPhotoCounts',
			'totalPoiReviewCounts',
			'badgeStatusesForTotalPoints',
			'badgeStatusesForTotalCheckInCounts',
			'badgeStatusesForTotalPoiPhotoCounts',
			'badgeStatusesForTotalPoiReviewCounts'
		];
		const response = await fetch('/api/points-badges');
		if (response.ok) {
			const data = await response.json();
			if (KEYS.some((key) => data[key] === undefined)) {
				console.error('Undefined data returned from API');
				return;
			}
			if (
				typeof data.totalPoints !== 'number' ||
				typeof data.totalCheckInCounts !== 'number' ||
				typeof data.totalPoiPhotoCounts !== 'number' ||
				typeof data.totalPoiReviewCounts !== 'number'
			) {
				console.error('Data returned from API has unexpected type');
				return;
			}

			badgeStatusesTotalPoints = validateBadgeStatuses(data.badgeStatusesForTotalPoints);
			badgeStatusesTotalCheckInCounts = validateBadgeStatuses(
				data.badgeStatusesForTotalCheckInCounts
			);
			badgeStatusesTotalPoiPhotoCounts = validateBadgeStatuses(
				data.badgeStatusesForTotalPoiPhotoCounts
			);
			badgeStatusesTotalPoiReviewCounts = validateBadgeStatuses(
				data.badgeStatusesForTotalPoiReviewCounts
			);

			({ totalPoints, totalCheckInCounts, totalPoiPhotoCounts, totalPoiReviewCounts } = data);

			loading = false;
		}
	};

	onMount(getData);

	const findInProgressOrLast = (badgeStatuses: BadgeStatus[]) =>
		badgeStatuses.find(({ status }) => status === 'IN PROGRESS') ?? badgeStatuses.slice(-1)[0];

	const onlyLocked = (badgeStatuses: BadgeStatus[]) =>
		badgeStatuses.filter(({ status }) => status === 'LOCKED');

	const onlyAchievedReversed = (badgeStatuses: BadgeStatus[]) =>
		badgeStatuses.filter(({ status }) => status === 'ACHIEVED').reverse();
</script>

<svelte:window on:resize={updateLayoutOffsets} />

<div class="flex flex-col p-4 relative h-full">
	<Card.Root class="relative p-4 h-full">
		<div bind:this={cardHeader}>
			<Card.Header class="p-0 pb-4 space-y-0">
				<div class="flex justify-between mb-3 items-center">
					<Card.Title tag="h2">Points & Badges</Card.Title>
					<Popover.Root portal={null}>
						<Popover.Trigger asChild let:builder>
							<Button
								aria-label="Additional Information"
								builders={[builder]}
								variant="secondary"
								size="icon"><Info class="h-5 w-5" /></Button
							>
						</Popover.Trigger>
						<Popover.Content class="w-80">
							<div class="flex justify-between space-x-4">
								<div class="shrink-0">
									<Info className="h-4 w-4" />
								</div>
								<div class="space-y-1">
									<h4 class="text-sm font-semibold">Note</h4>
									<p class="text-sm">Total Points are calculated according to this formula:</p>
									<p class="italic text-xs">
										total_points = 20 * total_check_ins + 10 * total_photos + 5 * total_reviews
									</p>
								</div>
							</div>
						</Popover.Content>
					</Popover.Root>
				</div>
				<Separator />
			</Card.Header>
		</div>
		<Card.Content
			class="flex flex-col overflow-y-auto p-0"
			style={`height: calc(100% - ${cardHeaderHeight}px);`}
		>
			{#if loading}
				<div class="grow flex items-center justify-center">
					<span class="loading loading-ring loading-lg" />
				</div>
			{:else}
				<SummaryCard
					{totalPoints}
					{totalCheckInCounts}
					{totalPoiPhotoCounts}
					{totalPoiReviewCounts}
					inProgressTotalPoints={findInProgressOrLast(badgeStatusesTotalPoints)}
					inProgressTotalCheckIns={findInProgressOrLast(badgeStatusesTotalCheckInCounts)}
					inProgressTotalPoiPhotos={findInProgressOrLast(badgeStatusesTotalPoiPhotoCounts)}
					inProgressTotalPoiReviews={findInProgressOrLast(badgeStatusesTotalPoiReviewCounts)}
				/>
				<UpcomingMilestones
					lockedTotalPoints={onlyLocked(badgeStatusesTotalPoints)}
					lockedTotalCheckIns={onlyLocked(badgeStatusesTotalCheckInCounts)}
					lockedTotalPoiPhotos={onlyLocked(badgeStatusesTotalPoiPhotoCounts)}
					lockedTotalPoiReviews={onlyLocked(badgeStatusesTotalPoiReviewCounts)}
				/>
				<PastAchievements
					achievedTotalPoints={onlyAchievedReversed(badgeStatusesTotalPoints)}
					achievedTotalCheckIns={onlyAchievedReversed(badgeStatusesTotalCheckInCounts)}
					achievedTotalPoiPhotos={onlyAchievedReversed(badgeStatusesTotalPoiPhotoCounts)}
					achievedTotalPoiReviews={onlyAchievedReversed(badgeStatusesTotalPoiReviewCounts)}
				/>
			{/if}
		</Card.Content>
	</Card.Root>
</div>
