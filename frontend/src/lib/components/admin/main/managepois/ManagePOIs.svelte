<script lang="ts">
	import ManagementTable from '$lib/components/admin/main/managepois/ManagementTable.svelte';
	import { onMount } from 'svelte';

	let loading = true;
	let allPOIFeatureOptions: string[];

	onMount(async () => {
		const response = await fetch('/api/admin/pois/features');
		const data = await response.json();
		allPOIFeatureOptions = data.allPOIFeatureOptions;
		loading = false;
	});

	const getAllPois = async () => {
		const response = await fetch('/api/admin/pois');
		const data = await response.json();
		return data;
	};

	const createPoi = async (poi: {
		name: string;
		description: string;
		location: string;
		features: string[];
		likes: number;
		latitude: number;
		longitude: number;
	}) => {
		const response = await fetch('/api/admin/pois', {
			method: 'POST',
			body: JSON.stringify({ poi }),
			headers: {
				'Content-Type': 'application/json'
			}
		});
		const data = await response.json();
		return data;
	};

	const deletePoi = async (id: number) => {
		const response = await fetch('/api/admin/pois', {
			method: 'DELETE',
			body: JSON.stringify({ id }),
			headers: {
				'Content-Type': 'application/json'
			}
		});
		const data = await response.json();
		return data;
	};

	const editPoi = async (id: number, values: Record<string, string | number | string[]>) => {
		const response = await fetch('/api/admin/pois/edit', {
			method: 'POST',
			body: JSON.stringify({
				id,
				name: values.name,
				description: values.description,
				location: values.location,
				features: values.features,
				latitude: values.latitude,
				longitude: values.longitude
			}),
			headers: {
				'Content-Type': 'application/json'
			}
		});
		const data = await response.json();
		return data;
	};
</script>

{#if loading}
	<div class="grow flex items-center justify-center">
		<span class="loading loading-ring loading-lg" />
	</div>
{:else}
	<div class="relative p-6 h-full w-full">
		<div
			class="relative card flex bg-base-100 shadow-xl p-6 flex-col h-full w-full overflow-x-auto"
		>
			<ManagementTable
				{allPOIFeatureOptions}
				getItemsAction={getAllPois}
				deleteAction={deletePoi}
				createAction={createPoi}
				editAction={editPoi}
				tableHeaders={[
					'Name',
					'Description',
					'Location',
					'Features',
					'Likes',
					'Latitude',
					'Longitude'
				]}
				tableName={'POI Management'}
			/>
		</div>
	</div>
{/if}
