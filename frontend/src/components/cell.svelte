<script lang="ts">
	import 'carbon-components-svelte/css/g100.css';
	import {} from 'carbon-icons-svelte';

	export let state: boolean = false;
	export let stateDidChange: (state: boolean) => void = () => {};
</script>

<div
	on:click={() => {
		state = !state;
		stateDidChange(state);
	}}
>
	{#if state}
		<div class="cell-enabled" />
	{:else}
		<div class="cell-disabled" />
	{/if}
</div>

<style>
	.cell-enabled {
		aspect-ratio: 1;
		max-height: 5cm;
		min-height: 0.5cm;
		background-color: 'interactive-01';
	}

	.cell-disabled {
		aspect-ratio: 1;
		max-height: 5cm;
		min-height: 0.5cm;
		background-color: 'inverse-link';
	}
</style>
