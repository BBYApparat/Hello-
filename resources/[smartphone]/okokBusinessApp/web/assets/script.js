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
  // For now, skip category filters since they're not in the new simplified interface
  // Categories will be filtered via search instead
  console.log('Categories available:', categories);
}

function setupCategoryButtons(container, categories) {
  categories.forEach(category => {
    const button = document.createElement('button');
    button.onclick = () => filterByCategory(category);
    button.className = `category-filter ${category === 'All' ? 'active' : ''} bg-white/20 hover:bg-white/30 px-3 py-1 rounded-full text-xs whitespace-nowrap transition-colors`;
    button.textContent = category;
    container.appendChild(button);
  });
}

// Display businesses
function displayBusinesses(businesses, filterCategory = 'All') {
  const businessList = document.getElementById('business-list');
  if (!businessList) return;
  
  businessList.innerHTML = '';
  
  const filteredBusinesses = filterCategory === 'All' 
    ? businesses 
    : businesses.filter(b => b.category === filterCategory);
  
  if (filteredBusinesses.length === 0) {
    businessList.innerHTML = '<div class="text-center py-8 text-gray-400 text-sm">No businesses found in this category</div>';
    showContent();
    return;
  }
  
  filteredBusinesses.forEach(business => {
    const businessCard = createBusinessCard(business);
    businessList.appendChild(businessCard);
  });
  
  showContent();
}

// Create business card element (phone-sized)
function createBusinessCard(business) {
  const card = document.createElement('div');
  card.className = 'flex items-center p-3 bg-gray-700/40 rounded-lg border border-gray-600/30 hover:bg-gray-600/50 transition-all cursor-pointer';
  card.onclick = () => openBusinessModal(business);
  
  card.innerHTML = `
    <div class="flex items-center w-full">
      <!-- Circular Icon -->
      <div class="w-10 h-10 rounded-full flex items-center justify-center text-lg bg-gradient-to-br ${getBusinessColorClass(business.category)} flex-shrink-0">
        ${business.icon}
      </div>
      
      <!-- Business Info -->
      <div class="flex-1 ml-2">
        <div class="flex items-center justify-between">
          <div>
            <h3 class="font-semibold text-white text-sm">${business.label}</h3>
            <div class="flex items-center gap-1 text-xs">
              <span class="text-gray-300">${business.category}</span>
              <div class="flex items-center ml-1">
                ${generateStars(business.rating, 'small')}
                <span class="text-yellow-400 ml-1">${business.rating}</span>
                <span class="text-gray-400">(${business.ratingCount || 0})</span>
              </div>
            </div>
          </div>
          
          <!-- Online Count -->
          <div class="text-right">
            <div class="text-green-400 text-xs">${business.onlineCount || 0} online</div>
            <div class="text-gray-400 text-xs">→</div>
          </div>
        </div>
      </div>
    </div>
  `;
  
  return card;
}

// Get business color class based on category
function getBusinessColorClass(category) {
  const colorMap = {
    'Emergency Services': 'from-gray-500 to-gray-600',
    'Automotive': 'from-gray-600 to-gray-700', 
    'Transportation': 'from-gray-500 to-gray-600',
    'Real Estate': 'from-gray-600 to-gray-700',
    'Professional Services': 'from-gray-500 to-gray-600',
    'Media': 'from-gray-600 to-gray-700',
    'Delivery': 'from-gray-500 to-gray-600',
    'Food': 'from-gray-600 to-gray-700',
    'Entertainment': 'from-gray-500 to-gray-600',
    'default': 'from-gray-600 to-gray-700'
  };
  
  return colorMap[category] || colorMap['default'];
}

