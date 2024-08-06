<script lang="ts">
	import ManagementTable from '$lib/components/admin/main/users/ManagementTable.svelte';
	import EmailField from '$lib/components/admin/main/users/editfields/EmailField.svelte';
	import UserTypeField from '$lib/components/admin/main/users/editfields/UserTypeField.svelte';
	import { authenticated } from '$lib/stores';

	const getAllUsers = async () => {
		const response = await fetch('/api/admin/users');
		const data = await response.json();
		return data.users;
	};

	const updateUser = async (id: number, values: Record<string, string>) => {
		const response = await fetch('/api/admin/users', {
			method: 'POST',
			body: JSON.stringify({ id, email: values.email, user_type: values.user_type }),
			headers: {
				'Content-Type': 'application/json'
			}
		});
		authenticated.verify();
		const data = await response.json();
		return data;
	};

	const deleteUser = async (id: number) => {
		const response = await fetch('/api/admin/users', {
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

	const deactivateUser = async (id: number) => {
		const response = await fetch('/api/admin/users/deactivate', {
			method: 'POST',
			body: JSON.stringify({ id }),
			headers: {
				'Content-Type': 'application/json'
			}
		});
		authenticated.verify();
		const data = await response.json();
		return data;
	};

	const activateUser = async (id: number) => {
		const response = await fetch('/api/admin/users/activate', {
			method: 'POST',
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
			editFields={[EmailField, UserTypeField]}
			getItemsAction={getAllUsers}
			editAction={updateUser}
			deleteAction={deleteUser}
			deactivateAction={deactivateUser}
			activateAction={activateUser}
			tableFieldFormatters={{ user_type: (value) => value.toUpperCase() }}
			tableHeaders={['Email', 'User Type', 'Active', '']}
			tableName={'User Management'}
		/>
	</div>
</div>
