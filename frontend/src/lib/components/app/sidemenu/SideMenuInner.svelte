<script lang="ts">
	import AppUrls from '$lib/enums/AppUrls';
	import { createEventDispatcher } from 'svelte';
	import { Map, Settings2, Heart, Check, Shield, UsersRound } from 'lucide-svelte';
	import { Button } from '$lib/components/ui/button';
	import LogoutButton from '$lib/components/LogoutButton.svelte';

	export let slug: string | undefined;

	const dispatch = createEventDispatcher();
</script>

<ul class="menu menu-lg p-4 min-h-full text-base-content flex-nowrap" role="tablist">
	<li role="tab">
		<Button
			variant={!slug ? 'secondary' : 'outline'}
			href={`/app${AppUrls.HOME ? '/' + AppUrls.HOME : ''}`}
			data-testid="home-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			class="flex items-center text-sm justify-start"><Map class="h-5 w-5 mr-2" />Home</Button
		>
	</li>
	<div class="my-1" />
	<li role="tab">
		<Button
			variant={slug?.split('/')[0] === AppUrls.SOCIAL_NETWORK ? 'secondary' : 'outline'}
			href={`/app${AppUrls.SOCIAL_NETWORK ? '/' + AppUrls.SOCIAL_NETWORK : ''}`}
			data-testid="social-network-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			class="flex items-center text-sm justify-start"
			><UsersRound class="h-5 w-5 mr-2" />Social Network</Button
		>
	</li>
	<div class="my-1" />
	<li role="tab">
		<Button
			variant={slug?.split('/')[0] === AppUrls.POINTS_AND_BADGES ? 'secondary' : 'outline'}
			href={`/app${AppUrls.POINTS_AND_BADGES ? '/' + AppUrls.POINTS_AND_BADGES : ''}`}
			data-testid="points-and-badges-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			class="flex items-center text-sm justify-start"
			><Shield class="h-5 w-5 mr-2" />Points & Badges</Button
		>
	</li>
	<div class="my-1" />
	<li role="tab">
		<Button
			variant={slug?.split('/')[0] === AppUrls.CHECK_INS ? 'secondary' : 'outline'}
			href={`/app${AppUrls.CHECK_INS ? '/' + AppUrls.CHECK_INS : ''}`}
			data-testid="checked-in-pois-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			class="flex items-center text-sm justify-start"
			><Check class="h-5 w-5 mr-2" />Checked-in POIs</Button
		>
	</li>
	<div class="my-1" />
	<li role="tab">
		<Button
			variant={slug?.split('/')[0] === AppUrls.FAVOURITES ? 'secondary' : 'outline'}
			href={`/app${AppUrls.FAVOURITES ? '/' + AppUrls.FAVOURITES : ''}`}
			data-testid="favourite-pois-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			class="flex items-center text-sm justify-start"
			><Heart class="h-5 w-5 mr-2" />Favourite POIs</Button
		>
	</li>
	<div class="my-1" />
	<li role="tab">
		<Button
			variant={slug?.split('/')[0] === AppUrls.SETTINGS ? 'secondary' : 'outline'}
			href={`/app${AppUrls.SETTINGS ? '/' + AppUrls.SETTINGS : ''}`}
			data-testid="settings-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			class="flex items-center text-sm justify-start"
			><Settings2 class="h-5 w-5 mr-2" />Profile Settings</Button
		>
	</li>
	<div class="grow" />
	<div class="my-2" />
	<li role="tab">
		<LogoutButton variant="secondary" />
	</li>
</ul>
