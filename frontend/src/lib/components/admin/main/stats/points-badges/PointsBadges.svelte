<script lang="ts" context="module">
	import * as t from 'io-ts';
	import Badges from '$lib/enums/Badges';

	const BadgeCountType = t.type({
		badge: t.keyof(Badges),
		threshold: t.number,
		count: t.number
	});

	export type BadgeCount = t.TypeOf<typeof BadgeCountType>;
</script>

<script lang="ts">
	import { onMount } from 'svelte';
	import { isRight } from 'fp-ts/lib/Either';
	import TotalPoints from './total-points/TotalPoints.svelte';
	import TotalCheckIns from './total-check-ins/TotalCheckIns.svelte';
	import TotalPoiPhotos from './total-poi-photos/TotalPoiPhotos.svelte';
	import TotalPoiReviews from './total-poi-reviews/TotalPoiReviews.svelte';

	export let updateLayoutOffsets: () => void;

	type BadgeCounts = {
		total_points_badges: BadgeCount[];
		total_check_ins_badges: BadgeCount[];
		total_poi_photos_badges: BadgeCount[];
		total_poi_reviews_badges: BadgeCount[];
	};

	onMount(updateLayoutOffsets);

	let data: BadgeCounts = {
		total_points_badges: [],
		total_check_ins_badges: [],
		total_poi_photos_badges: [],
		total_poi_reviews_badges: []
	};
	let loading = true;

	const getPointsBadges = async () => {
		const response = await fetch('/api/admin/stats/points-badges');
		if (response.ok) {
			const badgeData = await response.json();

			if (badgeData.total_points_badges !== undefined) {
				const badgeDataIntermediate: BadgeCount[] = [];

				badgeData.total_points_badges.forEach((badge: any) => {
					const validationResult = BadgeCountType.decode(badge);

					if (isRight(validationResult)) {
						const badgeCountValidated: BadgeCount = validationResult.right;
						badgeDataIntermediate.push(badgeCountValidated);
					} else {
						console.error(
							'Invalid total points badge count object received from API: ',
							validationResult.left
						);
					}
				});

				data.total_points_badges = badgeDataIntermediate;
			} else {
				console.error('Invalid total points badge count data received from API');
			}

			if (badgeData.total_check_ins_badges !== undefined) {
				const badgeDataIntermediate: BadgeCount[] = [];

				badgeData.total_check_ins_badges.forEach((badge: any) => {
					const validationResult = BadgeCountType.decode(badge);

					if (isRight(validationResult)) {
						const badgeCountValidated: BadgeCount = validationResult.right;
						badgeDataIntermediate.push(badgeCountValidated);
					} else {
						console.error(
							'Invalid total check-ins badge count object received from API: ',
							validationResult.left
						);
					}
				});

				data.total_check_ins_badges = badgeDataIntermediate;
			} else {
				console.error('Invalid total check-ins badge count data received from API');
			}

			if (badgeData.total_poi_photos_badges !== undefined) {
				const badgeDataIntermediate: BadgeCount[] = [];

				badgeData.total_poi_photos_badges.forEach((badge: any) => {
					const validationResult = BadgeCountType.decode(badge);

					if (isRight(validationResult)) {
						const badgeCountValidated: BadgeCount = validationResult.right;
						badgeDataIntermediate.push(badgeCountValidated);
					} else {
						console.error(
							'Invalid total POI photos badge count object received from API: ',
							validationResult.left
						);
					}
				});

				data.total_poi_photos_badges = badgeDataIntermediate;
			} else {
				console.error('Invalid total POI photos badge count data received from API');
			}

			if (badgeData.total_poi_reviews_badges !== undefined) {
				const badgeDataIntermediate: BadgeCount[] = [];

				badgeData.total_poi_reviews_badges.forEach((badge: any) => {
					const validationResult = BadgeCountType.decode(badge);

					if (isRight(validationResult)) {
						const badgeCountValidated: BadgeCount = validationResult.right;
						badgeDataIntermediate.push(badgeCountValidated);
					} else {
						console.error(
							'Invalid total POI reviews badge count object received from API: ',
							validationResult.left
						);
					}
				});

				data.total_poi_reviews_badges = badgeDataIntermediate;
			} else {
				console.error('Invalid total POI reviews badge count data received from API');
			}

			loading = false;
		}
	};

	onMount(getPointsBadges);
</script>

{#if loading}
	<div class="grow flex items-center justify-center">
		<span class="loading loading-ring loading-lg" />
	</div>
{:else}
	<div>
		<TotalPoints totalPointsBadgeCounts={data.total_points_badges} />
		<TotalCheckIns totalCheckInsBadgeCounts={data.total_check_ins_badges} />
		<TotalPoiPhotos totalPoiPhotosBadgeCounts={data.total_poi_photos_badges} />
		<TotalPoiReviews totalPoiReviewsBadgeCounts={data.total_poi_reviews_badges} />
	</div>
{/if}
