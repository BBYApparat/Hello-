// Global variables
let companiesData = [];
let selectedCompany = null;
let currentCategory = 'all';
let isEditing = false;
let selectedRating = 0;
let selectedReview = null;

// Company categories with display names and icons
const COMPANY_CATEGORIES = {
  'restaurant': { name: 'Restaurants', icon: 'fa-utensils' },
  'retail': { name: 'Retail Stores', icon: 'fa-store' },
  'automotive': { name: 'Automotive', icon: 'fa-car' },
  'services': { name: 'Services', icon: 'fa-concierge-bell' },
  'entertainment': { name: 'Entertainment', icon: 'fa-film' },
  'healthcare': { name: 'Healthcare', icon: 'fa-heart' }
};

// Initialize the app
document.addEventListener("loadedPhoneFunctions", () => {
  console.log("CompanyReviews: Phone functions loaded");
  loadCompanies();
});

document.addEventListener("DOMContentLoaded", () => {
  console.log("CompanyReviews: DOM loaded");
  
  // Initialize if phone functions already available
  if (document.okokPhone) {
    loadCompanies();
  }
  
  // Setup event listeners
  setupEventListeners();
});

// Setup all event listeners
function setupEventListeners() {
  // Search functionality
  document.getElementById('company-search').addEventListener('input', handleSearch);
  
  // Category dropdown
  const dropdown = document.getElementById('category-dropdown');
  const dropdownMenu = document.getElementById('category-dropdown-menu');
  
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
      const category = e.target.dataset.category;
      const categoryName = e.target.textContent;
      
      document.getElementById('selected-category').textContent = categoryName;
      currentCategory = category;
      dropdownMenu.classList.remove('show');
      filterCompanies();
    }
  });
  
  // Add review button
  document.getElementById('add-review-btn').addEventListener('click', () => {
    openReviewModal();
  });
  
  // Review modal controls
  document.getElementById('review-modal-close').addEventListener('click', closeReviewModal);
  document.getElementById('review-cancel-btn').addEventListener('click', closeReviewModal);
  document.getElementById('review-save-btn').addEventListener('click', saveReview);
  
  // Company modal controls
  document.getElementById('company-modal-close').addEventListener('click', closeCompanyModal);
  
  // Reply modal controls
  document.getElementById('reply-modal-close').addEventListener('click', closeReplyModal);
  document.getElementById('reply-cancel-btn').addEventListener('click', closeReplyModal);
  document.getElementById('reply-save-btn').addEventListener('click', saveReply);
  
  // Claim modal controls
  document.getElementById('claim-modal-close').addEventListener('click', closeClaimModal);
  document.getElementById('claim-cancel-btn').addEventListener('click', closeClaimModal);
  document.getElementById('claim-confirm-btn').addEventListener('click', claimCompany);
  
  // Star rating functionality
  document.querySelectorAll('.star-btn').forEach(star => {
    star.addEventListener('click', (e) => {
      const rating = parseInt(e.currentTarget.dataset.rating);
      setStarRating(rating);
    });
  });
}

// Load companies from server/storage
async function loadCompanies() {
  showLoading();
  
  try {
    const response = await fetchNui("getCompanies");
    if (response && response.success) {
      companiesData = response.companies || [];
      renderCompanies();
    } else {
      // Use mock data for demo
      companiesData = getMockCompanies();
      renderCompanies();
    }
  } catch (error) {
    console.error("Error loading companies:", error);
    // Use mock data for demo
    companiesData = getMockCompanies();
    renderCompanies();
  }
}

