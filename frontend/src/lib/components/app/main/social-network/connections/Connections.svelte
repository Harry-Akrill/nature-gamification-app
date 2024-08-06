<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import * as Card from '$lib/components/ui/card/index.js';
	import { Search } from 'lucide-svelte';
	import { onMount } from 'svelte';
	import { toast } from 'svelte-sonner';
	import * as Command from '$lib/components/ui/command';

	let current_user: { id: any } | null = null;
	let users: any[] = [];
	let friends: any[] = [];
	let incomingFriendRequests: any[] = [];
	let outgoingFriendRequests: any[] = [];
	let blockedUsers: string | any[] = [];
	let open = false;
	let loading = false;
	let searchQuery: string;
	let matchingUsers: any[] = [];

	const fetchUsers = async () => {
		const response = await fetch('/api/social/users', {
			method: 'GET',
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			const message = `[Connections.svelte] ERROR: ${response.status}`;
			throw new Error(message);
		}

		users = await response.json();
	};

	const fetchFriends = async () => {
		const response = await fetch('/api/social/friends', {
			method: 'GET',
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			const message = `[Connections.svelte] ERROR: ${response.status}`;
			throw new Error(message);
		}

		friends = await response.json();

		const blockedResponse = await fetch('/api/social/blocks', {
			method: 'GET',
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!blockedResponse.ok) {
			const message = `[Connections.svelte] ERROR: ${blockedResponse.status}`;
			throw new Error(message);
		}

		const blockedUsers = await blockedResponse.json();
		const unblockedUsers = friends.filter((user: { id: any }) => !blockedUsers.includes(user.id));

		friends = unblockedUsers;
	};

	const fetchFriendRequests = async () => {
		const response = await fetch('/api/social/friend_requests', {
			method: 'GET',
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			const message = `[Connections.svelte] ERROR: ${response.status}`;
			throw new Error(message);
		}

		const data = await response.json();
		incomingFriendRequests = data.incoming;
		outgoingFriendRequests = data.outgoing;
	};

	const sendFriendRequest = async (userId: any) => {
		await fetchFriendRequests();
		if (outgoingFriendRequests.some((request) => String(request.friend_id) === String(userId))) {
			toast.warning('Friend request already sent!');
			return;
		}
		const response = await fetch('/api/social/friend_requests', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ friend_id: userId })
		});

		if (response.ok) {
			toast.success('Friend request sent!');
		} else {
			const message = `[Connections.svelte] ERROR: ${response.status}`;
			throw new Error(message);
		}

		fetchUsers();
		fetchFriends();
		fetchFriendRequests();
	};

	const acceptFriendRequest = async (friendRequestId: any) => {
		const response = await fetch(`/api/social/friend_requests/${friendRequestId}`, {
			method: 'PUT',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ friend_id: friendRequestId })
		});

		if (!response.ok) {
			const message = `[Connections.svelte] ERROR: ${response.status}`;
			throw new Error(message);
		}

		fetchUsers();
		fetchFriends();
		fetchFriendRequests();
	};

	const rejectFriendRequest = async (friendRequestId: any) => {
		const response = await fetch(`/api/social/friend_requests/${friendRequestId}`, {
			method: 'DELETE',
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			const message = `[Connections.svelte] ERROR: ${response.status}`;
			throw new Error(message);
		}

		fetchUsers();
		fetchFriends();
		fetchFriendRequests();
	};

	const deleteFriend = async (friendId: any) => {
		const response = await fetch(`/api/social/friends/${friendId}`, {
			method: 'DELETE',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ id: friendId })
		});

		if (!response.ok) {
			const message = `[Connections.svelte] ERROR: ${response.status}`;
			throw new Error(message);
		}

		fetchUsers();
		fetchFriends();
		fetchFriendRequests();
	};

	const blockUser = async (userId: any) => {
		const response = await fetch(`/api/social/users/block/${userId}`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			const message = `[Connections.svelte] ERROR: ${response.status}`;
			throw new Error(message);
		} else {
			deleteFriend(userId);
		}

		rejectFriendRequest(userId);
		fetchUsers();
		fetchFriends();
		fetchBlockedUsers();
	};

	const unblockUser = async (userId: any) => {
		const response = await fetch(`/api/social/users/unblock/${userId}`, {
			method: 'DELETE',
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			const message = `[Connections.svelte] ERROR: ${response.status}`;
			throw new Error(message);
		}

		fetchUsers();
		fetchFriends();
		fetchBlockedUsers();
	};

	const fetchBlockedUsers = async () => {
		const response = await fetch('/api/social/blocks', {
			method: 'GET',
			headers: {
				'Content-Type': 'application/json'
			}
		});

		if (!response.ok) {
			const message = `[Connections.svelte] ERROR: ${response.status}`;
			throw new Error(message);
		}

		blockedUsers = await response.json();
		fetchUsers();
		fetchFriends();
		fetchFriendRequests();
	};

	const searchUsers = async () => {
		loading = true;
		const response = await fetch(
			`/api/social/users/search-by-nickname?nickname=${encodeURIComponent(searchQuery)}`
		);
		let data = await response.json();

		// remove current usr from search results to stop them adding self
		data = data.filter((user: { id: any }) => user.id !== current_user?.id);
		matchingUsers = data;
		loading = false;
	};

	// get random users from the list of all and put them in peopke you might know
	function getRandomUsers(users: any[]) {
		const shuffledUsers = users.sort(() => 0.5 - Math.random());
		return shuffledUsers.slice(0, 5);
	}

	// grab users, friends, frienqRequests and blocked users from the API
	onMount(fetchUsers);
	onMount(fetchFriends);
	onMount(fetchFriendRequests);
	onMount(fetchBlockedUsers);

	// get current user from API
	onMount(async () => {
		const response = await fetch('/api/social/users/show', {});
		if (response.ok) {
			current_user = await response.json();
		}
	});

	$: if (searchQuery?.trim()) {
		searchUsers();
	}

	$: users = users.filter(
		(user) =>
			Array.isArray(blockedUsers) &&
			!blockedUsers.some((blockedUser: { id: any }) => blockedUser.id === user.id)
	);
</script>

<h1 class="text-xl font-bold mb-4">Your Connections</h1>
<Button
	on:click={() => {
		searchQuery = '';
		open = true;
	}}
	class="text-secondary-foreground w-full bg-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input hover:bg-accent hover:text-accent-foreground mb-4"
>
	<div class="flex gap-2 items-center">
		<Search />
		<p class="text-sm">Search users...</p>
	</div>
</Button>

<Command.Dialog bind:open shouldFilter={false} loop>
	<Command.Input placeholder={'Search by name…'} bind:value={searchQuery} />
	<Command.List class="my-2">
		{#if loading}
			<Command.Loading>
				<div class="h-[300px] w-full flex items-center justify-center">
					<span class="loading loading-ring loading-lg" />
				</div>
			</Command.Loading>
		{:else if matchingUsers.length === 0}
			<Command.Empty class="h-[300px] flex items-center justify-center"
				>No results found.</Command.Empty
			>
		{:else}
			<p class="px-4 py-2 font-medium leading-none">User Search</p>
			<Command.Group>
				{#each matchingUsers as user (user.id)}
					<Command.Item
						value={user.id.toString()}
						onSelect={(id) => {
							// add friend request, close dialogue
							sendFriendRequest(id);
							open = false;
						}}
						class="cursor-pointer"
					>
						<div class="flex flex-col w-full gap-2">
							<div class="flex justify-between gap-4">
								<p>{user.nickname}</p>
								<!-- This is a kinda fake button - you can just press the whole item to add friend -->
								<Button>Add Friend</Button>
							</div>
						</div>
					</Command.Item>
				{/each}
			</Command.Group>
		{/if}
	</Command.List>
</Command.Dialog>

{#if friends.length === 0}
	<p class="mb-8">Add some friends to get started!</p>
{:else}
	<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 mb-8">
		{#each friends as friend}
			<Card.Root class="card">
				<Card.Header>
					<Card.Title>{friend.nickname}</Card.Title>
				</Card.Header>
				<Card.Content>
					<Button
						class="bg-red-500 text-white"
						on:click={() => {
							deleteFriend(friend.id);
						}}>Delete</Button
					>
					<Button
						class="bg-yellow-500 text-white"
						on:click={() => {
							blockUser(friend.id);
						}}>Block</Button
					>
				</Card.Content>
			</Card.Root>
		{/each}
	</div>
{/if}

{#if incomingFriendRequests.length !== 0}
	<h1 class="text-xl font-bold mb-4">Received Friend Requests</h1>
	<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 mb-8">
		{#each incomingFriendRequests as incomingFriend}
			<Card.Root class="card">
				<Card.Header>
					<Card.Title>{incomingFriend.user ? incomingFriend.user.nickname : 'Unknown'}</Card.Title>
				</Card.Header>

				<Card.Content>
					<Button
						on:click={() => {
							acceptFriendRequest(incomingFriend.id);
						}}>Accept</Button
					>
					<Button
						class="bg-red-500 text-white"
						on:click={() => {
							rejectFriendRequest(incomingFriend.id);
						}}>Reject</Button
					>
				</Card.Content>
			</Card.Root>
		{/each}
	</div>
{/if}

{#if users.length !== 0}
	<h1 class="text-xl font-bold mb-4">People you might know</h1>
	<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 mb-8">
		{#each getRandomUsers(users) as user}
			<Card.Root class="card">
				<Card.Header>
					<Card.Title>{user.nickname}</Card.Title>
				</Card.Header>

				<Card.Content>
					<Button on:click={() => sendFriendRequest(user.id)}>Add Friend</Button>
				</Card.Content>
			</Card.Root>
		{/each}
	</div>
{/if}

{#if outgoingFriendRequests.length !== 0}
	<h1 class="text-xl font-bold mb-4">Sent Friend Requests</h1>
	<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 mb-8">
		{#each outgoingFriendRequests as outgoingFriend}
			<Card.Root class="card">
				<Card.Header>
					<Card.Title
						>{outgoingFriend.friend ? outgoingFriend.friend.nickname : 'Unknown'}</Card.Title
					>
				</Card.Header>
			</Card.Root>
		{/each}
	</div>
{/if}

{#if blockedUsers.length !== 0}
	<h1 class="text-xl font-bold mb-4">Blocked</h1>
	<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 mb-8">
		{#each blockedUsers as user}
			<Card.Root class="card">
				<Card.Header>
					<Card.Title>{user.nickname}</Card.Title>
				</Card.Header>
				<Card.Content>
					<Button on:click={() => unblockUser(user.id)}>Unblock User</Button>
				</Card.Content>
			</Card.Root>
		{/each}
	</div>
{/if}
