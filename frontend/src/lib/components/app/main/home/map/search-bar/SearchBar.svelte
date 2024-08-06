<script lang="ts">
	import type layers from '$lib/components/app/main/home/map/search-bar/layers';
	import SearchBarInner from '$lib/components/app/main/home/map/search-bar/SearchBarInner.svelte';
	import type { Map } from 'maplibre-gl';
	import type { POI } from '../Map.svelte';
	import { Button } from '$lib/components/ui/button';
	import * as Accordion from '$lib/components/ui/accordion';
	import { tick } from 'svelte';
	import { createEventDispatcher } from 'svelte';
	import { sleep } from '$lib/utils';
	import { toast } from 'svelte-sonner';
	import { inProgressBadges } from '$lib/stores';

	export let selectedMapLayer: (typeof layers)[0];
	export let searchBar: HTMLDivElement;
	export let poiFeatureOptions: string[];
	export let poiFeaturesFilter: string[];
	export let onlyShowFavourites: boolean;
	export let map: Map;
	export let checkInCandidates: POI[];
	export let updateSearchBarOffset: () => void;
	export let idOfSelectedPOI: number | null;
	export let userLocation: { lng: number; lat: number; accuracyMeters: number };
	export let fetchCheckInCandidates: () => Promise<void>;
	export let pointsOfInterest: POI[];

	let accordionValue = '';
	let lastIdOfSelectedPOI: number | null = null;

	const dispatch = createEventDispatcher();

	const closeAccordionAndDispatch = (poiId: number) => {
		accordionValue = '';
		const poi = pointsOfInterest.find(({ id }) => id === poiId);

		if (poi) {
			const minZoomLevel = 14;
			const maxZoomLevel = 16;
			map.flyTo({
				center: poi.lngLat,
				zoom: Math.min(maxZoomLevel, Math.max(minZoomLevel, map.getZoom())),
				padding: { top: 300 }
			});
		}

		dispatch('poiSelected', poiId);
	};

	$: {
		if (checkInCandidates.length === 0) {
			accordionValue = '';
		}
	}

	let idOfSelectedPOIChangeFromParent = true;
	$: if (idOfSelectedPOI !== null) {
		accordionValue = '';
	} else if (idOfSelectedPOIChangeFromParent) {
		lastIdOfSelectedPOI = null;
	} else {
		idOfSelectedPOIChangeFromParent = true;
	}

	let oldCheckInCandidatesLength = 0;
	$: (async () => {
		if (
			(checkInCandidates.length > 0 && oldCheckInCandidatesLength === 0) ||
			(checkInCandidates.length === 0 && oldCheckInCandidatesLength > 0)
		) {
			oldCheckInCandidatesLength = checkInCandidates.length;
			await tick();
			updateSearchBarOffset();
		}
	})();

	const registerPOICheckIn = async (poiId: number) => {
		if (userLocation === undefined) return;
		const response = await fetch('/api/check-in', {
			method: 'POST',
			body: JSON.stringify({
				poi_id: poiId,
				latitude: userLocation.lat,
				longitude: userLocation.lat,
				accuracy_meters: userLocation.accuracyMeters
			}),
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			toast.error('Failed to check-in at POI, contact admin for details.');
		}

		fetchCheckInCandidates();
		const checkInVerificationResponse = await fetch(
			'/api/check-in/single?poi_id=' + encodeURIComponent(poiId)
		);

		const checkInVerificationData = await checkInVerificationResponse.json();
		if (checkInVerificationData) {
			toast.success('Successfully checked in at POI!');
			inProgressBadges.checkForUpdates();
			const checkedInPOI = pointsOfInterest.find(({ id: _id }) => poiId === _id);

			if (checkedInPOI !== undefined) {
				checkedInPOI.checkedIn = true;
				pointsOfInterest = pointsOfInterest;
			}
		}
	};
</script>

<svelte:window
	on:resize={async () => {
		map?.resize();

		if (accordionValue !== '') {
			const currentValue = accordionValue;
			accordionValue = '';
			await sleep(250);
			updateSearchBarOffset();
			accordionValue = currentValue;
		} else {
			updateSearchBarOffset();
		}
	}}
/>

<div
	class="z-10 absolute w-full p-2 border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 flex flex-col gap-2 justify-between"
	bind:this={searchBar}
>
	<SearchBarInner
		bind:selectedMapLayer
		{poiFeatureOptions}
		bind:poiFeaturesFilter
		bind:onlyShowFavourites
		{map}
		on:poiSelected
	/>
	{#if checkInCandidates.length > 0}
		<Accordion.Root
			bind:value={accordionValue}
			onValueChange={(newValue) => {
				if (newValue !== undefined && newValue !== '') {
					idOfSelectedPOIChangeFromParent = false;
					lastIdOfSelectedPOI = idOfSelectedPOI;
					idOfSelectedPOI = null;
				} else if (lastIdOfSelectedPOI !== null) {
					idOfSelectedPOIChangeFromParent = false;
					idOfSelectedPOI = lastIdOfSelectedPOI;
				}
			}}
		>
			<Accordion.Item value="check-in-prompt" class="border-b-0">
				<Accordion.Trigger
					class="hover:no-underline hover:backdrop-opacity-75 active:backdrop-opacity-95 rounded-md h-10 px-4 py-2"
					>Check-in to nearby POI{checkInCandidates.length > 1 ? 's' : ''}:</Accordion.Trigger
				>
				<Accordion.Content class="*:p-0 max-h-32 overflow-y-auto">
					{#each checkInCandidates as candidate (candidate.id)}
						<div class="flex justify-between items-center gap-4 px-4 py-2">
							<p class="max-sm:text-ellipsis max-sm:max-w-48 max-sm:overflow-hidden">
								{#each candidate.name.split(' ') as word, index (index)}
									{#if index === 0}
										{word}
									{:else}
										&nbsp;{word}
									{/if}
								{/each}
							</p>
							<div class="flex items-center gap-2">
								<Button
									size="sm"
									variant="secondary"
									on:click={() => closeAccordionAndDispatch(candidate.id)}>View</Button
								>
								<Button size="sm" on:click={() => registerPOICheckIn(candidate.id)}>Check-in</Button
								>
							</div>
						</div>
					{/each}
				</Accordion.Content>
			</Accordion.Item>
		</Accordion.Root>
	{/if}
</div>
