<script lang="ts">
	import { onMount, tick } from 'svelte';
	import * as Card from '$lib/components/ui/card';
	import { Separator } from '$lib/components/ui/separator';
	import DataTable from './data-table/data-table.svelte';
	import { POIType, type POI } from '../home/map/Map.svelte';
	import { isRight } from 'fp-ts/lib/Either';

	let cardHeader: HTMLDivElement;
	let cardHeaderHeight = 64;

	const updateLayoutOffsets = () => {
		const height = cardHeader.offsetHeight;
		if (height !== undefined) {
			cardHeaderHeight = height;
		}
	};

	onMount(updateLayoutOffsets);

	let data: POI[] = [];
	let loading = true;

	const getFavourites = async () => {
		const response = await fetch('/api/favourites');
		if (response.ok) {
			const pointsOfInterest = await response.json();

			const dataIntermediate: POI[] = [];

			pointsOfInterest.forEach((poi: any) => {
				const validationResult = POIType.decode(poi);

				if (isRight(validationResult)) {
					const poiValidated: POI = validationResult.right;
					dataIntermediate.push(poiValidated);
				} else {
					console.error('Invalid POI object received from API: ', validationResult.left);
				}
			});

			data = dataIntermediate;
			loading = false;
		}
	};

	export const removeFavourite = async (id: number) => {
		loading = true;
		const poiId = data[id].id;

		const response = await fetch('/api/favourites?poi_id=' + encodeURIComponent(poiId), {
			method: 'DELETE'
		});

		if (!response.ok) {
			console.error(await response.json());
		}
		await tick();
		getFavourites();
	};

	onMount(getFavourites);
</script>

<svelte:window on:resize={updateLayoutOffsets} />

<div class="flex flex-col p-4 relative h-full">
	<Card.Root class="relative p-4 h-full">
		<div bind:this={cardHeader}>
			<Card.Header class="p-0 pb-4 space-y-0">
				<Card.Title tag="h2" class="mb-3">Favourites</Card.Title>
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
				<DataTable {data} {removeFavourite} />
			{/if}
		</Card.Content>
	</Card.Root>
</div>
