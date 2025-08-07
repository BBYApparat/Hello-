// Global variables
let employeesData = [];
let jobData = null;
let selectedEmployee = null;
let currentStatusFilter = 'all';

// Initialize the app
document.addEventListener("loadedPhoneFunctions", () => {
  console.log("JobManager: Phone functions loaded");
  loadJobData();
});

document.addEventListener("DOMContentLoaded", () => {
  console.log("JobManager: DOM loaded");
  
  // Initialize if phone functions already available
  if (document.okokPhone) {
    loadJobData();
  }
  
  // Setup event listeners
  setupEventListeners();
});

// Setup all event listeners
function setupEventListeners() {
  // Search functionality
  document.getElementById('employee-search').addEventListener('input', handleSearch);
  
  // Status dropdown
  const dropdown = document.getElementById('status-dropdown');
  const dropdownMenu = document.getElementById('status-dropdown-menu');
  
  dropdown.addEventListener('click', () => {
    dropdownMenu.classList.toggle('show');
  });
  
  // Close dropdown when clicking outside
  document.addEventListener('click', (e) => {
    if (!dropdown.contains(e.target)) {
      dropdownMenu.classList.remove('show');
    }
  });
  
  // Dropdown item selection
  dropdownMenu.addEventListener('click', (e) => {
    if (e.target.classList.contains('dropdown-item')) {
      const status = e.target.dataset.status;
      const statusName = e.target.textContent;
      
      document.getElementById('selected-status').textContent = statusName;
      currentStatusFilter = status;
      dropdownMenu.classList.remove('show');
      filterEmployees();
    }
  });
  
  // Hire employee button
  document.getElementById('hire-employee-btn').addEventListener('click', openHireModal);
  
  // Employee modal controls
  document.getElementById('employee-modal-close').addEventListener('click', closeEmployeeModal);
  
  // Hire modal controls
  document.getElementById('hire-modal-close').addEventListener('click', closeHireModal);
  document.getElementById('hire-cancel-btn').addEventListener('click', closeHireModal);
  document.getElementById('hire-confirm-btn').addEventListener('click', hireEmployee);
  
  // Bonus modal controls
  document.getElementById('bonus-modal-close').addEventListener('click', closeBonusModal);
  document.getElementById('bonus-cancel-btn').addEventListener('click', closeBonusModal);
  document.getElementById('bonus-confirm-btn').addEventListener('click', giveBonus);
}

// Load job and employee data
async function loadJobData() {
  showLoading();
  
  try {
    const response = await fetchNui("getJobData");
    if (response && response.success) {
      jobData = response.jobData;
      employeesData = response.employees || [];
      
      // Update header info
      document.getElementById('company-name').textContent = jobData.label;
      document.getElementById('user-role').textContent = `${jobData.gradeName} (Grade ${jobData.grade})`;
      
      // Populate hire grade select
      populateGradeSelect();
      
      renderEmployees();
    } else {
      if (response?.message === "UNAUTHORIZED") {
        showUnauthorized();
      } else {
        showError(response?.message || "Failed to load job data");
      }
    }
  } catch (error) {
    console.error("Error loading job data:", error);
    showError("Connection error");
  }
}

// Populate grade select for hiring
function populateGradeSelect() {
  const select = document.getElementById('hire-grade-select');
  select.innerHTML = '';
  
  if (jobData && jobData.grades) {
    // Only show grades lower than current user's grade
    jobData.grades.forEach(grade => {
      if (grade.grade < jobData.grade) {
        const option = document.createElement('option');
        option.value = grade.grade;
        option.textContent = `${grade.name} (Grade ${grade.grade})`;
        select.appendChild(option);
      }
    });
  }
}

// Render employees list
function renderEmployees() {
  const listContainer = document.querySelector('#employees-list');
  const loadingState = document.getElementById('loading-state');
  const emptyState = document.getElementById('empty-state');
  
  // Hide loading
  loadingState.classList.add('hidden');
  
  // Filter employees
  let filteredEmployees = employeesData;
  if (currentStatusFilter !== 'all') {
    filteredEmployees = employeesData.filter(employee => 
      currentStatusFilter === 'online' ? employee.isOnline : !employee.isOnline
    );
  }
  
  // Apply search filter
  const searchTerm = document.getElementById('employee-search').value.toLowerCase();
  if (searchTerm) {
    filteredEmployees = filteredEmployees.filter(employee => 
      employee.name.toLowerCase().includes(searchTerm) ||
      employee.gradeName.toLowerCase().includes(searchTerm)
    );
  }
  
  // Show empty state if no employees
  if (filteredEmployees.length === 0) {
    listContainer.innerHTML = '';
    emptyState.classList.remove('hidden');
    return;
  }
  
  emptyState.classList.add('hidden');
  
  // Render employees
  listContainer.innerHTML = filteredEmployees.map(employee => createEmployeeHTML(employee)).join('');
  
  // Add click listeners to employees
  document.querySelectorAll('.employee-item').forEach(item => {
    item.addEventListener('click', () => {
      const employeeId = item.dataset.id;
      showEmployeeDetails(employeeId);
    });
  });
}

