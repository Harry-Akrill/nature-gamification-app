<script lang="ts" context="module">
	import * as t from 'io-ts';

	export const LoginType = t.type({
		id: t.number,
		email: t.string,
		session_id: t.string,
		latitude: t.number,
		longitude: t.number,
		country: t.string,
		ip_address: t.string,
		time_spent_seconds: t.number,
		created_at: t.string
	});

	export type Login = t.TypeOf<typeof LoginType>;
</script>

<script lang="ts">
	import { onMount } from 'svelte';
	import DataTable from './data-table/data-table.svelte';
	import { isRight } from 'fp-ts/lib/Either';

	export let updateLayoutOffsets: () => void;

	onMount(updateLayoutOffsets);

	let data: Login[] = [];
	let loading = true;

	const getLogins = async () => {
		const response = await fetch('/api/admin/stats/logins');
		if (response.ok) {
			const logins = await response.json();

			const dataIntermediate: Login[] = [];

			logins.forEach((login: any) => {
				const validationResult = LoginType.decode(login);

				if (isRight(validationResult)) {
					const loginValidated: Login = validationResult.right;
					dataIntermediate.push(loginValidated);
				} else {
					console.error('Invalid Login object received from API: ', validationResult.left);
				}
			});

			data = dataIntermediate;
			loading = false;
		}
	};

	onMount(getLogins);
</script>

{#if loading}
	<div class="grow flex items-center justify-center">
		<span class="loading loading-ring loading-lg" />
	</div>
{:else}
	<DataTable {data} />
{/if}