// Get mock data for demonstration
function getMockCompanies() {
  return [
    {
      id: 1,
      name: "Joe's Diner",
      category: "restaurant",
      description: "Classic American diner serving comfort food 24/7",
      averageRating: 4.2,
      totalReviews: 18,
      reviews: [
        { id: 1, author: "John D.", rating: 5, text: "Amazing burgers and great service! Will definitely come back.", date: "2024-01-15" },
        { id: 2, author: "Sarah M.", rating: 4, text: "Good food but a bit slow during rush hours.", date: "2024-01-10" }
      ]
    },
    {
      id: 2,
      name: "Tech Solutions Inc",
      category: "services",
      description: "Professional IT services and computer repair for businesses and individuals",
      averageRating: 4.7,
      totalReviews: 12,
      reviews: [
        { id: 1, author: "Mike R.", rating: 5, text: "Fixed my laptop quickly and professionally. Highly recommended!", date: "2024-01-12" }
      ]
    },
    {
      id: 3,
      name: "Downtown Auto Repair",
      category: "automotive",
      description: "Full service auto repair shop with certified mechanics",
      averageRating: 3.8,
      totalReviews: 25,
      reviews: [
        { id: 1, author: "Lisa K.", rating: 4, text: "Fair prices and honest work. They explained everything clearly.", date: "2024-01-08" }
      ]
    }
  ];
}

// Render companies list
function renderCompanies() {
  const listContainer = document.querySelector('#companies-list');
  const loadingState = document.getElementById('loading-state');
  const emptyState = document.getElementById('empty-state');
  
  // Hide loading
  loadingState.classList.add('hidden');
  
  // Filter companies
  let filteredCompanies = companiesData;
  if (currentCategory !== 'all') {
    filteredCompanies = companiesData.filter(company => company.category === currentCategory);
  }
  
  // Apply search filter
  const searchTerm = document.getElementById('company-search').value.toLowerCase();
  if (searchTerm) {
    filteredCompanies = filteredCompanies.filter(company => 
      company.name.toLowerCase().includes(searchTerm) ||
      company.description.toLowerCase().includes(searchTerm)
    );
  }
  
  // Show empty state if no companies
  if (filteredCompanies.length === 0) {
    listContainer.innerHTML = '';
    emptyState.classList.remove('hidden');
    return;
  }
  
  emptyState.classList.add('hidden');
  
  // Render companies
  listContainer.innerHTML = filteredCompanies.map(company => createCompanyHTML(company)).join('');
  
  // Add click listeners to companies
  document.querySelectorAll('.company-item').forEach(item => {
    item.addEventListener('click', () => {
      const companyId = parseInt(item.dataset.id);
      showCompanyDetails(companyId);
    });
  });
}

// Create HTML for a single company
function createCompanyHTML(company) {
  const categoryInfo = COMPANY_CATEGORIES[company.category] || { name: 'Other', icon: 'fa-building' };
  const stars = generateStarsHTML(company.average_rating || 0);
  const imageHTML = company.image_url ? 
    `<img src="${company.image_url}" alt="${company.name}" class="company-image w-12 h-12 rounded-lg object-cover mr-3" onerror="this.style.display='none'">` : 
    `<div class="company-image-placeholder w-12 h-12 rounded-lg bg-gray-600 flex items-center justify-center mr-3">
      <i class="fas ${categoryInfo.icon} text-gray-400"></i>
    </div>`;
  
  return `
    <div class="company-item cursor-pointer" data-id="${company.id}">
      <div class="company-header">
        <div class="flex items-center">
          ${imageHTML}
          <div class="flex-1">
            <div class="company-title">
              <span class="text-white font-bold">${company.name}</span>
              <span class="company-category-badge">${categoryInfo.name}</span>
            </div>
            <div class="company-rating">
              ${stars}
              <span class="text-gray-300 text-sm ml-1">${(company.average_rating || 0).toFixed(1)} (${company.total_reviews || 0} reviews)</span>
            </div>
          </div>
        </div>
      </div>
      <div class="company-description">${company.description || 'No description available'}</div>
    </div>
  `;
}

// Generate stars HTML for rating display
function generateStarsHTML(rating) {
  let starsHTML = '';
  for (let i = 1; i <= 5; i++) {
    if (i <= rating) {
      starsHTML += '<i class="fas fa-star text-yellow-400 text-sm"></i>';
    } else if (i - rating < 1) {
      starsHTML += '<i class="fas fa-star-half-alt text-yellow-400 text-sm"></i>';
    } else {
      starsHTML += '<i class="far fa-star text-gray-500 text-sm"></i>';
    }
  }
  return starsHTML;
}

