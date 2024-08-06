import { writable } from 'svelte/store';
import { authenticationStatus } from '$lib/auth';
import type UserType from '$lib/enums/userType';
import { toast } from 'svelte-sonner';
import { isRight } from 'fp-ts/lib/Either';
import * as t from 'io-ts';
import Badges from '$lib/enums/Badges';
import { goto } from '$app/navigation';
import { ShieldHalf } from 'lucide-svelte';

const createAuthenticatedStore = () => {
	const { subscribe, set } = writable<null | boolean | UserType>(null);

	return {
		subscribe,
		verify: async () => set(await authenticationStatus())
	};
};
export const authenticated = createAuthenticatedStore();

export const newLandingPageVisitRegisteredPromise = writable<Promise<void>>(new Promise(() => {}));

export const pathToRegistrationAppendCurrentCallStack = writable<Promise<void>>(
	new Promise((resolve) => resolve())
);

const BadgeStatusInProgressType = t.type({
	status: t.literal('IN PROGRESS'),
	badge: t.keyof(Badges),
	threshold: t.number,
	previous_threshold: t.number
});

type BadgeStatusInProgress = t.TypeOf<typeof BadgeStatusInProgressType>;

const validateBadgeStatus = (badgeStatusUnsafe: any) => {
	if (badgeStatusUnsafe === undefined) {
		return undefined;
	}

	const validationResult = BadgeStatusInProgressType.decode(badgeStatusUnsafe);

	if (isRight(validationResult)) {
		return validationResult.right;
	}

	console.error('Invalid BadgeStatus object received from API: ', validationResult.left);
	return null;
};

const createInProgressBadgesStore = () => {
	const { subscribe, update } = writable<null | {
		total_points_in_progress: BadgeStatusInProgress | undefined;
		total_check_ins_in_progress: BadgeStatusInProgress | undefined;
		total_poi_photos_in_progress: BadgeStatusInProgress | undefined;
		total_poi_reviews_in_progress: BadgeStatusInProgress | undefined;
	}>(null);

	return {
		subscribe,
		checkForUpdates: async () => {
			const response = await fetch('/api/points-badges/in-progress');
			if (response.ok) {
				const data = await response.json();

				const new_total_points_in_progress = validateBadgeStatus(data.total_points_in_progress);
				const new_total_check_ins_in_progress = validateBadgeStatus(
					data.total_check_ins_in_progress
				);
				const new_total_poi_photos_in_progress = validateBadgeStatus(
					data.total_poi_photos_in_progress
				);
				const new_total_poi_reviews_in_progress = validateBadgeStatus(
					data.total_poi_reviews_in_progress
				);

				update((oldValue) => {
					if (
						new_total_points_in_progress === null ||
						new_total_check_ins_in_progress === null ||
						new_total_poi_photos_in_progress === null ||
						new_total_poi_reviews_in_progress === null
					) {
						return oldValue;
					}

					if (oldValue === null) {
						return {
							total_points_in_progress: new_total_points_in_progress,
							total_check_ins_in_progress: new_total_check_ins_in_progress,
							total_poi_photos_in_progress: new_total_poi_photos_in_progress,
							total_poi_reviews_in_progress: new_total_poi_reviews_in_progress
						};
					}

					if (
						oldValue.total_points_in_progress !== undefined &&
						JSON.stringify(oldValue.total_points_in_progress) !==
							JSON.stringify(new_total_points_in_progress)
					) {
						toast.info('New Total Points Milestone: ' + oldValue.total_points_in_progress.badge, {
							icon: ShieldHalf
						});
					}

					if (
						oldValue.total_check_ins_in_progress !== undefined &&
						JSON.stringify(oldValue.total_check_ins_in_progress) !==
							JSON.stringify(new_total_check_ins_in_progress)
					) {
						toast.info(
							'New Total Check-ins Milestone: ' + oldValue.total_check_ins_in_progress.badge,
							{ icon: ShieldHalf }
						);
					}

					if (
						oldValue.total_poi_photos_in_progress !== undefined &&
						JSON.stringify(oldValue.total_poi_photos_in_progress) !==
							JSON.stringify(new_total_poi_photos_in_progress)
					) {
						toast.info(
							'New Total Photos Milestone: ' + oldValue.total_poi_photos_in_progress.badge,
							{ icon: ShieldHalf }
						);
					}

					if (
						oldValue.total_poi_reviews_in_progress !== undefined &&
						JSON.stringify(oldValue.total_poi_reviews_in_progress) !==
							JSON.stringify(new_total_poi_reviews_in_progress)
					) {
						toast.info(
							'New Total Reviews Milestone: ' + oldValue.total_poi_reviews_in_progress.badge,
							{ icon: ShieldHalf }
						);
					}

					return {
						total_points_in_progress: new_total_points_in_progress,
						total_check_ins_in_progress: new_total_check_ins_in_progress,
						total_poi_photos_in_progress: new_total_poi_photos_in_progress,
						total_poi_reviews_in_progress: new_total_poi_reviews_in_progress
					};
				});
			}
		}
	};
};
export const inProgressBadges = createInProgressBadgesStore();
