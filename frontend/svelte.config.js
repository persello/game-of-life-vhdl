import adapter from '@sveltejs/adapter-auto';
import { optimizeImports, optimizeCss, elements } from 'carbon-preprocess-svelte';
import preprocess from 'svelte-preprocess';
const { typescript } = preprocess;

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://github.com/sveltejs/svelte-preprocess
	// for more information about preprocessors
	preprocess: [typescript(), optimizeImports(), optimizeCss(), elements()],
	kit: {
		adapter: adapter(),
		vite: {
			server: {
				fs: {
					allow: ['generated/']
				}
			}
		},

		// hydrate the <div id="svelte"> element in src/app.html
		target: '#svelte'
	}
};

export default config;
