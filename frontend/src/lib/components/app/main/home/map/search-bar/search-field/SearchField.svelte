<script lang="ts">
	import * as Command from '$lib/components/ui/command';
	import { Button } from '$lib/components/ui/button';
	import axios, { type CancelTokenSource } from 'axios';
	import { PUBLIC_HERE_API_KEY } from '$env/static/public';
	import type { Map } from 'maplibre-gl';
	import { type POI, POIType } from '$lib/components/app/main/home/map/Map.svelte';
	import { isRight } from 'fp-ts/Either';
	import { ThumbsUp, MessageCircleMore, Search, Heart } from 'lucide-svelte';
	import { createEventDispatcher } from 'svelte';

	const AUTOSUGGEST_RESPONSE_LIMIT = 30;

	export let map: Map;

	const dispatch = createEventDispatcher();

	let loadingMatchingPointsOfInterest = false;
	let loadingAutoSuggestData = false;
	$: loading = loadingMatchingPointsOfInterest || loadingAutoSuggestData;
	let searchQuery: string;
	let open = false;
	let matchingPointsOfInterestCancelTokenSource: CancelTokenSource = axios.CancelToken.source();
	let autoSuggestCancelTokenSource: CancelTokenSource = axios.CancelToken.source();

	let matchingPointsOfInterest: POI[] = [];

	const fetchMatchingPointsOfInterest = async () => {
		loadingMatchingPointsOfInterest = true;
		if (matchingPointsOfInterestCancelTokenSource) {
			matchingPointsOfInterestCancelTokenSource.cancel();
		}
		matchingPointsOfInterestCancelTokenSource = axios.CancelToken.source();
		const cancelToken = matchingPointsOfInterestCancelTokenSource.token;

		const params = new URLSearchParams({ name: searchQuery });

		const request = await axios
			.get(`/api/poi/search?${params.toString()}`, {
				cancelToken
			})
			.catch((error) => error);

		if (request?.data) {
			let data = request.data;

			data = data.map((poi: any): POI | { error: boolean; message: string } => {
				const validationResult = POIType.decode(poi);

				if (isRight(validationResult)) {
					const typeSafePOI: POI = validationResult.right;
					return typeSafePOI;
				} else {
					return {
						error: true,
						message: 'Invalid POI object received from API: ' + validationResult.left
					};
				}
			});

			data = data.filter((poi: POI | { error: boolean; message: string }) => {
				if ('error' in poi && poi.error) {
					console.error(poi.message);
					return false;
				}

				return true;
			});

			matchingPointsOfInterest = data;
		}
		loadingMatchingPointsOfInterest = false;
	};

	type AutoSuggestData = {
		id: string;
		title: string;
		address: { label: string };
		position: { lat: number; lng: number };
	}[];

	let autoSuggestData: AutoSuggestData = [];

	const fetchAutoSuggest = async () => {
		loadingAutoSuggestData = true;
		if (autoSuggestCancelTokenSource) {
			autoSuggestCancelTokenSource.cancel();
		}
		autoSuggestCancelTokenSource = axios.CancelToken.source();
		const cancelToken = autoSuggestCancelTokenSource.token;
		const mapCenter = map.getCenter();

		const params = new URLSearchParams({
			q: searchQuery,
			at: `${mapCenter.lat},${mapCenter.lng}`,
			limit: AUTOSUGGEST_RESPONSE_LIMIT.toString(),
			lang: 'en',
			apiKey: PUBLIC_HERE_API_KEY
		});

		const request = await axios
			.get(`https://autosuggest.search.hereapi.com/v1/autosuggest?${params.toString()}`, {
				cancelToken
			})
			.catch((error) => error);

		if (request?.data?.items) {
			const data = request.data.items;
			autoSuggestData = data.filter(
				(item: any) =>
					item.id !== undefined &&
					item.title !== undefined &&
					item.address?.label !== undefined &&
					item.position !== undefined &&
					item.distance !== undefined
			);
		}
		loadingAutoSuggestData = false;
	};

	$: if (searchQuery?.trim()) {
		fetchMatchingPointsOfInterest();
		fetchAutoSuggest();
	}

	const handleSelectAutoSuggest = (itemId: string) => {
		const item = autoSuggestData.find(({ id }) => id === itemId);

		if (item) {
			const minZoomLevel = 14;
			const maxZoomLevel = 16;
			map.flyTo({
				center: { lat: item.position.lat, lng: item.position.lng },
				zoom: Math.min(maxZoomLevel, Math.max(minZoomLevel, map.getZoom())),
				padding: { top: 300 }
			});
		}

		open = false;
	};

	const handleSelectMatchingPOIs = (poiId: string) => {
		const poi = matchingPointsOfInterest.find(({ id }) => id === parseInt(poiId));

		if (poi) {
			const minZoomLevel = 14;
			const maxZoomLevel = 16;
			map.flyTo({
				center: poi.lngLat,
				zoom: Math.min(maxZoomLevel, Math.max(minZoomLevel, map.getZoom())),
				padding: { top: 300 }
			});
			dispatch('poiSelected', parseInt(poiId));
		}

		open = false;
	};

	const haversine = (
		firstCoords: {
			lng: number;
			lat: number;
		},
		secondCoords: {
			lng: number;
			lat: number;
		}
	) => {
		const R = 6371e3;
		const lat1 = (firstCoords.lat * Math.PI) / 180;
		const lat2 = (secondCoords.lat * Math.PI) / 180;
		const deltaLat = ((secondCoords.lat - firstCoords.lat) * Math.PI) / 180;
		const deltaLng = ((secondCoords.lng - firstCoords.lng) * Math.PI) / 180;

		const a =
			Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
			Math.cos(lat1) * Math.cos(lat2) * Math.sin(deltaLng / 2) * Math.sin(deltaLng / 2);
		const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

		const distance = R * c;
		return distance;
	};
