// Global variables
let businessData = null;
let selectedBusiness = null;

// Load business directory data
async function loadBusinessData() {
  showLoading();
  try {
    const response = await fetchNui("getBusinessData");
    if (response && response.success) {
      businessData = response;
      setupCategories(response.categories);
      displayBusinesses(response.businesses);
    } else {
      showError(response?.message || "Failed to load business directory");
    }
  } catch (error) {
    console.error("Error loading business data:", error);
    showError("Connection error");
  }
}

// Setup category filters
function setupCategories(categories) {
  const categoryContainer = document.querySelector('.flex.gap-2.overflow-x-auto.pb-2');
  categoryContainer.innerHTML = '';
  
  categories.forEach(category => {
    const button = document.createElement('button');
    button.onclick = () => filterByCategory(category);
    button.className = `category-filter ${category === 'All' ? 'active' : ''} bg-white/20 hover:bg-white/30 px-3 py-1 rounded-full text-xs whitespace-nowrap transition-colors`;
    button.textContent = category;
    categoryContainer.appendChild(button);
  });
}

// Display businesses
function displayBusinesses(businesses, filterCategory = 'All') {
  const businessList = document.getElementById('business-list');
  businessList.innerHTML = '';
  
  const filteredBusinesses = filterCategory === 'All' 
    ? businesses 
    : businesses.filter(b => b.category === filterCategory);
  
  if (filteredBusinesses.length === 0) {
    businessList.innerHTML = '<div class="text-center py-8 text-gray-400">No businesses found in this category</div>';
    showContent();
    return;
  }
  
  filteredBusinesses.forEach(business => {
    const businessCard = createBusinessCard(business);
    businessList.appendChild(businessCard);
  });
  
  showContent();
}

// Create business card element
function createBusinessCard(business) {
  const card = document.createElement('div');
  card.className = 'bg-black/30 rounded-lg p-4 border border-white/10 hover:border-white/30 transition-all cursor-pointer';
  card.onclick = () => openBusinessModal(business);
  
  // Emergency badge
  const emergencyBadge = business.emergency 
    ? '<span class="bg-red-600 text-white px-2 py-1 rounded-full text-xs font-semibold">EMERGENCY</span>'
    : '';
  
  // Online status
  const onlineStatus = business.onlineCount > 0
    ? `<span class="flex items-center gap-1 text-green-400 text-sm"><span class="w-2 h-2 bg-green-400 rounded-full"></span>${business.onlineCount} online</span>`
    : '<span class="text-gray-400 text-sm">Offline</span>';
  
  card.innerHTML = `
    <div class="flex items-start justify-between">
      <div class="flex items-start gap-3 flex-1">
        <div class="text-2xl">${business.icon}</div>
        <div class="flex-1">
          <div class="flex items-center gap-2 mb-1">
            <h3 class="font-semibold">${business.label}</h3>
            ${emergencyBadge}
          </div>
          <p class="text-gray-300 text-sm mb-2">${business.description}</p>
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-1">
              ${generateStars(business.rating)}
              <span class="text-sm text-gray-400 ml-1">${business.rating}/5</span>
            </div>
            ${onlineStatus}
          </div>
        </div>
      </div>
    </div>
  `;
  
  return card;
}

// Generate star rating display
function generateStars(rating) {
  let stars = '';
  for (let i = 1; i <= 5; i++) {
    if (i <= rating) {
      stars += '<span class="text-yellow-400">★</span>';
    } else {
      stars += '<span class="text-gray-600">★</span>';
    }
  }
  return stars;
}

// Filter businesses by category
function filterByCategory(category) {
  // Update active category button
  document.querySelectorAll('.category-filter').forEach(btn => {
    btn.classList.remove('active');
    if (btn.textContent === category) {
      btn.classList.add('active');
    }
  });
  
  if (businessData) {
    displayBusinesses(businessData.businesses, category);
  }
}

// Open business detail modal
async function openBusinessModal(business) {
  try {
    const response = await fetchNui("getBusinessDetails", { businessName: business.name });
    if (response && response.success) {
      selectedBusiness = response;
      displayBusinessModal(response.business, response.employees);
    } else {
      notifyIsland({
        title: "Error",
        text: response?.message || "Failed to load business details",
        duration: 3000,
      });
    }
  } catch (error) {
    console.error("Error loading business details:", error);
    notifyIsland({
      title: "Error",
      text: "Connection error",
      duration: 3000,
    });
  }
}

// Display business modal
function displayBusinessModal(business, employees) {
  document.getElementById('modal-icon').textContent = business.icon;
  document.getElementById('modal-title').textContent = business.label;
  document.getElementById('modal-description').textContent = business.description;
  document.getElementById('modal-rating').innerHTML = generateStars(business.rating);
  document.getElementById('online-count').textContent = employees.length;
  
  const employeesList = document.getElementById('employees-list');
  const noEmployees = document.getElementById('no-employees');
  
  if (employees.length === 0) {
    employeesList.classList.add('hidden');
    noEmployees.classList.remove('hidden');
  } else {
    employeesList.classList.remove('hidden');
    noEmployees.classList.add('hidden');
    
    employeesList.innerHTML = '';
    employees.forEach(employee => {
      const employeeCard = createEmployeeCard(employee);
      employeesList.appendChild(employeeCard);
    });
  }
  
  document.getElementById('business-modal').classList.remove('hidden');
}

