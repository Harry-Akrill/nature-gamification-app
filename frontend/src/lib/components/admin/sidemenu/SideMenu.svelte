<script lang="ts">
	import SideMenuDesktop from '$lib/components/admin/sidemenu/SideMenuDesktop.svelte';
	import SideMenuMobile from '$lib/components/admin/sidemenu/SideMenuMobile.svelte';

	export let menuClosed: boolean;
	export let slug: string | undefined;

	const sideMenuItemClicked = () => (menuClosed = true);
</script>

<SideMenuDesktop on:sideMenuItemClicked={sideMenuItemClicked} {slug} />
<SideMenuMobile {menuClosed} on:sideMenuItemClicked={sideMenuItemClicked} {slug} />
