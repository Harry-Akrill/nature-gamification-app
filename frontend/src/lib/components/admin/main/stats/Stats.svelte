<script lang="ts">
	import { onMount, type SvelteComponent } from 'svelte';
	import Logins from '$lib/components/admin/main/stats/logins/Logins.svelte';
	import POIs from '$lib/components/admin/main/stats/pois/POIs.svelte';
	import PointsBadges from '$lib/components/admin/main/stats/points-badges/PointsBadges.svelte';
	import AdminDashboardUrls from '$lib/enums/AdminDashboardUrls';
	import { LogIn, MapPinned, Shield } from 'lucide-svelte';
	import * as Card from '$lib/components/ui/card';
	import { Separator } from '$lib/components/ui/separator';
	import { goto } from '$app/navigation';

	export let slug: string;

	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	let statisticsComponent: (new (...args: any[]) => SvelteComponent) | null = null;
	let pageTitle = '';

	$: {
		switch (slug) {
			case AdminDashboardUrls.STATS_LOGINS:
				statisticsComponent = Logins;
				pageTitle = 'Logins (App Visits)';
				break;
			case AdminDashboardUrls.STATS_POIS:
				statisticsComponent = POIs;
				pageTitle = 'Points Of Interest';
				break;
			case AdminDashboardUrls.STATS_POINTS_BADGES:
				statisticsComponent = PointsBadges;
				pageTitle = 'Points & Badges';
				break;
			default:
				goto('/admin/' + AdminDashboardUrls.STATS_LOGINS);
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
	<title>{pageTitle} - Statistics</title>
</svelte:head>

<svelte:window on:resize={updateLayoutOffsets} />

<div class="flex grow flex-col relative h-full w-full">
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
				<svelte:component this={statisticsComponent} {updateLayoutOffsets} />
			</Card.Content>
		</Card.Root>
	</div>
	<div class="btm-nav static max-sm:btm-nav-md" bind:this={bottomNav}>
		<a
			class={'text-primary transition-colors hover:bg-secondary/70 focus:bg-secondary/90' +
				(slug === AdminDashboardUrls.STATS_LOGINS ? ' bg-secondary/30' : '')}
			href={`/admin/${AdminDashboardUrls.STATS_LOGINS}`}
			class:active={slug === AdminDashboardUrls.STATS_LOGINS}
			data-testid="stats-logins-button"
		>
			<LogIn class="h-5 w-5" />
			<span class="btm-nav-label text-neutral-content font-medium">Logins</span>
		</a>
		<a
			class={'text-primary transition-colors hover:bg-secondary/70 focus:bg-secondary/90' +
				(slug === AdminDashboardUrls.STATS_POIS ? ' bg-secondary/30' : '')}
			href={`/admin/${AdminDashboardUrls.STATS_POIS}`}
			class:active={slug === AdminDashboardUrls.STATS_POIS}
			data-testid="stats-pois-button"
		>
			<MapPinned class="h-5 w-5" />
			<span class="btm-nav-label text-neutral-content font-medium">POIs</span>
		</a>
		<a
			class={'text-primary transition-colors hover:bg-secondary/70 focus:bg-secondary/90' +
				(slug === AdminDashboardUrls.STATS_POINTS_BADGES ? ' bg-secondary/30' : '')}
			href={`/admin/${AdminDashboardUrls.STATS_POINTS_BADGES}`}
			class:active={slug === AdminDashboardUrls.STATS_POINTS_BADGES}
			data-testid="stats-points-badges-button"
		>
			<Shield class="h-5 w-5" />
			<span class="btm-nav-label text-neutral-content font-medium">Points & Badges</span>
		</a>
	</div>
</div>
