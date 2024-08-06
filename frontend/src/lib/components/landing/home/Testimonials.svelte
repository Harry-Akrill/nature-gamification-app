<script lang="ts">
	import { fly, fade } from 'svelte/transition';
	import { cubicOut, cubicIn } from 'svelte/easing';
	import { onMount } from 'svelte';

	const MAX_SLIDE_NUM = 3;
	const TRANSITION_DURATION = 400;
	let currentSlide = 1;

	const nextSlide = () => {
		let temp = currentSlide;
		currentSlide = -1;
		setTimeout(() => (currentSlide = temp + 1 > MAX_SLIDE_NUM ? 1 : temp + 1), TRANSITION_DURATION);
	};

	onMount(() => {
		const interval = setInterval(nextSlide, 5000);
		return () => clearInterval(interval);
	});
</script>

<figure
	class="max-w-screen-md text-center relative mx-8"
	in:fade={{ duration: 1600, delay: 200, easing: cubicOut }}
>
	<svg
		class="h-6 mx-auto mb-4 text-white"
		aria-hidden="true"
		xmlns="http://www.w3.org/2000/svg"
		fill="currentColor"
		viewBox="0 0 18 14"
	>
		<path
			d="M6 0H2a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h4v1a3 3 0 0 1-3 3H2a1 1 0 0 0 0 2h1a5.006 5.006 0 0 0 5-5V2a2 2 0 0 0-2-2Zm10 0h-4a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h4v1a3 3 0 0 1-3 3h-1a1 1 0 0 0 0 2h1a5.006 5.006 0 0 0 5-5V2a2 2 0 0 0-2-2Z"
		/>
	</svg>
	<div class="h-16">
		{#if currentSlide === 1}
			<div
				in:fly={{ duration: TRANSITION_DURATION, x: 200, opacity: 0, easing: cubicOut }}
				out:fly={{ duration: TRANSITION_DURATION, x: -200, opacity: 0, easing: cubicIn }}
			>
				<blockquote>
					<p class="sm:text-lg text-sm italic font-medium text-white">
						"Before discovering Natreon&#8482; I was depressed and miserable, now I am the happiest
						person on planet earth..."
					</p>
				</blockquote>
				<!-- svelte-ignore a11y-structure -->
				<figcaption class="flex items-center justify-center mt-6 space-x-3 sm:text-base text-sm">
					<div class="flex items-center divide-x-2 divide-white">
						<cite class="pr-3 font-medium text-white">Some random guy</cite>
						<cite class="pl-3 text-sm">CEO at a company</cite>
					</div>
				</figcaption>
			</div>
		{:else if currentSlide === 2}
			<div
				in:fly={{ duration: TRANSITION_DURATION, x: 200, opacity: 0, easing: cubicOut }}
				out:fly={{ duration: TRANSITION_DURATION, x: -200, opacity: 0, easing: cubicIn }}
			>
				<blockquote>
					<p class="sm:text-xl text-lg italic font-medium text-white">"10/10"</p>
				</blockquote>
				<!-- svelte-ignore a11y-structure -->
				<figcaption class="flex items-center justify-center mt-6 space-x-3 sm:text-base text-sm">
					<div class="flex items-center divide-x-2 divide-white">
						<cite class="pr-3 font-medium text-white">Some random guy</cite>
						<cite class="pl-3 text-sm">IGN</cite>
					</div>
				</figcaption>
			</div>
		{:else if currentSlide === 3}
			<div
				in:fly={{ duration: TRANSITION_DURATION, x: 200, opacity: 0, easing: cubicOut }}
				out:fly={{ duration: TRANSITION_DURATION, x: -200, opacity: 0, easing: cubicIn }}
			>
				<blockquote>
					<p class="sm:text-xl text-lg italic font-medium text-white">"Really good app ( ͡° ͜ʖ ͡°)"</p>
				</blockquote>
				<!-- svelte-ignore a11y-structure -->
				<figcaption class="flex items-center justify-center mt-6 space-x-3 sm:text-base text-sm">
					<div class="flex items-center divide-x-2 divide-white">
						<cite class="pr-3 font-medium text-white">Some random guy</cite>
						<cite class="pl-3 text-sm">CEO at a company</cite>
					</div>
				</figcaption>
			</div>
		{/if}
	</div>
</figure>