// Show company details modal
function showCompanyDetails(companyId) {
  const company = companiesData.find(c => c.id === companyId);
  if (!company) return;
  
  selectedCompany = company;
  const modal = document.getElementById('company-modal');
  const modalTitle = document.getElementById('company-modal-title');
  const modalContent = document.getElementById('company-details-content');
  
  modalTitle.textContent = company.name;
  
  const categoryInfo = COMPANY_CATEGORIES[company.category] || { name: 'Other', icon: 'fa-building' };
  const stars = generateStarsHTML(company.average_rating || 0);
  const imageHTML = company.image_url ? 
    `<img src="${company.image_url}" alt="${company.name}" class="w-16 h-16 rounded-lg object-cover mr-4" onerror="this.style.display='none'">` : 
    `<div class="w-16 h-16 rounded-lg bg-gray-600 flex items-center justify-center mr-4">
      <i class="fas ${categoryInfo.icon} text-gray-400 text-2xl"></i>
    </div>`;
  
  modalContent.innerHTML = `
    <div class="company-info bg-gray-800/50 rounded-lg p-4 mb-4">
      <div class="flex items-center mb-3">
        ${imageHTML}
        <div class="flex-1">
          <div class="flex items-center gap-2 mb-2">
            <i class="fas ${categoryInfo.icon} text-purple-400"></i>
            <span class="text-purple-400 font-medium">${categoryInfo.name}</span>
          </div>
          <div class="flex items-center gap-2 mb-2">
            ${stars}
            <span class="text-white font-bold">${(company.average_rating || 0).toFixed(1)}</span>
            <span class="text-gray-400">• ${company.total_reviews || 0} reviews</span>
          </div>
        </div>
      </div>
      <p class="text-gray-300 mb-3">${company.description || 'No description available'}</p>
      <div class="flex gap-2">
        <button class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-lg transition-colors" onclick="openReviewModal('${company.name}', '${company.category}', '${company.description || ''}')">
          <i class="fas fa-plus mr-2"></i>Add Review
        </button>
        ${!company.owner_identifier ? `
          <button class="bg-orange-600 hover:bg-orange-700 text-white px-4 py-2 rounded-lg transition-colors" onclick="openClaimModal('${company.name}')">
            <i class="fas fa-crown mr-2"></i>Claim Company
          </button>
        ` : ''}
      </div>
    </div>
    
    <div class="reviews-section">
      <h3 class="text-white font-bold mb-3">Reviews</h3>
      ${(company.reviews || []).map(review => `
        <div class="review-item bg-gray-800/30 rounded-lg p-3 mb-3">
          <div class="flex justify-between items-start mb-2">
            <div class="flex items-center gap-2">
              <span class="text-white font-medium">${review.reviewer_name || review.author || 'Anonymous'}</span>
              <div class="flex">
                ${generateStarsHTML(review.rating)}
              </div>
            </div>
            <div class="flex items-center gap-2">
              <span class="text-gray-500 text-sm">${new Date(review.created_at || review.date).toLocaleDateString()}</span>
              ${company.owner_identifier && !review.reply_text ? `
                <button class="reply-btn text-purple-400 hover:text-purple-300 text-sm" onclick="openReplyModal(${review.id}, '${review.reviewer_name || review.author || 'Anonymous'}', '${review.review_text || review.text}')">
                  <i class="fas fa-reply mr-1"></i>Reply
                </button>
              ` : ''}
            </div>
          </div>
          <p class="text-gray-300 text-sm mb-2">${review.review_text || review.text}</p>
          ${review.reply_text ? `
            <div class="company-reply bg-purple-900/30 border-l-4 border-purple-500 pl-3 py-2 ml-4 mt-2">
              <div class="flex items-center gap-2 mb-1">
                <i class="fas fa-building text-purple-400 text-xs"></i>
                <span class="text-purple-400 text-sm font-medium">${company.name} replied</span>
                <span class="text-gray-500 text-xs">${new Date(review.reply_date).toLocaleDateString()}</span>
              </div>
              <p class="text-gray-300 text-sm">${review.reply_text}</p>
            </div>
          ` : ''}
        </div>
      `).join('')}
    </div>
  `;
  
  modal.classList.add('active');
}

// Close company modal
function closeCompanyModal() {
  document.getElementById('company-modal').classList.remove('active');
  selectedCompany = null;
}

