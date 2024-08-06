import AppUrls from '$lib/enums/AppUrls';

export const load = ({ params }) => {
	return {
		slug: params.slug
	};
};

/** @type {import('./$types').EntryGenerator} */
export function entries() {
	return Object.values(AppUrls).map((slug) => ({ slug }));
}
