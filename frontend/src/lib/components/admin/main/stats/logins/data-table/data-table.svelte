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
		DataTableColumnHeader,
		DataTableToolbar,
		DataTablePagination
	} from '.';
	import type { Login } from '../Logins.svelte';

	export let data: Login[];

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
			accessor: 'session_id',
			header: 'Session ID',
			id: 'Session ID',
			cell: ({ value, row }) => {
				if (row.isData()) {
					return createRender(DataTableValueCell, {
						value
					});
				}
				return value;
			},
			plugins: {
				sort: {
					disable: true
				}
			}
		}),
		table.column({
			accessor: 'email',
			header: 'Email',
			id: 'Email',
			cell: ({ value, row }) => {
				if (row.isData()) {
					return createRender(DataTableValueCell, {
						value
					});
				}
				return value;
			},
			plugins: {
				sort: {
					disable: true
				}
			}
		}),
		table.column({
			accessor: 'latitude',
			header: 'Latitude',
			id: 'Latitude',
			cell: ({ value, row }) => {
				if (row.isData()) {
					return createRender(DataTableValueCell, {
						value: value.toString()
					});
				}
				return value;
			},
			plugins: {
				sort: {
					disable: true
				}
			}
		}),
		table.column({
			accessor: 'longitude',
			header: 'Longitude',
			id: 'Longitude',
			cell: ({ value, row }) => {
				if (row.isData()) {
					return createRender(DataTableValueCell, {
						value: value.toString()
					});
				}
				return value;
			},
			plugins: {
				sort: {
					disable: true
				}
			}
		}),
		table.column({
			accessor: 'country',
			header: 'Country',
			id: 'Country',
			cell: ({ value, row }) => {
				if (row.isData()) {
					return createRender(DataTableValueCell, {
						value: value
					});
				}
				return value;
			},
			plugins: {
				sort: {
					disable: true
				}
			}
		}),
		table.column({
			accessor: 'ip_address',
			header: 'IP Address',
			id: 'IP Address',
			cell: ({ value, row }) => {
				if (row.isData()) {
					return createRender(DataTableValueCell, {
						value: value
					});
				}
				return value;
			},
			plugins: {
				sort: {
					disable: true
				}
			}
		}),
		table.column({
			accessor: 'time_spent_seconds',
			header: 'Time Spent(s)',
			id: 'Time Spent(s)',
			cell: ({ value, row }) => {
				if (row.isData()) {
					return createRender(DataTableValueCell, {
						value: value.toString()
					});
				}
				return value;
			},
			plugins: {
				sort: {
					disable: true
				}
			}
		}),
		table.column({
			accessor: 'created_at',
			header: 'Time/Date',
			id: 'Time/Date',
			cell: ({ value, row }) => {
				if (row.isData()) {
					const date = new Date(value);
					const formattedDate = date.toLocaleString('en-US', {
						year: 'numeric',
						month: 'long',
						day: 'numeric',
						hour: '2-digit',
						minute: '2-digit',
						second: '2-digit'
					});
					return createRender(DataTableValueCell, {
						value: formattedDate
					});
				}
				return value;
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
		<p class="text-center text-xl">No Logins…</p>
	{:else}
		<DataTablePagination {tableModel} />
	{/if}
</div>
