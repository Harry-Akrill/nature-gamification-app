<script lang="ts">
	import Icon from '@iconify/svelte';
	import { onMount } from 'svelte';
	import thumbUpIcon from '@iconify-icons/mdi/thumb-up';
	import thumbDownIcon from '@iconify-icons/mdi/thumb-down';
	import AddQuestion from '$lib/components/landing/questions/AddQuestion.svelte';
	import { fade } from 'svelte/transition';
	import { cubicOut } from 'svelte/easing';
	import { pathToRegistrationAppend } from '$lib/utils';
	import { MINIMUM_TIME_ON_REVIEWS_QUESTIONS_LOGIN_SIGNUP_PAGES_FOR_PATH_REGISTRATION_MS } from '$lib/config';

	let timeout: ReturnType<typeof setTimeout>;

	onMount(() => {
		timeout = setTimeout(
			() => pathToRegistrationAppend('/questions'),
			MINIMUM_TIME_ON_REVIEWS_QUESTIONS_LOGIN_SIGNUP_PAGES_FOR_PATH_REGISTRATION_MS
		);
		return () => clearTimeout(timeout);
	});

	const enum Order {
		RECENCY,
		USEFULLNESS
	}

	let showAddQuestion = false;
	let showYourQuestions = false;
	let loading = true;
	let questions: {
		id: number;
		question: string;
		answer: string;
		upvotes: number;
		downvotes: number;
	}[] = [];
	let questionsAwaitingApproval: {
		id: number;
		question: string;
	}[] = [];
	let totalNumberOfQuestions = 0;
	let orderBy: Order = Order.RECENCY;
	let questionsByRecency: {
		id: number;
		question: string;
		answer: string;
		upvotes: number;
		downvotes: number;
	}[] = [];
	let upvoted: number[] = [];
	let downvoted: number[] = [];

	$: {
		switch (orderBy) {
			case Order.RECENCY:
				questions = questionsByRecency;
				break;
			case Order.USEFULLNESS:
				questions = questions.toSorted(
					(a, b) => b.upvotes - b.downvotes - (a.upvotes - a.downvotes)
				);
				break;
			default:
				questions = questionsByRecency;
				break;
		}
	}

	const upvote = async (id: number) => {
		downvoted.includes(id) && cancelDownvote(id, false);

		const response = await fetch('/api/questions/upvote', {
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
		const index = questions.findIndex(({ id: _id }) => _id === id);
		if (index !== -1) {
			questions[index].upvotes += 1;
		}
		upvoted = [...upvoted, id];
	};

	const downvote = async (id: number) => {
		upvoted.includes(id) && cancelUpvote(id, false);

		const response = await fetch('/api/questions/downvote', {
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
		const index = questions.findIndex(({ id: _id }) => _id === id);
		if (index !== -1) {
			questions[index].downvotes += 1;
		}
		downvoted = [...downvoted, id];
	};

	const cancelUpvote = async (id: number, makeAPICall = true) => {
		if (makeAPICall) {
			const response = await fetch('/api/questions/upvote', {
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
		const index = questions.findIndex(({ id: _id }) => _id === id);
		if (index !== -1) {
			questions[index].upvotes -= 1;
		}
		upvoted = upvoted.filter((x) => x !== id);
	};

	const cancelDownvote = async (id: number, makeAPICall = true) => {
		if (makeAPICall) {
			const response = await fetch('/api/questions/downvote', {
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
		const index = questions.findIndex(({ id: _id }) => _id === id);
		if (index !== -1) {
			questions[index].downvotes -= 1;
		}
		downvoted = downvoted.filter((x) => x !== id);
	};

	const getAllQuestions = async () => {
		const response = await fetch('/api/questions');
		const data = await response.json();
		return data;
	};

	const updateQuestionsUiState = async () => {
		loading = true;
		const data = await getAllQuestions();
		questions = data.questions;
		upvoted = data.upvoted;
		downvoted = data.downvoted;
		questionsAwaitingApproval = data.awaiting_approval;
		totalNumberOfQuestions = data.total_number_of_questions;
		questionsByRecency = [...questions];
		loading = false;
	};

	onMount(updateQuestionsUiState);
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
						<div class="stat py-0 pl-0">
							<div class="stat-figure text-secondary hidden sm:block">
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
							<div class="stat-title text-xs sm:text-base whitespace-break-spaces">
								No. of Questions Answered
							</div>
							<div class="stat-value">{questions.length}</div>
							<div class="stat-desc">Out of {totalNumberOfQuestions} Total</div>
						</div>
					</div>
					<div class="join hidden sm:inline-flex">
						<select class="select select-bordered join-item" bind:value={orderBy}>
							<option disabled>Order By</option>
							<option selected={orderBy === Order.RECENCY} value={Order.RECENCY}>Recency</option>
							<option selected={orderBy === Order.USEFULLNESS} value={Order.USEFULLNESS}
								>Usefullness</option
							>
						</select>
						<div class="indicator">
							<button class="btn join-item btn-primary" on:click={() => (showAddQuestion = true)}
								>Ask Question</button
							>
						</div>
					</div>
					<div class="flex flex-col sm:hidden">
						<button class="btn btn-primary btn-sm" on:click={() => (showAddQuestion = true)}
							>Ask Question</button
						>
						<select class="select select-bordered select-sm mt-2" bind:value={orderBy}>
							<option disabled>Order By</option>
							<option selected={orderBy === Order.RECENCY} value={Order.RECENCY}>Recency</option>
							<option selected={orderBy === Order.USEFULLNESS} value={Order.USEFULLNESS}
								>Usefullness</option
							>
						</select>
					</div>
				</div>
				<div class="divider my-2 sm:my-3 h-3" />
				<div class="flex grow flex-col relative overflow-y-auto">
					{#if questionsAwaitingApproval.length > 0}
						<div class="flex justify-between items-center flex-row-reverse mb-4">
							<button
								class="btn btn-primary max-sm:btn-sm ml-2"
								on:click={() => (showYourQuestions = !showYourQuestions)}
								>{showYourQuestions ? 'Hide' : 'Show Your Questions'}</button
							>
							{#if showYourQuestions}
								<p class="text-sm sm:text-base" in:fade={{ duration: 800, easing: cubicOut }}>
									Your Questions (Pending Approval)
								</p>
							{/if}
						</div>
						{#if showYourQuestions}
							<div in:fade={{ duration: 800, easing: cubicOut }}>
								{#each questionsAwaitingApproval as { id, question }, index (id)}
									<div class="card p-4 flex items-center flex-row glass" class:mt-4={index > 0}>
										<div class="flex flex-col grow overflow-x-auto">
											<p class="text-xs sm:text-sm label-text mb-1">Question</p>
											<p>
												{question.length > 600
													? Array.from(question).slice(0, 600).join('') + '...'
													: question}
											</p>
										</div>
									</div>
								{/each}
							</div>
							<div class="divider" in:fade={{ duration: 800, easing: cubicOut }} />
						{/if}
					{/if}
					{#if questions.length > 0}
						{#each questions as { id, question, answer, upvotes, downvotes }, index (id)}
							<div class="card p-4 flex items-center flex-row glass" class:mt-4={index > 0}>
								<div class="flex flex-col grow overflow-x-auto">
									<p class="text-xs sm:text-sm label-text mb-1">Question</p>
									<p>
										{question.length > 600
											? Array.from(question).slice(0, 600).join('') + '...'
											: question}
									</p>
									<div class="divider my-0" />
									<p class="text-xs sm:text-sm label-text mb-1">Answer</p>
									<p>{answer}</p>
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
									</div>
								</div>
							</div>
						{/each}
					{:else}
						<div class="grow flex items-center justify-center">
							<p class="text-lg">No questions...</p>
						</div>
					{/if}
				</div>
			{/if}
		</div>
	</div>
	{#if showAddQuestion}
		<AddQuestion bind:showAddQuestion refreshCallback={updateQuestionsUiState} />
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
