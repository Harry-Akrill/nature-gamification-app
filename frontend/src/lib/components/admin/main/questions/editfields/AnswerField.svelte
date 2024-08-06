<script lang="ts">
	export let value: string;
	export let onValueChange: (value: string) => void;
</script>

<div class="form-control w-full">
	<!-- svelte-ignore a11y-label-has-associated-control -->
	<label class="label">
		<span class="label-text">Answer</span>
	</label>
	<textarea
		placeholder="Enter answer..."
		class="textarea textarea-bordered h-24"
		{value}
		on:input={(e) => onValueChange(e.currentTarget.value)}
	/>
</div>