// Generate star rating display
function generateStars(rating, size = 'normal') {
  let stars = '';
  let sizeClass = '';
  
  if (size === 'small') {
    sizeClass = 'text-sm';
  } else if (size === 'tiny') {
    sizeClass = 'text-xs';
  }
  
  for (let i = 1; i <= 5; i++) {
    if (i <= rating) {
      stars += `<span class="text-yellow-400 ${sizeClass}">★</span>`;
    } else {
      stars += `<span class="text-gray-600 ${sizeClass}">★</span>`;
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

// Open business detail modal - now opens as new tab-like view
async function openBusinessModal(business) {
  try {
    
    const response = await fetchNui("getBusinessDetails", { businessName: business.name });
    if (response && response.success) {
      selectedBusiness = response;
      showBusinessDetailView(response.business, response.employees);
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


// Show business detail view (phone tab interface)
function showBusinessDetailView(business, employees) {
  // Hide main business list and other elements (stay within phone frame)
  document.getElementById('business-list').classList.add('hidden');
  document.getElementById('loading').classList.add('hidden');
  document.getElementById('error-content').classList.add('hidden');
  
  // Hide the main header (search bar etc)
  const mainHeader = document.querySelector('.flex.items-center.justify-between.mb-6');
  if (mainHeader) {
    mainHeader.classList.add('hidden');
  }
  
  // Also hide search bar
  const searchContainer = document.querySelector('.relative.mb-6');
  if (searchContainer) {
    searchContainer.classList.add('hidden');
  }
  
  // Set up business detail header
  document.getElementById('detail-icon').textContent = business.icon;
  document.getElementById('detail-title').textContent = business.label;
  document.getElementById('detail-category').textContent = business.category;
  
  // Set company background image on full screen
  const backgroundFullscreen = document.getElementById('company-background-fullscreen');
  if (business.image && backgroundFullscreen) {
    backgroundFullscreen.style.backgroundImage = `url('${business.image}')`;
  }
  
  // Setup business rating interface for detail view
  setupBusinessRatingInterface(business.name, 'business-star-rating-detail');
  
  const employeesList = document.getElementById('detail-employees-list');
  const noEmployees = document.getElementById('detail-no-employees');
  
  if (employees.length === 0) {
    employeesList.classList.add('hidden');
    noEmployees.classList.remove('hidden');
  } else {
    employeesList.classList.remove('hidden');
    noEmployees.classList.add('hidden');
    
    employeesList.innerHTML = '';
    employees.forEach(employee => {
      const employeeCard = createDetailEmployeeCard(employee, business);
      employeesList.appendChild(employeeCard);
    });
  }
  
  // Show business detail view (replaces main content within phone)
  document.getElementById('business-detail-view').classList.remove('hidden');
}

// Create employee card for detail view (clickable for dropdown) - phone-sized
function createDetailEmployeeCard(employee, business) {
  const card = document.createElement('div');
  card.className = 'bg-gray-800/60 rounded-lg border border-gray-600/30 p-2 cursor-pointer hover:bg-gray-700/60 transition-all';
  card.onclick = (e) => openEmployeeDropdown(e, employee, business);
  
  // Generate random rating for demo
  const employeeRating = employee.rating || Math.floor(Math.random() * 5) + 1;
  const ratingCount = employee.ratingCount || Math.floor(Math.random() * 50) + 1;
  
  // Create avatar HTML - use mugshot if available, otherwise use initial
  const avatarHTML = employee.mugshot 
    ? `<img src="data:image/png;base64,${employee.mugshot}" class="w-8 h-8 rounded-full border-1 border-white/30" style="object-fit: cover;" alt="${employee.name}" />`
    : `<div class="w-8 h-8 rounded-full bg-gray-600 flex items-center justify-center text-white font-bold text-xs">${employee.name.charAt(0)}</div>`;
  
  card.innerHTML = `
    <div class="flex items-center justify-between">
      <div class="flex items-center gap-2">
        <!-- Employee Avatar -->
        ${avatarHTML}
        <div>
          <h4 class="font-semibold text-white text-sm">${employee.name}</h4>
          <p class="text-gray-300 text-xs">${employee.gradeLabel || 'Employee'}</p>
        </div>
      </div>
      
      <div class="text-right">
        <div class="flex items-center gap-1 text-xs">
          ${generateStars(employeeRating, 'tiny')}
          <span class="text-yellow-400">${employeeRating}</span>
          <span class="text-gray-400">(${ratingCount})</span>
        </div>
        <div class="text-gray-400 text-xs mt-0.5">Tap ⋯</div>
      </div>
    </div>
  `;
  
  return card;
}

// Go back to business list (phone tab navigation)
function goBackToBusiness() {
  // Hide business detail view
  document.getElementById('business-detail-view').classList.add('hidden');
  
  // Show main business list
  document.getElementById('business-list').classList.remove('hidden');
  
  // Show the main header again (search bar etc)
  const mainHeader = document.querySelector('.flex.items-center.justify-between.mb-6');
  if (mainHeader) {
    mainHeader.classList.remove('hidden');
  }
  
  // Also show search bar
  const searchContainer = document.querySelector('.relative.mb-6');
  if (searchContainer) {
    searchContainer.classList.remove('hidden');
  }
  
  // Close any open dropdown
  closeEmployeeDropdown();
}

// Open employee dropdown
function openEmployeeDropdown(event, employee, business) {
  event.stopPropagation();
  
  const dropdown = document.getElementById('employee-dropdown');
  
  // Set employee info
  document.getElementById('dropdown-employee-name').textContent = employee.name;
  document.getElementById('dropdown-employee-job').textContent = `${business.label} - ${employee.gradeLabel || 'Employee'}`;
  
  // Set avatar - use mugshot if available, otherwise use initial
  const avatarElement = document.getElementById('dropdown-employee-avatar');
  if (employee.mugshot) {
    avatarElement.innerHTML = `<img src="data:image/png;base64,${employee.mugshot}" class="w-10 h-10 rounded-full border-2 border-white/30" style="object-fit: cover;" alt="${employee.name}" />`;
  } else {
    avatarElement.textContent = employee.name.charAt(0);
  }
  
  // Show current rating
  const currentRating = employee.rating || Math.floor(Math.random() * 5) + 1;
  const ratingCount = employee.ratingCount || Math.floor(Math.random() * 50) + 1;
  document.getElementById('dropdown-current-rating').innerHTML = `
    ${generateStars(currentRating, 'small')}
    <span class="text-yellow-400 ml-1">${currentRating}</span>
    <span class="text-gray-400">(${ratingCount})</span>
  `;
  
  // Setup action buttons
  document.getElementById('dropdown-call-btn').onclick = () => {
    closeEmployeeDropdown();
    callEmployee(employee.serverId, employee.name);
  };
  
  document.getElementById('dropdown-message-btn').onclick = () => {
    closeEmployeeDropdown();
    messageEmployee(employee.serverId, employee.name);
  };
  
  // Setup rating stars
  setupDropdownRatingStars(employee);
  
  // Position dropdown within phone interface
  const rect = event.currentTarget.getBoundingClientRect();
  const container = document.querySelector('#business-detail-view');
  const containerRect = container.getBoundingClientRect();
  
  // Calculate position within the phone frame - position above the card if near bottom
  const cardBottom = rect.bottom - containerRect.top;
  const containerHeight = containerRect.height;
  const dropdownHeight = 180; // Approximate dropdown height
  
  let top, left;
  if (cardBottom + dropdownHeight > containerHeight - 20) {
    // Position above the card
    top = rect.top - containerRect.top - dropdownHeight - 5;
  } else {
    // Position below the card
    top = cardBottom + 5;
  }
  
  left = Math.max(5, Math.min(rect.left - containerRect.left, containerRect.width - 230));
  
  dropdown.style.top = `${top}px`;
  dropdown.style.left = `${left}px`;
  
  // Show dropdown
  dropdown.classList.remove('hidden');
  
  // Close dropdown when clicking outside
  setTimeout(() => {
    document.addEventListener('click', closeOnClickOutside);
  }, 10);
}

// Close employee dropdown
function closeEmployeeDropdown() {
  document.getElementById('employee-dropdown').classList.add('hidden');
  document.removeEventListener('click', closeOnClickOutside);
}

// Close dropdown when clicking outside
function closeOnClickOutside(event) {
  const dropdown = document.getElementById('employee-dropdown');
  if (!dropdown.contains(event.target)) {
    closeEmployeeDropdown();
  }
}

// Setup dropdown rating stars
function setupDropdownRatingStars(employee) {
  const stars = document.querySelectorAll('.dropdown-rating-star');
  stars.forEach((star, index) => {
    star.onclick = () => {
      const rating = parseInt(star.dataset.rating);
      
      // Update visual feedback
      stars.forEach((s, i) => {
        if (i < rating) {
          s.classList.remove('text-gray-600');
          s.classList.add('text-yellow-400');
        } else {
          s.classList.remove('text-yellow-400');
          s.classList.add('text-gray-600');
        }
      });
      
      // Submit rating
      submitEmployeeRating(employee.serverId, rating);
      
      // Auto close after rating
      setTimeout(() => {
        closeEmployeeDropdown();
      }, 1000);
    };
  });
}

// Legacy employee rating function - now redirects to dropdown
function setupEmployeeRatingStars(employee) {
  // This is kept for compatibility but no longer used
}

// Legacy function - kept for compatibility but redirects to new tab view
function displayBusinessModal(business, employees) {
  showBusinessDetailView(business, employees);
}

// Legacy function - no longer used, kept for compatibility
function createEmployeeCard(employee) {
  // Redirect to new detail card creation
  return createDetailEmployeeCard(employee, selectedBusiness?.business || {});
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

// Close modal - legacy function, now goes back to business list
function closeModal() {
  goBackToBusiness();
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
  
  // Try to load business data immediately if phone functions are already available
  if (document.okokPhone) {
    loadBusinessData();
  }
  
  // Setup search functionality
  const searchInput = document.getElementById('search-input');
  if (searchInput) {
    searchInput.addEventListener('input', handleSearch);
  }
});

// Handle search functionality
function handleSearch(event) {
  const searchTerm = event.target.value.toLowerCase();
  
  if (!businessData) return;
  
  const filteredBusinesses = businessData.businesses.filter(business => 
    business.label.toLowerCase().includes(searchTerm) ||
    business.description.toLowerCase().includes(searchTerm) ||
    business.category.toLowerCase().includes(searchTerm)
  );
  
  displayBusinesses(filteredBusinesses);
}

// Rating System Functions
let currentSelectedBusinessRating = 0;
let currentBusinessName = '';

// Setup business rating interface
async function setupBusinessRatingInterface(businessName, containerId = 'business-star-rating') {
  currentBusinessName = businessName;
  currentSelectedBusinessRating = 0;
  
  // Setup business star button listeners for the specific container
  const container = document.getElementById(containerId);
  if (container) {
    container.querySelectorAll('.business-star-btn').forEach(btn => {
      btn.onclick = () => selectBusinessRating(parseInt(btn.dataset.rating));
    });
  }
  
  // Setup employee rating listeners after modal content is loaded
  setTimeout(() => {
    setupEmployeeRatingListeners();
  }, 100);
}

// Legacy function - employee rating is now handled in the employee modal
function setupEmployeeRatingListeners() {
  // No longer needed - employee rating is handled in openEmployeeRating
}

// Select business rating
function selectBusinessRating(rating) {
  currentSelectedBusinessRating = rating;
  
  // Update business star display
  document.querySelectorAll('.business-star-btn').forEach((btn, index) => {
    if (index < rating) {
      btn.classList.remove('text-gray-600');
      btn.classList.add('text-yellow-400');
    } else {
      btn.classList.remove('text-yellow-400');
      btn.classList.add('text-gray-600');
    }
  });
  
  // Submit business rating immediately
  submitBusinessRating(rating);
}

// Legacy function - employee rating is now handled in setupEmployeeRatingStars
function selectEmployeeRating(employeeId, rating) {
  submitEmployeeRating(employeeId, rating);
}

// Submit business rating
async function submitBusinessRating(rating) {
  try {
    
    const response = await fetchNui("submitRating", {
      businessName: currentBusinessName,
      rating: rating,
      comment: ""
    });
    
    if (response && response.success) {
      notifyIsland({
        title: "Business Rated",
        text: `You rated this business ${rating} stars`,
        duration: 2000,
      });
    } else {
      notifyIsland({
        title: "Error",
        text: response?.message || "Failed to submit rating",
        duration: 3000,
      });
    }
  } catch (error) {
    console.error("Error submitting business rating:", error);
    notifyIsland({
      title: "Error",
      text: "Connection error",
      duration: 3000,
    });
  }
}

// Submit employee rating  
async function submitEmployeeRating(employeeId, rating) {
  try {
    
    // For now, just show notification - you could add employee rating to database
    notifyIsland({
      title: "Employee Rated",
      text: `You rated this employee ${rating} stars`,
      duration: 2000,
    });
  } catch (error) {
    console.error("Error submitting employee rating:", error);
  }
}