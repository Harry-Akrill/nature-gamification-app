<script lang="ts">
	import Icon from '@iconify/svelte';
	import windowCloseIcon from '@iconify-icons/mdi/window-close';

	export let showAddReview: boolean;
	export let refreshCallback: () => Promise<void>;

	let rating = 5;
	let review = '';
	let author = '';
	let isError = false;

	const handleSubmit = async () => {
		const response = await fetch('/api/reviews', {
			method: 'POST',
			body: JSON.stringify({
				rating,
				content: review.length > 0 ? review : undefined,
				author: author.length > 0 ? author : undefined
			}),
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			isError = true;
			return;
		}

		refreshCallback();
		showAddReview = false;
	};
</script>

<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
	class="absolute h-full w-full flex items-center justify-center p-12 backdrop-blur-sm backdrop-brightness-50"
	on:click|self={() => (showAddReview = false)}
>
	<form
		class="card h-full w-full md:w-3/4 max-w-3xl md:max-h-[32rem] max-h-none p-6 bg-base-100 flex flex-col overflow-auto"
		on:submit|preventDefault={handleSubmit}
	>
		<div class="flex items-center justify-between">
			<p>Add Review</p>
			<button class="btn btn-circle" on:click={() => (showAddReview = false)}>
				<Icon icon={windowCloseIcon} height={24} />
			</button>
		</div>
		<div class="divider my-2" />
		<div class="form-control">
			<!-- svelte-ignore a11y-label-has-associated-control -->
			<label class="label">
				<span class="label-text">Rating*</span>
			</label>
			<div class="rating flex justify-center custom-star-size">
				<input
					type="radio"
					class="mask mask-star"
					checked={rating === 1}
					on:click={() => (rating = 1)}
				/>
				<input
					type="radio"
					class="mask mask-star"
					checked={rating === 2}
					on:click={() => (rating = 2)}
				/>
				<input
					type="radio"
					class="mask mask-star"
					checked={rating === 3}
					on:click={() => (rating = 3)}
				/>
				<input
					type="radio"
					class="mask mask-star"
					checked={rating === 4}
					on:click={() => (rating = 4)}
				/>
				<input
					type="radio"
					class="mask mask-star"
					checked={rating === 5}
					on:click={() => (rating = 5)}
				/>
			</div>
		</div>
		<div class="form-control mt-2">
			<!-- svelte-ignore a11y-label-has-associated-control -->
			<label class="label">
				<span class="label-text">Review*</span>
			</label>
			<textarea
				class="textarea textarea-bordered h-24"
				placeholder="Type here"
				maxlength={600}
				class:textarea-error={isError}
				bind:value={review}
			/>
		</div>
		<div class="form-control mt-2">
			<!-- svelte-ignore a11y-label-has-associated-control -->
			<label class="label">
				<span class="label-text">Author</span>
			</label>
			<input
				type="text"
				placeholder="Type here"
				class="input input-bordered"
				maxlength={40}
				bind:value={author}
			/>
		</div>
		<p class="self-end mt-4 label-text">*Required</p>
		<div class="flex justify-between grow items-end mt-2">
			<button class="btn" type="button" on:click={() => (showAddReview = false)}>Cancel</button>
			<button class="btn btn-primary" class:btn-error={isError} type="submit">Submit</button>
		</div>
	</form>
</div>

<style>
	.custom-star-size input {
		height: 2rem;
		width: 2rem;
	}
</style>
