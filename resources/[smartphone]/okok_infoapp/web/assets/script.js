// Global variables
let playerInfo = null;
let clientData = null;
let lastUpdate = 0;
let autoRefreshInterval = null;

// Load player information with enhanced client-side integration
async function loadPlayerInfo() {
  showLoading();
  try {
    // First try to get client-side data for faster response
    const clientResponse = await fetchNui("getPlayerInfoClient");
    if (clientResponse && clientResponse.success) {
      clientData = clientResponse.data;
      
      // If we have client data, display it immediately
      if (clientData && !clientData.needsServerData) {
        displayPlayerInfo(clientData);
        showContent();
      }
    }
    
    // Then get complete server data for sensitive information (money, state_id, gang)
    const serverResponse = await fetchNui("getPlayerInfo");
    if (serverResponse && serverResponse.success) {
      playerInfo = serverResponse.data;
      
      // Merge client and server data for complete info
      if (clientData) {
        playerInfo.name = clientData.name;
        // Keep server job data as it might be more up-to-date with gang info
      }
      
      displayPlayerInfo(playerInfo);
      lastUpdate = Date.now();
    } else {
      // If server fails but we have client data, show what we can
      if (clientData) {
        displayPlayerInfo(clientData, true); // true = partial data
      } else {
        showError(serverResponse?.message || "Failed to load player information");
      }
    }
  } catch (error) {
    console.error("Error loading player info:", error);
    if (clientData) {
      displayPlayerInfo(clientData, true); // Show cached data on error
    } else {
      showError("Connection error");
    }
  }
}

// Display player information in the UI
function displayPlayerInfo(data, isPartial = false) {
  if (!data) return;

  // Update State ID (only from server data for security)
  if (data.state_id !== undefined) {
    document.getElementById('state-id').textContent = data.state_id || 'N/A';
  } else if (isPartial) {
    document.getElementById('state-id').textContent = data.identifier ? 
      data.identifier.substring(0, 8) + '...' : 'Loading...';
  }
  
  // Update Financial Info (only from server data for security)
  if (data.bank_balance !== undefined && data.cash_balance !== undefined) {
    document.getElementById('bank-balance').textContent = formatCurrency(data.bank_balance);
    document.getElementById('cash-balance').textContent = formatCurrency(data.cash_balance);
  } else if (isPartial) {
    document.getElementById('bank-balance').textContent = 'Loading...';
    document.getElementById('cash-balance').textContent = 'Loading...';
  }
  
  // Update Job Info (can use client data)
  document.getElementById('job-label').textContent = data.job?.label || 'Unemployed';
  document.getElementById('job-grade').textContent = data.job?.grade_label || 'N/A';
  
  // Update Gang Info (prefer server data but fallback to client)
  if (data.gang) {
    document.getElementById('gang-label').textContent = data.gang.label || 'No Gang';
    document.getElementById('gang-grade').textContent = data.gang.grade_label || 'N/A';
  } else if (isPartial) {
    document.getElementById('gang-label').textContent = 'Loading...';
    document.getElementById('gang-grade').textContent = 'Loading...';
  }
  
  // Add visual indicator for partial data
  const header = document.querySelector('h1');
  if (isPartial) {
    header.innerHTML = 'Personal Info <span class="text-yellow-400 text-sm">(Partial)</span>';
  } else {
    header.textContent = 'Personal Info';
  }
  
  showContent();
}

// Format currency
function formatCurrency(amount) {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD'
  }).format(amount || 0);
}

// Show loading state
function showLoading() {
  document.getElementById('loading').classList.remove('hidden');
  document.getElementById('info-content').classList.add('hidden');
  document.getElementById('error-content').classList.add('hidden');
}

// Show content
function showContent() {
  document.getElementById('loading').classList.add('hidden');
  document.getElementById('info-content').classList.remove('hidden');
  document.getElementById('error-content').classList.add('hidden');
}

// Show error
function showError(message) {
  document.getElementById('loading').classList.add('hidden');
  document.getElementById('info-content').classList.add('hidden');
  document.getElementById('error-content').classList.remove('hidden');
  document.getElementById('error-message').textContent = message;
}

// Refresh information
function refreshInfo() {
  loadPlayerInfo();
  notifyIsland({
    title: "Info",
    text: "Information refreshed",
    duration: 2000,
  });
}

// Handle Dark Mode Toggle
document.addEventListener("darkMode", (e) => {
  const isDark = e.detail;
  if (isDark) {
    console.log("Dark Mode is enabled");
  } else {
    console.log("Dark Mode is disabled");
  }
});

document.addEventListener("loadedPhoneFunctions", () => {
  console.log("props", document.okokPhone);
  // Load player info when phone functions are loaded
  loadPlayerInfo();
});

// Handle real-time updates from client-side
window.addEventListener("message", (event) => {
  if (event.data && event.data.type) {
    switch (event.data.type) {
      case 'jobUpdated':
        // Update job info in real-time
        if (event.data.job) {
          document.getElementById('job-label').textContent = event.data.job.label || 'Unemployed';
          document.getElementById('job-grade').textContent = event.data.job.grade_label || 'N/A';
          
          // Show notification
          notifyIsland({
            title: "Job Updated",
            text: `Now working as ${event.data.job.label}`,
            duration: 3000,
          });
        }
        break;
        
      case 'moneyUpdated':
        // Refresh money data when it changes
        refreshMoneyData();
        break;
    }
  }
});

// Refresh only money data for performance
async function refreshMoneyData() {
  try {
    const response = await fetchNui("getPlayerInfo");
    if (response && response.success) {
      document.getElementById('bank-balance').textContent = formatCurrency(response.data.bank_balance);
      document.getElementById('cash-balance').textContent = formatCurrency(response.data.cash_balance);
    }
  } catch (error) {
    console.error("Error refreshing money data:", error);
  }
}

// Auto-refresh functionality
function startAutoRefresh(intervalMs = 30000) { // 30 seconds default
  if (autoRefreshInterval) {
    clearInterval(autoRefreshInterval);
  }
  
  autoRefreshInterval = setInterval(() => {
    // Only refresh if the app is likely visible
    if (document.visibilityState === 'visible') {
      loadPlayerInfo();
    }
  }, intervalMs);
}

// Stop auto-refresh
function stopAutoRefresh() {
  if (autoRefreshInterval) {
    clearInterval(autoRefreshInterval);
    autoRefreshInterval = null;
  }
}

// Enhanced refresh function
function refreshInfo() {
  loadPlayerInfo();
  notifyIsland({
    title: "Info",
    text: "Information refreshed",
    duration: 2000,
  });
}

// Handle app focus/visibility
document.addEventListener('visibilitychange', () => {
  if (document.visibilityState === 'hidden') {
    stopAutoRefresh();
  } else if (document.visibilityState === 'visible') {
    // Refresh data when app becomes visible
    loadPlayerInfo();
    startAutoRefresh();
  }
});

// Notify about focus changes
async function notifyFocusChange(focused) {
  try {
    await fetchNui("onNUIFocus", { focused: focused });
  } catch (error) {
    console.error("Error notifying focus change:", error);
  }
}

document.addEventListener("loadedPhoneFunctions", () => {
  console.log("props", document.okokPhone);
  loadPlayerInfo();
  startAutoRefresh(); // Start auto-refresh when phone functions are loaded
  notifyFocusChange(true);
});

document.addEventListener("DOMContentLoaded", (event) => {
  console.log("DOM fully loaded and parsed");
  // Try to load info immediately if phone functions are already available
  if (document.okokPhone) {
    loadPlayerInfo();
    startAutoRefresh();
    notifyFocusChange(true);
  }
});