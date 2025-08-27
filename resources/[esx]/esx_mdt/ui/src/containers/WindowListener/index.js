import React, { useEffect } from 'react';
import { useDispatch } from 'react-redux';

export default ({ children }) => {
	const dispatch = useDispatch();
	const handleEvent = (event) => {
		console.log('[ESX_MDT NUI] Received message event:', event);
		console.log('[ESX_MDT NUI] Event data JSON:', JSON.stringify(event.data, null, 2));
		console.log('[ESX_MDT NUI] Event trusted:', event.isTrusted);
		
		if (!event.isTrusted) {
			console.log('[ESX_MDT NUI] Untrusted Event - ignoring');
			return;
		}
		
		const { type, data, action, playerData, config } = event.data;
		console.log('[ESX_MDT NUI] Extracted - type:', type, 'data:', data, 'action:', action);
		console.log('[ESX_MDT NUI] Extracted - playerData:', playerData, 'config:', config);
		
		if (type != null) {
			// For flat structure: use entire event.data as payload
			const payload = event.data;
			console.log('[ESX_MDT NUI] Dispatching redux action:', type, 'with payload:', payload);
			dispatch({ type, payload });
		} else if (action != null) {
			console.log('[ESX_MDT NUI] Dispatching redux action (from action):', action, event.data);
			dispatch({ type: action, payload: event.data });
		} else {
			console.log('[ESX_MDT NUI] No type or action found - message ignored');
		}
	};

	useEffect(() => {
		window.addEventListener('message', handleEvent);
		return () => {
			window.removeEventListener('message', handleEvent);
		};
	}, []);

	return React.Children.only(children);
};
