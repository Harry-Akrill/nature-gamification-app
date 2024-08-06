<!--<div
	class="flex flex-col h-full items-center justify-center relative select-none background-image"
	id="home"
>
</div>

<style>
	.background-image {
		background-image: url('/nature.jpg');
		background-size: cover;
	}
</style>-->
<script lang="ts">
	import MarketplaceImg from '$lib/components/landing/pricing/marketplace-pricing.png';
	import POIPricingImg from '$lib/components/landing/pricing/poi-pricing.png';
	import TrustPricingImg from '$lib/components/landing/pricing/trust-pricing.png';
	import { notifyAction } from 'svelte-legos';
	import IntersectionObserver from 'svelte-intersection-observer';
	import { MINIMUM_TIME_ON_SLIDE_FOR_PATH_REGISTRATION_MS } from '$lib/config';
	import { pathToRegistrationAppend } from '$lib/utils';

	let timeout: ReturnType<typeof setTimeout>;

	$: {
		if (intersecting) {
			timeout = setTimeout(() => {
				if (intersecting) {
					pathToRegistrationAppend('/pricing');
				}
			}, MINIMUM_TIME_ON_SLIDE_FOR_PATH_REGISTRATION_MS);
		} else {
			clearTimeout(timeout);
		}
	}

	let element: HTMLDivElement;
	let intersecting: boolean;

	let notificationAcknowledgeButton: HTMLButtonElement;
</script>

<IntersectionObserver {element} bind:intersecting threshold={0.1}>
	<div
		class="flex flex-col items-center relative select-none background-image h-full w-full overflow-hidden"
		id="home"
		bind:this={element}
	>
		<div class="max-w-screen-xl mx-auto py-4 flex flex-col justify-between h-full">
			<h2 class="text-3xl font-bold mb-2 text-grey text-center">
				How will we fund our operations?
			</h2>
			<p class="text-lg text-white text-center mb-4">
				Explore our funding sources below and consider supporting us through donations.
			</p>

			<div class="grid grid-rows-2 grid-cols-3 gap-2">
				<img src={MarketplaceImg} alt="download icon" class="rounded-3xl" />
				<img src={POIPricingImg} alt="download icon" class="rounded-3xl" />
				<img src={TrustPricingImg} alt="download icon" class="rounded-3xl" />

				<div>
					<!-- svelte-ignore a11y-click-events-have-key-events -->
					<!-- svelte-ignore a11y-no-static-element-interactions -->
					<div
						class="collapse bg-base-200"
						on:click={(e) => console.log('AffliatePricingClick', e)}
					>
						<input type="checkbox" />
						<div class="collapse-title text-xl font-medium">Affiliate Marketplace</div>
						<div class="collapse-content">
							<p>
								A Marketplace for affiliate companies to sell their products. We will prioritize
								companies which are pro-environmental. For every product sold on our platform, we
								will take a percentage of the sale.
							</p>
						</div>
					</div>

					<div>
						<form>
							<button
								class="btn btn-primary"
								bind:this={notificationAcknowledgeButton}
								use:notifyAction={{
									title:
										'We appreciate your willingness to donate! Unfortunately this feature is not yet implemented.',
									type: 'error',
									duration: 4000
								}}>Donate £5</button
							>
						</form>
					</div>
				</div>

				<div>
					<!-- svelte-ignore a11y-click-events-have-key-events -->
					<!-- svelte-ignore a11y-no-static-element-interactions -->
					<div
						class="collapse bg-base-200"
						on:click={(e) => console.log('ActivitiesPricingClick', e)}
					>
						<input type="checkbox" />
						<div class="collapse-title text-xl font-medium">Sponsored Activities</div>
						<div class="collapse-content">
							<p>
								Activities will appear on our in-app map, sponsored by local companies. This will
								provide an opportunity for local companies to attract pro-environment-minded
								customers, as well as creating a revenue stream for our product.
							</p>
						</div>
					</div>

					<div>
						<form>
							<button
								class="btn btn-primary"
								bind:this={notificationAcknowledgeButton}
								use:notifyAction={{
									title:
										'We appreciate your willingness to donate! Unfortunately this feature is not yet implemented.',
									type: 'error',
									duration: 4000
								}}>Donate £10</button
							>
						</form>
					</div>
				</div>

				<div>
					<!-- svelte-ignore a11y-click-events-have-key-events -->
					<!-- svelte-ignore a11y-no-static-element-interactions -->
					<div class="collapse bg-base-200" on:click={(e) => console.log('TrustsPricingClick', e)}>
						<input type="checkbox" />
						<div class="collapse-title text-xl font-medium">Government Trusts</div>
						<div class="collapse-content">
							<p>
								Our content will be supported through funds from government trusts, with a
								partnership with the National Trust being a potential possibility.
							</p>
						</div>
					</div>
					<div>
						<form>
							<button
								class="btn btn-primary"
								bind:this={notificationAcknowledgeButton}
								use:notifyAction={{
									title:
										'We appreciate your willingness to donate! Unfortunately this feature is not yet implemented.',
									type: 'error',
									duration: 4000
								}}>Donate £15</button
							>
						</form>
					</div>
				</div>
			</div>
			<div>
				<p class="text-lg text-white text-center">
					Donations will help to support us to produce the application that we feel so passionately
					about. Donations at this stage are greatly appreciated, but please only do so if you are
					financially stable.
				</p>
			</div>
		</div>
	</div>
</IntersectionObserver>

<style>
	.background-image {
		background-image: url('/nature.jpg');
		background-size: cover;
	}
	.btn {
		margin: 1rem auto;
		padding: 10px 20px;
		font-size: 16px;
		max-width: 100%;
		width: auto;
		box-sizing: border-box;
		display: block;
	}
</style>
