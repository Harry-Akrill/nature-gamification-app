<script lang="ts" context="module">
	import * as t from 'io-ts';

	export const POIType = t.type({
		id: t.number,
		isFavourite: t.boolean,
		lngLat: t.type({ lng: t.number, lat: t.number }),
		name: t.string,
		description: t.string,
		features: t.array(t.string),
		likes: t.number,
		comments: t.array(t.type({ text: t.string, nickname: t.string })),
		pictures: t.array(t.string),
		checkedIn: t.boolean
	});

	export type POI = t.TypeOf<typeof POIType>;
</script>

<script lang="ts">
	import { MapLibre, Popup, Marker } from 'svelte-maplibre';
	import { Map, NavigationControl, GeolocateControl, ScaleControl } from 'maplibre-gl';
	import { onDestroy, onMount, tick } from 'svelte';
	import POIcard from './POIcard.svelte';
	import layers from '$lib/components/app/main/home/map/search-bar/layers';
	import SearchBar from '$lib/components/app/main/home/map/search-bar/SearchBar.svelte';
	import { isRight } from 'fp-ts/Either';
	import { Check, Heart, TreePine } from 'lucide-svelte';
	import { page } from '$app/stores';
	import * as Dialog from '$lib/components/ui/dialog';
	import { Button } from '$lib/components/ui/button';
	import axios, { type CancelTokenSource } from 'axios';

	const focusPOIId = $page.url.searchParams.get('focus-poi');

	let selectedMapLayer = layers.find(({ value }) => value === 'outdoor')!;

	onMount(() => {
		const preferredMapLayer = localStorage.getItem('preferredMapLayer');

		if (preferredMapLayer && layers.map(({ value }) => value).includes(preferredMapLayer)) {
			selectedMapLayer = layers.find(({ value }) => value === preferredMapLayer)!;
		}
	});

	let map: Map;
	let nav: NavigationControl;
	let geolocate: GeolocateControl;
	let scale: ScaleControl;

	let poiFeatureOptions: string[];
	let poiFeaturesFilter: string[] = [];
	let onlyShowFavourites = false;
	let searchBar: HTMLDivElement;
	let searchBarHeight = 64;

	let pointsOfInterest: POI[] = [];

	$: filteredPointsOfInterest = pointsOfInterest.filter(({ features, isFavourite, id }) => {
		if (id === idOfSelectedPOI) {
			return true;
		}

		if (
			poiFeaturesFilter.length > 0 &&
			!features.some((feature) => poiFeaturesFilter.includes(feature))
		) {
			return false;
		}

		if (onlyShowFavourites && !isFavourite) {
			return false;
		}

		return true;
	});

	let idOfSelectedPOI: number | null = null;

	let defaultCoords = { lon: 0, lat: 0 };
	let foundLocationByIP = false;
	let loading = true;
	let userLocation: { lng: number; lat: number; accuracyMeters: number };

	let checkInCandidates: POI[] = [];
	let checkInCandidatesCancelTokenSource: CancelTokenSource = axios.CancelToken.source();

	const updateSearchBarOffset = () => {
		if (searchBar) {
			searchBarHeight = searchBar.offsetHeight;
		}
	};

	const fetchCheckInCandidates = async () => {
		if (checkInCandidatesCancelTokenSource) {
			checkInCandidatesCancelTokenSource.cancel();
		}
		checkInCandidatesCancelTokenSource = axios.CancelToken.source();
		const cancelToken = checkInCandidatesCancelTokenSource.token;

		const params = new URLSearchParams({
			latitude: userLocation.lat.toString(),
			longitude: userLocation.lng.toString(),
			accuracy_meters: userLocation.accuracyMeters.toString()
		});

		const request = await axios
			.get(`/api/check-in/candidates?${params.toString()}`, {
				cancelToken
			})
			.catch((error) => error);

		if (request?.data) {
			let data = request.data;

			data = data.map((poi: any): POI | { error: boolean; message: string } => {
				const validationResult = POIType.decode(poi);

				if (isRight(validationResult)) {
					const typeSafePOI: POI = validationResult.right;
					return typeSafePOI;
				} else {
					return {
						error: true,
						message: 'Invalid POI object received from API: ' + validationResult.left
					};
				}
			});

			data = data.filter((poi: POI | { error: boolean; message: string }) => {
				if ('error' in poi && poi.error) {
					console.error(poi.message);
					return false;
				}

				return true;
			});

			checkInCandidates = data;
		}
	};

	$: userLocation !== undefined && fetchCheckInCandidates();

	let previousPOIRequestParams: {
		north: string;
		south: string;
		east: string;
		west: string;
	} | null = null;

	const sortedStringify = (obj: Record<string, string>) => {
		return JSON.stringify(obj, Object.keys(obj).sort());
	};

	let updatePOIDataCancelTokenSource: CancelTokenSource = axios.CancelToken.source();

	const updatePOIData = async () => {
		const mapBound = map.getBounds();
		const north = mapBound._ne.lat;
		const south = mapBound._sw.lat;
		const east = mapBound._ne.lng;
		const west = mapBound._sw.lng;

		const paramsFormatted = {
			north: north > 90 ? '90' : north.toString(),
			south: south < -90 ? '-90' : south.toString(),
			east: east > 180 ? '180' : east.toString(),
			west: west < -180 ? '-180' : west.toString()
		};

		if (
			previousPOIRequestParams !== null &&
			sortedStringify(previousPOIRequestParams) === sortedStringify(paramsFormatted)
		) {
			return;
		}

		if (updatePOIDataCancelTokenSource) {
			updatePOIDataCancelTokenSource.cancel();
		}
		updatePOIDataCancelTokenSource = axios.CancelToken.source();
		const cancelToken = updatePOIDataCancelTokenSource.token;

		previousPOIRequestParams = paramsFormatted;
		const params = new URLSearchParams(paramsFormatted);

		const response = await axios
			.get(`/api/poi?${params.toString()}`, {
				cancelToken
			})
			.catch((error) => error);

		if (response.status === 200 && response.data) {
			const data = response.data;

			data.forEach((newPOI: any) => {
				const validationResult = POIType.decode(newPOI);

				if (isRight(validationResult)) {
					const newPOI: POI = validationResult.right;
					if (!pointsOfInterest.some((poi) => poi.id === newPOI.id)) {
						pointsOfInterest = [...pointsOfInterest, newPOI];
					}
				} else {
					console.error('Invalid POI object received from API: ', validationResult.left);
				}
			});
		}
	};

	const fetchPOIById = async (poiId: number) => {
		// Potential early reject if POI has already been in viewport/lazily-loaded
		if (pointsOfInterest.some((poi) => poi.id === poiId)) {
			idOfSelectedPOI = poiId;
			return;
		}

		const params = new URLSearchParams({ id: poiId.toString() });

		const response = await fetch(`/api/poi/get-by-id?${params.toString()}`);

		if (response.ok) {
			const data = await response.json();

			const validationResult = POIType.decode(data);
			if (isRight(validationResult)) {
				const newPOI: POI = validationResult.right;
				if (!pointsOfInterest.some((poi) => poi.id === newPOI.id)) {
					pointsOfInterest = [...pointsOfInterest, newPOI];
					idOfSelectedPOI = newPOI.id;
				}
			} else {
				console.error('Invalid POI object received from API: ', validationResult.left);
			}
		}
	};

	const getPOIById = (id: number) => pointsOfInterest.find(({ id: _id }) => id === _id)!;

	let userNickname: string;

	let geolocationDisabled = false;
	let geolocationDisabledShowDialog = false;
	let geolocationPermissionsWatchInterval: ReturnType<typeof setInterval>;

	onDestroy(() => clearInterval(geolocationPermissionsWatchInterval));

	const registerPOIClick = (id: number) =>
		fetch('/api/stats/app/register-new-poi-click?poi_id=' + encodeURIComponent(id), {
			method: 'POST'
		});

	onMount(async () => {
		const ipGeolocationRequest = async () => {
			try {
				const response = await fetch('/api/utils/geolocation');

				if (response.ok) {
					const data = await response.json();
					if (!isNaN(parseFloat(data.lon)) && !isNaN(parseFloat(data.lat))) {
						[defaultCoords.lon, defaultCoords.lat] = [parseFloat(data.lon), parseFloat(data.lat)];
						foundLocationByIP = true;
					}
				} else {
					const response = await fetch('https://api.ipify.org?format=json');
					const data = await response.json();
					const ip = data.ip;

					if (!response.ok) return;

					const secondResponse = await fetch('/api/utils/geolocation-with-ip-param', {
						method: 'POST',
						body: JSON.stringify({ ip }),
						headers: {
							'Content-Type': 'application/json'
						}
					});

					if (!secondResponse.ok) return;
					const secondData = await secondResponse.json();

					if (!isNaN(parseFloat(secondData.lon)) && !isNaN(parseFloat(secondData.lat))) {
						[defaultCoords.lon, defaultCoords.lat] = [
							parseFloat(secondData.lon),
							parseFloat(secondData.lat)
						];
						foundLocationByIP = true;
					}
				}
			} catch (error) {
				console.error(error);
			}
		};

		const poiFeatureOptionsRequest = async () => {
			try {
				const response = await fetch('/api/poi/features');
				const data = await response.json();
				poiFeatureOptions = data.allPOIFeatures;
			} catch (error) {
				console.error(error);
			}
		};

		const getUserNicknameRequest = async () => {
			const response = await fetch('/api/settings/profile');
			const { nickname } = await response.json();
			if (nickname === undefined && typeof nickname !== 'string') return;
			userNickname = nickname;
		};

		// Make 3 fetch requests in parallel for efficiency
		await Promise.allSettled([
			ipGeolocationRequest(),
			poiFeatureOptionsRequest(),
			getUserNicknameRequest()
		]);

		loading = false;
		await tick();

		nav = new NavigationControl({
			visualizePitch: true,
			showZoom: true,
			showCompass: true
		});

		map.addControl(nav, 'bottom-right');
		nav._container.parentElement!.style.zIndex = '10';

		// Add a geolocate control to the map.
		geolocate = new GeolocateControl({
			positionOptions: {
				enableHighAccuracy: true
			},
			trackUserLocation: true
		});

		map.addControl(geolocate, 'bottom-right');
		geolocate._container.parentElement!.style.zIndex = '10';

		scale = new ScaleControl({
			maxWidth: 160,
			unit: 'metric'
		});

		map.addControl(scale, 'bottom-left');
		scale._container.parentElement!.style.zIndex = '10';

		map.on('load', async () => {
			map.resize();
			if (focusPOIId) {
				await fetchPOIById(parseInt(focusPOIId));
				const poiToBeFocused = pointsOfInterest.find(({ id }) => id === parseInt(focusPOIId));

				if (poiToBeFocused) {
					await new Promise((resolve) => {
						geolocate.on('trackuserlocationstart', () => map.once('movestart', resolve));
						geolocate.trigger();
					});

					map.stop();

					const zoomLevel = 14;
					map.flyTo({ center: poiToBeFocused.lngLat, zoom: zoomLevel, padding: { top: 300 } });
					idOfSelectedPOI = parseInt(focusPOIId);
				} else {
					geolocate.trigger();
				}
			} else {
				geolocate.trigger();
			}
		});

		map.on('pitchend', updatePOIData);

		updateSearchBarOffset();

		geolocate.on('error', () => {
			geolocationDisabled = true;
			geolocationDisabledShowDialog = true;
			geolocationPermissionsWatchInterval = setInterval(() => {
				if ('permissions' in navigator) {
					navigator.permissions.query({ name: 'geolocation' }).then((permissionStatus) => {
						if (permissionStatus.state === 'granted') {
							geolocate.trigger();
						}
					});
				}
			}, 1000);
		});

		geolocate.on(
			'trackuserlocationend',
			(e) => e.target._watchState === 'OFF' && geolocate.trigger()
		);

		geolocate.on('geolocate', (e) => {
			// eslint-disable-next-line
			const coords: GeolocationCoordinates = e.coords;
			userLocation = {
				lat: coords.latitude,
				lng: coords.longitude,
				accuracyMeters: coords.accuracy
			};
		});

		map.on('click', (e) => {
			const target = e.originalEvent.target as HTMLElement;
			if (target.dataset.testid === 'map-canvas') {
				idOfSelectedPOI = null;
			}
		});
	});
