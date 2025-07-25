let radarContainer = null;
let helicoptersLayer = null;
let updateInterval = null;
let currentFilter = 'all';
let animationFrameId = null;

// Demo helicopters for browser preview
const demoHelicopters = [
    { id: 1, name: "Officer Johnson", x: 200, y: -800, color: "blue", callsign: "LSPD-1" },
    { id: 2, name: "Medic Smith", x: -1500, y: 300, color: "green", callsign: "EMS-2" },
    { id: 3, name: "Civilian Pilot", x: 800, y: 1200, color: "red", callsign: "N123AB" },
    { id: 4, name: "Sheriff Davis", x: -300, y: -200, color: "blue", callsign: "BCSO-3" },
    { id: 5, name: "Fire Chief", x: 600, y: -600, color: "green", callsign: "FIRE-1" }
];

window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.type) {
        case 'openRadar':
            openRadar(data.helicopters);
            break;
        case 'closeRadar':
            closeRadar();
            break;
        case 'updateHelicopters':
            updateHelicopters(data.helicopters);
            break;
    }
});

// Initialize radar when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeRadar();
    // Only show demo in browser, not in FiveM
    if (window.location.protocol === 'file:' || window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
        openRadar(demoHelicopters);
    }
});

function initializeRadar() {
    // Initialize filter controls
    const filterButtons = document.querySelectorAll('.control-btn');
    filterButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            // Remove active class from all buttons
            filterButtons.forEach(b => b.classList.remove('active'));
            // Add active class to clicked button
            this.classList.add('active');
            // Update filter
            currentFilter = this.dataset.filter;
            // Reapply filter to helicopters
            applyFilter();
        });
    });
}

function openRadar(helicopters) {
    radarContainer = document.getElementById('radar-container');
    helicoptersLayer = document.getElementById('helicopters-layer');
    
    radarContainer.classList.remove('hidden');
    updateHelicopters(helicopters || []);
    
    // Start update interval for FiveM
    if (updateInterval) {
        clearInterval(updateInterval);
    }
    
    updateInterval = setInterval(() => {
        // In FiveM, this will use the NUI callback
        fetch(`https://${GetParentResourceName()}/updateRadar`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        })
        .then(response => response.json())
        .then(helicopters => {
            updateHelicopters(helicopters);
        })
        .catch(error => {
            // Silently handle errors in FiveM environment
            console.log('Update error:', error);
        });
    }, 2000);
}

function closeRadar() {
    if (radarContainer) {
        radarContainer.classList.add('hidden');
    }
    
    if (updateInterval) {
        clearInterval(updateInterval);
        updateInterval = null;
    }
    
    fetch(`https://${GetParentResourceName()}/closeRadar`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
}

function updateHelicopters(helicopters) {
    if (!helicoptersLayer) return;
    
    // Store current helicopters
    window.currentHelicopters = helicopters || demoHelicopters;
    
    // Smooth transition animation
    helicoptersLayer.style.opacity = '0';
    
    setTimeout(() => {
        helicoptersLayer.innerHTML = '';
        
        const filteredHelicopters = filterHelicopters(window.currentHelicopters);
        
        filteredHelicopters.forEach((helicopter, index) => {
            const marker = createHelicopterMarker(helicopter);
            marker.style.animationDelay = `${index * 0.1}s`;
            helicoptersLayer.appendChild(marker);
        });
        
        updateStats(filteredHelicopters.length);
        helicoptersLayer.style.opacity = '1';
    }, 150);
}

function filterHelicopters(helicopters) {
    switch(currentFilter) {
        case 'police':
            return helicopters.filter(h => h.color === 'blue');
        case 'emergency':
            return helicopters.filter(h => h.color === 'blue' || h.color === 'green');
        case 'all':
        default:
            return helicopters;
    }
}

function applyFilter() {
    if (window.currentHelicopters) {
        updateHelicopters(window.currentHelicopters);
    }
}

function updateStats(count) {
    const totalElement = document.getElementById('total-aircraft');
    if (totalElement) {
        // Animate number change
        const currentCount = parseInt(totalElement.textContent) || 0;
        animateNumber(totalElement, currentCount, count, 300);
    }
}

function animateNumber(element, start, end, duration) {
    const startTime = performance.now();
    
    function animate(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        
        // Easing function
        const easeOut = 1 - Math.pow(1 - progress, 3);
        const current = Math.round(start + (end - start) * easeOut);
        
        element.textContent = current;
        
        if (progress < 1) {
            requestAnimationFrame(animate);
        }
    }
    
    requestAnimationFrame(animate);
}

function createHelicopterMarker(helicopter) {
    const marker = document.createElement('div');
    marker.className = `helicopter-marker ${helicopter.color === 'blue' ? 'police' : helicopter.color === 'green' ? 'ambulance' : 'civilian'}`;
    
    const mapX = ((helicopter.x + 4000) / 8000) * 100;
    const mapY = ((4000 - helicopter.y) / 8000) * 100;
    
    marker.style.left = `${mapX}%`;
    marker.style.top = `${mapY}%`;
    
    // Add entrance animation
    marker.style.transform = 'translate(-50%, -50%) scale(0)';
    marker.style.opacity = '0';
    
    // Animate in
    requestAnimationFrame(() => {
        marker.style.transform = 'translate(-50%, -50%) scale(1)';
        marker.style.opacity = '1';
        marker.style.transition = 'all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275)';
    });
    
    const tooltip = document.createElement('div');
    tooltip.className = 'helicopter-tooltip';
    
    // Enhanced tooltip content
    const callsign = helicopter.callsign || `ID: ${helicopter.id}`;
    const type = helicopter.color === 'blue' ? 'LAW ENFORCEMENT' : 
                 helicopter.color === 'green' ? 'EMERGENCY MEDICAL' : 'CIVILIAN';
    
    tooltip.innerHTML = `
        <div style="font-weight: 600; margin-bottom: 2px;">${callsign}</div>
        <div style="font-size: 10px; opacity: 0.8;">${helicopter.name}</div>
        <div style="font-size: 9px; opacity: 0.6; margin-top: 2px;">${type}</div>
    `;
    
    marker.appendChild(tooltip);
    
    // Add click interaction
    marker.addEventListener('click', function(e) {
        e.stopPropagation();
        showHelicopterDetails(helicopter);
    });
    
    return marker;
}

function showHelicopterDetails(helicopter) {
    // Create a temporary detail popup (optional enhancement)
    console.log('Helicopter Details:', helicopter);
}

function GetParentResourceName() {
    return 'police_radar';
}

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeRadar();
    }
});