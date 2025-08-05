window.addEventListener('message', (event) => {
  if (event.data === 'app-loaded') {
    console.log('App loaded');
  }
});

/**
 * Notifies the user with a message.
 *
 * @param {string} content - The message content.
 * @param {number} duration - The duration of the message in milliseconds.
 * @param {number} width - The width of the message in pixels.
 * @param {number} height - The height of the message in pixels.
 * @returns {void}
 */
function notify(content, duration, width, height) {
  globalThis.notify(content, duration, width, height);
}

document.getElementById('clicker').addEventListener('click', function () {
  notify('test notification', 2000, 100, 20);
});
