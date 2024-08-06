<script lang="ts">
	import LogoutButton from '$lib/components/LogoutButton.svelte';

	export let menuClosed: boolean;
</script>

<div class="navbar bg-base-100 justify-between relative">
	<div class="px-1 md:hidden">
		<button class="btn-ghost btn-square btn flex-col" on:click={() => (menuClosed = !menuClosed)}>
			<div
				class="h-1 w-7 rounded bg-base-content transition-all"
				class:w-0={!menuClosed}
				class:opacity-0={!menuClosed}
				class:opacity-100={menuClosed}
			/>
			<div class="relative">
				<div
					class="absolute h-1 w-7 -translate-x-1/2 -translate-y-1/2 rounded bg-base-content transition-all"
					class:rotate-45={!menuClosed}
				/>
				<div
					class="absolute h-1 w-7 -translate-x-1/2 -translate-y-1/2 rounded bg-base-content transition-all"
					class:-rotate-45={!menuClosed}
				/>
			</div>
			<div
				class="h-1 w-7 rounded bg-base-content transition-all"
				class:w-0={!menuClosed}
				class:opacity-0={!menuClosed}
				class:opacity-100={menuClosed}
			/>
		</button>
	</div>
	<h1 class="select-none px-4 hidden md:block">Admin Dashboard</h1>
	<h1 class="select-none md:hidden absolute left-1/2 -translate-x-1/2">Admin Dashboard</h1>
	<LogoutButton />
</div>
