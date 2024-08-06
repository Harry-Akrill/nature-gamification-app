<script lang="ts">
	import * as Card from '$lib/components/ui/card';
	import { ShieldHalf } from 'lucide-svelte';
	import Badges from '$lib/enums/Badges';
	import type { BadgeCount } from '../PointsBadges.svelte';

	export let badgeItem: BadgeCount;

	let badgeIconError = false;
</script>

<Card.Root class="grow min-w-32 shrink-0">
	<Card.Header class="p-2">
		<Card.Title class="text-base"
			>{badgeItem.count} User{badgeItem.count === 1 ? '' : 's'}</Card.Title
		>
		<Card.Description>
			<div class="flex flex-col space-y-1 items-center self-stretch">
				<p class="text-sm font-medium leading-none">{badgeItem.badge}</p>
				<div class="shrink-0">
					{#if !badgeIconError}
						<img
							src={Badges[badgeItem.badge]}
							class="h-14 w-14 -ml-0.5"
							alt="Badge Icon"
							on:error={() => (badgeIconError = true)}
						/>
					{:else}
						<ShieldHalf class="h-14 w-14 -ml-0.5" />
					{/if}
				</div>
				<p class="text-xs">{badgeItem.threshold} Total Reviews</p>
			</div>
		</Card.Description>
	</Card.Header>
</Card.Root>
