<script lang="ts">
	import { Toaster as Sonner, type ToasterProps as SonnerProps } from 'svelte-sonner';
	import { mode } from 'mode-watcher';

	type $$Props = SonnerProps;
</script>

<Sonner
	theme={$mode}
	class="toaster group"
	toastOptions={{
		classes: {
			toast:
				'm-2 group toast group-[.toaster]:bg-background group-[.toaster]:text-foreground group-[.toaster]:border-border group-[.toaster]:shadow-lg',
			description: 'group-[.toast]:text-muted-foreground',
			// actionButton: 'group-[.toast]:bg-primary group-[.toast]:text-primary-foreground',
			actionButton: 'bg-primary text-primary-foreground',
			// cancelButton: 'group-[.toast]:bg-muted group-[.toast]:text-muted-foreground',
			cancelButton: 'bg-muted text-muted-foreground'
		}
	}}
	{...$$restProps}
/>

<style>
	@media (max-width: 600px) {
		:global([data-sonner-toaster]) {
			--mobile-offset: 0.5rem !important;
		}
	}
</style>
