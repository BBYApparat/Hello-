import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';

import App from './containers/App';

import KeyListener from './containers/KeyListener';
import WindowListener from './containers/WindowListener';

import configureStore from './configureStore';

const initialState = {};
export const store = configureStore(initialState);
const MOUNT_NODE = document.getElementById('app');

const render = () => {
	console.log('[ESX_MDT NUI] Starting React app render');
	console.log('[ESX_MDT NUI] Mount node:', MOUNT_NODE);
	console.log('[ESX_MDT NUI] Store:', store);
	
	ReactDOM.render(
		<Provider store={store}>
			<KeyListener>
				<WindowListener>
					<App />
				</WindowListener>
			</KeyListener>
		</Provider>,
		MOUNT_NODE,
	);
	
	console.log('[ESX_MDT NUI] React app rendered successfully');
};

if (module.hot) {
	module.hot.accept(['containers/App'], () => {
		ReactDOM.unmountComponentAtNode(MOUNT_NODE);
		render();
	});
}

render();
