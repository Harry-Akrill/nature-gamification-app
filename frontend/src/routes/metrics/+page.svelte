<script lang="ts">
	import LocationsGlobe from '$lib/components/metrics/landing-page/LocationsGlobe.svelte';
	import VisitDetails from '$lib/components/metrics/landing-page/VisitDetails.svelte';
	import RegistrationFunnel from '$lib/components/metrics/landing-page/RegistrationFunnel.svelte';
	import OverallDetails from '$lib/components/metrics/landing-page/OverallDetails.svelte';

	let screenWidth = screen.width;

	const checkValueInRange = (value: number, ranges: [number, number][]) => {
		for (let i = 0; i < ranges.length; i++) {
			let range = ranges[i];
			if (value >= range[0] && value <= range[1]) {
				return true;
			}
		}
		return false;
	};

	const RANGES: [number, number][] = [[0, 850]];

	$: mobileView = checkValueInRange(screenWidth, RANGES);

	const RANGES_REGISTRATION_FUNNEL: [number, number][] = [
		[0, 475],
		[850, 875]
	];

	$: mobileViewRegistrationFunnel = checkValueInRange(screenWidth, RANGES_REGISTRATION_FUNNEL);
</script>

<svelte:window on:resize={() => (screenWidth = screen.width)} />

<div class="relative flex grow bg-base-200 md:brightness-100 overflow-x-hidden">
	<div class="relative grow m-6">
		<div class="card h-full w-full flex bg-base-100 shadow-xl p-6 overflow-y-auto">
			<div class="flex"><h1 class="text-2xl">Metrics</h1></div>
			<div class="divider my-2" />
			<div class="flex flex-col pt-4">
				<OverallDetails />
				{#if mobileView}
					<div class="flex mb-6">
						<div class="grow flex flex-col">
							<div class="h-96 flex grow"><LocationsGlobe /></div>
							<div class="h-6" />
							<div class="h-96 flex grow">
								<RegistrationFunnel mobileView={mobileViewRegistrationFunnel} />
							</div>
						</div>
					</div>
				{:else}
					<div class="flex mb-6">
						<div class="grow flex justify-between max-sm:flex-col">
							<div class="h-96 flex grow sm:basis-1/2"><LocationsGlobe /></div>
							<div class="max-sm:hidden w-6" />
							<div class="h-6 sm:hidden" />
							<div class="h-96 flex grow sm:basis-1/2">
								<RegistrationFunnel mobileView={mobileViewRegistrationFunnel} />
							</div>
						</div>
					</div>
				{/if}
				<div class="flex">
					<div class="height-details grow flex" class:height-details-mobile={mobileView}>
						<VisitDetails {mobileView} />
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<style>
	.height-details {
		height: 36rem;
	}

	.height-details-mobile {
		height: 80rem;
	}
</style>
