<script lang="ts">
	import * as Card from '$lib/components/ui/card';
	import { Button } from '$lib/components/ui/button';
	import { quintOut } from 'svelte/easing';
	import { fly } from 'svelte/transition';
	import * as Carousel from '$lib/components/ui/carousel/index.js';
	import ViewDetailsPOI from './ViewDetailsPOI.svelte';
	import type { POI } from './Map.svelte';
	import * as HoverCard from '$lib/components/ui/hover-card';
	import { Toggle } from '$lib/components/ui/toggle';
	import { Heart } from 'lucide-svelte';
	import { tick } from 'svelte';
	import { Label } from '$lib/components/ui/label';
	import * as Accordion from '$lib/components/ui/accordion';
	import * as Dialog from '$lib/components/ui/dialog';

	export let poi: POI;
	export let userNickname: string;

	// Define closePOICard function prop
	export let closePOICard: () => void;
	export let refreshPOIs: () => void;

	let detailsOpen = false;
	let allPicturesOpen = false;
	let pictureFullScreen: number | null = null;

	let hoverCardsOpened = [false];

	const closeAllHoverCards = () => {
		hoverCardsOpened = new Array(hoverCardsOpened.length).fill(false);
	};

	const syncFavouritePOIToggle = async () => {
		const response = await fetch('/api/favourites/single?poi_id=' + encodeURIComponent(poi.id));
		const data = await response.json();
		if (typeof data !== 'boolean') return;
		poi.isFavourite = !poi.isFavourite;
		await tick();

		poi.isFavourite = data;
	};

	const overrideInitialFavouriteToggleUIUpdate = async () => {
		const oldValue = poi.isFavourite;
		poi.isFavourite = !poi.isFavourite;
		await tick();

		poi.isFavourite = oldValue;
	};

	let favouriteUpdateInProgress = false;
	const updateFavourite = async (newValue: boolean) => {
		overrideInitialFavouriteToggleUIUpdate();
		if (favouriteUpdateInProgress) return;
		favouriteUpdateInProgress = true;
		if (newValue) {
			await fetch('/api/favourites?poi_id=' + encodeURIComponent(poi.id), { method: 'POST' });
		} else {
			await fetch('/api/favourites?poi_id=' + encodeURIComponent(poi.id), {
				method: 'DELETE'
			});
		}
		await syncFavouritePOIToggle();
		refreshPOIs();
		favouriteUpdateInProgress = false;
	};
</script>

<div
	class={'z-20 absolute w-full flex pl-4' + (poi.pictures.length === 0 ? ' h-72' : ' h-80')}
	transition:fly={{ duration: 300, x: 200, y: 0, opacity: 0, easing: quintOut }}
