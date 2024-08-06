<script lang="ts">
	import { get, readable } from 'svelte/store';
	import { Render, Subscribe, createRender, createTable } from 'svelte-headless-table';
	import * as Table from '$lib/components/new-york/ui/table';
	import {
		addColumnFilters,
		addHiddenColumns,
		addPagination,
		addSortBy
	} from 'svelte-headless-table/plugins';
	import {
		DataTableNameCell,
		DataTableColumnHeader,
		DataTableToolbar,
		DataTablePagination
	} from '.';
	import { goto } from '$app/navigation';
	import type { POI } from '../../home/map/Map.svelte';

	export let data: POI[];

	const table = createTable(readable(data), {
		sort: addSortBy({
			toggleOrder: ['asc', 'desc']
		}),
		page: addPagination(),
		colFilter: addColumnFilters(),
		hide: addHiddenColumns()
	});

	const columns = table.createColumns([
		table.column({
			accessor: 'name',
			header: 'Name',
			id: 'name',
			cell: ({ value, row }) => {
				if (row.isData()) {
					return createRender(DataTableNameCell, {
						value
					});
				}
				return value;
			},
			plugins: {
				colFilter: {
					fn: ({ filterValue, value }) => {
						return value.toLowerCase().includes(filterValue.toLowerCase());
					},
					initialFilterValue: '',
					render: ({ filterValue }) => {
						return get(filterValue);
					}
				}
			}
		}),
		table.column({
			accessor: 'features',
			header: 'Features',
			id: 'features',
			cell: ({ value, row }) => {
				if (row.isData()) {
					return createRender(DataTableNameCell, {
						value: value.join(', ')
					});
				}
				return value.join('');
			},
			plugins: {
				colFilter: {
					fn: ({ filterValue, value }) => {
						if (filterValue.length === 0) return true;
						if (!Array.isArray(filterValue)) return true;

						return filterValue.some((filter) => {
							return value.includes(filter);
						});
					},
					initialFilterValue: [],
					render: ({ filterValue }) => {
						return get(filterValue);
					}
				},
				sort: { disable: true }
			}
		})
	]);

	const rowToRowOriginal = (row: any) => row.original;

	const tableModel = table.createViewModel(columns);

	const { headerRows, pageRows, tableAttrs, tableBodyAttrs } = tableModel;
</script>

<div class="space-y-4">
	<DataTableToolbar {tableModel} />
	<div class="rounded-md border">
		<Table.Root {...$tableAttrs}>
			<Table.Header>
				{#each $headerRows as headerRow}
					<Subscribe rowAttrs={headerRow.attrs()}>
						<Table.Row>
							{#each headerRow.cells as cell (cell.id)}
								<Subscribe attrs={cell.attrs()} let:attrs props={cell.props()} let:props>
									<Table.Head {...attrs}>
										<DataTableColumnHeader {props}
											><Render of={cell.render()} /></DataTableColumnHeader
										>
									</Table.Head>
								</Subscribe>
							{/each}
						</Table.Row>
					</Subscribe>
				{/each}
			</Table.Header>
			<Table.Body {...$tableBodyAttrs}>
				{#each $pageRows as row (row.id)}
					<Subscribe rowAttrs={row.attrs()} let:rowAttrs>
						<Table.Row
							{...rowAttrs}
							class="cursor-pointer"
							on:click={() =>
								goto('/app?focus-poi=' + encodeURIComponent(rowToRowOriginal(row).id))}
						>
							{#each row.cells as cell (cell.id)}
								<Subscribe attrs={cell.attrs()} let:attrs>
									<Table.Cell {...attrs}>
										<Render of={cell.render()} />
									</Table.Cell>
								</Subscribe>
							{/each}
						</Table.Row>
					</Subscribe>
				{/each}
			</Table.Body>
		</Table.Root>
	</div>
	{#if data.length === 0}
		<p class="text-center text-xl">No POIs in Favourites…</p>
	{:else}
		<DataTablePagination {tableModel} />
	{/if}
</div>
