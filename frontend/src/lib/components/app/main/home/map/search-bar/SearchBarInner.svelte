<script lang="ts">
	import { Toggle } from '$lib/components/ui/toggle';
	import { Heart, FilterX } from 'lucide-svelte';
	import FacetedPoiFilter from '$lib/components/app/main/home/map/search-bar/faceted-poi-filter/FacetedPOIFilter.svelte';
	import type layers from '$lib/components/app/main/home/map/search-bar/layers';
	import LayerToggle from '$lib/components/app/main/home/map/search-bar/LayerToggle.svelte';
	import SearchField from '$lib/components/app/main/home/map/search-bar/search-field/SearchField.svelte';
	import * as HoverCard from '$lib/components/ui/hover-card';
	import type { Map } from 'maplibre-gl';

	export let selectedMapLayer: (typeof layers)[0];
	export let poiFeatureOptions: string[];
	export let poiFeaturesFilter: string[];
	export let onlyShowFavourites: boolean;
	export let map: Map;

	let hoverCardsOpened = [false, false, false, false, false];
	let facetedPoiFilterForceClosePopover: () => void;
	let layerToggleForceClosePopover: () => void;

	const closeAllHoverCards = () => {
		hoverCardsOpened = new Array(hoverCardsOpened.length).fill(false);
	};
</script>

<div class="flex gap-2 max-sm:flex-col w-full sm:overflow-x-auto">
	<HoverCard.Root
		bind:open={hoverCardsOpened[0]}
		openDelay={0}
		closeDelay={0}
		onOutsideClick={(e) => {
			closeAllHoverCards();
			facetedPoiFilterForceClosePopover();
			layerToggleForceClosePopover();
			e.target.focus();
		}}
	>
		<HoverCard.Trigger class="w-full sm:max-w-md">
			<SearchField {map} on:poiSelected />
		</HoverCard.Trigger>
		<HoverCard.Content class="w-fit h-fit py-2 px-2.5">
			<div class="text-xs flex items-center">Search By POI Name Or Location</div>
		</HoverCard.Content>
	</HoverCard.Root>
	<div class="flex justify-between gap-2 grow max-sm:w-full max-sm:overflow-x-auto">
		<div class="flex gap-2">
			<HoverCard.Root
				bind:open={hoverCardsOpened[1]}
				openDelay={0}
				closeDelay={0}
				onOutsideClick={(e) => {
					closeAllHoverCards();
					layerToggleForceClosePopover();
					e.target.focus();
				}}
			>
				<HoverCard.Trigger>
					<FacetedPoiFilter
						title="POI Features"
						bind:filterValues={poiFeaturesFilter}
						{poiFeatureOptions}
						bind:forceClosePopover={facetedPoiFilterForceClosePopover}
					/>
				</HoverCard.Trigger>
				<HoverCard.Content class="w-fit h-fit py-2 px-2.5">
					<div class="text-xs flex items-center">Filter By POI Features</div>
				</HoverCard.Content>
			</HoverCard.Root>
			{#if poiFeaturesFilter.length > 0}
				<HoverCard.Root
					bind:open={hoverCardsOpened[2]}
					openDelay={0}
					closeDelay={0}
					onOutsideClick={(e) => {
						closeAllHoverCards();
						facetedPoiFilterForceClosePopover();
						layerToggleForceClosePopover();
						e.target.focus();
					}}
				>
					<HoverCard.Trigger>
						<Toggle
							class="bg-background"
							onPressedChange={(pressed) => {
								if (pressed) poiFeaturesFilter = [];
							}}><FilterX /></Toggle
						>
					</HoverCard.Trigger>
					<HoverCard.Content class="w-fit h-fit py-2 px-2.5">
						<div class="text-xs flex items-center">Clear POI Features Filter</div>
					</HoverCard.Content>
				</HoverCard.Root>
			{/if}
			<HoverCard.Root
				bind:open={hoverCardsOpened[3]}
				openDelay={0}
				closeDelay={0}
				onOutsideClick={(e) => {
					closeAllHoverCards();
					facetedPoiFilterForceClosePopover();
					layerToggleForceClosePopover();
					e.target.focus();
				}}
			>
				<HoverCard.Trigger>
					<Toggle
						aria-label="Show Favourites Only"
						class="text-secondary-foreground hover:text-accent-foreground data-[state=off]:hover:bg-accent data-[state=off]:bg-background data-[state=on]:bg-primary data-[state=on]:hover:brightness-90 data-[state=on]:text-error-content"
						bind:pressed={onlyShowFavourites}><Heart /></Toggle
					>
				</HoverCard.Trigger>
				<HoverCard.Content class="w-fit h-fit py-2 px-2.5">
					<div class="text-xs flex items-center">Show Favourites Only</div>
				</HoverCard.Content>
			</HoverCard.Root>
		</div>
		<HoverCard.Root
			bind:open={hoverCardsOpened[4]}
			openDelay={0}
			closeDelay={0}
			onOutsideClick={(e) => {
				closeAllHoverCards();
				facetedPoiFilterForceClosePopover();
				e.target.focus();
			}}
		>
			<HoverCard.Trigger>
				<LayerToggle bind:selectedMapLayer bind:forceClosePopover={layerToggleForceClosePopover} />
			</HoverCard.Trigger>
			<HoverCard.Content class="w-fit h-fit py-2 px-2.5">
				<div class="text-xs flex items-center">Change Map Layer</div>
			</HoverCard.Content>
		</HoverCard.Root>
	</div>
</div>
