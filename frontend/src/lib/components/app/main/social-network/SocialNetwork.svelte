<script lang="ts">
	import { onMount, type SvelteComponent } from 'svelte';
	import Feed from '$lib/components/app/main/social-network/feed/Feed.svelte';
	import Connections from '$lib/components/app/main/social-network/connections/Connections.svelte';
	import AppUrls from '$lib/enums/AppUrls';
	import { UserRoundSearch, MessagesSquare } from 'lucide-svelte';
	import * as Card from '$lib/components/ui/card';
	import { Separator } from '$lib/components/ui/separator';
	import { goto } from '$app/navigation';

	export let slug: string;

	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	let socialNetworkComponent: (new (...args: any[]) => SvelteComponent) | null = null;
	let pageTitle = '';

	$: {
		switch (slug) {
			case AppUrls.SOCIAL_NETWORK_FEED:
				socialNetworkComponent = Feed;
				pageTitle = 'Feed';
				break;
			case AppUrls.SOCIAL_NETWORK_CONNECTIONS:
				socialNetworkComponent = Connections;
				pageTitle = 'Connections';
				break;
			default:
				goto('/app/' + AppUrls.SOCIAL_NETWORK_FEED);
				break;
		}
	}

	let bottomNav: HTMLDivElement;
	let bottomNavHeight = 64;
	let cardHeader: HTMLDivElement;
	let cardHeaderHeight = 64;

	const updateLayoutOffsets = () => {
		let height = bottomNav.offsetHeight;
		if (height !== undefined) {
			bottomNavHeight = height;
		}

		height = cardHeader.offsetHeight;
		if (height !== undefined) {
			cardHeaderHeight = height;
		}
	};

	onMount(updateLayoutOffsets);
</script>

<svelte:head>
	<title>{pageTitle} - Social Network</title>
</svelte:head>

<svelte:window on:resize={updateLayoutOffsets} />

<div class="flex grow flex-col relative h-full">
	<div class="flex flex-col p-4 relative" style={`height: calc(100% - ${bottomNavHeight}px);`}>
		<Card.Root class="relative p-4 h-full">
			<div bind:this={cardHeader}>
				<Card.Header class="p-0 pb-4 space-y-0">
					<Card.Title tag="h2" class="mb-3">{pageTitle}</Card.Title>
					<Separator />
				</Card.Header>
			</div>
			<Card.Content
				class="flex flex-col overflow-y-auto p-0"
				style={`height: calc(100% - ${cardHeaderHeight}px);`}
			>
				<svelte:component this={socialNetworkComponent} />
			</Card.Content>
		</Card.Root>
	</div>
	<div class="btm-nav static max-sm:btm-nav-md" bind:this={bottomNav}>
		<a
			class={'text-primary transition-colors hover:bg-secondary/70 focus:bg-secondary/90' +
				(slug === AppUrls.SOCIAL_NETWORK_FEED ? ' bg-secondary/30' : '')}
			href={`/app/${AppUrls.SOCIAL_NETWORK_FEED}`}
			class:active={slug === AppUrls.SOCIAL_NETWORK_FEED}
			data-testid="social-network-feed-button"
		>
			<MessagesSquare class="h-5 w-5" />
			<span class="btm-nav-label text-neutral-content font-medium">Feed</span>
		</a>
		<a
			class={'text-primary transition-colors hover:bg-secondary/70 focus:bg-secondary/90' +
				(slug === AppUrls.SOCIAL_NETWORK_CONNECTIONS ? ' bg-secondary/30' : '')}
			href={`/app/${AppUrls.SOCIAL_NETWORK_CONNECTIONS}`}
			class:active={slug === AppUrls.SOCIAL_NETWORK_CONNECTIONS}
			data-testid="social-network-connections-button"
		>
			<UserRoundSearch class="h-5 w-5" />
			<span class="btm-nav-label text-neutral-content font-medium">Connections</span>
		</a>
	</div>
</div>
