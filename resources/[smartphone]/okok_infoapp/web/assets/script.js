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
  const stateIdEl = document.getElementById('state-id');
  if (stateIdEl) stateIdEl.textContent = data.state_id || '-';
  
  // Update Phone Number
  const phoneEl = document.getElementById('phone-number');
  if (phoneEl) phoneEl.textContent = data.phone_number || '-';
  
  // Update Financial Info
  const bankEl = document.getElementById('bank-balance');
  const cashEl = document.getElementById('cash-balance');
  if (bankEl) bankEl.textContent = formatCurrency(data.bank_balance);
  if (cashEl) cashEl.textContent = formatCurrency(data.cash_balance);
  
  // Update Job Info
  const jobInfo = `${data.job?.label || 'Unemployed'} - ${data.job?.grade_label || 'No Grade'}`;
  const jobEl = document.getElementById('job-info');
  if (jobEl) jobEl.textContent = jobInfo;
  
  // Update Gang Info  
  const gangInfo = `${data.gang?.label || 'No Gang'} - ${data.gang?.grade_label || 'No Rank'}`;
  const gangEl = document.getElementById('gang-info');
  if (gangEl) gangEl.textContent = gangInfo;
  
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
  const loading = document.getElementById('loading');
  const content = document.getElementById('info-content');
  const error = document.getElementById('error-content');
  
  if (loading) loading.classList.remove('hidden');
  if (content) content.classList.add('hidden');
  if (error) error.classList.add('hidden');
}

// Show content
function showContent() {
  const loading = document.getElementById('loading');
  const content = document.getElementById('info-content');
  const error = document.getElementById('error-content');
  
  if (loading) loading.classList.add('hidden');
  if (content) content.classList.remove('hidden');
  if (error) error.classList.add('hidden');
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
  console.log(`Info App: Dark Mode ${isDark ? 'enabled' : 'disabled'}`);
});

// Initialize when phone functions are loaded
document.addEventListener("loadedPhoneFunctions", () => {
  console.log("Info App: Phone functions loaded");
  loadPlayerInfo();
});

// Initialize on DOM load as fallback
document.addEventListener("DOMContentLoaded", (event) => {
  console.log("Info App: DOM loaded");
  
  // Try to load info immediately if phone functions are already available
  if (document.okokPhone) {
    loadPlayerInfo();
  }
});