// Create HTML for a single employee
function createEmployeeHTML(employee) {
  const onlineStatusClass = employee.isOnline ? 'text-green-400' : 'text-red-400';
  const onlineText = employee.isOnline ? 'Online' : 'Offline';
  const lastSeenText = employee.isOnline ? 'Active now' : formatLastSeen(employee.lastSeen);
  
  return `
    <div class="employee-item cursor-pointer" data-id="${employee.identifier}">
      <div class="employee-header">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="relative">
              <div class="w-12 h-12 rounded-full bg-gray-600 flex items-center justify-center">
                <i class="fas fa-user text-gray-300 text-lg"></i>
              </div>
              <div class="absolute -bottom-1 -right-1 w-4 h-4 rounded-full border-2 border-gray-900">
                <i class="fas fa-circle ${onlineStatusClass} text-xs"></i>
              </div>
            </div>
            <div>
              <div class="text-white font-bold">${employee.name}</div>
              <div class="text-gray-300 text-sm">${employee.gradeName} (Grade ${employee.grade})</div>
            </div>
          </div>
          <div class="text-right">
            <div class="text-sm ${onlineStatusClass} font-medium">${onlineText}</div>
            <div class="text-gray-500 text-xs">${lastSeenText}</div>
          </div>
        </div>
      </div>
    </div>
  `;
}

// Show employee details modal
function showEmployeeDetails(employeeId) {
  const employee = employeesData.find(emp => emp.identifier === employeeId);
  if (!employee) return;
  
  selectedEmployee = employee;
  const modal = document.getElementById('employee-modal');
  const modalTitle = document.getElementById('employee-modal-title');
  const modalContent = document.getElementById('employee-details-content');
  
  modalTitle.textContent = `${employee.name} - Management`;
  
  const onlineStatusClass = employee.isOnline ? 'text-green-400' : 'text-red-400';
  const onlineText = employee.isOnline ? 'Online' : 'Offline';
  const lastSeenText = employee.isOnline ? 'Active now' : formatLastSeen(employee.lastSeen);
  
  // Check if current user can manage this employee
  const canManage = jobData.grade > employee.grade;
  
  modalContent.innerHTML = `
    <div class="employee-info bg-gray-800/50 rounded-lg p-4 mb-4">
      <div class="flex items-center gap-4 mb-4">
        <div class="relative">
          <div class="w-16 h-16 rounded-full bg-gray-600 flex items-center justify-center">
            <i class="fas fa-user text-gray-300 text-2xl"></i>
          </div>
          <div class="absolute -bottom-1 -right-1 w-6 h-6 rounded-full border-2 border-gray-900 flex items-center justify-center">
            <i class="fas fa-circle ${onlineStatusClass} text-sm"></i>
          </div>
        </div>
        <div class="flex-1">
          <h3 class="text-white font-bold text-lg">${employee.name}</h3>
          <p class="text-gray-300">${employee.gradeName} (Grade ${employee.grade})</p>
          <div class="flex items-center gap-2 mt-1">
            <span class="${onlineStatusClass} font-medium">${onlineText}</span>
            <span class="text-gray-500 text-sm">• ${lastSeenText}</span>
          </div>
        </div>
      </div>
      
      <div class="grid grid-cols-2 gap-4 mb-4">
        <div class="bg-gray-700/50 rounded-lg p-3">
          <div class="text-gray-400 text-sm">Employee ID</div>
          <div class="text-white font-medium">${employee.identifier.slice(-8)}</div>
        </div>
        <div class="bg-gray-700/50 rounded-lg p-3">
          <div class="text-gray-400 text-sm">Hire Date</div>
          <div class="text-white font-medium">${formatDate(employee.hireDate)}</div>
        </div>
      </div>
    </div>
    
    ${canManage ? `
      <div class="actions-section">
        <h4 class="text-white font-bold mb-3">Employee Actions</h4>
        <div class="grid grid-cols-2 gap-3">
          ${employee.grade < (jobData.grades.length - 1) ? `
            <button class="action-btn bg-green-600 hover:bg-green-700 text-white py-2 px-4 rounded-lg transition-colors" onclick="promoteEmployee('${employee.identifier}')">
              <i class="fas fa-arrow-up mr-2"></i>Promote
            </button>
          ` : ''}
          ${employee.grade > 0 ? `
            <button class="action-btn bg-yellow-600 hover:bg-yellow-700 text-white py-2 px-4 rounded-lg transition-colors" onclick="demoteEmployee('${employee.identifier}')">
              <i class="fas fa-arrow-down mr-2"></i>Demote
            </button>
          ` : ''}
          <button class="action-btn bg-blue-600 hover:bg-blue-700 text-white py-2 px-4 rounded-lg transition-colors" onclick="openBonusModal('${employee.identifier}', '${employee.name}')">
            <i class="fas fa-dollar-sign mr-2"></i>Give Bonus
          </button>
          <button class="action-btn bg-red-600 hover:bg-red-700 text-white py-2 px-4 rounded-lg transition-colors" onclick="fireEmployee('${employee.identifier}')">
            <i class="fas fa-times mr-2"></i>Fire
          </button>
        </div>
      </div>
    ` : `
      <div class="text-center py-8">
        <i class="fas fa-lock text-gray-600 text-4xl mb-4"></i>
        <p class="text-gray-400">You don't have permission to manage this employee</p>
        <p class="text-gray-500 text-sm">Only higher-ranking employees can perform management actions</p>
      </div>
    `}
  `;
  
  modal.classList.add('active');
}

