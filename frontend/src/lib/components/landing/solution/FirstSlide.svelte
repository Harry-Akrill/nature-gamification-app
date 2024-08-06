<script lang="ts">
	import Problem from './problem.svelte';
</script>

<div
	class="flex flex-col h-full items-center justify-center relative select-none background-image"
	id="home"
>
	<Problem />
</div>

<style>
	.background-image {
		background-image: url('/nature.jpg');
		background-size: cover;
		background-color: rgba(0, 0, 0, 0.5);
	}
</style>
