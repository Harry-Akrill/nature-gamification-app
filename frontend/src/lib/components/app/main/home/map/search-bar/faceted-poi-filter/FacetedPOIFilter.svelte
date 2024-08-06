<script lang="ts">
	import { Check } from 'svelte-radix';
	import * as Command from '$lib/components/new-york/ui/command';
	import * as Popover from '$lib/components/new-york/ui/popover';
	import { Button } from '$lib/components/new-york/ui/button';
	import { cn } from '$lib/utils/ui';
	import { Separator } from '$lib/components/ui/separator';
	import { Badge } from '$lib/components/new-york/ui/badge';
	import { Glasses, Filter } from 'lucide-svelte';

	export let filterValues: string[] = [];
	export let title: string;
	export let poiFeatureOptions: string[];
	export let counts: { [index: string]: number } = {};

	let open = false;
	export const forceClosePopover: () => void = () => (open = false);

	function handleSelect(currentValue: string) {
		if (Array.isArray(filterValues) && filterValues.includes(currentValue)) {
			filterValues = filterValues.filter((v) => v !== currentValue);
		} else {
			filterValues = [...(Array.isArray(filterValues) ? filterValues : []), currentValue];
		}
	}
</script>

<Popover.Root bind:open disableFocusTrap={true} onOutsideClick={forceClosePopover}>
	<Popover.Trigger asChild let:builder>
		<Button
			builders={[builder]}
			variant="outline"
			class="h-10 bg-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input hover:bg-accent hover:text-accent-foreground"
		>
			<Filter class="mr-2 h-5 w-5" />
			<p class="text-sm">{title}</p>
			{#if filterValues.length > 0}
				<Separator orientation="vertical" class="mx-2 h-4" />
				<Badge variant="secondary" class="rounded-sm px-1 font-normal lg:hidden">
					{filterValues.length}
				</Badge>
				<div class="hidden space-x-1 lg:flex">
					{#if filterValues.length > 2}
						<Badge variant="secondary" class="rounded-sm px-1 font-normal">
							{filterValues.length} Selected
						</Badge>
					{:else}
						{#each filterValues as option}
							<Badge variant="secondary" class="rounded-sm px-1 font-normal">
								{option}
							</Badge>
						{/each}
					{/if}
				</div>
			{/if}
		</Button>
	</Popover.Trigger>
	<Popover.Content class="w-[200px] p-0" align="start" side="bottom">
		<Command.Root loop>
			<Command.Input placeholder={title} />
			<Command.List>
				<Command.Empty>No results found.</Command.Empty>
				<Command.Group>
					{#each poiFeatureOptions as option}
						<Command.Item
							class="cursor-pointer"
							value={option}
							onSelect={(currentValue) => {
								handleSelect(currentValue);
							}}
						>
							<div
								class={cn(
									'mr-2 flex h-4 w-4 items-center justify-center rounded-sm border border-primary',
									filterValues.includes(option)
										? 'bg-primary text-primary-foreground'
										: 'opacity-50 [&_svg]:invisible'
								)}
							>
								<Glasses className={cn('h-4 w-4')} />
							</div>
							<span>
								{option}
							</span>
							{#if counts[option]}
								<span class="ml-auto flex h-4 w-4 items-center justify-center font-mono text-xs">
									{counts[option]}
								</span>
							{/if}
						</Command.Item>
					{/each}
				</Command.Group>
				{#if filterValues.length > 0}
					<Command.Separator />
					<Command.Item
						class="justify-center text-center cursor-pointer"
						onSelect={() => {
							filterValues = [];
						}}
					>
						Clear Filter
					</Command.Item>
				{/if}
			</Command.List>
		</Command.Root>
	</Popover.Content>
</Popover.Root>
