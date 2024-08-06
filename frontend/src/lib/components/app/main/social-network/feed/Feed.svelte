<script lang="ts">
	import { onMount } from 'svelte';
	import { Textarea } from '$lib/components/ui/textarea/index.js';
	import { Input } from '$lib/components/ui/input/index.js';
	import { Button } from '$lib/components/ui/button';
	import * as Card from '$lib/components/ui/card/index.js';
	import { Trash, Pencil, Check, ClipboardX, ThumbsUp } from 'lucide-svelte';

	let content = '';
	let isEditing: { [key: string]: boolean } = {};
	let editedText: { [key: string]: string } = {};
	let posts: any[] = [];
	let commentContent: any = {};

	let current_user: { id: any } | null = null;

	onMount(async () => {
		const response = await fetch('/api/social/users/show', {});
		if (response.ok) {
			current_user = await response.json();
		}
	});

	const createPost = async () => {
		const response = await fetch('/api/social/posts', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ content })
		});
		if (response.ok) {
			content = '';
			await fetchPosts();
		} else {
			console.error('Post creation failed');
		}
	};

	const fetchPosts = async () => {
		const response = await fetch('/api/social/posts', {});
		if (response.ok) {
			posts = await response.json();
		} else {
			console.error('Failed to get posts');
		}
	};

	const updatePost = async (postId: string | number, editedText: string) => {
		const response = await fetch(`/api/social/posts/${postId}`, {
			method: 'PUT',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ post: { content: editedText } })
		});
		if (response.ok) {
			isEditing[postId] = false;
			await fetchPosts();
		} else {
			console.error('Post editing failed');
		}
	};

	const deletePost = async (postId: any) => {
		const response = await fetch(`/api/social/posts/${postId}`, {
			method: 'DELETE'
		});
		if (response.ok) {
			await fetchPosts();
		} else {
			console.error('Post deletion failed');
		}
	};

	const likePost = async (postId: any) => {
		const response = await fetch(`/api/social/posts/${postId}/like`, {
			method: 'POST'
			// headers: {
			// 	Authorization: `Bearer ${localStorage.getItem('jwt')}`
			// }
		});
		if (response.ok) {
			await fetchPosts();
		} else {
			console.error('Post liking failed');
		}
	};

	async function createComment(postId: any) {
		const response = await fetch(`/api/social/posts/${postId}/comments`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ content: commentContent[postId] } as { content: string })
		});

		if (!response.ok) {
			console.error('Post comment failed');
		}

		fetchPosts();
		commentContent[postId] = '';
	}

	async function deleteComment(postId: any, commentId: any) {
		const response = await fetch(`/api/social/posts/${postId}/comments/${commentId}`, {
			method: 'DELETE'
		});
		if (response.ok) {
			await fetchPosts();
		} else {
			console.error('Comment deletion failed');
		}
	}

	onMount(fetchPosts);
</script>

<Textarea
	bind:value={content}
	class="px-4 mb-2 focus-visible:mx-1 focus-visible:mt-1 focus-visible:w-[calc(100%-0.5rem)]"
	placeholder="What's on your mind?"
/>
<Button
	variant="outline"
	on:click={() => {
		if (content.trim() !== '') {
			createPost();
		} else {
			alert('You cannot make an empty post!');
		}
	}}>Post</Button
>

{#each posts as post (post.id)}
	<Card.Root class="card m-2">
		<Card.Header>
			<Card.Title>{post.user.nickname}</Card.Title>

			{#if post.user.id === (current_user && current_user.id)}
				<div class="button-container">
					<Button
						on:click={() => {
							isEditing[post.id] = true;
							editedText[post.id] = post.content;
						}}
						class="icon-button"
					>
						<Pencil class="h-5 w-5" />
					</Button>
					<Button
						on:click={() => {
							if (confirm('Are you sure you want to delete this post?')) {
								deletePost(post.id);
							}
						}}
						class="icon-button bg-red-400 hover:bg-red-500"><Trash class="h-5 w-5" /></Button
					>
				</div>
			{/if}

			<Card.Description>
				{#if post.updated_at !== post.created_at}
					{new Date(post.updated_at).toLocaleDateString('en-UK', {
						year: 'numeric',
						month: 'long',
						day: 'numeric',
						hour: '2-digit',
						minute: '2-digit'
					})}
					<span> (edited)</span>
				{:else}
					{new Date(post.created_at).toLocaleDateString('en-UK', {
						year: 'numeric',
						month: 'long',
						day: 'numeric',
						hour: '2-digit',
						minute: '2-digit'
					})}
				{/if}
			</Card.Description>
		</Card.Header>

		<Card.Content>
			{#if isEditing[post.id]}
				<form class="flex w-full max-w-sm items-center space-x-2">
					<Input class="max-w-xs" bind:value={editedText[post.id]} />
					<Button
						on:click={() => {
							if (editedText[post.id].trim() !== '') {
								updatePost(post.id, editedText[post.id]);
							} else {
								alert('Post content cannot be empty');
							}
						}}><Check class="icon-button h-3 w-3" /></Button
					>
					<Button
						on:click={() => (isEditing[post.id] = false)}
						class="icon-button bg-red-400 hover:bg-red-500"><ClipboardX class="h-3 w-3" /></Button
					>
				</form>
			{:else}
				<div class="flex justify-between items-center">
					<p>{post.content}</p>
					<div class="flex items-center">
						<Button
							on:click={() => {
								console.log(`liked: ${post.id}`);
								likePost(post.id);
							}}
							><div class="flex space-x-1">
								<ThumbsUp /><span>{post.likes_count}</span>
							</div></Button
						>
					</div>
				</div>
			{/if}

			{#each post.comments as comment (comment.id)}
				<Card.Root class="mt-4">
					<Card.Header>
						<Card.Title>{comment.user.nickname}</Card.Title>
						<Card.Description>
							{new Date(comment.created_at).toLocaleDateString('en-UK', {
								year: 'numeric',
								month: 'long',
								day: 'numeric',
								hour: '2-digit',
								minute: '2-digit'
							})}
						</Card.Description>
					</Card.Header>
					<Card.Content>
						<p>{comment.content}</p>

						{#if comment.user.id === (current_user && current_user.id)}
							<div class="flex justify-end mt-4">
								<Button
									on:click={() => {
										if (confirm('Are you sure you want to delete this comment?')) {
											console.log(post.id, comment.id);
											deleteComment(post.id, comment.id);
										}
									}}
									class="icon-button bg-red-400 hover:bg-red-500"><Trash class="h-5 w-5" /></Button
								>
							</div>
						{/if}
					</Card.Content>
				</Card.Root>
			{/each}

			<form
				on:submit|preventDefault={() => createComment(post.id)}
				class="flex justify-between mt-4"
			>
				<Input
					bind:value={commentContent[post.id]}
					placeholder="Write a comment..."
					class="w-full mr-2"
				/>
				<button type="submit" disabled={!commentContent[post.id]}>Submit</button>
			</form>
		</Card.Content>
	</Card.Root>
{/each}

<style>
	.button-container {
		position: absolute;
		top: 10px;
		right: 10px;
	}
</style>