// Open review modal
function openReviewModal(companyName = '', category = 'restaurant', description = '') {
  const modal = document.getElementById('review-modal');
  const modalTitle = document.getElementById('review-modal-title');
  const companyNameInput = document.getElementById('review-company-name');
  const categorySelect = document.getElementById('review-company-category');
  const descriptionInput = document.getElementById('review-company-description');
  
  modalTitle.textContent = companyName ? `Review ${companyName}` : 'Add Review';
  companyNameInput.value = companyName;
  categorySelect.value = category;
  descriptionInput.value = description;
  
  // Reset form
  document.getElementById('review-text').value = '';
  setStarRating(0);
  
  // If editing existing company, disable name/category fields
  if (companyName) {
    companyNameInput.disabled = true;
    categorySelect.disabled = true;
    descriptionInput.disabled = true;
  } else {
    companyNameInput.disabled = false;
    categorySelect.disabled = false;
    descriptionInput.disabled = false;
  }
  
  modal.classList.add('active');
  
  // Focus appropriate field
  if (companyName) {
    document.getElementById('review-text').focus();
  } else {
    companyNameInput.focus();
  }
}

// Close review modal
function closeReviewModal() {
  document.getElementById('review-modal').classList.remove('active');
  document.getElementById('company-modal').classList.remove('active');
  isEditing = false;
  selectedCompany = null;
}

// Set star rating
function setStarRating(rating) {
  selectedRating = rating;
  document.getElementById('selected-rating').value = rating;
  
  document.querySelectorAll('.star-btn').forEach((star, index) => {
    if (index < rating) {
      star.classList.remove('text-gray-600');
      star.classList.add('text-yellow-400');
    } else {
      star.classList.remove('text-yellow-400');
      star.classList.add('text-gray-600');
    }
  });
}

// Save review
async function saveReview() {
  const companyName = document.getElementById('review-company-name').value.trim();
  const category = document.getElementById('review-company-category').value;
  const description = document.getElementById('review-company-description').value.trim();
  const reviewText = document.getElementById('review-text').value.trim();
  const rating = selectedRating;
  
  if (!companyName) {
    notifyIsland({
      title: "Company Reviews",
      text: "Please enter a company name",
      duration: 3000
    });
    return;
  }
  
  if (!reviewText) {
    notifyIsland({
      title: "Company Reviews",
      text: "Please enter your review",
      duration: 3000
    });
    return;
  }
  
  if (rating === 0) {
    notifyIsland({
      title: "Company Reviews",
      text: "Please select a rating",
      duration: 3000
    });
    return;
  }
  
  const reviewData = {
    companyName: companyName,
    category: category,
    description: description,
    rating: rating,
    reviewText: reviewText,
    date: new Date().toISOString()
  };
  
  try {
    const response = await fetchNui("saveCompanyReview", reviewData);
    
    if (response && response.success) {
      notifyIsland({
        title: "Company Reviews",
        text: "Review saved successfully",
        duration: 2000
      });
      closeReviewModal();
      loadCompanies(); // Refresh the list
    } else {
      // Demo mode - add to mock data
      addReviewToMockData(reviewData);
      notifyIsland({
        title: "Company Reviews",
        text: "Review saved successfully",
        duration: 2000
      });
      closeReviewModal();
      renderCompanies();
    }
  } catch (error) {
    console.error("Error saving review:", error);
    // Demo mode - add to mock data
    addReviewToMockData(reviewData);
    notifyIsland({
      title: "Company Reviews",
      text: "Review saved successfully",
      duration: 2000
    });
    closeReviewModal();
    renderCompanies();
  }
}

// Add review to mock data (for demo)
function addReviewToMockData(reviewData) {
  let company = companiesData.find(c => c.name.toLowerCase() === reviewData.companyName.toLowerCase());
  
  if (!company) {
    // Create new company
    company = {
      id: Date.now(),
      name: reviewData.companyName,
      category: reviewData.category,
      description: reviewData.description,
      averageRating: reviewData.rating,
      totalReviews: 1,
      reviews: []
    };
    companiesData.push(company);
  }
  
  // Add review
  const newReview = {
    id: Date.now(),
    author: "You",
    rating: reviewData.rating,
    text: reviewData.reviewText,
    date: reviewData.date
  };
  
  company.reviews.unshift(newReview);
  company.totalReviews++;
  
  // Recalculate average rating
  const totalRating = company.reviews.reduce((sum, review) => sum + review.rating, 0);
  company.averageRating = totalRating / company.reviews.length;
}

