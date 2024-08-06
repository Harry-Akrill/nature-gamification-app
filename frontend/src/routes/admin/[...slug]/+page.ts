import AdminDashboardUrls from '$lib/enums/AdminDashboardUrls';

export const load = ({ params }) => {
	return {
		slug: params.slug
	};
};

/** @type {import('./$types').EntryGenerator} */
export function entries() {
	return Object.values(AdminDashboardUrls).map((slug) => ({ slug }));
}
