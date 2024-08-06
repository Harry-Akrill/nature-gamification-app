<script lang="ts">
	import SignupForm from '$lib/components/forms/SignupForm.svelte';
</script>

<div class="grow relative">
	<div class="wrap">
		{#each Array(200) as _}
			<div class="tri" />
		{/each}
	</div>
	<div class="h-full flex items-center justify-center">
		<SignupForm />
	</div>
</div>

<style lang="scss">
	$total: 200;
	$time: 10s;

	.wrap {
		height: 100%;
		width: 100%;
		overflow: hidden;
		transform-style: preserve-3d;
		perspective: 800px;
		position: absolute;
		opacity: 0.15;
	}

	.tri {
		height: 0;
		width: 0;
		position: absolute;
		top: 50%;
		left: 50%;
	}

	@for $i from 1 through $total {
		$size: random(50) * 1px;
		$rotate: random(360) * 1deg;
		.tri:nth-child(#{$i}) {
			border-top: $size solid hsla(random(360), 100%, 50%, 1);
			border-right: $size solid transparent;
			border-left: $size solid transparent;
			margin-left: calc(-1 * $size/2);
			margin-top: calc(-1 * $size/2);
			-webkit-filter: grayscale(1);
			filter: grayscale(1);
			transform: rotate($rotate) translate3d(0, 0, -1500px) scale(0);
			animation: anim#{$i} $time infinite linear;
			animation-delay: calc(-1 * $i * ($time/$total));
			opacity: 0;
		}

		@keyframes anim#{$i} {
			0% {
				opacity: 1;
				transform: rotate($rotate * 1.5) translate3d(random(1000) * 1px, random(1000) * 1px, 1000px)
					scale(1);
			}
		}
	}
</style>