>
	<Card.Root class="flex flex-col grow relative w-full">
		<Card.Header class="p-3">
			<Card.Title>
				<div class="flex justify-between items-center gap-2">
					<p class="max-sm:text-sm">{poi.name}</p>
					<HoverCard.Root
						bind:open={hoverCardsOpened[0]}
						openDelay={0}
						closeDelay={0}
						onOutsideClick={(e) => {
							closeAllHoverCards();
							e.target.focus();
						}}
					>
						<HoverCard.Trigger>
							<Toggle
								class="max-sm:p-2 max-sm:h-auto text-secondary-foreground hover:text-accent-foreground data-[state=off]:hover:bg-accent data-[state=off]:bg-background data-[state=on]:bg-primary data-[state=on]:hover:brightness-90 data-[state=on]:text-error-content"
								pressed={poi.isFavourite}
								onPressedChange={updateFavourite}
								><div class="flex gap-2 items-center max-sm:text-xs">
									{poi.isFavourite ? 'Remove From Favourites' : 'Add To Favourites'}<Heart
										class="max-sm:w-4 max-sm:h-4"
									/>
								</div></Toggle
							>
						</HoverCard.Trigger>
						<HoverCard.Content class="w-fit h-fit py-2 px-2.5">
							<div class="text-xs flex items-center">Add/Remove Favourite</div>
						</HoverCard.Content>
					</HoverCard.Root>
				</div>
			</Card.Title>
		</Card.Header>
		<Card.Content class="grow p-3 pt-0 flex flex-col overflow-y-auto gap-2">
			{#if poi.pictures.length === 0}
				<Card.Root class="mb-2">
					<Card.Content class="p-2">
						<p class="text-center">No Pictures available for this Point of Interest</p>
					</Card.Content>
				</Card.Root>
			{:else}
				<Accordion.Root>
					<Accordion.Item value="poi-pictures" class="border-b-0">
						<Accordion.Trigger
							class="hover:no-underline transition-colors hover:bg-secondary/70 rounded-md px-3 py-2"
							><div class="flex justify-between items-center grow mr-4">
								<p>Pictures:</p>
								<Button
									size="sm"
									on:click={(e) => {
										e.stopPropagation();
										allPicturesOpen = true;
									}}>All Pictures</Button
								>
							</div></Accordion.Trigger
						>
						<Accordion.Content class="p-0 *:p-0 mt-2">
							<Carousel.Root class="w-full">
								<Carousel.Content>
									{#each Array(Math.ceil(poi.pictures.length / 3)) as _, index (index)}
										<Carousel.Item>
											<div class="flex relative gap-4 h-24">
												<!-- svelte-ignore a11y-click-events-have-key-events -->
												<!-- svelte-ignore a11y-no-static-element-interactions -->
												<div
													class="basis-1/3 relative h-full"
													on:click={() => (pictureFullScreen = index * 3)}
												>
													<Card.Root
														class="p-1 relative h-full bg-background transition-colors hover:bg-secondary/70 cursor-pointer"
													>
														<Card.Content
															class="p-2 flex justify-center items-center relative h-full"
														>
															<img
																src={poi.pictures[index * 3]}
																alt={'Picture ' + (index * 3 + 1)}
																class="object-contain rounded-xl h-full"
															/>
														</Card.Content>
													</Card.Root>
												</div>
												{#if poi.pictures[index * 3 + 1] !== undefined}
													<!-- svelte-ignore a11y-click-events-have-key-events -->
													<!-- svelte-ignore a11y-no-static-element-interactions -->
													<div
														class="basis-1/3 relative h-full"
														on:click={() => (pictureFullScreen = index * 3 + 1)}
													>
														<Card.Root
															class="p-1 relative h-full bg-background transition-colors hover:bg-secondary/70 cursor-pointer"
														>
															<Card.Content
																class="p-2 flex justify-center items-center relative h-full"
															>
																<img
																	src={poi.pictures[index * 3 + 1]}
																	alt={'Picture ' + (index * 3 + 2)}
																	class="object-contain rounded-xl h-full"
																/>
															</Card.Content>
														</Card.Root>
													</div>
												{/if}
												{#if poi.pictures[index * 3 + 2] !== undefined}
													<!-- svelte-ignore a11y-click-events-have-key-events -->
													<!-- svelte-ignore a11y-no-static-element-interactions -->
													<div
														class="basis-1/3 relative h-full"
														on:click={() => (pictureFullScreen = index * 3 + 2)}
													>
														<Card.Root
															class="p-1 relative h-full bg-background transition-colors hover:bg-secondary/70 cursor-pointer"
														>
															<Card.Content
																class="p-2 flex justify-center items-center relative h-full"
															>
																<img
																	src={poi.pictures[index * 3 + 2]}
																	alt={'Picture ' + (index * 3 + 3)}
																	class="object-contain rounded-xl h-full"
																/>
															</Card.Content>
														</Card.Root>
													</div>
												{/if}
											</div>
										</Carousel.Item>
									{/each}
								</Carousel.Content>
							</Carousel.Root>
						</Accordion.Content>
					</Accordion.Item>
				</Accordion.Root>
			{/if}
			<Label for="description">Description:</Label>
			<Card.Root class="p-0">
				<Card.Content class="px-3 py-2 max-h-16 overflow-y-auto">
					<p id="description" class="text-muted-foreground">
						{poi.description || 'No description…'}
					</p>
				</Card.Content>
			</Card.Root>
			<Label for="features">Features:</Label>
			<Card.Root class="p-0">
				<Card.Content class="px-3 py-2 max-h-16 overflow-y-auto">
					{#if poi.features.length === 0}
						<p id="features" class="text-muted-foreground">No features…</p>
					{:else}
						<ul id="features" class="list-disc ml-2">
							{#each poi.features as feature}
								<li class="text-muted-foreground">{feature}</li>
							{/each}
						</ul>
					{/if}
				</Card.Content>
			</Card.Root>
		</Card.Content>
		<Card.Footer class="flex justify-between p-3 grow-0 gap-2">
			<Button
				size="sm"
				class="basis-1/3"
				href={`https://www.google.com/maps/dir/?api=1&destination=${encodeURIComponent(
					poi.lngLat.lat
				)},${encodeURIComponent(poi.lngLat.lng)}`}
				target="_blank">Navigate</Button
			>
			<Button variant="secondary" size="sm" class="basis-1/3" on:click={() => (detailsOpen = true)}
				>View Details</Button
			>
			<Button variant="secondary" size="sm" class="basis-1/3" on:click={closePOICard}>Close</Button>
		</Card.Footer>
	</Card.Root>
</div>

{#if detailsOpen}
	<ViewDetailsPOI bind:poi {refreshPOIs} onClose={() => (detailsOpen = false)} {userNickname} />
{/if}

{#if allPicturesOpen}
	<Dialog.Root
		open={true}
		onOpenChange={(newOpenValue) => newOpenValue || (() => (allPicturesOpen = false))()}
	>
		<Dialog.Content class="max-h-[90%] max-w-[90%] overflow-y-auto p-4">
			<Dialog.Header>
				<Dialog.Title class="mb-4">All Pictures</Dialog.Title>
				<Dialog.Description>
					<div class="grid grid-cols-4 max-sm:grid-cols-2 max-sm:grid-rows-2 gap-2">
						{#each poi.pictures as picture, index (picture)}
							<Card.Root>
								<!-- svelte-ignore a11y-click-events-have-key-events -->
								<!-- svelte-ignore a11y-no-static-element-interactions -->
								<div on:click={() => (pictureFullScreen = index)}>
									<Card.Header
										class="p-2 transition-colors hover:bg-secondary/70 rounded-lg cursor-pointer"
									>
										<Card.Description>
											<Card.Content class="p-2 flex justify-center items-center relative h-24">
												<img
													src={picture}
													alt={'Picture ' + (index * 3 + 1)}
													class="object-contain rounded-xl h-full"
												/>
											</Card.Content>
										</Card.Description>
									</Card.Header>
								</div>
							</Card.Root>
						{/each}
					</div>
				</Dialog.Description>
			</Dialog.Header>
		</Dialog.Content>
	</Dialog.Root>
{/if}

{#if pictureFullScreen !== null}
	<Dialog.Root
		open={true}
		onOpenChange={(newOpenValue) => newOpenValue || (() => (pictureFullScreen = null))()}
	>
		<Dialog.Content class="h-[90%] max-w-[90%] overflow-y-auto p-8">
			<Dialog.Header>
				<Dialog.Description class="flex grow">
					<Card.Root class="flex grow">
						<Card.Header class="p-2 flex grow">
							<Card.Description class="flex grow">
								<Card.Content class="p-2 flex justify-center items-center grow relative">
									<!-- svelte-ignore a11y-img-redundant-alt -->
									<img
										src={poi.pictures[pictureFullScreen]}
										alt="Fullscreen POI picture"
										class="object-contain rounded-xl h-full"
									/>
								</Card.Content>
							</Card.Description>
						</Card.Header>
					</Card.Root>
				</Dialog.Description>
			</Dialog.Header>
		</Dialog.Content>
	</Dialog.Root>
{/if}
