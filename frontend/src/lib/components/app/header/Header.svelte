<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import AvatarDropdown from './AvatarDropdown.svelte';

	export let menuClosed: boolean;
</script>

<header
	id="app-header"
	class="p-2 flex items-center justify-between sticky top-0 z-50 w-full border-b border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60"
>
	<div class="px-1 md:hidden">
		<Button
			variant="outline"
			size="none"
			class="flex-col btn btn-square p-0"
			on:click={() => (menuClosed = !menuClosed)}
		>
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
		</Button>
	</div>
	<h1 class="select-none px-4 hidden md:block">Natreon&#8482;</h1>
	<h1 class="select-none md:hidden absolute left-1/2 -translate-x-1/2">Natreon&#8482;</h1>
	<AvatarDropdown />
</header>
