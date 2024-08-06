<script lang="ts">
	import { onMount } from 'svelte';
	import ProfileSettings from '$lib/components/app/main/settings/ProfileSettings.svelte';
	import * as Card from '$lib/components/ui/card';
	import { Separator } from '$lib/components/ui/separator';

	let cardHeader: HTMLDivElement;
	let cardHeaderHeight = 64;

	const updateLayoutOffsets = () => {
		const height = cardHeader.offsetHeight;
		if (height !== undefined) {
			cardHeaderHeight = height;
		}
	};

	onMount(updateLayoutOffsets);
</script>

<svelte:window on:resize={updateLayoutOffsets} />

<div class="flex grow flex-col relative h-full">
	<div class="flex flex-col p-4 relative h-full">
		<Card.Root class="relative p-4 h-full">
			<div bind:this={cardHeader}>
				<Card.Header class="p-0 pb-4 space-y-0">
					<Card.Title tag="h2" class="mb-3">Profile Settings</Card.Title>
					<Separator />
				</Card.Header>
			</div>
			<Card.Content
				class="flex flex-col overflow-y-auto p-0"
				style={`height: calc(100% - ${cardHeaderHeight}px);`}
			>
				<ProfileSettings />
			</Card.Content>
		</Card.Root>
	</div>
</div>
