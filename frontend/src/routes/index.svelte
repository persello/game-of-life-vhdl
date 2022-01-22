<script lang="ts">
	import 'carbon-components-svelte/css/g100.css';
	import { Content, Header, Grid, Row, Column, Button } from 'carbon-components-svelte';
	import { CancelablePromise, ServiceVHDLBackend } from '../../generated/index';
	import World from '../components/world.svelte';
	import Controls from '../components/controls.svelte';
	import { onMount } from 'svelte';

	let size = ServiceVHDLBackend.boardSize().then((size) => {
		let result: [number, number] = [parseInt(size[0]), parseInt(size[1])];
		return result;
	});

	let board_state = ServiceVHDLBackend.getBoardState().then((board_state) => {
		return board_state;
	});

	let autoPlay: boolean = false;

	// User interactions
	function userChangedWorld(world: boolean[][]) {
		board_state = ServiceVHDLBackend.setBoardState(world);
		console.log(world);
	}

	function step() {
		board_state = ServiceVHDLBackend.step();
	}

	function erase() {
		ServiceVHDLBackend.boardSize().then((size) => {
			let new_state = Array(size[1]).fill(Array(size[0]).fill(false));
			userChangedWorld(new_state);
		});
	}

	// Autoplay loop
	setInterval(() => {
		if (autoPlay) {
			step();
		}
	}, 500);
</script>

<svelte:head>
	<title>VHDL Game of Life</title>
</svelte:head>

<Header company="Riccardo Persello" platformName="VHDL Game of Life" />

<Content>
	{#await size}
		<p>Loading board size...</p>
	{:then size}
		{#await board_state}
			<World {size} worldDidChange={userChangedWorld} />
		{:then board_state}
			<World {size} world={board_state} worldDidChange={userChangedWorld} />
		{:catch error}
			<p>Error loading board state ({error}).</p>
		{/await}
		<div class="controls-container">
			<Controls bind:autoPlay didStep={step} didErase={erase} />
		</div>
	{:catch error}
		<p>Error loading board size ({error}).</p>
	{/await}
</Content>

<style>
	.controls-container {
		width: 100%;
		display: flex;
		flex-direction: row;
		justify-content: center;
	}
</style>
