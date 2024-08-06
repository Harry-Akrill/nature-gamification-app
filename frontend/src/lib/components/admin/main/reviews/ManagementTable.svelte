<script lang="ts">
	import { onMount } from 'svelte';

	//type TypeFromVar<T> = T[keyof T][];
	type itemType = Record<string, string> & { id: number };
	export let getItemsAction: () => Promise<itemType[]>;
	export let deleteAction: (id: number) => Promise<void>;
	export let tableName: string;
	export let tableHeaders: string[];

	let loading = true;
	let currentlyViewed: {
		id: number;
		values: Record<string, string | number>;
	} | null = null;
	let items: itemType[];

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
{:else if currentlyViewed !== null}
	<div class="relative grow flex items-center justify-center">
		<div
			class="relative card h-full w-full md:w-3/4 max-w-3xl md:max-h-[32rem] max-h-none flex bg-base-200 shadow-xl p-6 flex-col"
		>
			<div class="flex justify-center"><h2>Review Details</h2></div>
			<div class="divider my-2" />
			<div class="flex flex-col grow">
				<div class="flex flex-col grow">
					<div class="flex mt-2">
						<div class="form-control grow">
							<!-- svelte-ignore a11y-label-has-associated-control -->
							<label class="label">
								<span class="label-text">Rating</span>
							</label>
							<div class="rating">
								<input
									type="radio"
									class="mask mask-star"
									disabled
									checked={currentlyViewed.values.rating === 1}
								/>
								<input
									type="radio"
									class="mask mask-star"
									disabled
									checked={currentlyViewed.values.rating === 2}
								/>
								<input
									type="radio"
									class="mask mask-star"
									disabled
									checked={currentlyViewed.values.rating === 3}
								/>
								<input
									type="radio"
									class="mask mask-star"
									disabled
									checked={currentlyViewed.values.rating === 4}
								/>
								<input
									type="radio"
									class="mask mask-star"
									disabled
									checked={currentlyViewed.values.rating === 5}
								/>
							</div>
						</div>
						<div class="divider divider-horizontal" />
						<div class="form-control grow">
							<!-- svelte-ignore a11y-label-has-associated-control -->
							<label class="label">
								<span class="label-text">Upvotes</span>
							</label>
							<p>{currentlyViewed.values.upvotes}</p>
						</div>
						<div class="divider divider-horizontal" />
						<div class="form-control grow">
							<!-- svelte-ignore a11y-label-has-associated-control -->
							<label class="label">
								<span class="label-text">Downvotes</span>
							</label>
							<p>{currentlyViewed.values.downvotes}</p>
						</div>
					</div>
					<div class="divider" />
					<div class="form-control">
						<!-- svelte-ignore a11y-label-has-associated-control -->
						<label class="label">
							<span class="label-text">Content</span>
						</label>
						<textarea
							class="textarea textarea-bordered h-16"
							disabled
							value={currentlyViewed.values.content}
						/>
					</div>
					<div class="divider" />
					<div class="form-control">
						<!-- svelte-ignore a11y-label-has-associated-control -->
						<label class="label">
							<span class="label-text">Author</span>
						</label>
						<input
							type="text"
							class="input input-bordered"
							disabled
							value={currentlyViewed.values.author}
						/>
					</div>
				</div>
				<div class="divider" />
				<div class="flex justify-between">
					<button class="btn" on:click={() => (currentlyViewed = null)}>Cancel</button>
					<button
						class="btn btn-error"
						on:click={() => {
							if (currentlyViewed !== null) {
								deleteAction(currentlyViewed.id);
								currentlyViewed = null;
							}
						}}>Delete</button
					>
				</div>
			</div>
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
						<td>{item.rating}</td>
						<td
							>{item.content.length === 0
								? 'EMPTY'
								: item.content.length > 30
								? Array.from(item.content).slice(0, 30).join('') + '...'
								: item.content}</td
						>
						<td
							>{item.author.length === 0
								? 'EMPTY'
								: item.author.length > 10
								? Array.from(item.author).slice(0, 10).join('') + '...'
								: item.author}</td
						>
						<td>{item.upvotes}</td>
						<td>{item.downvotes}</td>
						<td class="flex items-center justify-center">
							<button
								class="btn btn-primary mr-4"
								on:click={() => (currentlyViewed = { id: item.id, values: removeIdFromItem(item) })}
								>View</button
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
