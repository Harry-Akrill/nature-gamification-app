<script lang="ts">
	import * as Card from '$lib/components/ui/card';
	import type { BadgeStatus } from '../PointsBadges.svelte';
	import { ShieldHalf } from 'lucide-svelte';
	import Badges from '$lib/enums/Badges';

	export let badgeStatus: BadgeStatus;
	export let appendix: string;

	let badgeIconError = false;
</script>

<Card.Root>
	<Card.Header class="p-2">
		<Card.Description>
			<div class="flex flex-col space-y-1 items-center self-stretch">
				<p class="text-sm font-medium leading-none">{badgeStatus.badge}</p>
				<div class="shrink-0">
					{#if !badgeIconError}
						<img
							src={Badges[badgeStatus.badge]}
							class="h-14 w-14 -ml-0.5"
							alt="Badge Icon"
							on:error={() => (badgeIconError = true)}
						/>
					{:else}
						<ShieldHalf class="h-14 w-14 -ml-0.5" />
					{/if}
				</div>
				<p class="text-xs">{badgeStatus.threshold} {appendix}</p>
			</div>
		</Card.Description>
	</Card.Header>
</Card.Root>
