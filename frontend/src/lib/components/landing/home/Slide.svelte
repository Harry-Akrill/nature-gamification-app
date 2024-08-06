<script lang="ts">
	import IntersectionObserver from 'svelte-intersection-observer';
	import { fade } from 'svelte/transition';
	import { cubicOut } from 'svelte/easing';
	import AnimatedBusinessName from '$lib/components/landing/home/AnimatedBusinessName.svelte';
	import AnimatedLogo from './AnimatedLogo.svelte';
	import Testimonials from './Testimonials.svelte';
	import { MINIMUM_TIME_ON_SLIDE_FOR_PATH_REGISTRATION_MS } from '$lib/config';
	import { pathToRegistrationAppend } from '$lib/utils';

	let timeout: ReturnType<typeof setTimeout>;

	$: {
		if (intersecting) {
			timeout = setTimeout(() => {
				if (intersecting) {
					pathToRegistrationAppend('/home');
				}
			}, MINIMUM_TIME_ON_SLIDE_FOR_PATH_REGISTRATION_MS);
		} else {
			clearTimeout(timeout);
		}
	}

	let element: HTMLDivElement;
	let intersecting: boolean;
	$: mounted = intersecting;
</script>

<IntersectionObserver {element} bind:intersecting threshold={0.1}>
	<div class="h-full w-full relative background-image" id="home" bind:this={element}>
		<div class="h-full w-full relative overflow-y-auto overflow-x-hidden">
			<div class="h-full w-full relative flex flex-col items-center justify-center min-height">
				<div class="relative -mt-24 w-72 overflow-hidden flex justify-center">
					<AnimatedLogo
						height={400}
						strokeColour1="#2c9296"
						strokeColour2="#fa7443"
						duration={4500}
						strokeWidthHeightProportion={0.025}
						{mounted}
					/>
				</div>
				{#if mounted}
					<div
						class="relative -mt-4 mb-12"
						in:fade={{ duration: 1600, delay: 200, easing: cubicOut }}
					>
						<AnimatedBusinessName />
					</div>
					<Testimonials />
				{/if}
			</div>
		</div>
	</div>
</IntersectionObserver>

<style>
	.background-image {
		background-image: url('/nature.jpg');
		background-size: cover;
	}

	.background-image::before {
		content: '';
		position: absolute;
		height: 100%;
		width: 100%;
		background-color: rgba(0, 0, 0, 0.3);
		backdrop-filter: blur(2px);
	}

	.min-height {
		min-height: 40rem;
	}
</style>
