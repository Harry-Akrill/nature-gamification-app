<script lang="ts">
	import * as Dialog from '$lib/components/ui/dialog';
	import { POIType, type POI } from './Map.svelte';
	import { Button } from '$lib/components/ui/button';
	import { isRight } from 'fp-ts/lib/Either';
	import { toast } from 'svelte-sonner';
	import { inProgressBadges } from '$lib/stores';
	import { onMount } from 'svelte';

	export let poi: POI;
	const { id, name, description, features } = poi;
	export let onClose: () => void;
	export let refreshPOIs: () => void;

	interface Comment {
		id: number;
		userId: number;
		nickname: string;
		poiId: number;
		text: string;
		rating: number;
	}

	let newComment = '';
	let newRating = 1;

	let selectedFile: File | undefined;
	let comments: Comment[] = [];

	const getComments = async (poiId: number | undefined) => {
		try {
			let url = '/api/comments';
			if (poiId !== undefined) {
				url += `?poiId=${poiId}`;
			}
			const response = await fetch(url);
			if (response.ok) {
				const data = await response.json();
				console.log('Fetched comments:', data);
				comments = data;
			} else {
				console.error('Failed to fetch comments:', response.statusText);
			}
		} catch (error) {
			console.error('Error fetching comments:', error);
		}
	};

	async function addNewComment() {
		if (newComment.trim() !== '') {
			try {
				console.log('User ID:', 1);
				console.log('POI ID:', poi.id);
				console.log('Comment Text:', newComment);
				console.log('Rating:', newRating);

				const response = await fetch('/api/comments', {
					method: 'POST',
					headers: {
						'Content-Type': 'application/json'
					},
					body: JSON.stringify({
						user_id: 1,
						poi_id: poi.id,
						text: newComment,
						rating: newRating
					})
				});
				if (response.ok) {
					getComments(poi.id);
					newComment = '';
				} else {
					console.error('Failed to add ViewDetails comment:', response.statusText);
				}
			} catch (error) {
				console.error('Error adding comment:', error);
			}
		}
	}

	async function handleUpload() {
		if (selectedFile) {
			const formData = new FormData();
			formData.append('picture', selectedFile);
			formData.append('poi_id', String(poi.id));
			try {
				const response = await fetch('/api/poi/poi-image/upload', {
					method: 'POST',
					body: formData
				});

				if (response.ok) {
					syncPOIPictures(poi.id);
					toast.success('Successfully added picture for POI!');
					inProgressBadges.checkForUpdates();
					onClose();
				}
			} catch (error) {
				console.error('Error uploading file:', error);
			}
		}
	}

	const VALID_TYPES = ['image/png', 'image/jpg', 'image/jpeg'];
	function selectFile(event: Event) {
		const input = event.target as HTMLInputElement;
		if (
			input &&
			input.files &&
			input.files.length > 0 &&
			VALID_TYPES.includes(input.files[0].type)
		) {
			selectedFile = input.files[0];
		} else {
			selectedFile = undefined;
		}
	}

	const syncPOIPictures = async (poiId: number) => {
		const params = new URLSearchParams({ id: poiId.toString() });

		const response = await fetch(`/api/poi/get-by-id?${params.toString()}`);

		if (response.ok) {
			const data = await response.json();

			const validationResult = POIType.decode(data);
			if (isRight(validationResult)) {
				const updatedPOI: POI = validationResult.right;
				poi.pictures = updatedPOI.pictures;
				refreshPOIs();
			} else {
				console.error('Invalid POI object received from API: ', validationResult.left);
			}
		}
	};

	async function reportComment(commentId: number): Promise<void> {
		try {
			const response = await fetch(`/api/comments/${commentId}/report`, {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({ reported: true })
			});
			if (response.ok) {
				toast.success('Comment reported successfully.');
			} else {
				throw new Error('Failed to report comment.');
			}
		} catch (error) {
			console.error('Error reporting comment:', error);
			toast.error('An error occurred while reporting the comment.');
		}
	}

	onMount(() => {
		getComments(poi.id);
	});
</script>

<Dialog.Root open={true} onOpenChange={(newOpenValue) => newOpenValue || onClose()}>
    <Dialog.Content class = "max-h-[90%] overflow-y-auto p-4 "style="max-width:max(70%, 800px);">
        <!-- Display the details using the props -->
        <div class="flex flex-col items-center w-full max-w-full mx-auto bg-gray-800 rounded-lg p-8">
            <h2 class="text-2xl font-bold text-white">{name}</h2>
            <p class="text-white">ID: {id}</p>

            <!-- Comments container with separate scroll -->
            <div class="comment-container mt-8 overflow-y-auto max-h-48" style="width: 80%;"> <!-- Adjust width as needed -->
                <h3 class="text-lg font-bold text-white mb-4">Comments</h3>
                <div class="comments-scroll">
                    <div class="comment-header flex items-center bg-gray-700 text-white py-2 px-4 mb-4">
                        <div class="w-1/4">User</div>
                        <div class="w-1/2">Review</div>
                        <div class="w-1/6">Rating </div>
                        <div class="w-1/6">Report </div>
                        <!-- No header for the fourth column -->
                    </div>

                    {#each comments as comment, i}
                        <div class="comment-wrapper flex items-center justify-between px-4 mb-4 w-full">
                            <div class="comment-info w-1/4"> <!-- Adjust width as needed, e.g., w-1/3 -->
                                <div class="user-name text-white">{comment.nickname}</div>
                            </div>
                            <div class="comment-info w-1/4"> <!-- Adjust width as needed, e.g., w-1/2 -->
                                <div class="comment-text text-white break-words">{comment.text}</div>
                            </div>                            
                            <div class="comment-info w-1/6"> <!-- Adjust width as needed, e.g., w-1/6 -->
                                <div class="comment-rating text-white">{comment.rating}</div>
                            </div>
                            <div class="comment-info w-1/6"> <!-- Fourth column for report buttons -->
                                <button class="report-button py-2 px-4 bg-red-600 text-white rounded-lg" on:click={() => reportComment(comment.id)}>Report</button>
                            </div>
                        </div>
                    {/each}

                </div>
            </div>
                    


            <!-- Textarea for user to input comments -->
            <textarea class="comment-input mt-4 w-full rounded-lg px-4 py-2" bind:value={newComment} placeholder="Type your comment here..."></textarea>

			<div class="rating-container mt-4">
				<label for="rating" class="text-white">Rating:</label>
				<input
					id="rating"
					type="number"
					min="1"
					max="5"
					bind:value={newRating}
					class="w-full rounded-lg px-4 py-2 bg-gray-700 text-white"
				/>
			</div>

			<button on:click={addNewComment} class="bg-blue-500 text-white rounded-lg px-4 py-2 mt-4"
				>Add Comment</button
			>
		</div>

		<div class="mb-4 text-white rounded shadow-md mt-6 w-full md:w-3/4 lg:w-1/2">
			<div class="mb-4">
				<label for="poi-picture">Upload a picture of this location!</label>
				<input
					id="poi-picture"
					type="file"
					accept="image/png, image/jpg, image/jpeg"
					on:change={selectFile}
					class="mt-1 block w-full rounded-md text-white shadow-sm focus:border-green-300"
				/>
			</div>

			<Button variant="secondary" class="mt-4" on:click={handleUpload}>Upload Picture</Button>
		</div>
	</Dialog.Content>
</Dialog.Root>