// Handle search
function handleSearch() {
  filterCompanies();
}

// Filter companies
function filterCompanies() {
  renderCompanies();
}

// Show loading state
function showLoading() {
  document.getElementById('loading-state').classList.remove('hidden');
  document.getElementById('empty-state').classList.add('hidden');
  document.querySelector('#companies-list').innerHTML = '';
}

// Open reply modal
function openReplyModal(reviewId, reviewerName, reviewText) {
  selectedReview = { id: reviewId, reviewer: reviewerName, text: reviewText };
  
  const modal = document.getElementById('reply-modal');
  const originalReviewDiv = document.getElementById('reply-original-review');
  const replyTextarea = document.getElementById('reply-text');
  
  originalReviewDiv.innerHTML = `
    <div class="flex items-center gap-2 mb-2">
      <span class="font-medium">${reviewerName}</span>
      <div class="flex">
        ${generateStarsHTML(5)} <!-- You might want to pass actual rating -->
      </div>
    </div>
    <p>${reviewText}</p>
  `;
  
  replyTextarea.value = '';
  modal.classList.add('active');
  replyTextarea.focus();
}

// Close reply modal
function closeReplyModal() {
  document.getElementById('reply-modal').classList.remove('active');
  selectedReview = null;
}

// Save reply
async function saveReply() {
  const replyText = document.getElementById('reply-text').value.trim();
  
  if (!replyText) {
    notifyIsland({
      title: "Company Reviews",
      text: "Please enter a reply",
      duration: 3000
    });
    return;
  }
  
  if (!selectedReview || !selectedCompany) {
    notifyIsland({
      title: "Company Reviews",
      text: "Error: Missing data",
      duration: 3000
    });
    return;
  }
  
  try {
    const response = await fetchNui("addCompanyReply", {
      reviewId: selectedReview.id,
      companyId: selectedCompany.id,
      replyText: replyText
    });
    
    if (response && response.success) {
      notifyIsland({
        title: "Company Reviews",
        text: "Reply sent successfully",
        duration: 2000
      });
      closeReplyModal();
      // Refresh company details
      showCompanyDetails(selectedCompany.id);
    } else {
      notifyIsland({
        title: "Company Reviews",
        text: response?.message || "Failed to send reply",
        duration: 3000
      });
    }
  } catch (error) {
    console.error("Error saving reply:", error);
    notifyIsland({
      title: "Company Reviews",
      text: "Connection error",
      duration: 3000
    });
  }
}

// Open claim modal
function openClaimModal(companyName) {
  const modal = document.getElementById('claim-modal');
  document.getElementById('claim-company-name').textContent = companyName;
  modal.classList.add('active');
}

// Close claim modal
function closeClaimModal() {
  document.getElementById('claim-modal').classList.remove('active');
}

// Claim company
async function claimCompany() {
  const companyName = document.getElementById('claim-company-name').textContent;
  
  try {
    const response = await fetchNui("setCompanyOwner", {
      companyName: companyName
    });
    
    if (response && response.success) {
      notifyIsland({
        title: "Company Reviews",
        text: response.message,
        duration: 3000
      });
      closeClaimModal();
      loadCompanies(); // Refresh the list
    } else {
      notifyIsland({
        title: "Company Reviews",
        text: response?.message || "Failed to claim company",
        duration: 3000
      });
    }
  } catch (error) {
    console.error("Error claiming company:", error);
    notifyIsland({
      title: "Company Reviews",
      text: "Connection error",
      duration: 3000
    });
  }
}

// Handle Dark Mode Toggle
document.addEventListener("darkMode", (e) => {
  const isDark = e.detail;
  console.log(`CompanyReviews: Dark Mode ${isDark ? 'enabled' : 'disabled'}`);
});
