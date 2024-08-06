<script lang="ts">
	import Icon from '@iconify/svelte';
	import { onMount } from 'svelte';
	import thumbUpIcon from '@iconify-icons/mdi/thumb-up';
	import thumbDownIcon from '@iconify-icons/mdi/thumb-down';
	import AddReview from '$lib/components/landing/reviews/AddReview.svelte';
	import { pathToRegistrationAppend } from '$lib/utils';
	import { MINIMUM_TIME_ON_REVIEWS_QUESTIONS_LOGIN_SIGNUP_PAGES_FOR_PATH_REGISTRATION_MS } from '$lib/config';

	let timeout: ReturnType<typeof setTimeout>;

	onMount(() => {
		timeout = setTimeout(
			() => pathToRegistrationAppend('/reviews'),
			MINIMUM_TIME_ON_REVIEWS_QUESTIONS_LOGIN_SIGNUP_PAGES_FOR_PATH_REGISTRATION_MS
		);
		return () => clearTimeout(timeout);
	});

	const enum Order {
		RECENCY,
		RATING,
		USEFULLNESS
	}

	let showAddReview = false;
	let loading = true;
	let reviews: {
		id: number;
		content: string;
		author: string;
		rating: number;
		upvotes: number;
		downvotes: number;
	}[] = [];
	let averageRating = 5;
	let orderBy: Order = Order.RECENCY;
	let reviewsByRecency: {
		id: number;
		content: string;
		author: string;
		rating: number;
		upvotes: number;
		downvotes: number;
	}[] = [];
	let upvoted: number[] = [];
	let downvoted: number[] = [];

	$: {
		switch (orderBy) {
			case Order.RECENCY:
				reviews = reviewsByRecency;
				break;
			case Order.RATING:
				reviews = reviews.toSorted((a, b) => b.rating - a.rating);
				break;
			case Order.USEFULLNESS:
				reviews = reviews.toSorted((a, b) => b.upvotes - b.downvotes - (a.upvotes - a.downvotes));
				break;
			default:
				reviews = reviewsByRecency;
				break;
		}
	}

	const upvote = async (id: number) => {
		downvoted.includes(id) && cancelDownvote(id, false);

		const response = await fetch('/api/reviews/upvote', {
			method: 'POST',
			body: JSON.stringify({
				id
			}),
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			return;
		}
		const index = reviews.findIndex(({ id: _id }) => _id === id);
		if (index !== -1) {
			reviews[index].upvotes += 1;
		}
		upvoted = [...upvoted, id];
	};

	const downvote = async (id: number) => {
		upvoted.includes(id) && cancelUpvote(id, false);

		const response = await fetch('/api/reviews/downvote', {
			method: 'POST',
			body: JSON.stringify({
				id
			}),
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			return;
		}
		const index = reviews.findIndex(({ id: _id }) => _id === id);
		if (index !== -1) {
			reviews[index].downvotes += 1;
		}
		downvoted = [...downvoted, id];
	};

	const cancelUpvote = async (id: number, makeAPICall = true) => {
		if (makeAPICall) {
			const response = await fetch('/api/reviews/upvote', {
				method: 'DELETE',
				body: JSON.stringify({
					id
				}),
				headers: {
					'Content-Type': 'application/json'
				}
			});

			if (!response.ok) {
				return;
			}
		}
		const index = reviews.findIndex(({ id: _id }) => _id === id);
		if (index !== -1) {
			reviews[index].upvotes -= 1;
		}
		upvoted = upvoted.filter((x) => x !== id);
	};

	const cancelDownvote = async (id: number, makeAPICall = true) => {
		if (makeAPICall) {
			const response = await fetch('/api/reviews/downvote', {
				method: 'DELETE',
				body: JSON.stringify({
					id
				}),
				headers: {
					'Content-Type': 'application/json'
				}
			});

			if (!response.ok) {
				return;
			}
		}
		const index = reviews.findIndex(({ id: _id }) => _id === id);
		if (index !== -1) {
			reviews[index].downvotes -= 1;
		}
		downvoted = downvoted.filter((x) => x !== id);
	};

	const getAllReviews = async () => {
		const response = await fetch('/api/reviews');
		const data = await response.json();
		return data;
	};

	const updateReviewsUiState = async () => {
		loading = true;
		const data = await getAllReviews();
		reviews = data.reviews;
		upvoted = data.upvoted;
		downvoted = data.downvoted;
		reviewsByRecency = [...reviews];

		if (reviews.length > 0) {
			averageRating = reviews.reduce((total, review) => total + review.rating, 0) / reviews.length;
		}

		loading = false;
	};

	onMount(updateReviewsUiState);
</script>

<div class="flex h-full items-center justify-center relative background-image">
	<div class="relative p-6 h-full w-full">
		<div class="card p-6 bg-base-200 flex h-full overflow-x-auto opacity-95">
			{#if loading}
				<div class="grow flex items-center justify-center">
					<span class="loading loading-ring loading-lg" />
				</div>
			{:else}
				<div class="flex justify-between items-center">
					<div class="flex">
						<div class="stat md:hidden py-0 pl-0">
							<div class="stat-figure text-primary hidden sm:block">
								<svg
									xmlns="http://www.w3.org/2000/svg"
									fill="none"
									viewBox="0 0 192 180"
									class="inline-block w-8 h-8 stroke-current"
									><path
										stroke-linecap="round"
										stroke-linejoin="round"
										stroke-width="16"
										d="m96 137.263-58.779 42.024 22.163-68.389L.894 68.481l72.476-.243L96 0l22.63 68.238 72.476.243-58.49 42.417 22.163 68.389z"
									/></svg
								>
							</div>
							<div class="stat-title">Average Review</div>
							<div class="stat-value text-primary">{averageRating.toFixed(1)}</div>
							<div class="stat-desc">Out of {reviews.length} Reviews</div>
						</div>
						<div class="stat hidden md:inline-grid py-0 pl-0">
							<div class="stat-figure text-primary">
								<svg
									xmlns="http://www.w3.org/2000/svg"
									fill="none"
									viewBox="0 0 192 180"
									class="inline-block w-8 h-8 stroke-current"
									><path
										stroke-linecap="round"
										stroke-linejoin="round"
										stroke-width="16"
										d="m96 137.263-58.779 42.024 22.163-68.389L.894 68.481l72.476-.243L96 0l22.63 68.238 72.476.243-58.49 42.417 22.163 68.389z"
									/></svg
								>
							</div>
							<div class="stat-title">Average Review</div>
							<div class="stat-value text-primary">{averageRating.toFixed(1)}</div>
						</div>
						<div class="stat hidden md:inline-grid py-0">
							<div class="stat-figure text-secondary">
								<svg
									xmlns="http://www.w3.org/2000/svg"
									fill="none"
									viewBox="0 0 24 24"
									class="inline-block w-8 h-8 stroke-current"
									><path
										stroke-linecap="round"
										stroke-linejoin="round"
										stroke-width="2"
										d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"
									/></svg
								>
							</div>
							<div class="stat-title">No. of Reviews</div>
							<div class="stat-value">{reviews.length}</div>
						</div>
					</div>
					<div class="join hidden sm:inline-flex">
						<select class="select select-bordered join-item" bind:value={orderBy}>
							<option disabled>Order By</option>
							<option selected={orderBy === Order.RECENCY} value={Order.RECENCY}>Recency</option>
							<option selected={orderBy === Order.RATING} value={Order.RATING}>Rating</option>
							<option selected={orderBy === Order.USEFULLNESS} value={Order.USEFULLNESS}
								>Usefullness</option
							>
						</select>
						<div class="indicator">
							<button class="btn join-item btn-primary" on:click={() => (showAddReview = true)}
								>Add Review</button
							>
						</div>
					</div>
					<div class="flex flex-col sm:hidden">
						<button class="btn btn-primary btn-sm" on:click={() => (showAddReview = true)}
							>Add Review</button
						>
						<select class="select select-bordered select-sm mt-2" bind:value={orderBy}>
							<option disabled>Order By</option>
							<option selected={orderBy === Order.RECENCY} value={Order.RECENCY}>Recency</option>
							<option selected={orderBy === Order.RATING} value={Order.RATING}>Rating</option>
							<option selected={orderBy === Order.USEFULLNESS} value={Order.USEFULLNESS}
								>Usefullness</option
							>
						</select>
					</div>
				</div>
				<div class="divider my-2 sm:my-3 h-3" />
				<div class="flex grow flex-col relative overflow-y-auto">
					{#if reviews.length > 0}
						{#each reviews as { id, author, content, rating, upvotes, downvotes }, index (id)}
							<div class="card p-4 flex items-center flex-row glass" class:mt-4={index > 0}>
								<div class="sm:inline-flex hidden">
									<div class="rating">
										<input type="radio" class="mask mask-star" disabled checked={rating === 1} />
										<input type="radio" class="mask mask-star" disabled checked={rating === 2} />
										<input type="radio" class="mask mask-star" disabled checked={rating === 3} />
										<input type="radio" class="mask mask-star" disabled checked={rating === 4} />
										<input type="radio" class="mask mask-star" disabled checked={rating === 5} />
									</div>
								</div>
								<p class="sm:hidden w-7 text-sm">{rating}/5</p>
								<div class="divider divider-horizontal max-sm:mx-0 mx-1" />
								<div class="flex flex-col grow overflow-x-auto">
									<p>
										{content.length > 600
											? Array.from(content).slice(0, 600).join('') + '...'
											: content}
									</p>
									<div class="flex justify-between items-center pt-4 max-sm:pt-2">
										<div class="flex items-center">
											<button
												class="btn sm:btn-sm btn-circle btn-xs"
												on:click={() => (upvoted.includes(id) ? cancelUpvote(id) : upvote(id))}
												><Icon
													icon={thumbUpIcon}
													height={18}
													class="max-sm:scale-75"
													color={upvoted.includes(id) ? 'oklch(var(--su))' : undefined}
												/></button
											>
											<p class="mx-2 max-sm:text-xs">{upvotes - downvotes}</p>
											<button
												class="btn sm:btn-sm btn-circle btn-xs"
												on:click={() =>
													downvoted.includes(id) ? cancelDownvote(id) : downvote(id)}
												><Icon
													icon={thumbDownIcon}
													height={18}
													class="max-sm:scale-75"
													color={downvoted.includes(id) ? 'oklch(var(--er))' : undefined}
												/></button
											>
										</div>
										<p class="my-0 ml-2 font-semibold text-xs sm:text-sm">
											{author.length > 40
												? Array.from(author).slice(0, 40).join('') + '...'
												: author}
										</p>
									</div>
								</div>
							</div>
						{/each}
					{:else}
						<div class="grow flex items-center justify-center">
							<p class="text-lg">No reviews...</p>
						</div>
					{/if}
				</div>
			{/if}
		</div>
	</div>
	{#if showAddReview}
		<AddReview bind:showAddReview refreshCallback={updateReviewsUiState} />
	{/if}
</div>

<style>
	.background-image {
		background-image: url('/nature.jpg');
		background-size: cover;
	}

	.background-image::before {
		content: '';
		position: absolute;
		height: 100%;
		width: 100%;
		background-color: rgba(0, 0, 0, 0.3);
		backdrop-filter: blur(2px);
	}
</style>
