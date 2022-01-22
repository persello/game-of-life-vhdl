<script lang="ts">
	import Cell from './cell.svelte';

	export let size: [number, number] = [10, 10];
	export let world: boolean[][] = Array(size[0])
		.fill(0)
		.map(() => Array(size[1]).fill(false));
	export let worldDidChange: (world: boolean[][]) => void = () => {};

	function userChangedWorld(x: number, y: number, value: boolean) {
		world[x][y] = value;
		worldDidChange(world);
	}
</script>

<table class="main-table">
	{#each Array(size[1]) as _, i}
		<tr>
			{#each Array(size[0]) as _, j ({ i, j })}
				<td>
					<Cell
						state={world[i][j]}
						stateDidChange={(new_state) => {
							userChangedWorld(i, j, new_state);
						}}
					/>
				</td>
			{/each}
		</tr>
	{/each}
</table>

<style>
	.main-table {
		height: 80vh;
		width: 100%;
		border-collapse: separate;
		border-spacing: 2px;
	}
</style>
