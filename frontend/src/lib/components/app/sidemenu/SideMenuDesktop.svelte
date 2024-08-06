<script lang="ts">
	import SideMenuInner from './SideMenuInner.svelte';

	export let slug: string | undefined;
</script>

<div class="hidden w-64 h-full flex-col md:flex shrink-0">
	<SideMenuInner on:sideMenuItemClicked {slug} />
</div>
