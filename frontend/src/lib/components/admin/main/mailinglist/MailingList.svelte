<script lang="ts">
	// import ManagementTable from '$lib/components/admin/main/reviews/ManagementTable.svelte';
	// import { authenticated } from '$lib/stores';

	import { onMount } from 'svelte';
	import mailIcon from '@iconify-icons/mdi/email';
	import Icon from '@iconify/svelte';
	import { saveAs } from 'file-saver';

	let emails: { email: string }[] = [];

	const getAllEmails = async () => {
		const response = await fetch('/api/admin/mailinglist');
		const data = await response.json();
		//console.log(data.emails);
		return data.emails;
	};

	onMount(async () => {
		emails = await getAllEmails();
	});

	const exportEmails = () => {
		const blob = new Blob([emails.map((e) => e.email).join('\n')], {
			type: 'text/plain;charset=utf-8'
		});
		saveAs(blob, 'emails.txt');
	};
</script>

<div class="relative p-6 h-full w-full">
	<div class="relative card flex bg-base-100 shadow-xl p-6 flex-col h-full w-full overflow-x-auto">
		<div class="flex"><h1 class="text-2xl">Mailing List</h1></div>
		<div class="divider my-2" />
		<div class="flex max-sm:flex-col gap-6">
			<table class="table">
				<thead>
					<tr>
						<th class="text-left text-2xl">Emails</th>
					</tr>
				</thead>
				<tbody>
					{#if emails.length > 0}
						{#each emails as email (email)}
							<tr>
								<td class="text-left text-lg">{email.email}</td>
							</tr>
						{/each}
					{:else}
						<tr>
							<td class="text-left text-lg">No mailing list signups yet...</td>
						</tr>
					{/if}
				</tbody>
			</table>
			<div class="flex flex-col justify-between gap-6">
				<div class="stat card bg-base-300">
					<div class="stat-title">Mailing List Signups</div>
					<div class="stat-value">{emails.length}</div>
					<div class="stat-figure text-secondary">
						<Icon icon={mailIcon} height={24} class="scale-125" />
					</div>
				</div>
				<button class="btn btn-neutral" on:click={exportEmails} disabled={!emails.length}
					>Export Emails</button
				>
			</div>
		</div>
	</div>
</div>
