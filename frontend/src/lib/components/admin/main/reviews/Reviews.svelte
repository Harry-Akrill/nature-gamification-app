<script lang="ts">
	import ManagementTable from '$lib/components/admin/main/reviews/ManagementTable.svelte';
	import { authenticated } from '$lib/stores';

	const getAllReviews = async () => {
		const response = await fetch('/api/admin/reviews');
		const data = await response.json();

		return data.users;
	};

	const deleteReview = async (id: number) => {
		const response = await fetch('/api/admin/reviews', {
			method: 'DELETE',
			body: JSON.stringify({ id }),
			headers: {
				'Content-Type': 'application/json'
			}
		});
		authenticated.verify();
		const data = await response.json();
		return data;
	};
</script>

<div class="relative p-6 h-full w-full">
	<div class="relative card flex bg-base-100 shadow-xl p-6 flex-col h-full w-full overflow-x-auto">
		<ManagementTable
			getItemsAction={getAllReviews}
			deleteAction={deleteReview}
			tableHeaders={['Rating', 'Content', 'Author', 'Upvotes', 'Downvotes']}
			tableName={'Reviews'}
		/>
	</div>
</div>
