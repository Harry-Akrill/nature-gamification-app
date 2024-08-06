<script lang="ts">
	import { Input } from '$lib/components/new-york/ui/input';
	import { DataTableFacetedFilter, DataTableViewOptions } from '.';
	import type { POI } from '../../home/map/Map.svelte';
	import type { TableViewModel } from 'svelte-headless-table';
	import Button from '$lib/components/new-york/ui/button/button.svelte';
	import { Cross2 } from 'radix-icons-svelte';
	import type { Writable } from 'svelte/store';
	import { onMount } from 'svelte';

	export let tableModel: TableViewModel<POI>;

	let poiFeatureOptions: string[];
	const poiFeatureOptionsRequest = async () => {
		try {
			const response = await fetch('/api/poi/features');
			const data = await response.json();
			poiFeatureOptions = data.allPOIFeatures;
		} catch (error) {
			console.error(error);
		}
	};

	onMount(poiFeatureOptionsRequest);

	const { pluginStates } = tableModel;

	const {
		filterValues
	}: {
		filterValues: Writable<{
			name: string;
			features: string[];
		}>;
	} = pluginStates.colFilter;

	$: showReset = Object.values({ ...$filterValues }).some(
		(v) => v.length > 0 || (typeof v === 'string' && v.length > 0)
	);
</script>

<div class="flex items-center gap-2 flex-wrap">
	<Input
		placeholder="Filter by name..."
		class="h-8 sm:w-[250px] lg:w-[350px] grow sm:grow-0 lg:grow-0 md:grow hover:bg-accent hover:text-accent-foreground bg-background focus-visible:m-0.5"
		type="search"
		bind:value={$filterValues.name}
	/>
	<div
		class="flex flex-1 sm:items-center grow justify-between gap-2 flex-col sm:flex-row relative overflow-x-auto sm:overflow-x-visible"
	>
		<div class="relative overflow-x-auto flex sm:overflow-x-visible">
			<div class="flex items-center gap-2 w-full">
				<DataTableFacetedFilter
					bind:filterValues={$filterValues.features}
					title="POI Features"
					options={poiFeatureOptions}
				/>
				{#if showReset}
					<Button
						on:click={() => {
							$filterValues.name = '';
							$filterValues.features = [];
						}}
						variant="outline"
						class="h-8 px-2 lg:px-3"
					>
						<Cross2 class="h-4 w-4" />
					</Button>
				{/if}
			</div>
		</div>
		<DataTableViewOptions {tableModel} />
	</div>
</div>
