let deathScreen = null;
let timerInterval = null;
let currentTimer = 0;
let maxTimer = 0;
let canRespawn = false;

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    deathScreen = document.getElementById('death-screen');
    
    // Listen for NUI messages from FiveM
    window.addEventListener('message', function(event) {
        const data = event.data;
        
        switch(data.action) {
            case 'show':
                showDeathScreen(data);
                break;
            case 'hide':
                hideDeathScreen();
                break;
            case 'updateTimer':
                updateTimer(data.timer, data.maxTimer);
                break;
            case 'enableRespawn':
                enableRespawn();
                break;
            case 'disableRespawn':
                disableRespawn();
                break;
        }
    });
    
    // Handle key presses
    document.addEventListener('keydown', function(event) {
        if (!deathScreen || deathScreen.classList.contains('hidden')) return;
        
        switch(event.code) {
            case 'KeyE':
                event.preventDefault();
                callForHelp();
                break;
            case 'KeyG':
                event.preventDefault();
                if (canRespawn) {
                    respawn();
                }
                break;
        }
    });
});

function showDeathScreen(data) {
    if (!deathScreen) return;
    
    deathScreen.classList.remove('hidden');
    
    // Set initial timer values
    if (data.timer !== undefined && data.maxTimer !== undefined) {
        updateTimer(data.timer, data.maxTimer);
    }
    
    // Set respawn availability
    if (data.canRespawn !== undefined) {
        if (data.canRespawn) {
            enableRespawn();
        } else {
            disableRespawn();
        }
    }
    
    // Start timer animation if provided
    if (data.startTimer) {
        startTimerAnimation(data.maxTimer || 300); // Default 5 minutes
    }
}

function hideDeathScreen() {
    if (!deathScreen) return;
    
    deathScreen.classList.add('hidden');
    
    // Clear timer
    if (timerInterval) {
        clearInterval(timerInterval);
        timerInterval = null;
    }
    
    canRespawn = false;
    disableRespawn();
}

function updateTimer(timer, maxTimer) {
    const timerElement = document.getElementById('timer');
    if (!timerElement) return;
    
    currentTimer = timer;
    maxTimer = maxTimer || currentTimer;
    
    // Format timer (convert from seconds to MM:SS or just seconds)
    let displayTimer;
    if (timer >= 60) {
        const minutes = Math.floor(timer / 60);
        const seconds = timer % 60;
        displayTimer = `${minutes}:${seconds.toString().padStart(2, '0')}`;
    } else {
        displayTimer = timer.toString();
    }
    
    timerElement.textContent = displayTimer;
    
    // Update circular progress
    updateCircularProgress(timer, maxTimer);
}

function updateCircularProgress(current, max) {
    const circle = document.querySelector('.timer-circle');
    if (!circle) return;
    
    const percentage = max > 0 ? ((max - current) / max) * 360 : 0;
    const beforeElement = circle.querySelector('::before') || circle;
    
    // Update the conic gradient rotation
    circle.style.setProperty('--progress', `${percentage}deg`);
}

function startTimerAnimation(totalSeconds) {
    if (timerInterval) {
        clearInterval(timerInterval);
    }
    
    let remainingTime = totalSeconds;
    
    timerInterval = setInterval(() => {
        remainingTime--;
        updateTimer(remainingTime, totalSeconds);
        
        // Enable respawn when timer reaches 0
        if (remainingTime <= 0) {
            clearInterval(timerInterval);
            timerInterval = null;
            enableRespawn();
            
            // Notify the client that respawn is available
            fetch(`https://${GetParentResourceName()}/timerComplete`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({})
            });
        }
    }, 1000);
}

function enableRespawn() {
    const respawnControl = document.getElementById('respawn-control');
    if (respawnControl) {
        respawnControl.style.display = 'flex';
        respawnControl.classList.remove('disabled');
    }
    canRespawn = true;
}

function disableRespawn() {
    const respawnControl = document.getElementById('respawn-control');
    if (respawnControl) {
        respawnControl.style.display = 'none';
        respawnControl.classList.add('disabled');
    }
    canRespawn = false;
}

function callForHelp() {
    // Send NUI callback to FiveM client
    fetch(`https://${GetParentResourceName()}/callForHelp`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({})
    });
    
    // Visual feedback
    const controlItem = document.querySelector('.control-item');
    if (controlItem) {
        controlItem.style.transform = 'scale(0.95)';
        setTimeout(() => {
            controlItem.style.transform = '';
        }, 150);
    }
}

function respawn() {
    if (!canRespawn) return;
    
    // Send NUI callback to FiveM client
    fetch(`https://${GetParentResourceName()}/respawn`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({})
    });
}

// Utility function to get resource name (for NUI callbacks)
function GetParentResourceName() {
    return window.location.hostname === 'nui-game-internal' ? 
           window.location.pathname.split('/')[1] : 'ars_ambulancejob';
}