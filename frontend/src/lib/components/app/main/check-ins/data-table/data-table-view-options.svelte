<script lang="ts">
	import { MixerHorizontal } from 'radix-icons-svelte';
	import { Button } from '$lib/components/new-york/ui/button';
	import * as DropdownMenu from '$lib/components/new-york/ui/dropdown-menu';
	import type { POI } from '../../home/map/Map.svelte';
	import type { TableViewModel } from 'svelte-headless-table';

	export let tableModel: TableViewModel<POI>;
	const { pluginStates, flatColumns } = tableModel;
	const { hiddenColumnIds } = pluginStates.hide;

	const ids = flatColumns.map((col: { id: string }) => col.id);

	let hideForId = Object.fromEntries(ids.map((id: string) => [id, true]));

	$: $hiddenColumnIds = Object.entries(hideForId)
		.filter(([, hide]) => !hide)
		.map(([id]) => id);

	const hidableCols = ['name', 'features'];
</script>

<DropdownMenu.Root>
	<DropdownMenu.Trigger asChild let:builder>
		<Button
			variant="outline"
			size="sm"
			class="h-8 flex hover:bg-accent hover:text-accent-foreground bg-background"
			builders={[builder]}
		>
			<MixerHorizontal class="mr-2 h-4 w-4" />
			View
		</Button>
	</DropdownMenu.Trigger>
	<DropdownMenu.Content>
		<DropdownMenu.Label>Toggle columns</DropdownMenu.Label>
		<DropdownMenu.Separator />
		{#each flatColumns as col}
			{#if hidableCols.includes(col.id)}
				<DropdownMenu.CheckboxItem bind:checked={hideForId[col.id]}>
					{col.header}
				</DropdownMenu.CheckboxItem>
			{/if}
		{/each}
	</DropdownMenu.Content>
</DropdownMenu.Root>
