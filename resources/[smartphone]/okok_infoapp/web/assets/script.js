// Global variables
let playerInfo = null;

// Load player information (only when requested)
async function loadPlayerInfo() {
  showLoading();
  try {
    const response = await fetchNui("getPlayerInfo");
    if (response && response.success) {
      playerInfo = response.data;
      displayPlayerInfo(playerInfo);
    } else {
      showError(response?.message || "Failed to load player information");
    }
  } catch (error) {
    console.error("Error loading player info:", error);
    showError("Connection error");
  }
}

// Display player information in the UI
function displayPlayerInfo(data) {
  if (!data) return;

  // Update State ID
  document.getElementById('state-id').textContent = data.state_id || 'N/A';
  
  // Update Financial Info
  document.getElementById('bank-balance').textContent = formatCurrency(data.bank_balance);
  document.getElementById('cash-balance').textContent = formatCurrency(data.cash_balance);
  
  // Update Job Info
  document.getElementById('job-label').textContent = data.job?.label || 'Unemployed';
  document.getElementById('job-grade').textContent = data.job?.grade_label || 'N/A';
  
  // Update Gang Info
  document.getElementById('gang-label').textContent = data.gang?.label || 'No Gang';
  document.getElementById('gang-grade').textContent = data.gang?.grade_label || 'N/A';
  
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

// Manual refresh function
function refreshInfo() {
  loadPlayerInfo();
  notifyIsland({
    title: "Info",
    text: "Information refreshed",
    duration: 2000,
  });
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