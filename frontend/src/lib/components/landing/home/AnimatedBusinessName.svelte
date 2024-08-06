<h2 class="font-mono flex items-center justify-center">
	<span class="sm:text-4xl text-3xl">&#10240;</span>
	<span class="text-1 sm:text-4xl text-3xl">Natreon&#8482;</span>
	<span class="text-2 sm:text-3xl text-2xl">Trek into the wild.</span>
</h2>

<style>
	.text-1 {
		animation: text1;
		animation-timing-function: steps(16, end);
	}

	.text-2 {
		animation: text2;
		animation-timing-function: steps(20, end);
	}

	.text-1,
	.text-2 {
		overflow: hidden;
		white-space: nowrap;
		display: inline-block;
		position: absolute;
		animation-duration: 20s;
		/* animation-timing-function: steps(25, end); */
		animation-iteration-count: infinite;
	}

	.text-1::after,
	.text-2::after {
		content: '▐';
		position: absolute;
		right: 0;
		animation: caret infinite;
		animation-duration: 1s;
		animation-timing-function: steps(1, end);
	}

	@keyframes text1 {
		0%,
		50%,
		100% {
			width: 0;
		}
		10%,
		40% {
			width: 5.3em;
		}
	}

	@keyframes text2 {
		0%,
		50%,
		100% {
			width: 0;
		}

		60%,
		90% {
			width: 11.6em;
		}
	}

	@keyframes caret {
		0%,
		100% {
			opacity: 0;
		}
		50% {
			opacity: 1;
		}
	}
</style>
