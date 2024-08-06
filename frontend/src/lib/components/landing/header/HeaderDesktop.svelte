<script lang="ts">
	import { goto } from '$app/navigation';
	import Icon from '@iconify/svelte';
	import menuDownIcon from '@iconify-icons/mdi/menu-down';
</script>

<div class="navbar bg-base-100 justify-between hidden sm:flex fixed z-10">
	<h1 class="select-none px-4">Natreon&#8482;</h1>
	<ul class="menu menu-horizontal px-1 absolute left-1/2 -translate-x-1/2 flex-nowrap z-[1]">
		<li class="dropdown dropdown-hover">
			<!-- svelte-ignore a11y-label-has-associated-control -->
			<!-- svelte-ignore a11y-no-noninteractive-tabindex -->
			<label tabindex="0" class="mx-1 btn btn-sm btn-ghost px-4 py-2 flex items-center"
				><p>Home</p>
				<div class="scale">
					<Icon icon={menuDownIcon} height={12} />
				</div></label
			>
			<!-- svelte-ignore a11y-no-noninteractive-tabindex -->
			<ul tabindex="0" class="dropdown-content z-[1] menu p-2 shadow bg-base-100 rounded-box w-40">
				<li>
					<button
						on:click={async () => {
							await goto('/');
							const element = document.getElementById('home-desktop');
							element?.scrollIntoView({ behavior: 'smooth' });
						}}>Home</button
					>
				</li>
				<li>
					<button
						on:click={async () => {
							await goto('/');
							const element = document.getElementById('solution-desktop');
							element?.scrollIntoView({ behavior: 'smooth' });
						}}>Our Solution</button
					>
				</li>
				<li>
					<button
						on:click={async () => {
							await goto('/');
							const element = document.getElementById('features-desktop');
							element?.scrollIntoView({ behavior: 'smooth' });
						}}>Features</button
					>
				</li>
				<li>
					<button
						on:click={async () => {
							await goto('/');
							const element = document.getElementById('pricing-desktop');
							element?.scrollIntoView({ behavior: 'smooth' });
						}}>Pricing</button
					>
				</li>
				<li>
					<button
						on:click={async () => {
							await goto('/');
							const element = document.getElementById('signup-desktop');
							element?.scrollIntoView({ behavior: 'smooth' });
						}}>Register Interest</button
					>
				</li>
			</ul>
		</li>
		<li>
			<button class="mx-1 btn btn-sm btn-ghost px-4 py-2" on:click={() => goto('/reviews')}
				>Reviews</button
			>
		</li>
		<li>
			<button class="mx-1 btn btn-sm btn-ghost px-4 py-2" on:click={() => goto('/questions')}
				>Questions</button
			>
		</li>
	</ul>

	<a class="btn btn-primary" href="/login">Login</a>
</div>

<style>
	.scale {
		scale: 2;
	}
</style>
