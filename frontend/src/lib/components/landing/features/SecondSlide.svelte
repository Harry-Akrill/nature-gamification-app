<script lang="ts">
	import AnimatedBusinessName from '$lib/components/landing/home/AnimatedBusinessName.svelte';
</script>

<div
	class="flex flex-col h-full items-center justify-center relative select-none background-image"
	id="home"
>
	<AnimatedBusinessName />
</div>

<style>
	.background-image {
		background-image: url('/nature.jpg');
		background-size: cover;
	}
</style>
