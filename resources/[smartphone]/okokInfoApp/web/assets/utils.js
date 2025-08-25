/**
 * This file contains functions that interact with the FiveM NUI client side
 * It also contains okokPhone specific functions
 */

/**
 * Send Event to NUI
 * @template T
 * @param {string} eventName Nui Event Name
 * @param {any} data?
 * @returns {Promise<T>}
 */
async function fetchNui(eventName, data = {}) {
  try {
    const result = await fetch(
      `https://${document.okokPhone.resourceName}/${eventName}`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: JSON.stringify(data),
      }
    );
    
    // Check if response is empty or not OK
    if (!result.ok) {
      console.error(`HTTP error calling ${eventName}: ${result.status}`);
      return { success: false, message: `HTTP error: ${result.status}` };
    }
    
    const text = await result.text();
    if (!text || text.trim() === '') {
      console.error(`Empty response from ${eventName}`);
      return { success: false, message: 'Empty response from server' };
    }
    
    try {
      return JSON.parse(text);
    } catch (parseError) {
      console.error(`JSON parse error for ${eventName}:`, parseError, 'Response text:', text);
      return { success: false, message: 'Invalid JSON response' };
    }
  } catch (error) {
    console.error(`Error calling ${eventName}\n`, error);
    return { success: false, message: error.message || 'Network error' };
  }
}

/**
 * ----------------------------------------
 * okokPhone specific functions
 * ----------------------------------------
 */

/**
 * Trigger an island notification
 * @param {{title?: string, text?: string, app?: string, icon?: string, duration: number}} notification
 */
function notifyIsland(notification) {
  if (!notification.app && !notification.icon) {
    notification.app = document.okokPhone.appId;
  }
  document.okokPhone.notifyIsland(notification);
}