<script lang="ts" context="module">
	import * as t from 'io-ts';

	export const POIType = t.type({
		id: t.number,
		name: t.string,
		description: t.string,
		features: t.array(t.string),
		latitude: t.number,
		longitude: t.number,
		likes: t.number,
		location: t.string,
		created_at: t.string,
		updated_at: t.string
	});

	export type POI = t.TypeOf<typeof POIType>;
	export type POIViewCount = { count: number; poi: POI };
	type POIViewCounts = {
		groupedByUniqueUser: POIViewCount[];
		groupedByUniqueSession: POIViewCount[];
		groupedByUniqueAppVisit: POIViewCount[];
		allPOIViewsWithDuplicates: POIViewCount[];
	};
</script>

<script lang="ts">
	import { onMount } from 'svelte';
	import DataTable from './data-table/data-table.svelte';
	import { isRight } from 'fp-ts/lib/Either';
	import * as Tabs from '$lib/components/ui/tabs';

	export let updateLayoutOffsets: () => void;

	onMount(updateLayoutOffsets);

	let data: POIViewCounts = {
		groupedByUniqueUser: [],
		groupedByUniqueSession: [],
		groupedByUniqueAppVisit: [],
		allPOIViewsWithDuplicates: []
	};
	let loading = true;

	const getPOIs = async () => {
		const response = await fetch('/api/admin/stats/pois');
		if (response.ok) {
			const pois = await response.json();

			if (pois.email_grouped !== undefined) {
				const dataIntermediate: { count: number; poi: POI }[] = [];

				pois.email_grouped.forEach(({ count, poi }: { count: any; poi: any }) => {
					const validationResult = POIType.decode(poi);

					if (typeof count === 'number') {
						if (isRight(validationResult)) {
							const poiValidated: POI = validationResult.right;
							dataIntermediate.push({ count, poi: poiValidated });
						} else {
							console.error(
								'Invalid POI view count object received from API: ',
								validationResult.left,
								'Count: ' + count
							);
						}
					} else {
						console.error('Invalid POI view count object received from API: ', 'Count: ' + count);
					}
				});

				data.groupedByUniqueUser = dataIntermediate;
			} else {
				console.error('Invalid email grouped POI View data received from API');
			}

			if (pois.session_id_grouped !== undefined) {
				const dataIntermediate: { count: number; poi: POI }[] = [];

				pois.session_id_grouped.forEach(({ count, poi }: { count: any; poi: any }) => {
					const validationResult = POIType.decode(poi);

					if (typeof count === 'number') {
						if (isRight(validationResult)) {
							const poiValidated: POI = validationResult.right;
							dataIntermediate.push({ count, poi: poiValidated });
						} else {
							console.error(
								'Invalid POI view count object received from API: ',
								validationResult.left,
								'Count: ' + count
							);
						}
					} else {
						console.error('Invalid POI view count object received from API: ', 'Count: ' + count);
					}
				});

				data.groupedByUniqueSession = dataIntermediate;
			} else {
				console.error('Invalid session grouped POI View data received from API');
			}

			if (pois.app_visit_grouped !== undefined) {
				const dataIntermediate: { count: number; poi: POI }[] = [];

				pois.app_visit_grouped.forEach(({ count, poi }: { count: any; poi: any }) => {
					const validationResult = POIType.decode(poi);

					if (typeof count === 'number') {
						if (isRight(validationResult)) {
							const poiValidated: POI = validationResult.right;
							dataIntermediate.push({ count, poi: poiValidated });
						} else {
							console.error(
								'Invalid POI view count object received from API: ',
								validationResult.left,
								'Count: ' + count
							);
						}
					} else {
						console.error('Invalid POI view count object received from API: ', 'Count: ' + count);
					}
				});

				data.groupedByUniqueAppVisit = dataIntermediate;
			} else {
				console.error('Invalid app view grouped POI View data received from API');
			}

			if (pois.pois_grouped_with_duplicates !== undefined) {
				const dataIntermediate: { count: number; poi: POI }[] = [];

				pois.pois_grouped_with_duplicates.forEach(({ count, poi }: { count: any; poi: any }) => {
					const validationResult = POIType.decode(poi);

					if (typeof count === 'number') {
						if (isRight(validationResult)) {
							const poiValidated: POI = validationResult.right;
							dataIntermediate.push({ count, poi: poiValidated });
						} else {
							console.error(
								'Invalid POI view count object received from API: ',
								validationResult.left,
								'Count: ' + count
							);
						}
					} else {
						console.error('Invalid POI view count object received from API: ', 'Count: ' + count);
					}
				});

				data.allPOIViewsWithDuplicates = dataIntermediate;
			} else {
				console.error('Invalid total POI View data received from API');
			}

			loading = false;
		}
	};

	enum ViewMode {
		UNIQUE_USER_GROUPED = 'groupedByUniqueUser',
		UNIQUE_SESSION_GROUPED = 'groupedByUniqueSession',
		UNIQUE_APP_VISIT_GROUPED = 'groupedByUniqueAppVisit',
		ALL_POI_VIEWS_WITH_DUPLICATES = 'allPOIViewsWithDuplicates'
	}

	let currentViewModeForPOIViewCounts: ViewMode = ViewMode.UNIQUE_USER_GROUPED;

	onMount(getPOIs);
</script>

{#if loading}
	<div class="grow flex items-center justify-center">
		<span class="loading loading-ring loading-lg" />
	</div>
{:else}
	<p class="text-lg font-semibold leading-none tracking-tight mb-3">Group By:</p>
	<Tabs.Root bind:value={currentViewModeForPOIViewCounts}>
		<Tabs.List class="w-full overflow-x-auto">
			<Tabs.Trigger class="grow basis-1/4" value="groupedByUniqueUser">Unique Users</Tabs.Trigger>
			<Tabs.Trigger class="grow basis-1/4" value="groupedByUniqueSession"
				>Unique Sessions</Tabs.Trigger
			>
			<Tabs.Trigger class="grow basis-1/4" value="groupedByUniqueAppVisit"
				>Unique App Visits</Tabs.Trigger
			>
			<Tabs.Trigger class="grow basis-1/4" value="allPOIViewsWithDuplicates"
				>Total no. of POI clicks (includes duplicate clicks)</Tabs.Trigger
			>
		</Tabs.List>
		<Tabs.Content value="groupedByUniqueUser">
			<DataTable data={data.groupedByUniqueUser} />
		</Tabs.Content>
		<Tabs.Content value="groupedByUniqueSession">
			<DataTable data={data.groupedByUniqueSession} />
		</Tabs.Content>
		<Tabs.Content value="groupedByUniqueAppVisit">
			<DataTable data={data.groupedByUniqueAppVisit} />
		</Tabs.Content>
		<Tabs.Content value="allPOIViewsWithDuplicates">
			<DataTable data={data.allPOIViewsWithDuplicates} />
		</Tabs.Content>
	</Tabs.Root>
{/if}
