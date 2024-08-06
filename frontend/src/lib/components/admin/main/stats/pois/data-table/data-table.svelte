<script lang="ts">
	import { get, readable } from 'svelte/store';
	import { Render, Subscribe, createRender, createTable } from 'svelte-headless-table';
	import * as Table from '$lib/components/new-york/ui/table';
	import {
		addHiddenColumns,
		addPagination,
		addSortBy,
		addTableFilter
	} from 'svelte-headless-table/plugins';
	import {
		DataTableValueCell,
		DataTablePOICell,
		DataTableColumnHeader,
		DataTableToolbar,
		DataTablePagination
	} from '.';
	import type { POIViewCount } from '../POIs.svelte';

	export let data: POIViewCount[];

	const table = createTable(readable(data), {
		sort: addSortBy({
			toggleOrder: ['asc', 'desc']
		}),
		page: addPagination(),
		filter: addTableFilter({
			fn: ({ filterValue, value }) => {
				return value.toLowerCase().includes(filterValue.toLowerCase());
			}
		}),
		hide: addHiddenColumns()
	});

	const columns = table.createColumns([
		table.column({
			accessor: 'count',
			header: 'View Count',
			id: 'View Count',
			cell: ({ value, row }) => {
				if (row.isData()) {
					return createRender(DataTableValueCell, {
						value: value.toString()
					});
				}
				return value;
			}
		}),
		table.column({
			accessor: (row: POIViewCount) => JSON.stringify(row.poi),
			header: 'POI Name',
			id: 'POI Name',
			cell: ({ value, row }) => {
				if (row.isData()) {
					return createRender(DataTableValueCell, {
						value: JSON.parse(value).name
					});
				}
				return JSON.stringify(value);
			},
			plugins: {
				sort: {
					disable: true
				},
				filter: {}
			}
		}),
		table.display({
			id: 'actions',
			header: () => {
				return '';
			},
			cell: ({ row }) => {
				if (row.isData() && row.original) {
					return createRender(DataTablePOICell, {
						value: row.original.poi
					});
				}
				return '';
			},
			plugins: {
				sort: {
					disable: true
				}
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
						<Table.Row {...rowAttrs}>
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
		<p class="text-center text-xl">No POI Views…</p>
	{:else}
		<DataTablePagination {tableModel} />
	{/if}
</div>
