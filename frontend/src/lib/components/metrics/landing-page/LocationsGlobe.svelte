<script lang="ts">
	import type { EChartsType } from 'echarts';
	import { onDestroy, onMount } from 'svelte';

	// const groupCoordinatesSimple = (data: [number, number, number][], squareSize: number) => {
	// 	const groupedData: Record<string, number> = {};
	// 	data.forEach(([longitude, latitude, count]) => {
	// 		const lonIndex = Math.floor(longitude / squareSize);
	// 		const latIndex = Math.floor(latitude / squareSize);

	// 		const key = `${lonIndex},${latIndex}`;

	// 		groupedData[key] = (groupedData[key] || 0) + count;
	// 	});

	// 	const result = Object.entries(groupedData).map(([key, count]) => {
	// 		const [lonIndex, latIndex] = key.split(',').map(Number);
	// 		const longitude = (lonIndex + 0.5) * squareSize;
	// 		const latitude = (latIndex + 0.5) * squareSize;
	// 		return [longitude.toFixed(4), latitude.toFixed(4), count];
	// 	});

	// 	return result;
	// };

	const groupCoordinatesHaversine = (data: [number, number, number][], squareSize: number) => {
		const EARTH_RADIUS = 6371;
		const groupedData: Record<string, number> = {};

		data.forEach(([longitude, latitude, count]) => {
			const lonRad = (longitude * Math.PI) / 180;
			const latRad = (latitude * Math.PI) / 180;

			const lonIndex = Math.floor(lonRad / (squareSize / EARTH_RADIUS));
			const latIndex = Math.floor(latRad / (squareSize / EARTH_RADIUS));

			const key = `${lonIndex},${latIndex}`;

			groupedData[key] = (groupedData[key] || 0) + count;
		});

		//const maxCount = Math.max(...Object.values(groupedData));

		const result = Object.entries(groupedData).map(([key, count]) => {
			const [lonIndex, latIndex] = key.split(',').map(Number);

			const longitude = (((lonIndex + 0.5) * squareSize) / EARTH_RADIUS) * (180 / Math.PI);
			const latitude = (((latIndex + 0.5) * squareSize) / EARTH_RADIUS) * (180 / Math.PI);

			//const normalizedCount = count / maxCount;

			// return [longitude, latitude, normalizedCount];
			return [longitude, latitude, count];
		});

		return result;
	};

	let showUnique = false;
	let autoRotate = true;

	let loading = true;
	let totalVisits: [number, number, number][];
	let uniqueVisits: [number, number, number][];

	$: data =
		uniqueVisits &&
		totalVisits &&
		groupCoordinatesHaversine(showUnique ? uniqueVisits : totalVisits, 50).map(
			([longitude, latitude, count]) => [
				longitude.toFixed(4),
				latitude.toFixed(4),
				Math.log(count + 1)
			]
		);

	$: options = {
		darkMode: true,
		animation: true,
		backgroundColor: '#000',
		globe: {
			baseTexture: '/world.jpg',
			heightTexture: '/world_displacement.jpg',
			displacementScale: 0.02,
			displacementQuality: 'high',
			shading: 'realistic',
			environment: '/starfield.jpg',
			globeRadiusRadius: 100,
			globeOuterRadius: 120,
			// baseColor: '#000',
			// shading: 'realistic',
			realisticMaterial: {
				roughness: 0.2,
				metalness: 0
			},
			postEffect: {
				enable: true,
				depthOfField: {
					// focalRange: 15,
					enable: false
					// focalDistance: 100
				}
			},
			temporalSuperSampling: {
				enable: true
			},
			light: {
				ambient: {
					intensity: 0
				},
				main: {
					intensity: 0.1,
					shadow: false
				},
				ambientCubemap: {
					texture: '/lake.hdr',
					exposure: 1,
					diffuseIntensity: 0.5,
					specularIntensity: 0.5
					//specularIntensity: 2
				}
			},
			viewControl: {
				autoRotate,
				autoRotateSpeed: 5,
				beta: 180,
				alpha: 20,
				distance: 200,
				targetCoord: [-3.5, 35]
			}
		},
		visualMap: {
			show: false,
			max: data ? Math.max(...data.map((item) => item[2] as number)) : 1,
			//calculable: true,
			realtime: false,
			inRange: {
				colorLightness: [0.2, 0.65]
			},
			// textStyle: {
			// 	color: '#fff'
			// },
			// controller: {
			// 	inRange: {
			// 		color: 'orange'
			// 	}
			// },
			outOfRange: {
				colorAlpha: 0
			}
		},
		series: [
			{
				type: 'bar3D',
				coordinateSystem: 'globe',
				data,
				//barSize: 0.6,
				barSize: 0.6,
				minHeight: 0.2,
				silent: true,
				itemStyle: {
					color: 'red'
				}
			}
		]
	};

	let container: HTMLDivElement;
	let globe: EChartsType;
	$: globe && globe.setOption(options);

	onMount(async () => {
		const response = await fetch('/api/reporter/stats/globe');
		if (!response.ok) return;
		const data = await response.json();

		totalVisits = data.all;
		uniqueVisits = data.unique;
		loading = false;
	});

	const initializeGlobe = async () => {
		const echarts = await import('echarts');
		await import('echarts-gl');
		globe = echarts.init(container, 'dark', { locale: 'EN' });
	};

	$: {
		if (!loading) {
			initializeGlobe();
		}
	}

	onDestroy(() => globe && globe.dispose());
</script>

<svelte:window on:resize={() => globe && globe.resize()} />

<div class="flex grow card overflow-hidden bg-base-300">
	<p class="p-4">Landing Page Visits By Location</p>
	<div class="flex grow relative overflow-hidden">
		{#if loading}
			<div class="grow flex items-center justify-center">
				<span class="loading loading-ring loading-lg" />
			</div>
		{:else}
			<div class="absolute w-full h-full" bind:this={container} />
			<div class="absolute top-2 left-2">
				<select
					class="select select-sm max-sm:select-xs select-info w-full max-w-xs"
					bind:value={showUnique}
				>
					<option value={false}>All Visits</option>
					<option value={true}>Unique Visits</option>
				</select>
			</div>
			<div class="absolute bottom-2 right-2 card flex flex-row">
				<p class="mr-2">Autorotate</p>
				<input type="checkbox" class="toggle toggle-info" bind:checked={autoRotate} />
			</div>
		{/if}
	</div>
</div>
