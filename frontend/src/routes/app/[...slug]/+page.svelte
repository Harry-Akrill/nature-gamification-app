<script lang="ts">
	import Header from '$lib/components/app/header/Header.svelte';
	import SideMenu from '$lib/components/app/sidemenu/SideMenu.svelte';
	import AppUrls from '$lib/enums/AppUrls';
	import Home from '$lib/components/app/main/home/Home.svelte';
	import SocialNetwork from '$lib/components/app/main/social-network/SocialNetwork.svelte';
	import PointsBadges from '$lib/components/app/main/points-badges/PointsBadges.svelte';
	import CheckIns from '$lib/components/app/main/check-ins/CheckIns.svelte';
	import Favourites from '$lib/components/app/main/favourites/Favourites.svelte';
	import Settings from '$lib/components/app/main/settings/Settings.svelte';
	import { onMount } from 'svelte';
	import type { SvelteComponent } from 'svelte';
	import { goto } from '$app/navigation';

	export let data: { slug: string };
	let menuClosed = true;
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	let mainComponent: (new (...args: any[]) => SvelteComponent) | null = null;
	let pageTitle = '';

	$: {
		switch (data.slug.split('/')[0]) {
			case AppUrls.HOME:
				mainComponent = Home;
				pageTitle = 'Home';
				break;
			case AppUrls.SOCIAL_NETWORK:
				mainComponent = SocialNetwork;
				pageTitle = 'Social Network';
				break;
			case AppUrls.POINTS_AND_BADGES:
				mainComponent = PointsBadges;
				pageTitle = 'Points & Badges';
				break;
			case AppUrls.CHECK_INS:
				mainComponent = CheckIns;
				pageTitle = 'Check-ins';
				break;
			case AppUrls.FAVOURITES:
				mainComponent = Favourites;
				pageTitle = 'Favourites';
				break;
			case AppUrls.SETTINGS:
				mainComponent = Settings;
				pageTitle = 'Settings';
				break;
			default:
				goto('/app');
				break;
		}
	}

	let headerHeight = 64;

	const updateLayoutOffsets = () => {
		const header = document.getElementById('app-header');
		const height = header?.offsetHeight;
		if (height !== undefined) {
			headerHeight = height;
		}
	};

	onMount(updateLayoutOffsets);
</script>

<svelte:head>
	<title>{pageTitle}</title>
</svelte:head>

<svelte:window on:resize={updateLayoutOffsets} />

<Header bind:menuClosed />
<div class="relative flex" style={`height: calc(100% - ${headerHeight}px);`}>
	<div class="overflow-y-auto shrink-0">
		<SideMenu bind:menuClosed slug={data.slug} />
	</div>
	<!-- svelte-ignore a11y-no-static-element-interactions -->
	<!-- svelte-ignore a11y-click-events-have-key-events -->
	<div
		class="relative flex flex-col grow bg-base-300 md:brightness-100 overflow-x-hidden"
		class:brightness-50={!menuClosed}
		on:click={() => (menuClosed = true)}
	>
		<svelte:component this={mainComponent} slug={data.slug} />
		{#if !menuClosed}
			<div class="absolute w-full h-full md:hidden backdrop-blur" />
		{/if}
	</div>
</div>
