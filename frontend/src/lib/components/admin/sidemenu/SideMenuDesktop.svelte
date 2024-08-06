<script lang="ts">
	import SideMenuInner from './SideMenuInner.svelte';

	export let slug: string | undefined;
</script>

<div class="hidden w-64 flex-col bg-base-100 md:flex shrink-0 h-full">
	<SideMenuInner on:sideMenuItemClicked {slug} />
</div>
