<script lang="ts">
	import type { EChartsType } from 'echarts';
	import { onDestroy, onMount } from 'svelte';

	export let data: [string, string, number, boolean][];

	$: options = {
		tooltip: {
			trigger: 'item',
			// axisPointer: {
			// 	type: 'cross'
			// },
			formatter: (params: any) => {
				return `
				<b>${params.seriesName}</b><br />
				Time spent (s): ${params.data[2]}<br />
				Date: ${params.data[1]}<br />
				Country: ${params.data[0]}<br /><br />
				Signed Up: <b>${params.data[3] ? 'YES' : 'NO'}</b><br />
				`;
			}
		},
		backgroundColor: 'transparent',
		// darkMode: true,
		animation: true,
		grid3D: {},
		xAxis3D: {
			type: 'category',
			name: 'Date',
			nameTextStyle: {
				fontSize: 16,
				color: '#fff',
				align: 'center'
			},
			nameGap: 40,
			axisLabel: {
				textStyle: {
					color: '#aad8e6'
				}
			}
		},
		yAxis3D: {
			type: 'category',
			name: 'Country',
			nameTextStyle: {
				fontSize: 16,
				color: '#fff',
				verticalAlign: 'middle'
			},
			nameGap: 30,
			axisLabel: {
				textStyle: {
					color: '#aad8e6'
				}
			}
		},
		zAxis3D: {
			type: 'value',
			name: 'Time spent (s)',
			nameTextStyle: {
				fontSize: 16,
				color: '#fff',
				verticalAlign: 'top'
			},
			nameGap: 25,
			axisLabel: {
				textStyle: {
					color: '#aad8e6',
					formatter: (value: any, index: any) => {
						if (index === 0) {
							return '';
						} else {
							return value;
						}
					}
				}
			}
		},

		dataset: {
			dimensions: [
				'Country',
				'Date',
				'Time spent (s)',
				'Signed Up',
				{ name: 'Time spent (s)', type: 'ordinal' }
			],
			source: data
		},
		series: [
			{
				name: 'Landing Page Visit',
				type: 'scatter3D',
				symbolSize: 6,
				encode: {
					x: 'Date',
					y: 'Country',
					z: 'Time spent (s)'
				},
				itemStyle: {
					color: (params: any) => {
						return params.data[3] ? '#FF4683' : '#00b3f0';
					}
				}
			}
		]
	};

	let container: HTMLDivElement;
	let chart: EChartsType;
	$: chart && chart.setOption(options);

	const initialize3dChart = async () => {
		const echarts = await import('echarts');
		await import('echarts-gl');
		chart = echarts.init(container, 'dark', { locale: 'EN' });
	};

	onMount(initialize3dChart);
	onDestroy(() => chart && chart.dispose());
</script>

<svelte:window on:resize={() => chart && chart.resize()} />

<div class="flex grow relative overflow-hidden card">
	<div class="w-full h-full absolute" bind:this={container} />
</div>
