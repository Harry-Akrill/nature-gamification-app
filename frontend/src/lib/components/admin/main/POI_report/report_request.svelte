<script lang="ts">
	export let poi: {
		lngLat: { lng: number; lat: number };
		name: string;
		id: string;
		description: string;
		features: string[];
		comments: string[];
	};
</script>

<div>
	<h1>Admin Comments</h1>
	<ul>
		{#each poi.comments as comment}
			<li>{comment}</li>
		{/each}
	</ul>
</div>
