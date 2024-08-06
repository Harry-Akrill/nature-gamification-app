<script lang="ts">
	import Icon from '@iconify/svelte';
	import windowCloseIcon from '@iconify-icons/mdi/window-close';

	export let showAddQuestion: boolean;
	export let refreshCallback: () => Promise<void>;

	let question = '';
	let isError = false;

	const handleSubmit = async () => {
		const response = await fetch('/api/questions', {
			method: 'POST',
			body: JSON.stringify({
				question: question.length > 0 ? question : undefined
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
		showAddQuestion = false;
	};
</script>

<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
	class="absolute h-full w-full flex items-center justify-center p-12 backdrop-blur-sm backdrop-brightness-50"
	on:click|self={() => (showAddQuestion = false)}
>
	<form
		class="card h-full w-full md:w-3/4 max-w-3xl md:max-h-[32rem] max-h-none p-6 bg-base-100 flex flex-col overflow-auto"
		on:submit|preventDefault={handleSubmit}
	>
		<div class="flex items-center justify-between">
			<p>Ask Question</p>
			<button class="btn btn-circle" on:click={() => (showAddQuestion = false)}>
				<Icon icon={windowCloseIcon} height={24} />
			</button>
		</div>
		<div class="divider my-2" />
		<div class="form-control mt-2">
			<!-- svelte-ignore a11y-label-has-associated-control -->
			<label class="label">
				<span class="label-text">Question*</span>
			</label>
			<textarea
				class="textarea textarea-bordered h-24"
				placeholder="Type here"
				maxlength={600}
				class:textarea-error={isError}
				bind:value={question}
			/>
		</div>
		<p class="self-end mt-4 label-text">*Required</p>
		<div class="flex justify-between grow items-end mt-2">
			<button class="btn" type="button" on:click={() => (showAddQuestion = false)}>Cancel</button>
			<button class="btn btn-primary" class:btn-error={isError} type="submit">Submit</button>
		</div>
	</form>
</div>
