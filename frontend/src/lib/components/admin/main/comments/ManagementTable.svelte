<script lang="ts">
	import { onMount } from 'svelte';

	export let getItemsAction: () => Promise<any[]>;
	export let deleteAction: (id: number) => Promise<void>;
	export let toggleReportStatusAction: (id: number) => Promise<void>;
	export let tableName: string;
	export let tableHeaders: string[];

	let loading = true;
	let items: any[];

	// Function to update table UI state
	const updateTableUiState = async () => {
		loading = true;
		items = await getItemsAction();
		loading = false;
	};

	// Fetch items when component mounts
	onMount(updateTableUiState);

	// Function to handle item deletion
	const handleDelete = async (id: number) => {
		console.log('Deleting item with ID:', id);
		await deleteAction(id);
	};

	// Function to handle toggling report status
	const handleToggleReportStatus = async (id: number) => {
		console.log('Toggling report status for item with ID:', id);
		await toggleReportStatusAction(id);
	};
</script>

<div class="flex"><h1 class="text-2xl">{tableName}</h1></div>
<div class="divider my-2" />

{#if loading}
	<div class="grow flex items-center justify-center">
		<span class="loading loading-ring loading-lg" />
	</div>
{:else}
	<div class="overflow-x-auto grow">
		<table class="table table-zebra">
			<thead>
				<tr>
					{#each tableHeaders as header}
						<th>{header}</th>
					{/each}
					<th />
					<th />
				</tr>
			</thead>
			<tbody>
				{#each items as item (item.id)}
					<tr>
						<td>{item.user_nickname}</td>
						<td>{item.poi_name}</td>
						<td>{item.text}</td>
						<td>{item.rating}</td>
						<td>
							<button class="btn btn-error" on:click={() => handleDelete(item.id)}> Delete </button>
						</td>
						<td>
							<button class="btn btn-primary" on:click={() => handleToggleReportStatus(item.id)}>
								Toggle Report Status
							</button>
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
{/if}
