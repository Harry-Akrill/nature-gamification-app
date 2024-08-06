<script lang="ts">
	import { DotsHorizontal } from 'radix-icons-svelte';
	import { Button } from '$lib/components/new-york/ui/button';
	import * as DropdownMenu from '$lib/components/new-york/ui/dropdown-menu';
	import type { POI } from '../../home/map/Map.svelte';

	export let rowId: number;
	export let removeFavourite: (id: number) => Promise<void>;
</script>

<DropdownMenu.Root>
	<DropdownMenu.Trigger asChild let:builder>
		<Button
			variant="ghost"
			builders={[builder]}
			class="flex h-8 w-8 p-0 data-[state=open]:bg-muted ml-auto hover:bg-accent hover:text-accent-foreground bg-background"
			on:click={(e) => e.stopPropagation()}
		>
			<DotsHorizontal class="h-4 w-4" />
			<span class="sr-only">Open menu</span>
		</Button>
	</DropdownMenu.Trigger>
	<DropdownMenu.Content class="w-[160px]" align="end">
		<Button variant="destructive" on:click={() => removeFavourite(rowId)}
			>Remove From Favourites</Button
		>
	</DropdownMenu.Content>
</DropdownMenu.Root>
