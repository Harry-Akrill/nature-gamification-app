<script lang="ts">
	import AdminDashboardUrls from '$lib/enums/AdminDashboardUrls';
	import { createEventDispatcher } from 'svelte';
	import Icon from '@iconify/svelte';
	import homeIcon from '@iconify-icons/mdi/home';
	import accountGroupIcon from '@iconify-icons/mdi/account-group';
	import messageDrawIcon from '@iconify-icons/mdi/message-draw';
	import commentQuestionIcon from '@iconify-icons/mdi/comment-question';
	import cardAccountMailIcon from '@iconify-icons/mdi/card-account-mail';
	import mapMarkerIcon from '@iconify-icons/mdi/map-marker';
	import informationOutline from '@iconify-icons/mdi/information-outline';

	export let slug: string | undefined;
	console.log(slug);

	const dispatch = createEventDispatcher();
</script>

<ul class="menu menu-lg p-4 min-h-full text-base-content flex-nowrap">
	<li>
		<a
			class:font-semibold={!slug}
			class:active={!slug}
			href={`/admin${AdminDashboardUrls.OVERVIEW ? '/' + AdminDashboardUrls.OVERVIEW : ''}`}
			data-testid="overview-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			><Icon icon={homeIcon} height={24} class="scale-125 mr-2" />Overview</a
		>
	</li>
	<div class="my-1" />
	<li>
		<a
			class:font-semibold={slug?.split('/')[0] === AdminDashboardUrls.USERS}
			class:active={slug?.split('/')[0] === AdminDashboardUrls.USERS}
			href={`/admin${AdminDashboardUrls.USERS ? '/' + AdminDashboardUrls.USERS : ''}`}
			data-testid="users-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			><Icon icon={accountGroupIcon} height={24} class="scale-125 mr-2" />Users</a
		>
	</li>
	<div class="my-1" />
	<li>
		<a
			class:font-semibold={slug?.split('/')[0] === AdminDashboardUrls.STATS}
			class:active={slug?.split('/')[0] === AdminDashboardUrls.STATS}
			href={`/admin${AdminDashboardUrls.STATS ? '/' + AdminDashboardUrls.STATS : ''}`}
			data-testid="statistics-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			><Icon icon={informationOutline} height={24} class="scale-125 mr-2" />Statistics</a
		>
	</li>
	<div class="my-1" />
	<li>
		<a
			class:font-semibold={slug?.split('/')[0] === AdminDashboardUrls.REVIEWS}
			class:active={slug?.split('/')[0] === AdminDashboardUrls.REVIEWS}
			href={`/admin${AdminDashboardUrls.REVIEWS ? '/' + AdminDashboardUrls.REVIEWS : ''}`}
			data-testid="reviews-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			><Icon icon={messageDrawIcon} height={24} class="scale-125 mr-2" />Reviews</a
		>
	</li>
	<div class="my-1" />
	<li>
		<a
			class:font-semibold={slug?.split('/')[0] === AdminDashboardUrls.QA}
			class:active={slug?.split('/')[0] === AdminDashboardUrls.QA}
			href={`/admin${AdminDashboardUrls.QA ? '/' + AdminDashboardUrls.QA : ''}`}
			data-testid="qa-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			><Icon icon={commentQuestionIcon} height={24} class="scale-125 mr-2" />QA</a
		>
	</li>
	<div class="my-1" />
	<li>
		<a
			class:font-semibold={slug?.split('/')[0] === AdminDashboardUrls.MAILING_LIST}
			class:active={slug?.split('/')[0] === AdminDashboardUrls.MAILING_LIST}
			href={`/admin${AdminDashboardUrls.MAILING_LIST ? '/' + AdminDashboardUrls.MAILING_LIST : ''}`}
			data-testid="mailing-list-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			><Icon icon={cardAccountMailIcon} height={24} class="scale-125 mr-2" />Mailing List</a
		>
	</li>
	<div class="my-1" />
	<li>
		<a
			class:font-semibold={slug?.split('/')[0] === AdminDashboardUrls.MANAGE_POIS}
			class:active={slug?.split('/')[0] === AdminDashboardUrls.MANAGE_POIS}
			href={`/admin${AdminDashboardUrls.MANAGE_POIS ? '/' + AdminDashboardUrls.MANAGE_POIS : ''}`}
			data-testid="manage-pois-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			><Icon icon={mapMarkerIcon} height={24} class="scale-125 mr-2" />Manage POIs</a
		>
	</li>
	<div class="my-1" />
	<li>
		<a
			class:font-semibold={slug === AdminDashboardUrls.COMMENTS}
			class:active={slug === AdminDashboardUrls.COMMENTS}
			href={`/admin${AdminDashboardUrls.COMMENTS ? '/' + AdminDashboardUrls.COMMENTS : ''}`}
			data-testid="manage-comments-button"
			on:click={() => dispatch('sideMenuItemClicked')}
			><Icon icon={cardAccountMailIcon} height={24} class="scale-125 mr-2" />Manage Comments</a
		>
	</li>
</ul>
