<script lang="ts">
	import { Check, ChevronsUpDown, Layers as LayersIcon } from 'lucide-svelte';
	import { tick } from 'svelte';
	import * as Command from '$lib/components/ui/command/index.js';
	import * as Popover from '$lib/components/ui/popover/index.js';
	import { Button } from '$lib/components/ui/button/index.js';
	import { cn } from '$lib/utils/ui';
	import layers from '$lib/components/app/main/home/map/search-bar/layers';

	export let selectedMapLayer: (typeof layers)[0];
	let open = false;
	export const forceClosePopover: () => void = () => (open = false);
	let value = '';

	$: {
		if (layers.find((f) => f.value === value)) {
			selectedMapLayer = layers.find((f) => f.value === value)!;
		} else {
			value = selectedMapLayer.value;
		}
	}

	// We want to refocus the trigger button when the user selects
	// an item from the list so users can continue navigating the
	// rest of the form with the keyboard.
	function closeAndFocusTrigger(triggerId: string) {
		open = false;
		tick().then(() => {
			document.getElementById(triggerId)?.focus();
		});
	}
</script>

<Popover.Root bind:open let:ids disableFocusTrap={true} onOutsideClick={forceClosePopover}>
	<Popover.Trigger asChild let:builder>
		<Button
			builders={[builder]}
			variant="outline"
			role="combobox"
			aria-expanded={open}
			aria-label="Change Map Layer"
		>
			<div class="flex gap-2">
				<LayersIcon class="h-5 w-5" />
				<p class="max-lg:hidden text-sm">{selectedMapLayer.label}</p>
			</div>
			<ChevronsUpDown class="ml-2 h-4 w-4 shrink-0 opacity-50" />
		</Button>
	</Popover.Trigger>
	<Popover.Content class="w-[200px] p-0 mt-1" align="end">
		<Command.Root>
			<Command.Input placeholder="Search map layers…" />
			<Command.Empty>No map layer found.</Command.Empty>
			<Command.Group>
				{#each layers as layer}
					<Command.Item
						class="cursor-pointer"
						value={layer.value}
						onSelect={(currentValue) => {
							value = currentValue;
							localStorage.setItem('preferredMapLayer', currentValue);
							closeAndFocusTrigger(ids.trigger);
						}}
					>
						<Check class={cn('mr-2 h-4 w-4', value !== layer.value && 'text-transparent')} />
						{layer.label}
					</Command.Item>
				{/each}
			</Command.Group>
		</Command.Root>
	</Popover.Content>
</Popover.Root>
