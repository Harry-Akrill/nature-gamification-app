<script lang="ts">
	import MapFeatureImg from '$lib/components/landing/features/map-feature.png';
	import POIFeatureImg from '$lib/components/landing/features/poi-feature.png';
	import SocialFeatureImg from '$lib/components/landing/features/social-feature.png';
	import IntersectionObserver from 'svelte-intersection-observer';
	import { MINIMUM_TIME_ON_SLIDE_FOR_PATH_REGISTRATION_MS } from '$lib/config';
	import { pathToRegistrationAppend } from '$lib/utils';

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

	function sendEmail(email: string) {
		window.location.href = `mailto:${email}`;
	}

	let element: HTMLDivElement;
	let intersecting: boolean;
</script>

<IntersectionObserver {element} bind:intersecting threshold={0.1}>
	<div
		class="flex flex-col h-full items-center relative select-none background-image"
		id="home"
		bind:this={element}
	>
		<div class="w-5/6 py-10">
			<div class="grid grid-rows-2 grid-cols-3 gap-3">
				<img src={MapFeatureImg} alt="download icon" class="rounded-3xl" />
				<img src={POIFeatureImg} alt="download icon" class="rounded-3xl" />
				<img src={SocialFeatureImg} alt="download icon" class="rounded-3xl" />
				<div>
					<!-- svelte-ignore a11y-click-events-have-key-events -->
					<!-- svelte-ignore a11y-no-static-element-interactions -->
					<div class="collapse bg-base-200" on:click={(e) => console.log('MapFeatureClick', e)}>
						<input type="checkbox" />
						<div class="collapse-title text-xl font-medium">Map</div>
						<div class="collapse-content">
							<p>Be guided by the interactive map to your new favourite chill out spot! 🧘‍♀️</p>
							<div class="flex items-center justify-center space-x-4 py-5">
								<a
									href="mailto:?subject=The%20Nateron%20Map%20Feature%20is%20Awesome!&body=Hi!%20Checkout%20natreon.com%20and%20their%20awesome%20interactive%20map!"
									class="btn btn-primary">Email</a
								>
								<a
									href={`https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(
										'www.natreon.com/map'
									)}`}
									class="btn btn-secondary">Social Media</a
								>
							</div>
						</div>
					</div>
				</div>
				<div>
					<!-- svelte-ignore a11y-click-events-have-key-events -->
					<!-- svelte-ignore a11y-no-static-element-interactions -->
					<div class="collapse bg-base-200" on:click={(e) => console.log('POIFeatureClick', e)}>
						<input type="checkbox" />
						<div class="collapse-title text-xl font-medium">POI</div>
						<div class="collapse-content">
							<p>
								Learn more about your local environment with hand-curated Points of Interest! 🗿
							</p>
							<div class="flex items-center justify-center space-x-4 py-5">
								<a
									href="mailto:?subject=The%20Nateron%20POI%20Feature%20is%20Awesome!&body=Hi!%20Checkout%20natreon.com%20and%20their%20awesome%20points%20of%20local%20interest!"
									class="btn btn-primary">Email</a
								>
								<a
									href={`https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(
										'www.natreon.com/poi'
									)}`}
									class="btn btn-secondary">Social Media</a
								>
							</div>
						</div>
					</div>
				</div>
				<div>
					<!-- svelte-ignore a11y-click-events-have-key-events -->
					<!-- svelte-ignore a11y-no-static-element-interactions -->
					<div class="collapse bg-base-200" on:click={(e) => console.log('SocialFeatureClick', e)}>
						<input type="checkbox" />
						<div class="collapse-title text-xl font-medium">Social</div>
						<div class="collapse-content">
							<p>
								Share your favourite spots, plan events and see what's happening in your area with
								Natreon-𝕏. 🫶
							</p>
							<div class="flex items-center justify-center space-x-4 py-5">
								<a
									href="mailto:?subject=The%20Nateron%20Social%20Feature%20is%20Awesome!&body=Hi!%20Checkout%20natreon.com%20and%20their%20awesome%20social%20media%20features!"
									class="btn btn-primary">Email</a
								>
								<a
									href={`https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(
										'www.natreon.com/social'
									)}`}
									class="btn btn-secondary">Social Media</a
								>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</IntersectionObserver>

<style>
	.background-image {
		background-image: url('/nature.jpg');
		background-size: cover;
	}
</style>
