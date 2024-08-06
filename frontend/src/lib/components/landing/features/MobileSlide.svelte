<script lang="ts">
	import MapFeatureImg from '$lib/components/landing/features/map-feature.png';
	import POIFeatureImg from '$lib/components/landing/features/poi-feature.png';
	import SocialFeatureImg from '$lib/components/landing/features/social-feature.png';
	import IntersectionObserver from 'svelte-intersection-observer';
	import { MINIMUM_TIME_ON_SLIDE_FOR_PATH_REGISTRATION_MS } from '$lib/config';
	import { pathToRegistrationAppend } from '$lib/utils';
	import { onMount } from 'svelte';

	let timeout: ReturnType<typeof setTimeout>;
	$: {
		if (intersecting) {
			timeout = setTimeout(() => {
				if (intersecting) {
					pathToRegistrationAppend('/features');
				}
			}, MINIMUM_TIME_ON_SLIDE_FOR_PATH_REGISTRATION_MS);
		} else {
			clearTimeout(timeout);
		}
	}

	let element: HTMLDivElement;
	let intersecting: boolean;
	let slidesContainer: HTMLDivElement;
	let slidesContainerIntersecting: boolean;
	let slide1: HTMLDivElement;
	let slide1Intersecting: boolean;
	let slide2: HTMLDivElement;
	let slide2Intersecting: boolean;
	let slide3: HTMLDivElement;
	let slide3Intersecting: boolean;

	$: currentIndex = slide3Intersecting ? 2 : slide2Intersecting ? 1 : 0;
	let interval: ReturnType<typeof setTimeout>;

	const description = [
		'Be guided by the interactive map to your new favourite chill out spot! 🧘‍♀️',
		'Learn more about your local environment with hand-curated Points of Interest! 🗿',
		"Share your favourite spots, plan events and see what's happening in your area with Natreon-𝕏. 🫶"
	];

	const goToSlide = (index: number) => {
		if (!slidesContainerIntersecting) {
			return;
		}

		switch (index) {
			case 1:
				slide2.scrollIntoView();
				break;
			case 2:
				slide3.scrollIntoView();
				break;
			default:
				slide1.scrollIntoView();
				break;
		}
	};

	function next() {
		const newIndex = (currentIndex + 1) % 3;
		goToSlide(newIndex);
	}

	function prev() {
		const newIndex = (currentIndex - 1 + 3) % 3;
		goToSlide(newIndex);
	}

	function startAutoScroll() {
		interval = setInterval(next, 5000);
	}

	function stopAutoScroll() {
		clearInterval(interval);
	}

	onMount(() => {
		startAutoScroll();
		return stopAutoScroll;
	});
</script>

<IntersectionObserver {element} bind:intersecting threshold={0.1}>
	<div
		class="flex flex-col h-full items-center relative select-none background-image"
		id="home"
		bind:this={element}
	>
		<div class="w-full sm:w-5/6 p-4">
			<h2 class="text-3xl sm:text-4xl md:text-5xl font-bold mb-6 mt-4 text-grey text-center">
				What's it all about?
			</h2>
			<p class="text-lg text-white text-center mb-4">
				Natreon helps you to find green spaces, discover local points of interest, get involved with
				a great community and more!
			</p>
		</div>

		<div class="carousel-container flex flex-col items-center justify-center mt-4">
			<div class="left-button-container">
				<button
					on:click={() => {
						stopAutoScroll();
						prev();
					}}
					class="nav-button">←</button
				>
			</div>
			<IntersectionObserver
				element={slidesContainer}
				bind:intersecting={slidesContainerIntersecting}
				threshold={0.1}
			>
				<div
					class="w-5/6 carousel rounded-box relative"
					on:pointerdown={stopAutoScroll}
					bind:this={slidesContainer}
				>
					<IntersectionObserver
						element={slide1}
						bind:intersecting={slide1Intersecting}
						threshold={0.1}
					>
						<div id="feature1" class="carousel-item w-full" bind:this={slide1}>
							<img src={MapFeatureImg} alt="Interactive Map!" />
						</div></IntersectionObserver
					>
					<IntersectionObserver
						element={slide2}
						bind:intersecting={slide2Intersecting}
						threshold={0.1}
					>
						<div id="feature2" class="carousel-item w-full" bind:this={slide2}>
							<img src={POIFeatureImg} alt="Points of interest!" />
						</div>
					</IntersectionObserver>
					<IntersectionObserver
						element={slide3}
						bind:intersecting={slide3Intersecting}
						threshold={0.1}
					>
						<div id="feature3" class="carousel-item w-full" bind:this={slide3}>
							<img src={SocialFeatureImg} alt="Social Features!" />
						</div>
					</IntersectionObserver>
				</div>
			</IntersectionObserver>
			<div class="right-button-container">
				<button
					on:click={() => {
						stopAutoScroll();
						next();
					}}
					class="nav-button">→</button
				>
			</div>
		</div>
		<div id="feature-description" class="mt-10 mx-10 text-lg font-bold text-center">
			{description[currentIndex]}
		</div>
	</div>
</IntersectionObserver>

<style>
	.background-image {
		background-image: url('/nature.jpg');
		background-size: cover;
	}
	.carousel-container {
		display: flex;
		align-items: center;
		justify-content: space-between;
		position: relative;
	}

	.nav-button {
		font-size: 2rem;
		color: white;
		background-color: rgba(0, 0, 0, 0.5);
		border: none;
		border-radius: 50%;
		width: 35px;
		height: 35px;
		display: flex;
		align-items: center;
		justify-content: center;
		cursor: pointer;
		transition: background-color 0.3s ease;
	}

	.nav-button:hover {
		background-color: rgba(0, 0, 0, 0.7);
	}

	.left-button-container,
	.right-button-container {
		position: absolute;
		top: 50%;
		display: flex;
		align-items: center;
	}

	.left-button-container {
		left: 0;
	}

	.right-button-container {
		right: 0;
	}
</style>
