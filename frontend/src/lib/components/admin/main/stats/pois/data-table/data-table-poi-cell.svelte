<script lang="ts">
	import * as HoverCard from '$lib/components/ui/hover-card';
	import type { POI } from '../POIs.svelte';
	import * as Popover from '$lib/components/ui/popover';
	import { Button } from '$lib/components/ui/button';
	import { Info } from 'lucide-svelte';
	import { Separator } from '$lib/components/ui/separator';

	export let value: POI;
</script>

<div class="flex space-x-2">
	<HoverCard.Root>
		<HoverCard.Trigger>
			<span
				class="inline-block lg:max-w-[200px] sm:max-w-[160px] max-w-[80px] truncate font-medium cursor-default"
			>
				<Popover.Root portal={null}>
					<Popover.Trigger asChild let:builder>
						<Button
							aria-label="View POI Information"
							builders={[builder]}
							variant="outline"
							size="icon"><Info class="h-5 w-5" /></Button
						>
					</Popover.Trigger>
					<Popover.Content class="w-80 relative overflow-x-auto">
						<div class="flex flex-col gap-2">
							<div class="flex justify-between gap-4 shrink-0 self-end items-center w-full">
								<h4 class="text-sm font-semibold">POI Information</h4>
								<Info className="h-4 w-4" />
							</div>
							<Separator />
							<div class="space-y-1">
								<p class="text-sm text-wrap">ID: {value.id}</p>
								<p class="text-sm text-wrap">Name: {value.name}</p>
								<p class="text-sm text-wrap">Description: {value.description}</p>
								<p class="text-sm text-wrap">Features: {value.features.join(', ')}</p>
								<p class="text-sm text-wrap">Latitude: {value.latitude}</p>
								<p class="text-sm text-wrap">Longitude: {value.longitude}</p>
								<p class="text-sm text-wrap">Likes: {value.likes}</p>
								<p class="text-sm text-wrap">Location: {value.location}</p>
							</div>
						</div>
					</Popover.Content>
				</Popover.Root>
			</span>
		</HoverCard.Trigger>
		<HoverCard.Content class="w-fit h-fit py-2 px-2.5">
			<div class="text-xs flex items-center">View POI Information</div>
		</HoverCard.Content>
	</HoverCard.Root>
</div>