</script>

{#if loading}
	<div class="grow flex items-center justify-center">
		<span class="loading loading-ring loading-lg" />
	</div>
{:else}
	<MapLibre
		bind:map
		style={selectedMapLayer.URI}
		class="h-full w-full absolute"
		zoom={foundLocationByIP ? 6 : 1}
		center={[defaultCoords.lon, defaultCoords.lat]}
		attributionControl={false}
		on:moveend={updatePOIData}
		on:zoomend={updatePOIData}
	>
		{#each filteredPointsOfInterest as { lngLat, name, id, isFavourite, checkedIn } (id)}
			<Marker
				{lngLat}
				on:click={() => {
					idOfSelectedPOI = id;
					map.flyTo({ center: lngLat, padding: { top: 300 } });
					registerPOIClick(id);
				}}
				class={'z-10 grid h-8 w-8 place-items-center rounded-full border border-zinc-600 text-black shadow-2xl focus:outline-2 focus:outline-black' +
					(idOfSelectedPOI === id ? ' border-4 box-content' : '') +
					(checkedIn ? ' bg-cyan-300' : isFavourite ? ' bg-green-300' : ' bg-red-300')}
			>
				{#if checkedIn}
					<span class="text-xl"><Check class="h-5 w-5" /></span>
				{:else if isFavourite}
					<span class="text-xl"><Heart class="h-5 w-5" /></span>
				{:else}
					<span class="text-xl"><TreePine class="h-5 w-5" /></span>
				{/if}
				<Popup openOn="hover" offset={[0, -10]}>
					<div class="text-lg font-bold text-black">{name}</div>
				</Popup>
			</Marker>
		{/each}
	</MapLibre>
	<SearchBar
		bind:searchBar
		bind:selectedMapLayer
		{poiFeatureOptions}
		bind:poiFeaturesFilter
		bind:onlyShowFavourites
		{map}
		on:poiSelected={({ detail: poiId }) => fetchPOIById(poiId)}
		{checkInCandidates}
		{updateSearchBarOffset}
		bind:idOfSelectedPOI
		{userLocation}
		{fetchCheckInCandidates}
		bind:pointsOfInterest
	/>
	{#if idOfSelectedPOI !== null}
		{@const poi = getPOIById(idOfSelectedPOI)}
		<div
			class="absolute w-full max-w-md md:max-w-xl top-2 right-2"
			style={`margin-top: ${searchBarHeight}px;`}
		>
			<POIcard
				closePOICard={() => (idOfSelectedPOI = null)}
				{poi}
				{userNickname}
				refreshPOIs={() => (pointsOfInterest = [...pointsOfInterest])}
			/>
		</div>
	{/if}
	<Dialog.Root
		open={geolocationDisabledShowDialog}
		onOpenChange={(isOpen) => {
			if (!isOpen) {
				geolocationDisabledShowDialog = false;
			}
		}}
	>
		<Dialog.Content>
			<Dialog.Header>
				<Dialog.Description>
					Please allow geolocation permissions and turn on location services for check-in
					functionality.
				</Dialog.Description>
			</Dialog.Header>
			<Dialog.Footer>
				<Button on:click={() => (geolocationDisabledShowDialog = false)}>Close</Button>
			</Dialog.Footer>
		</Dialog.Content>
	</Dialog.Root>
{/if}
