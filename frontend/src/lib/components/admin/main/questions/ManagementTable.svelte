<script lang="ts">
	import { onMount } from 'svelte';
	import type { SvelteComponent } from 'svelte';

	//type TypeFromVar<T> = T[keyof T][];
	type itemType = Record<string, string> & { id: number };
	export let getItemsAction: () => Promise<itemType[]>;
	export let editAction: (id: number, values: Record<string, string>) => Promise<void>;
	export let deleteAction: (id: number) => Promise<void>;
	export let tableName: string;
	export let tableHeaders: string[];
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	export let editFields: (new (...args: any[]) => SvelteComponent)[];

	let loading = true;
	let currentlyEdited: {
		id: number;
		values: Record<string, string>;
	} | null = null;
	let items: itemType[];

	const onValueChange = (index: number) => (value: string) => {
		if (currentlyEdited !== null) {
			currentlyEdited.values[Object.keys(currentlyEdited.values)[index]] = value;
		}
	};

	const updateTableUiState = async () => {
		loading = true;
		items = await getItemsAction();
		loading = false;
	};

	const removeIdFromItem = (item: itemType) =>
		Object.keys(item)
			.filter((key) => key !== 'id')
			.reduce((obj, key) => {
				obj[key] = item[key];
				return obj;
			}, {} as Record<string, string>);

	onMount(updateTableUiState);
</script>

<div class="flex"><h1 class="text-2xl">{tableName}</h1></div>
<div class="divider my-2" />
{#if loading}
	<div class="grow flex items-center justify-center">
		<span class="loading loading-ring loading-lg" />
	</div>
{:else if currentlyEdited !== null}
	<div class="relative grow flex items-center justify-center">
		<div
			class="relative card h-full w-full md:w-3/4 max-w-3xl md:max-h-[32rem] max-h-none flex bg-base-200 shadow-xl p-6 flex-col"
		>
			<div class="flex justify-center"><h2>Answer&sol;Edit Question</h2></div>
			<div class="divider my-2" />
			<form
				class="flex flex-col grow"
				on:submit|preventDefault={async () => {
					if (currentlyEdited !== null) {
						await editAction(currentlyEdited.id, currentlyEdited.values);
						currentlyEdited = null;
						updateTableUiState();
					}
				}}
			>
				<div class="flex flex-col grow">
					{#each editFields as editField, index (index)}
						<svelte:component
							this={editField}
							value={currentlyEdited.values[Object.keys(currentlyEdited.values)[index]]}
							onValueChange={onValueChange(index)}
						/>
						<div class="divider" />
					{/each}
				</div>
				<div class="flex justify-between">
					<button type="button" class="btn" on:click={() => (currentlyEdited = null)}>Cancel</button
					>
					<button type="submit" class="btn btn-primary">Update</button>
				</div>
			</form>
		</div>
	</div>
{:else}
	<div class="overflow-x-auto grow">
		<table class="table table-zebra">
			<thead>
				<tr>
					{#each tableHeaders as header, index (index)}
						<th>{header}</th>
					{/each}
					<th />
				</tr>
			</thead>
			<tbody>
				{#each items as item (item.id)}
					<tr>
						<td
							>{item.question.length === 0
								? 'EMPTY'
								: item.question.length > 20
								? Array.from(item.question).slice(0, 20).join('') + '...'
								: item.question}</td
						>
						<td
							>{item.answer === null
								? 'NOT ANSWERED'
								: item.answer.length > 20
								? Array.from(item.answer).slice(0, 20).join('') + '...'
								: item.answer}</td
						>
						<td>{item.answer === null ? 'N/A' : item.upvotes}</td>
						<td>{item.answer === null ? 'N/A' : item.downvotes}</td>
						<td class="flex items-center justify-center">
							<button
								class="btn btn-primary mr-4 equalize-width"
								on:click={() => (currentlyEdited = { id: item.id, values: removeIdFromItem(item) })}
								>{item.answer === null ? 'Answer' : 'Edit'}</button
							>
							<button
								class="btn btn-error"
								on:click={async () => {
									await deleteAction(item.id);
									updateTableUiState();
								}}>Delete</button
							>
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
{/if}

<style>
	.equalize-width {
		min-width: 85px;
	}
</style>
