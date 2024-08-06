<script lang="ts">
	export let value: string;
	export let onValueChange: (value: string) => void;
</script>

<div class="form-control w-full">
	<!-- svelte-ignore a11y-label-has-associated-control -->
	<label class="label">
		<span class="label-text">User Type</span>
	</label>
	<select
		class="select select-bordered w-full"
		value={value.toUpperCase()}
		on:change={(e) => onValueChange(e.currentTarget.value.toLowerCase())}
	>
		<option>CUSTOMER</option>
		<option>REPORTER</option>
		<option>ADMIN</option>
	</select>
</div>