// Close employee modal
function closeEmployeeModal() {
  document.getElementById('employee-modal').classList.remove('active');
  selectedEmployee = null;
}

// Open hire modal
function openHireModal() {
  const modal = document.getElementById('hire-modal');
  document.getElementById('hire-player-input').value = '';
  document.getElementById('hire-grade-select').selectedIndex = 0;
  modal.classList.add('active');
  document.getElementById('hire-player-input').focus();
}

// Close hire modal
function closeHireModal() {
  document.getElementById('hire-modal').classList.remove('active');
}

// Hire employee
async function hireEmployee() {
  const playerInput = document.getElementById('hire-player-input').value.trim();
  const selectedGrade = document.getElementById('hire-grade-select').value;
  
  if (!playerInput) {
    notifyIsland({
      title: "Job Manager",
      text: "Please enter a player ID or name",
      duration: 3000
    });
    return;
  }
  
  if (!selectedGrade) {
    notifyIsland({
      title: "Job Manager",
      text: "Please select a starting grade",
      duration: 3000
    });
    return;
  }
  
  try {
    const response = await fetchNui("hireEmployee", {
      playerInput: playerInput,
      grade: parseInt(selectedGrade)
    });
    
    if (response && response.success) {
      notifyIsland({
        title: "Job Manager",
        text: "Employee hired successfully",
        duration: 2000
      });
      closeHireModal();
      loadJobData(); // Refresh the list
    } else {
      notifyIsland({
        title: "Job Manager",
        text: response?.message || "Failed to hire employee",
        duration: 3000
      });
    }
  } catch (error) {
    console.error("Error hiring employee:", error);
    notifyIsland({
      title: "Job Manager",
      text: "Connection error",
      duration: 3000
    });
  }
}

// Promote employee
async function promoteEmployee(employeeId) {
  try {
    const response = await fetchNui("promoteEmployee", { employeeId });
    
    if (response && response.success) {
      notifyIsland({
        title: "Job Manager",
        text: "Employee promoted successfully",
        duration: 2000
      });
      closeEmployeeModal();
      loadJobData(); // Refresh the list
    } else {
      notifyIsland({
        title: "Job Manager",
        text: response?.message || "Failed to promote employee",
        duration: 3000
      });
    }
  } catch (error) {
    console.error("Error promoting employee:", error);
    notifyIsland({
      title: "Job Manager",
      text: "Connection error",
      duration: 3000
    });
  }
}

// Demote employee
async function demoteEmployee(employeeId) {
  try {
    const response = await fetchNui("demoteEmployee", { employeeId });
    
    if (response && response.success) {
      notifyIsland({
        title: "Job Manager",
        text: "Employee demoted successfully",
        duration: 2000
      });
      closeEmployeeModal();
      loadJobData(); // Refresh the list
    } else {
      notifyIsland({
        title: "Job Manager",
        text: response?.message || "Failed to demote employee",
        duration: 3000
      });
    }
  } catch (error) {
    console.error("Error demoting employee:", error);
    notifyIsland({
      title: "Job Manager",
      text: "Connection error",
      duration: 3000
    });
  }
}

