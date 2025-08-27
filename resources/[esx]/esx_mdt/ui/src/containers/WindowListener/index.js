import React, { useEffect } from 'react';
import { useDispatch } from 'react-redux';

export default ({ children }) => {
	const dispatch = useDispatch();
	const handleEvent = (event) => {
		console.log('[ESX_MDT NUI] Received message event:', event);
		console.log('[ESX_MDT NUI] Event data:', event.data);
		console.log('[ESX_MDT NUI] Event trusted:', event.isTrusted);
		
		if (!event.isTrusted) {
			console.log('[ESX_MDT NUI] Untrusted Event - ignoring');
			return;
		}
		const { type, data, action } = event.data;
		console.log('[ESX_MDT NUI] Message type:', type);
		console.log('[ESX_MDT NUI] Message action:', action);
		console.log('[ESX_MDT NUI] Message data:', data);
		
		if (type != null) {
			console.log('[ESX_MDT NUI] Dispatching redux action:', type, data);
			dispatch({ type, payload: { ...data } });
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
