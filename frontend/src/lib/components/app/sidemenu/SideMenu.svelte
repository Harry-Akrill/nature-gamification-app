<script lang="ts">
	import SideMenuDesktop from '$lib/components/app/sidemenu/SideMenuDesktop.svelte';
	import SideMenuMobile from '$lib/components/app/sidemenu/SideMenuMobile.svelte';

	export let menuClosed: boolean;
	export let slug: string | undefined;

	const sideMenuItemClicked = () => (menuClosed = true);
</script>

<SideMenuDesktop on:sideMenuItemClicked={sideMenuItemClicked} {slug} />
<SideMenuMobile {menuClosed} on:sideMenuItemClicked={sideMenuItemClicked} {slug} />
