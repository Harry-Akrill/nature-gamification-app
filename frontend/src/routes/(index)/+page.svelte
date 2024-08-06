<script lang="ts">
	import HomeSlide from '$lib/components/landing/home/Slide.svelte';
	import SolutionDesktopSlide from '$lib/components/landing/solution/DesktopSlide.svelte';
	import SolutionMobileSlide from '$lib/components/landing/solution/MobileSlide.svelte';
	import FeaturesDesktopSlide from '$lib/components/landing/features/DesktopSlide.svelte';
	import FeaturesMobileSlide from '$lib/components/landing/features/MobileSlide.svelte';
	import PricingDesktopSlide from '$lib/components/landing/pricing/DesktopSlide.svelte';
	import PricingMobileSlide from '$lib/components/landing/pricing/MobileSlide.svelte';
	import SignupDesktopSlide from '$lib/components/landing/signup/DesktopSlide.svelte';
	import SignupMobileSlide from '$lib/components/landing/signup/MobileSlide.svelte';

	let isMobileDevice = false;
	let showCircle = false;
	let circle: HTMLDivElement;
	let container: HTMLDivElement;
	let cursorPosition = { x: 0, y: 0 };

	const updateCursorPosition = (e: MouseEvent) => {
		const [offsetX, offsetY] = [
			container.getBoundingClientRect().left,
			container.getBoundingClientRect().top
		];
		[cursorPosition.x, cursorPosition.y] = [e.x - offsetX, e.y - offsetY];
	};
</script>

<svelte:window on:touchstart={() => (isMobileDevice = true)} />

<div class="overflow-hidden grow flex relative">
	<!-- svelte-ignore a11y-no-static-element-interactions -->
	<div
		class="flex grow"
		on:mouseenter={() => (showCircle = !isMobileDevice)}
		on:mouseleave={() => (showCircle = false)}
		on:mousemove={updateCursorPosition}
		bind:this={container}
	>
		<div class="grow relative overflow-y-auto snap-y snap-mandatory hidden sm:block">
			<div class="snap-start relative h-full w-full overflow-hidden" id="home-desktop">
				<HomeSlide />
			</div>
			<div class="snap-start relative h-full w-full overflow-x-hidden" id="solution-desktop">
				<SolutionDesktopSlide />
			</div>
			<div class="snap-start relative h-full w-full overflow-x-hidden" id="features-desktop">
				<FeaturesDesktopSlide />
			</div>
			<div class="snap-start relative h-full w-full overflow-x-hidden" id="pricing-desktop">
				<PricingDesktopSlide />
			</div>
			<div class="snap-start relative h-full w-full overflow-x-hidden" id="signup-desktop">
				<SignupDesktopSlide />
			</div>
		</div>
		<div class="grow relative overflow-y-auto snap-y snap-mandatory sm:hidden">
			<div class="snap-start relative h-full w-full overflow-hidden" id="home-mobile">
				<HomeSlide />
			</div>
			<div class="snap-start relative h-full w-full overflow-x-hidden" id="solution-mobile">
				<SolutionMobileSlide />
			</div>
			<div class="snap-start relative h-full w-full overflow-x-hidden" id="features-mobile">
				<FeaturesMobileSlide />
			</div>
			<div class="snap-start relative h-full w-full overflow-x-hidden" id="pricing-mobile">
				<PricingMobileSlide />
			</div>
			<div class="snap-start relative h-full w-full overflow-x-hidden" id="signup-mobile">
				<SignupMobileSlide />
			</div>
		</div>
	</div>
	{#if showCircle}
		<div
			class="rounded-full h-8 w-8 absolute -translate-x-1/2 -translate-y-1/2 pointer-events-none backdrop-invert"
			bind:this={circle}
			style={`translate: ${cursorPosition.x}px ${cursorPosition.y}px`}
		/>
	{/if}
</div>
