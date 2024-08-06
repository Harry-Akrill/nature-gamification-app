<script lang="ts">
	import Header from '$lib/components/admin/header/Header.svelte';
	import SideMenu from '$lib/components/admin/sidemenu/SideMenu.svelte';
	import AdminDashboardUrls from '$lib/enums/AdminDashboardUrls';
	import Overview from '$lib/components/admin/main/overview/Overview.svelte';
	import Users from '$lib/components/admin/main/users/Users.svelte';
	import Reviews from '$lib/components/admin/main/reviews/Reviews.svelte';
	import QA from '$lib/components/admin/main/questions/QA.svelte';
	import MailingList from '$lib/components/admin/main/mailinglist/MailingList.svelte';
	import ManagePOIs from '$lib/components/admin/main/managepois/ManagePOIs.svelte';
	import Comments from '$lib/components/admin/main/comments/Comments.svelte';

	import Stats from '$lib/components/admin/main/stats/Stats.svelte';
	import type { SvelteComponent } from 'svelte';

	export let data: { slug: string };
	let menuClosed = true;
	let mainComponent: (new (...args: any[]) => SvelteComponent) | null = null;

	$: {
		switch (data.slug.split('/')[0]) {
			case AdminDashboardUrls.USERS:
				mainComponent = Users;
				break;
			case AdminDashboardUrls.REVIEWS:
				mainComponent = Reviews;
				break;
			case AdminDashboardUrls.QA:
				mainComponent = QA;
				break;
			case AdminDashboardUrls.MAILING_LIST:
				mainComponent = MailingList;
				break;
			case AdminDashboardUrls.MANAGE_POIS:
				mainComponent = ManagePOIs;
				break;
			case AdminDashboardUrls.COMMENTS:
				mainComponent = Comments;
				break;
			case AdminDashboardUrls.STATS:
				mainComponent = Stats;
				break;
			default:
				mainComponent = Overview;
				break;
		}
	}
</script>

<Header bind:menuClosed />
<div class="relative flex grow height">
	<div class="overflow-y-auto shrink-0">
		<SideMenu bind:menuClosed slug={data.slug} />
	</div>
	<!-- svelte-ignore a11y-no-static-element-interactions -->
	<!-- svelte-ignore a11y-click-events-have-key-events -->
	<div
		class="relative flex grow bg-base-200 md:brightness-100 overflow-hidden"
		class:brightness-50={!menuClosed}
		on:click={() => (menuClosed = true)}
	>
		<svelte:component this={mainComponent} slug={data.slug} />
	</div>
</div>

<style>
	.height {
		height: calc(100% - 64px);
	}
</style>
