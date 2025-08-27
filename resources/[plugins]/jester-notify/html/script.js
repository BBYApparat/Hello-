// Hoofdfunctie voor het tonen van notificaties
function showNotification(text, color = 'blue') {
    const div = document.createElement('div');
    div.className = `notify ${color}`;
    div.innerText = text;

    const container = document.getElementById('notifications');
    container.appendChild(div);

    // Eerst fade-out toepassen na 3 seconden
    setTimeout(() => {
        div.classList.add('fade-out');
    }, 3000);

    // Daarna verwijderen na 4 seconden
    setTimeout(() => {
        if (div.parentNode) {
            div.remove();
        }
    }, 4000);
}

// Luister naar berichten van FiveM client
window.addEventListener("message", function (event) {
    if (event.data && event.data.action === "notify") {
        const text = event.data.text || "Notificatie";
        const color = event.data.color || "blue";
        showNotification(text, color);
    }
});

// Globale functie voor externe scripts
window.notify = function(message, color = 'blue') {
    showNotification(message, color);
};

// Debug functie (alleen voor ontwikkeling)
function debugNotifications() {
    console.log("Debug: Testing notifications...");

    showNotification("Test Blue Notification", "blue");
    setTimeout(() => showNotification("Test Red Notification", "red"), 500);
    setTimeout(() => showNotification("Test Green Notification", "green"), 1000);
    setTimeout(() => showNotification("Test Yellow Notification", "yellow"), 1500);
    setTimeout(() => showNotification("Test Purple Notification", "purple"), 2000);
}

// Event listener voor escape key (FiveM standaard)
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        // Sluit NUI focus als dat nodig is
        fetch(`https://${GetParentResourceName()}/close`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
        });
    }
});

// Functie om alle notificaties te wissen (optioneel)
function clearAllNotifications() {
    const notifications = document.querySelectorAll('.notify');
    notifications.forEach(notification => {
        notification.remove();
    });
}

// Export functies voor gebruik in andere scripts
window.clearNotifications = clearAllNotifications;
window.debugNotifications = debugNotifications;
