<script lang="ts">
	import { Chart, type EChartsOptions } from '$lib/echarts';
	import { onMount } from 'svelte';

	//let showUnique = false;

	let totalUniqueVisits: number;
	let totalRegistrations: number;
	let routesVisited: Record<string, number>;
	export let mobileView = false;

	let loading = true;

	onMount(async () => {
		const response = await fetch('/api/admin/stats/route-visits');
		if (!response.ok) return;
		const data = await response.json();

		routesVisited = data.routes_visited;
		totalRegistrations = data.registrations;
		totalUniqueVisits = data.total_unique_visits;

		loading = false;
	});

	const toPercent = (x: number) =>
		totalUniqueVisits === 0 ? 0 : Math.floor((x * 100) / totalUniqueVisits);

	$: options = {
		tooltip: {
			trigger: 'item',
			formatter: '{a} <br/>{b} : {c}%'
		},
		// grid: {
		// 	//left: '10%',
		// 	right: '50%',
		// 	containLabel: true
		// },
		// toolbox: {
		// 	feature: {
		// 		dataView: { readOnly: false },
		// 		restore: {},
		// 		saveAsImage: {}
		// 	}
		// },
		// legend: {
		// 	data: ['Show', 'Click', 'Visit', 'Inquiry', 'Order']
		// },
		series: [
			{
				name: 'Expected',
				type: 'funnel',
				label: {
					formatter: '{b}',
					// formatter: '{b}Expected',
					color: '#fff'
				},
				labelLine: {
					show: false
				},
				itemStyle: {
					opacity: 0.6
				},
				tooltip: { show: false },
				left: '5%',
				// right: "5%",
				width: mobileView ? '65%' : '80%',
				top: '0%',
				bottom: '7%',
				// emphasis: { disabled: true },
				// emphasis: {
				// 	label: {
				// 		position: 'inside',
				// 		formatter: '{b}Expected: {c}%'
				// 	}
				// },
				sort: 'none',
				data: [
					{ value: 100, name: 'Home' },
					{ value: 90, name: 'Solution' },
					{ value: 80, name: 'Features' },
					{ value: 70, name: 'Pricing' },
					{ value: 60, name: 'Register Interest' },
					{ value: 50, name: 'Reviews' },
					{ value: 40, name: 'Questions' },
					{ value: 30, name: 'Login' },
					{ value: 20, name: 'Signup' },
					{ value: 10, name: 'Completed Signup' }
				]
			},
			{
				name: 'Unique Session Interactions',
				type: 'funnel',
				left: '5%',
				width: mobileView ? '65%' : '80%',
				top: '0%',
				bottom: '7%',
				// maxSize: '80%',
				label: {
					position: 'inside',
					formatter: '{c}%',
					color: '#fff'
				},
				labelLine: {
					show: false
				},
				itemStyle: {
					opacity: 0.5,
					borderColor: '#fff',
					borderWidth: 2
				},
				tooltip: { show: true },
				// emphasis: {
				// 	label: {
				// 		position: 'inside',
				// 		formatter: '{b}Actual: {c}%'
				// 	}
				// },
				sort: 'none',
				data: [
					{ value: toPercent(routesVisited?.home ?? 0), name: 'Viewed Home' },
					{ value: toPercent(routesVisited?.solution ?? 0), name: 'Viewed Solution' },
					{ value: toPercent(routesVisited?.features ?? 0), name: 'Viewed Features' },
					{ value: toPercent(routesVisited?.pricing ?? 0), name: 'Viewed Pricing' },
					{
						value: toPercent(routesVisited && (routesVisited['register-interest'] ?? 0)),
						name: 'Viewed Register Interest'
					},
					{ value: toPercent(routesVisited?.reviews ?? 0), name: 'Viewed Reviews' },
					{ value: toPercent(routesVisited?.questions ?? 0), name: 'Viewed Questions' },
					{ value: toPercent(routesVisited?.login ?? 0), name: 'Viewed Login' },
					{ value: toPercent(routesVisited?.signup ?? 0), name: 'Viewed Signup' },
					{ value: toPercent(routesVisited?.totalRegistrations ?? 0), name: 'Completed Signup' }
				],
				// // Ensure outer shape will not be over inner shape when hover.
				z: 100
			}
		]
	} as EChartsOptions;
</script>

<div class="flex grow card bg-base-300">
	<p class="p-4" class:text-xs={mobileView}>Registration Funnel For Unique Sessions</p>
	<div class="relative overflow-hidden grow flex">
		{#if loading}
			<div class="grow flex items-center justify-center" class:h-72={mobileView}>
				<span class="loading loading-ring loading-lg" />
			</div>
		{:else}
			<Chart {options} />
		{/if}
	</div>
</div>
