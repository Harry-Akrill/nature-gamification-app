/// <reference types="@sveltejs/kit" />
/// <reference no-default-lib="true"/>
/// <reference lib="esnext" />
/// <reference lib="webworker" />

// const DB_NAME = 'db';
// const DB_VERSION = 1;

const sw = self as unknown as ServiceWorkerGlobalScope;

// import { build, files, prerendered, version } from '$service-worker';

// const cacheId = `cache${version}`;

// const cachePayloadArr = [...build, ...files, ...prerendered];

sw.addEventListener('install', () => {
	// event.waitUntil(
	// 	caches
	// 		.open(cacheId)
	// 		.then((cache) => cache.addAll(cachePayloadArr))
	// 		.then(() => sw.skipWaiting())
	// );
	sw.skipWaiting();
});

// sw.addEventListener('activate', (event) => {
// 	event.waitUntil(sw.clients.claim());
// });

// sw.addEventListener('fetch', (event) => {
// 	if (!event.request.url.startsWith('http')) {
// 		return;
// 	}

// 	const promise = new Promise((resolve: (value: Response) => void) => {
// 		const openRequest = indexedDB.open(DB_NAME, DB_VERSION);

// 		openRequest.onupgradeneeded = (event) => {
// 			const db = (event.target as IDBOpenDBRequest).result;
// 			const objectStore = db.createObjectStore('auth', { keyPath: 'id' });
// 			objectStore.createIndex('id', 'id', { unique: true });
// 		};

// 		openRequest.onsuccess = (openDBRequestEvent) => {
// 			const db = (openDBRequestEvent.target as IDBOpenDBRequest).result;

// 			const fetchRequest = event.request.clone();
// 			if (fetchRequest.headers.has('Authorization')) {
// 				fetch(event.request).then((response) => {
// 					if (response.ok) {
// 						const authHeader = fetchRequest.headers.get('Authorization');

// 						if (authHeader === null) {
// 							return resolve(response);
// 						}

// 						const transaction = db.transaction('auth', 'readwrite');
// 						const objectStore = transaction.objectStore('auth');
// 						const request = objectStore.put({ id: 0, header: authHeader });

// 						request.onsuccess = () => resolve(response);

// 						request.onerror = (e) => {
// 							console.error((e.target as IDBRequest).error);
// 							resolve(response);
// 						};
// 					} else {
// 						resolve(response);
// 					}
// 				});
// 			} else {
// 				const transaction = db.transaction('auth', 'readonly');
// 				const objectStore = transaction.objectStore('auth');
// 				const index = objectStore.index('id');
// 				const request = index.get(0);

// 				request.onsuccess = async (e) => {
// 					const result = (e.target as IDBRequest).result;
// 					if (result) {
// 						const authHeader = result.header;
// 						const headers = new Headers(fetchRequest.headers);
// 						headers.set('Authorization', authHeader);
// 						const fetchRequestModified = new Request(fetchRequest, { headers });
// 						const response = await fetch(fetchRequestModified);

// 						if (response.ok) {
// 							resolve(response);
// 						} else {
// 							const responseOfUnmodifiedRequest = await fetch(event.request);
// 							resolve(responseOfUnmodifiedRequest);
// 						}
// 					} else {
// 						const response = await fetch(fetchRequest);
// 						resolve(response);
// 					}
// 				};

// 				request.onerror = async (e) => {
// 					console.error((e.target as IDBRequest).error);
// 					const response = await fetch(fetchRequest);
// 					resolve(response);
// 				};
// 			}
// 		};

// 		openRequest.onerror = async (e) => {
// 			console.error((e.target as IDBOpenDBRequest).error);
// 			const response = await fetch(event.request);
// 			resolve(response);
// 		};
// 	});

// 	event.respondWith(promise);

// 	// event.respondWith(
// 	// 	fetch(event.request)
// 	// 		.then((response) => {
// 	// 			if (!response || response.status !== 200 || response.type !== 'basic') {
// 	// 				return response;
// 	// 			}

// 	// 			const responseToCache = response.clone();

// 	// 			caches.open(cacheId).then((cache) => {
// 	// 				try {
// 	// 					if (event.request.method === 'GET' && !event.request.url.includes('api')) {
// 	// 						cache.put(event.request, responseToCache);
// 	// 					}
// 	// 				} catch (error) {
// 	// 					console.error(error);
// 	// 				}
// 	// 			});

// 	// 			return response;
// 	// 		})
// 	// 		.catch(async () => {
// 	// 			const response = await caches.match(event.request);
// 	// 			return response ?? new Response();
// 	// 		})
// 	// );
// });
