<script lang="ts">
	import { Button } from 'carbon-components-svelte';
	import { Play16, Pause16, SkipForward16, Erase16 } from 'carbon-icons-svelte';

	export let autoPlay: boolean = false;

	export let didStep: () => void = () => {};
	export let didErase: () => void = () => {};
</script>

<div style="flex: content; padding: 2rem;">
	<Button
		icon={autoPlay ? Pause16 : Play16}
		iconDescription="Play automatically"
		kind="secondary"
		tooltipPosition="top"
		on:click={() => {
			autoPlay = !autoPlay;
		}}
	/>
	<Button
		icon={SkipForward16}
		iconDescription="Step once"
		kind="secondary"
		tooltipPosition="top"
		on:click={didStep}
		disabled={autoPlay}
	/>
	<Button
		icon={Erase16}
		iconDescription="Clear world"
		kind="secondary"
		tooltipPosition="top"
		on:click={didErase}
		disabled={autoPlay}
	/>
</div>
