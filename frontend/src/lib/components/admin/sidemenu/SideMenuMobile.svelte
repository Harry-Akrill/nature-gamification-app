<script lang="ts">
	import SideMenuInner from './SideMenuInner.svelte';

	export let menuClosed: boolean;
	export let slug: string | undefined;
</script>

<div
	class="absolute left-0 z-20 flex h-full w-64 flex-col bg-base-100 transition-all md:hidden shrink-0"
	class:menuClosed
>
	<SideMenuInner on:sideMenuItemClicked {slug} />
</div>

<style>
	.menuClosed {
		transform: translate(-100%, 0);
	}
</style>