// Create employee card
function createEmployeeCard(employee) {
  const card = document.createElement('div');
  card.className = 'bg-black/30 rounded-lg p-3 border border-white/10';
  
  card.innerHTML = `
    <div class="flex items-center justify-between">
      <div>
        <h4 class="font-semibold">${employee.name}</h4>
        <p class="text-sm text-gray-400">${employee.gradeLabel}</p>
      </div>
      <div class="flex gap-2">
        <button onclick="callEmployee(${employee.serverId}, '${employee.name}')" 
                class="bg-green-600 hover:bg-green-700 px-3 py-1 rounded-md text-sm transition-colors">
          📞 Call
        </button>
        <button onclick="messageEmployee(${employee.serverId}, '${employee.name}')" 
                class="bg-blue-600 hover:bg-blue-700 px-3 py-1 rounded-md text-sm transition-colors">
          💬 Message
        </button>
      </div>
    </div>
  `;
  
  return card;
}

// Call employee
async function callEmployee(employeeId, employeeName) {
  try {
    // First get the contact details
    const contactResponse = await fetchNui("getEmployeeContact", { targetId: employeeId });
    if (!contactResponse || !contactResponse.success) {
      notifyIsland({
        title: "Call Failed",
        text: contactResponse?.message || "Unable to get contact details",
        duration: 3000,
      });
      return;
    }
    
    const contact = contactResponse.contact;
    
    // Use client-side calling function
    const callResponse = await fetchNui("initiateCall", {
      targetNumber: contact.phoneNumber,
      targetName: contact.name
    });
    
    if (callResponse && callResponse.success) {
      // Log the business call
      TriggerServerEvent('okokBusinessApp:server:logBusinessCall', employeeId, selectedBusiness?.business?.name || 'Unknown');
      
      notifyIsland({
        title: "Calling",
        text: `Calling ${contact.name} at ${contact.phoneNumber}`,
        duration: 3000,
      });
      closeModal();
    } else {
      notifyIsland({
        title: "Call Failed",
        text: callResponse?.message || "Unable to initiate call",
        duration: 3000,
      });
    }
  } catch (error) {
    console.error("Error calling employee:", error);
    notifyIsland({
      title: "Error",
      text: "Connection error",
      duration: 3000,
    });
  }
}

// Message employee
async function messageEmployee(employeeId, employeeName) {
  try {
    // First get the contact details
    const contactResponse = await fetchNui("getEmployeeContact", { targetId: employeeId });
    if (!contactResponse || !contactResponse.success) {
      notifyIsland({
        title: "Message Failed",
        text: contactResponse?.message || "Unable to get contact details",
        duration: 3000,
      });
      return;
    }
    
    const contact = contactResponse.contact;
    const defaultMessage = "Hello, I would like to request your services.";
    
    // Use client-side messaging function
    const messageResponse = await fetchNui("sendMessage", {
      targetNumber: contact.phoneNumber,
      targetName: contact.name,
      message: defaultMessage
    });
    
    if (messageResponse && messageResponse.success) {
      // Log the business message
      TriggerServerEvent('okokBusinessApp:server:logBusinessMessage', employeeId, defaultMessage, selectedBusiness?.business?.name || 'Unknown');
      
      notifyIsland({
        title: "Message Sent",
        text: `Message sent to ${contact.name}`,
        duration: 3000,
      });
      closeModal();
    } else {
      notifyIsland({
        title: "Message Failed",
        text: messageResponse?.message || "Unable to send message",
        duration: 3000,
      });
    }
  } catch (error) {
    console.error("Error messaging employee:", error);
    notifyIsland({
      title: "Error",
      text: "Connection error",
      duration: 3000,
    });
  }
}

// Helper function to trigger servidor events from NUI
function TriggerServerEvent(eventName, ...args) {
  fetchNui("triggerServerEvent", {
    eventName: eventName,
    args: args
  });
}

// Close modal
function closeModal() {
  document.getElementById('business-modal').classList.add('hidden');
  selectedBusiness = null;
}

// Refresh businesses
function refreshBusinesses() {
  loadBusinessData();
  notifyIsland({
    title: "Business Directory",
    text: "Directory refreshed",
    duration: 2000,
  });
}

// Show loading state
function showLoading() {
  document.getElementById('loading').classList.remove('hidden');
  document.getElementById('business-list').classList.add('hidden');
  document.getElementById('error-content').classList.add('hidden');
}

// Show content
function showContent() {
  document.getElementById('loading').classList.add('hidden');
  document.getElementById('business-list').classList.remove('hidden');
  document.getElementById('error-content').classList.add('hidden');
}

// Show error
function showError(message) {
  document.getElementById('loading').classList.add('hidden');
  document.getElementById('business-list').classList.add('hidden');
  document.getElementById('error-content').classList.remove('hidden');
  document.getElementById('error-message').textContent = message;
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
  loadBusinessData();
});

document.addEventListener("DOMContentLoaded", (event) => {
  console.log("DOM fully loaded and parsed");
  if (document.okokPhone) {
    loadBusinessData();
  }
});