</script>

<Button
	on:click={() => (open = true)}
	class="text-secondary-foreground w-full sm:max-w-md bg-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input hover:bg-accent hover:text-accent-foreground"
>
	<div class="flex gap-2 items-center">
		<Search />
		<p class="text-sm">Search By Name Or Location…</p>
	</div>
</Button>
<Command.Dialog bind:open shouldFilter={false} loop>
	<Command.Input placeholder={'Search by POI name or location…'} bind:value={searchQuery} />
	<Command.List class="my-2">
		{#if loading}
			<Command.Loading>
				<div class="h-[300px] w-full flex items-center justify-center">
					<span class="loading loading-ring loading-lg" />
				</div>
			</Command.Loading>
		{:else if autoSuggestData.length === 0 && matchingPointsOfInterest.length === 0}
			<Command.Empty class="h-[300px] flex items-center justify-center"
				>No results found.</Command.Empty
			>
		{:else if matchingPointsOfInterest.length === 0}
			<p class="px-4 py-2 font-medium leading-none">Locations</p>
			<Command.Group>
				{#each autoSuggestData as item (item.id)}
					<Command.Item value={item.id} onSelect={handleSelectAutoSuggest} class="cursor-pointer">
						<div class="flex flex-col w-full gap-0.5">
							<div class="flex justify-between gap-4">
								<p>{item.title}</p>
								<p class="text-sm text-muted-foreground">
									{Math.round(haversine(item.position, map.getCenter()) / 100) / 10}&nbsp;Km
								</p>
							</div>
							{#if item.address.label !== item.title}
								<p class="text-xs text-muted-foreground">
									{item.address.label}
								</p>
							{/if}
						</div>
					</Command.Item>
				{/each}
			</Command.Group>
			<div class="flex w-full justify-end p-2">
				<p class="text-xs font-light leading-none">
					Note: Distances are relative to current map center.
				</p>
			</div>
		{:else if autoSuggestData.length === 0}
			<p class="px-4 py-2 font-medium leading-none">Points Of Interest</p>
			<Command.Group>
				{#each matchingPointsOfInterest as poi (poi.id)}
					<Command.Item
						value={poi.id.toString()}
						onSelect={handleSelectMatchingPOIs}
						class="cursor-pointer"
					>
						<div class="flex flex-col w-full gap-2">
							<div class="flex justify-between gap-4">
								<p>{poi.name}</p>
								<p class="text-sm text-muted-foreground">
									{Math.round(haversine(poi.lngLat, map.getCenter()) / 100) / 10}&nbsp;Km
								</p>
							</div>
							<div class="flex justify-between gap-2">
								<div class="flex">
									<p class="text-xs text-muted-foreground">
										Features:&nbsp;{poi.features.join(', ')}
									</p>
								</div>
								<div class="flex gap-4">
									{#if poi.isFavourite}
										<div class="flex gap-2">
											<Heart class="h-3 w-3 text-primary" />
										</div>
									{/if}
									<div class="flex gap-2">
										<ThumbsUp class="h-3 w-3" />
										<p class="text-muted-foreground">{poi.likes}</p>
									</div>
									<div class="flex gap-2">
										<MessageCircleMore class="h-3 w-3" />
										<p class="text-muted-foreground">{poi.comments.length}</p>
									</div>
								</div>
							</div>
						</div>
					</Command.Item>
				{/each}
			</Command.Group>
			<div class="flex w-full justify-end p-2">
				<p class="text-xs font-light leading-none">
					Note: Distances are relative to current map center.
				</p>
			</div>
		{:else}
			<p class="px-4 py-2 font-medium leading-none">Points Of Interest</p>
			<Command.Group>
				{#each matchingPointsOfInterest as poi (poi.id)}
					<Command.Item
						value={poi.id.toString()}
						onSelect={handleSelectMatchingPOIs}
						class="cursor-pointer"
					>
						<div class="flex flex-col w-full gap-2">
							<div class="flex justify-between gap-4">
								<p>{poi.name}</p>
								<p class="text-sm text-muted-foreground">
									{Math.round(haversine(poi.lngLat, map.getCenter()) / 100) / 10}&nbsp;Km
								</p>
							</div>
							<div class="flex justify-between gap-2">
								<div class="flex">
									<p class="text-xs text-muted-foreground">
										Features:&nbsp;{poi.features.join(', ')}
									</p>
								</div>
								<div class="flex gap-4">
									{#if poi.isFavourite}
										<div class="flex gap-2">
											<Heart class="h-3 w-3 text-primary" />
										</div>
									{/if}
									<div class="flex gap-2">
										<ThumbsUp class="h-3 w-3" />
										<p class="text-muted-foreground">{poi.likes}</p>
									</div>
									<div class="flex gap-2">
										<MessageCircleMore class="h-3 w-3" />
										<p class="text-muted-foreground">{poi.comments.length}</p>
									</div>
								</div>
							</div>
						</div>
					</Command.Item>
				{/each}
			</Command.Group>
			<div class="divider my-0 mx-4" />
			<p class="px-4 py-2 font-medium leading-none">Locations</p>
			<Command.Group>
				{#each autoSuggestData as item (item.id)}
					<Command.Item value={item.id} onSelect={handleSelectAutoSuggest} class="cursor-pointer">
						<div class="flex flex-col w-full gap-0.5">
							<div class="flex justify-between gap-4">
								<p>{item.title}</p>
								<p class="text-sm text-muted-foreground">
									{Math.round(haversine(item.position, map.getCenter()) / 100) / 10}&nbsp;Km
								</p>
							</div>
							{#if item.address.label !== item.title}
								<p class="text-xs text-muted-foreground">
									{item.address.label}
								</p>
							{/if}
						</div>
					</Command.Item>
				{/each}
			</Command.Group>
			<div class="flex w-full justify-end p-2">
				<p class="text-xs font-light leading-none">
					Note: Distances are relative to current map center.
				</p>
			</div>
		{/if}
	</Command.List>
</Command.Dialog>
