<script lang="ts">
	import { goto } from '$app/navigation';
</script>

<div class="navbar bg-base-100 justify-between sm:hidden fixed z-10">
	<div>
		<div class="dropdown dropdown-hover">
			<!-- svelte-ignore a11y-no-noninteractive-tabindex -->
			<!-- svelte-ignore a11y-label-has-associated-control -->
			<label tabindex="0" class="btn btn-ghost">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					class="h-5 w-5"
					fill="none"
					viewBox="0 0 24 24"
					stroke="currentColor"
					><path
						stroke-linecap="round"
						stroke-linejoin="round"
						stroke-width="2"
						d="M4 6h16M4 12h8m-8 6h16"
					/></svg
				>
			</label>
			<!-- svelte-ignore a11y-no-noninteractive-tabindex -->
			<ul tabindex="0" class="menu dropdown-content z-[1] p-2 shadow bg-base-100 rounded-box w-48">
				<li>
					<p class="menu-title">Home</p>
					<ul>
						<li>
							<button
								on:click={async () => {
									await goto('/');
									const element = document.getElementById('home-mobile');
									element?.scrollIntoView({ behavior: 'smooth' });
								}}>Home</button
							>
						</li>
						<li>
							<button
								on:click={async () => {
									await goto('/');
									const element = document.getElementById('solution-mobile');
									element?.scrollIntoView({ behavior: 'smooth' });
								}}>Our Solution</button
							>
						</li>
						<li>
							<button
								on:click={async () => {
									await goto('/');
									const element = document.getElementById('features-mobile');
									element?.scrollIntoView({ behavior: 'smooth' });
								}}>Features</button
							>
						</li>
						<li>
							<button
								on:click={async () => {
									await goto('/');
									const element = document.getElementById('pricing-mobile');
									element?.scrollIntoView({ behavior: 'smooth' });
								}}>Pricing</button
							>
						</li>
						<li>
							<button
								on:click={async () => {
									await goto('/');
									const element = document.getElementById('signup-mobile');
									element?.scrollIntoView({ behavior: 'smooth' });
								}}>Register Interest</button
							>
						</li>
					</ul>
				</li>
				<li>
					<button on:click={() => goto('/reviews')}>Reviews</button>
				</li>
				<li>
					<button on:click={() => goto('/questions')}>Questions</button>
				</li>
			</ul>
		</div>
		<h1 class="select-none px-4">Natreon&#8482;</h1>
	</div>
	<a class="btn btn-primary" href="/login">Login</a>
</div>
