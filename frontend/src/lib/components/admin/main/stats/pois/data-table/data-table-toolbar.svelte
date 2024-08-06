<script lang="ts">
	import { Input } from '$lib/components/new-york/ui/input';
	import { DataTableViewOptions } from '.';
	import type { POIViewCount } from '../POIs.svelte';
	import type { TableViewModel } from 'svelte-headless-table';
	import Button from '$lib/components/new-york/ui/button/button.svelte';
	import { Cross2 } from 'radix-icons-svelte';
	import type { Writable } from 'svelte/store';

	export let tableModel: TableViewModel<POIViewCount>;

	const { pluginStates } = tableModel;

	const {
		filterValue
	}: {
		filterValue: Writable<string>;
	} = pluginStates.filter;

	$: showReset = $filterValue.length > 0;
</script>

<div class="flex items-center gap-2 flex-wrap">
	<Input
		placeholder="Filter..."
		class="h-8 sm:w-[250px] lg:w-[350px] grow sm:grow-0 lg:grow-0 md:grow hover:bg-accent hover:text-accent-foreground bg-background focus-visible:m-0.5"
		type="search"
		bind:value={$filterValue}
	/>
	{#if showReset}
		<Button on:click={() => ($filterValue = '')} variant="outline" class="h-8 px-2 lg:px-3">
			<Cross2 class="h-4 w-4" />
		</Button>
	{/if}
	<div
		class="flex flex-1 sm:items-center grow justify-end gap-2 flex-col sm:flex-row relative overflow-x-auto sm:overflow-x-visible"
	>
		<DataTableViewOptions {tableModel} />
	</div>
</div>
