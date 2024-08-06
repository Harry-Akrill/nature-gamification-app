<script lang="ts">
	import * as HoverCard from '$lib/components/ui/hover-card';

	export let value: string;
</script>

<div class="flex space-x-2">
	<HoverCard.Root>
		<HoverCard.Trigger>
			<span
				class="inline-block lg:max-w-[200px] sm:max-w-[160px] max-w-[80px] truncate font-medium cursor-default"
			>
				{value}
			</span>
		</HoverCard.Trigger>
		<HoverCard.Content class="w-fit h-fit py-2 px-2.5">
			<div class="text-xs flex items-center">
				{value}
			</div>
		</HoverCard.Content>
	</HoverCard.Root>
</div>
