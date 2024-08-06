<script lang="ts">
	import { Chart, type EChartsOptions } from '$lib/echarts';
	import { graphic } from '$lib/echarts';

	export let data: [string, string, number, boolean][];

	let signupOutcome = false;
	let filterByCountry: string | boolean = false;

	$: dateCounts = Object.entries(
		data.reduce((acc: Record<string, number>, curr) => {
			if (signupOutcome) {
				if (!curr[3]) {
					return acc;
				}
			}
			if (filterByCountry) {
				if (curr[0] !== filterByCountry) {
					return acc;
				}
			}
			const date = curr[1];
			if (!acc[date]) {
				acc[date] = 0;
			}
			acc[date]++;
			return acc;
		}, {})
	);

	$: countriesPresentInData = Array.from(new Set(data.map((item) => item[0]))).sort();

	$: options = {
		animation: false,
		tooltip: {
			trigger: 'axis',
			position: (pt) => {
				return [pt[0], '10%'];
			}
		},
		toolbox: {
			feature: {
				restore: {}
			}
		},
		xAxis: {
			type: 'category',
			boundaryGap: false,
			data: dateCounts.map((x) => x[0]),
			axisLabel: {
				color: '#FFFFFF'
			}
		},
		yAxis: {
			type: 'value',
			boundaryGap: [0, '100%'],
			name: 'No. of Visits',
			nameTextStyle: {
				color: '#FFFFFF'
			},
			axisLabel: {
				color: '#FFFFFF'
			}
		},
		dataZoom: [
			{
				type: 'inside',
				start: 0,
				end: 100
			},
			{
				start: 0,
				end: 100
			}
		],
		series: [
			{
				name: 'No. of Visits',
				type: 'line',
				symbol: 'none',
				sampling: 'lttb',
				itemStyle: {
					color: 'rgb(255, 70, 131)'
				},
				areaStyle: {
					color: new graphic.LinearGradient(0, 0, 0, 1, [
						{
							offset: 0,
							color: 'rgb(255, 158, 68)'
						},
						{
							offset: 1,
							color: 'rgb(255, 70, 131)'
						}
					])
				},
				data: dateCounts
			}
		]
	} as EChartsOptions;
</script>

<div class="flex grow flex-col card">
	<div class="flex justify-between p-4 items-center">
		<div>
			<select
				class="select select-sm max-sm:select-xs select-info w-full max-w-xs"
				bind:value={filterByCountry}
			>
				<option value={false}>All Countries</option>
				{#each countriesPresentInData as country (country)}
					<option value={country}>{country}</option>
				{/each}
			</select>
		</div>
		<div class="form-control">
			<label class="cursor-pointer label">
				<span class="label-text mr-2 max-sm:text-xs text-right">Only With Signup Outcome</span>
				<input
					type="checkbox"
					bind:checked={signupOutcome}
					class="checkbox checkbox-info max-sm:checkbox-xs"
				/>
			</label>
		</div>
	</div>
	<div class="relative overflow-hidden grow flex">
		<Chart {options} />
	</div>
</div>