// Fire employee
async function fireEmployee(employeeId) {
  // Show confirmation
  if (!confirm("Are you sure you want to fire this employee?")) {
    return;
  }
  
  try {
    const response = await fetchNui("fireEmployee", { employeeId });
    
    if (response && response.success) {
      notifyIsland({
        title: "Job Manager",
        text: "Employee fired successfully",
        duration: 2000
      });
      closeEmployeeModal();
      loadJobData(); // Refresh the list
    } else {
      notifyIsland({
        title: "Job Manager",
        text: response?.message || "Failed to fire employee",
        duration: 3000
      });
    }
  } catch (error) {
    console.error("Error firing employee:", error);
    notifyIsland({
      title: "Job Manager",
      text: "Connection error",
      duration: 3000
    });
  }
}

// Open bonus modal
function openBonusModal(employeeId, employeeName) {
  selectedEmployee = { identifier: employeeId, name: employeeName };
  document.getElementById('bonus-employee-name').textContent = employeeName;
  document.getElementById('bonus-amount').value = '';
  document.getElementById('bonus-modal').classList.add('active');
  document.getElementById('bonus-amount').focus();
}

// Close bonus modal
function closeBonusModal() {
  document.getElementById('bonus-modal').classList.remove('active');
  selectedEmployee = null;
}

// Give bonus
async function giveBonus() {
  const amount = parseInt(document.getElementById('bonus-amount').value);
  
  if (!amount || amount < 1) {
    notifyIsland({
      title: "Job Manager",
      text: "Please enter a valid bonus amount",
      duration: 3000
    });
    return;
  }
  
  if (!selectedEmployee) {
    notifyIsland({
      title: "Job Manager",
      text: "Employee not selected",
      duration: 3000
    });
    return;
  }
  
  try {
    const response = await fetchNui("giveBonus", {
      employeeId: selectedEmployee.identifier,
      amount: amount
    });
    
    if (response && response.success) {
      notifyIsland({
        title: "Job Manager",
        text: `$${amount} bonus given to ${selectedEmployee.name}`,
        duration: 2000
      });
      closeBonusModal();
    } else {
      notifyIsland({
        title: "Job Manager",
        text: response?.message || "Failed to give bonus",
        duration: 3000
      });
    }
  } catch (error) {
    console.error("Error giving bonus:", error);
    notifyIsland({
      title: "Job Manager",
      text: "Connection error",
      duration: 3000
    });
  }
}

// Handle search
function handleSearch() {
  filterEmployees();
}

// Filter employees
function filterEmployees() {
  renderEmployees();
}

// Utility functions
function formatLastSeen(timestamp) {
  if (!timestamp) return 'Never';
  
  const now = new Date();
  const lastSeen = new Date(timestamp);
  const diffMs = now - lastSeen;
  const diffMins = Math.floor(diffMs / 60000);
  const diffHours = Math.floor(diffMins / 60);
  const diffDays = Math.floor(diffHours / 24);
  
  if (diffMins < 1) return 'Just now';
  if (diffMins < 60) return `${diffMins}m ago`;
  if (diffHours < 24) return `${diffHours}h ago`;
  if (diffDays < 7) return `${diffDays}d ago`;
  
  return lastSeen.toLocaleDateString();
}

function formatDate(timestamp) {
  if (!timestamp) return 'Unknown';
  return new Date(timestamp).toLocaleDateString();
}

// Show loading state
function showLoading() {
  document.getElementById('loading-state').classList.remove('hidden');
  document.getElementById('empty-state').classList.add('hidden');
  document.getElementById('unauthorized-state').classList.add('hidden');
  document.querySelector('#employees-list').innerHTML = '';
}

// Show unauthorized state
function showUnauthorized() {
  document.getElementById('loading-state').classList.add('hidden');
  document.getElementById('empty-state').classList.add('hidden');
  document.getElementById('unauthorized-state').classList.remove('hidden');
  document.querySelector('#employees-list').innerHTML = '';
}

// Show error
function showError(message) {
  document.getElementById('loading-state').classList.add('hidden');
  
  notifyIsland({
    title: "Job Manager",
    text: message,
    duration: 3000
  });
}

// Handle Dark Mode Toggle
document.addEventListener("darkMode", (e) => {
  const isDark = e.detail;
  console.log(`JobManager: Dark Mode ${isDark ? 'enabled' : 'disabled'}`);
});
