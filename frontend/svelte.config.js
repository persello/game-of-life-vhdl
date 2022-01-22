import adapter from '@sveltejs/adapter-node';
import { optimizeImports, optimizeCss, elements } from 'carbon-preprocess-svelte';
import preprocess from 'svelte-preprocess';
const { typescript } = preprocess;

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://github.com/sveltejs/svelte-preprocess
	// for more information about preprocessors
	preprocess: [typescript(), optimizeImports(), optimizeCss(), elements()],
	kit: {
		adapter: adapter({
			// default options are shown
			out: 'build',
			precompress: true,
			env: {
				path: 'SOCKET_PATH',
				host: 'frontend',
				port: '80',
				origin: 'localhost',
				headers: {
					protocol: 'PROTOCOL_HEADER',
					host: 'HOST_HEADER'
				}
			}
		}),
		vite: {
			server: {
				fs: {
					allow: ['generated/']
				},
				hmr: {
					hmr: {
						host: 'localhost',
						port: 24678,
						protocol: 'ws'
					}
				}
			}
		},

		// hydrate the <div id="svelte"> element in src/app.html
		target: '#svelte'
	}
};

export default config;
