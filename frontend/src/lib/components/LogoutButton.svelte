<script lang="ts">
	import { logOut } from '$lib/auth';
	import { authenticated } from '$lib/stores';
	import { Button, buttonVariants } from '$lib/components/ui/button';
	import type { VariantProps } from 'tailwind-variants';

	type Variant = VariantProps<typeof buttonVariants>['variant'];
	type Size = VariantProps<typeof buttonVariants>['size'];

	export let variant: Variant = undefined;
	export let size: Size = undefined;

	const handleLogout = async () => {
		const logoutSuccessful = await logOut();
		logoutSuccessful && authenticated.verify();
	};
</script>

<Button {variant} {size} on:click={handleLogout} data-testid="logout-button">Log out</Button>
