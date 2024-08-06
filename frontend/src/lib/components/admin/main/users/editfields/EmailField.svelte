<script lang="ts">
	export let value: string;
	export let onValueChange: (value: string) => void;
</script>

<div class="form-control w-full">
	<!-- svelte-ignore a11y-label-has-associated-control -->
	<label class="label">
		<span class="label-text">Email</span>
	</label>
	<input
		type="email"
		placeholder="Enter email..."
		class="input input-bordered w-full"
		{value}
		on:input={(e) => onValueChange(e.currentTarget.value)}
	/>
</div>
