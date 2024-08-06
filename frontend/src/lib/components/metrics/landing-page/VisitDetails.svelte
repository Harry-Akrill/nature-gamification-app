<script lang="ts">
	import { onMount } from 'svelte';
	import Plot3D from './visitdetails/Plot3D.svelte';
	import Chart from './visitdetails/Chart.svelte';

	let showUnique = false;
	export let mobileView = false;

	let loading = true;
	let totalVisits: [string, string, number][];
	let uniqueVisits: [string, string, number][];

	const formatDate = (dateParam: string) => {
		const date = new Date(dateParam);
		const day = String(date.getDate()).padStart(2, '0');
		const month = String(date.getMonth() + 1).padStart(2, '0');
		const year = date.getFullYear();

		const formattedDate = `${day}/${month}/${year}`;
		return formattedDate;
	};

	onMount(async () => {
		const response = await fetch('/api/reporter/stats/all-visits');
		if (!response.ok) return;
		const data = await response.json();

		const total = data.all;
		const unique = data.unique;

		totalVisits = total.map((visit: [string, string, number, boolean]) => [
			visit[0],
			formatDate(visit[1]),
			visit[2],
			visit[3]
		]);
		uniqueVisits = unique.map((visit: [string, string, number, boolean]) => [
			visit[0],
			formatDate(visit[1]),
			visit[2],
			visit[3]
		]);

		loading = false;
	});
</script>

<div class="grow flex flex-col">
	<div class="flex bg-base-300 justify-between items-center p-4 card flex-row">
		<p>Landing Page Visits</p>
		<div>
			<select
				class="select select-sm max-sm:select-xs select-info w-full max-w-xs"
				bind:value={showUnique}
			>
				<option value={false}>All Visits</option>
				<option value={true}>Unique Visits</option>
			</select>
		</div>
	</div>
	<div class="flex grow gap-6 mt-6 max-sm:flex-col" class:flex-col={mobileView}>
		{#if loading}
			<div class="grow flex items-center justify-center bg-base-300 basis-1/2">
				<span class="loading loading-ring loading-lg" />
			</div>
			<div class="grow flex items-center justify-center bg-base-300 basis-1/2">
				<span class="loading loading-ring loading-lg" />
			</div>
		{:else}
			<div class="grow flex card overflow-hidden bg-base-300 basis-1/2">
				<Plot3D data={showUnique ? uniqueVisits : totalVisits} />
			</div>
			<div class="grow flex card overflow-hidden bg-base-300 basis-1/2">
				<Chart data={showUnique ? uniqueVisits : totalVisits} />
			</div>
		{/if}
	</div>
</div>
