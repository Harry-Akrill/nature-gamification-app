<script lang="ts">
	import LocationsGlobe from './landing-page/LocationsGlobe.svelte';
	import VisitDetails from './landing-page/VisitDetails.svelte';
	import RegistrationFunnel from './landing-page/RegistrationFunnel.svelte';
	import OverallDetails from './landing-page/OverallDetails.svelte';

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

	const RANGES: [number, number][] = [
		[0, 500],
		[635, 1140]
	];

	$: mobileView = checkValueInRange(screenWidth, RANGES);

	const RANGES_VISIT_DETAILS: [number, number][] = [[0, 1140]];

	$: mobileViewVisitDetails = checkValueInRange(screenWidth, RANGES_VISIT_DETAILS);

	const isInTestingMode = localStorage.getItem('testingMode') === 'true';
</script>

<svelte:window on:resize={() => (screenWidth = screen.width)} />

<div class="relative grow m-6">
	<div class="card h-full w-full flex bg-base-100 shadow-xl p-6 overflow-y-auto">
		<div class="flex"><h1 class="text-2xl">Overview</h1></div>
		<div class="divider my-2" />
		<div class="flex flex-col pt-4">
			<OverallDetails />
			{#if !isInTestingMode}
				{#if mobileView}
					<div class="flex mb-6">
						<div class="grow flex flex-col">
							<div class="h-96 flex grow"><LocationsGlobe /></div>
							<div class="h-6" />
							<div class="h-96 flex grow"><RegistrationFunnel {mobileView} /></div>
						</div>
					</div>
				{:else}
					<div class="flex mb-6">
						<div class="grow flex justify-between max-sm:flex-col">
							<div class="h-96 flex grow sm:basis-1/2"><LocationsGlobe /></div>
							<div class="max-sm:hidden w-6" />
							<div class="h-6 sm:hidden" />
							<div class="h-96 flex grow sm:basis-1/2"><RegistrationFunnel {mobileView} /></div>
						</div>
					</div>
				{/if}
				<div class="flex">
					<div
						class="height-details grow flex"
						class:height-details-mobile={mobileViewVisitDetails}
					>
						<VisitDetails mobileView={mobileViewVisitDetails} />
					</div>
				</div>
			{/if}
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
